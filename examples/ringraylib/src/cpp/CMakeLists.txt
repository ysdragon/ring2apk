cmake_minimum_required(VERSION 3.22)
project(ringraylib C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Workaround for large file support on some Android ABIs
if((ANDROID_ABI STREQUAL "armeabi-v7a" OR ANDROID_ABI STREQUAL "x86") AND ANDROID_PLATFORM_LEVEL LESS 24)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -U_FILE_OFFSET_BITS")
endif()

# ============================================================================
# Raylib (build from source)
# ============================================================================
set(RAYLIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/raylib")
set(RAYGUI_DIR "${CMAKE_CURRENT_SOURCE_DIR}/raygui")
if(NOT EXISTS "${RAYLIB_DIR}/CMakeLists.txt" OR NOT EXISTS "${RAYGUI_DIR}/src/raygui.h")
    message(FATAL_ERROR "RayLib and RayGUI not found!")
endif()

# Raylib build options for Android
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_GAMES OFF CACHE BOOL "" FORCE)
set(PLATFORM "Android" CACHE STRING "" FORCE)
set(OPENGL_VERSION "ES 2.0" CACHE STRING "" FORCE)

# Vendored raylib still declares cmake_minimum_required(VERSION 3.0),
# which CMake >= 4.0 rejects. Allow its old policies without touching vendored files.
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

# Vendored raylib is 5.0: rcore_android.c uses ALooper_pollAll(), which NDK 27
# headers removed (hard error, no warning flag can silence it). Patch a
# configure-time copy so the vendored tree stays pristine.
set(RAYLIB_PATCHED_DIR "${CMAKE_CURRENT_BINARY_DIR}/raylib-patched")
file(COPY "${RAYLIB_DIR}/CMakeLists.txt" "${RAYLIB_DIR}/CMakeOptions.txt" "${RAYLIB_DIR}/raylib.pc.in" "${RAYLIB_DIR}/README.md" "${RAYLIB_DIR}/LICENSE" DESTINATION "${RAYLIB_PATCHED_DIR}")
file(COPY "${RAYLIB_DIR}/cmake" DESTINATION "${RAYLIB_PATCHED_DIR}")
file(COPY "${RAYLIB_DIR}/src" DESTINATION "${RAYLIB_PATCHED_DIR}")
file(READ "${RAYLIB_PATCHED_DIR}/src/platforms/rcore_android.c" _RCORE_ANDROID)
string(REPLACE "ALooper_pollAll(" "ALooper_pollOnce(" _RCORE_ANDROID "${_RCORE_ANDROID}")
file(WRITE "${RAYLIB_PATCHED_DIR}/src/platforms/rcore_android.c" "${_RCORE_ANDROID}")

# Ring's ring_raylib.c (generated for Ring's 5.0 bundle) calls MatrixNormalize(),
# which is in Ring's raymath v1.2 but not in official raylib 5.0 raymath v1.5.
# Patch the copy so the binding compiles against vendored 5.0.
file(READ "${RAYLIB_PATCHED_DIR}/src/raymath.h" _RAYMATH)
if(NOT _RAYMATH MATCHES "MatrixNormalize")
    string(REPLACE "RMAPI Matrix MatrixInvert(Matrix mat)"
        "RMAPI Matrix MatrixNormalize(Matrix mat);\nRMAPI Matrix MatrixInvert(Matrix mat)"
        _RAYMATH "${_RAYMATH}")
    string(REPLACE "// Get identity matrix"
        "// Normalize provided matrix\nRMAPI Matrix MatrixNormalize(Matrix mat)\n{\n    Matrix result = { 0 };\n    float det = MatrixDeterminant(mat);\n    result.m0 = mat.m0/det;\n    result.m1 = mat.m1/det;\n    result.m2 = mat.m2/det;\n    result.m3 = mat.m3/det;\n    result.m4 = mat.m4/det;\n    result.m5 = mat.m5/det;\n    result.m6 = mat.m6/det;\n    result.m7 = mat.m7/det;\n    result.m8 = mat.m8/det;\n    result.m9 = mat.m9/det;\n    result.m10 = mat.m10/det;\n    result.m11 = mat.m11/det;\n    result.m12 = mat.m12/det;\n    result.m13 = mat.m13/det;\n    result.m14 = mat.m14/det;\n    result.m15 = mat.m15/det;\n    return result;\n}\n\n// Get identity matrix"
        _RAYMATH "${_RAYMATH}")
    file(WRITE "${RAYLIB_PATCHED_DIR}/src/raymath.h" "${_RAYMATH}")
endif()

add_subdirectory(${RAYLIB_PATCHED_DIR} raylib-build)

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
# Native App Glue (provides ANativeActivity_onCreate)
# ============================================================================
set(NATIVE_APP_GLUE_DIR "${ANDROID_NDK}/sources/android/native_app_glue")
add_library(native_app_glue STATIC
    ${NATIVE_APP_GLUE_DIR}/android_native_app_glue.c
)
target_include_directories(native_app_glue PUBLIC ${NATIVE_APP_GLUE_DIR})

# ============================================================================
# Ring Raylib Extension + Main Application
# ============================================================================
add_library(main SHARED
    main.c
    ${CMAKE_SOURCE_DIR}/../../build/gen/ringappcode.c
    ring_raylib.c
)

target_include_directories(main PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/../../build/gen
    ${RING_DIR}/include
    ${RAYLIB_PATCHED_DIR}/src
    ${RAYGUI_DIR}/src
    ${NATIVE_APP_GLUE_DIR}
)

target_link_libraries(main PRIVATE
    ring
    raylib
    -Wl,--whole-archive
    native_app_glue
    -Wl,--no-whole-archive
    android
    log
    EGL
    GLESv2
    OpenSLES
)
