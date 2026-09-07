cmake_minimum_required(VERSION 3.22)
project(myapp C)

# Workaround for large file support on some Android ABIs
if((ANDROID_ABI STREQUAL "armeabi-v7a" OR ANDROID_ABI STREQUAL "x86") AND ANDROID_PLATFORM_LEVEL LESS 24)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -U_FILE_OFFSET_BITS")
endif()

# ============================================================================
# Ring Language (build from source)
# ============================================================================
set(RING_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ring")
if(NOT EXISTS "${RING_DIR}/src")
    message(FATAL_ERROR "Ring sources not found! Expected at ${RING_DIR}/src")
endif()

file(GLOB RING_SOURCES ${RING_DIR}/src/*.c)

add_library(ring STATIC ${RING_SOURCES})
target_include_directories(ring PUBLIC "${RING_DIR}/include")
target_link_libraries(ring PUBLIC android log)

# ============================================================================
# Main Application
# ============================================================================
add_library(main SHARED
    main.c
    ${CMAKE_SOURCE_DIR}/../../build/gen/ringappcode.c
)

target_include_directories(main PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/../../build/gen
    ${RING_DIR}/include
)

target_link_libraries(main PRIVATE
    ring
    android
    log
)

# ============================================================================
# WebView
# ============================================================================
set(WEBVIEW_DIR "${CMAKE_CURRENT_SOURCE_DIR}/webview")
set(WEBVIEW_TAG "v1.6.0")
if(NOT EXISTS "${WEBVIEW_DIR}/CMakeLists.txt")
    message(STATUS "Cloning ring_webview ${WEBVIEW_TAG} to ${WEBVIEW_DIR}...")
    execute_process(
        COMMAND git clone --branch ${WEBVIEW_TAG} --depth 1 --recurse-submodules https://github.com/ysdragon/webview.git "${WEBVIEW_DIR}"
        RESULT_VARIABLE _clone_res
    )
    if(NOT _clone_res EQUAL 0)
        message(FATAL_ERROR "Failed to clone ring_webview ${WEBVIEW_TAG}")
    endif()
endif()
add_subdirectory("${WEBVIEW_DIR}" "${CMAKE_BINARY_DIR}/ring_webview")

target_link_libraries(main PRIVATE ring_webview_android)