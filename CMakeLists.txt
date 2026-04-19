cmake_minimum_required (VERSION 3.21)

# Build universal binaries on macOS
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
endif()

project(f2bgl VERSION 1.0.3 LANGUAGES CXX)

set(DIST_PATH "${CMAKE_SOURCE_DIR}/dist")
set(LINUX_PKG_PATH "${DIST_PATH}/linux")
set(FREEDESKTOP_APP_ID "net.yellowkeycard.f2bgl")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(git_version)
get_version_from_git()

FILE(GLOB F2BGL_SOURCES src/*.cpp)
add_executable(f2bgl ${F2BGL_SOURCES})

find_package(SDL2 REQUIRED)
find_package(OpenGL REQUIRED)
find_package(ZLIB REQUIRED)
find_package(WildMidi REQUIRED)
find_package(FluidSynth REQUIRED)

target_include_directories(f2bgl PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${OPENGL_INCLUDE_DIR}
    ${SDL2_INCLUDE_DIR}
    ${ZLIB_INCLUDE_DIR}
    ${WILDMIDI_INCLUDE_DIR}
    ${FLUIDSYNTH_INCLUDE_DIR}
)
target_link_libraries(f2bgl PRIVATE
    SDL2
    OpenGL
    ZLIB::ZLIB
    WildMidi
    FluidSynth::libfluidsynth
)

include(install)
include(packaging)
