option(APPIMAGE "Build an AppImage" OFF)

# Get distribution info
if(UNIX AND NOT APPLE)
    find_program(LSB_RELEASE_EXEC lsb_release)
    execute_process(COMMAND ${LSB_RELEASE_EXEC} -is
        OUTPUT_VARIABLE LSB_RELEASE_ID_SHORT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message(STATUS "Detected Linux distribution: ${LSB_RELEASE_ID_SHORT}")

    if(LSB_RELEASE_ID_SHORT EQUAL "Debian" OR LSB_RELEASE_ID_SHORT EQUAL "Ubuntu")
        set(CPACK_GENERATOR "DEB")
    elseif(LSB_RELEASE_ID_SHORT EQUAL "Fedora")
        set(CPACK_GENERATOR "RPM")
    else()
        set(CPACK_GENERATOR "TGZ;ZIP")
    endif()

    if(APPIMAGE)
        if(CMAKE_VERSION VERSION_GREATER "4.2.0")
            set(CPACK_GENERATOR "AppImage")
            install(CODE [[
                file(GET_RUNTIME_DEPENDENCIES
                     EXECUTABLES $<TARGET_FILE:f2bgl>
                     RESOLVED_DEPENDENCIES_VAR resolved_deps
                )
                foreach(dep ${resolved_deps})
                    # Copy library symlinks and real paths if possible
                    message(STATUS "Copying ${dep} to AppImage...")
                    file(COPY ${dep}
                         DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
                    )
                    file(REAL_PATH ${dep} resolved_dep_path)
                    file(COPY ${resolved_dep_path}
                         DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
                    )
                endforeach()
            ]])
        else()
            message(WARNING "AppImage generation is only supported in CMake >=4.2.0")
        endif()
    endif()
endif()

# Packaging
set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_SOURCE_IGNORE_FILES
    /.git
    /.*build.*
    /\\\\.DS_Store
)

set(CPACK_PACKAGE_NAME "f2bgl")
set(CPACK_PACKAGE_VENDOR "Florian Piesche")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "A reimplementation of Delphine Software's Fade to Black")
set(CPACK_PACKAGE_CONTACT "https://github.com/fpiesche")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_PACKAGE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/dist")

set(CPACK_BUILD_SOURCE_DIRS ${CMAKE_CURRENT_SOURCE_DIR})
set(CPACK_PACKAGE_EXECUTABLES "f2bgl" "f2bgl")
set(CPACK_PACKAGE_ICON ${FREEDESKTOP_APP_ID}.svg)

# AppImage configuration
set(CPACK_APPIMAGE_DESKTOP_FILE ${FREEDESKTOP_APP_ID}.desktop)
# set(CPACK_APPIMAGE_SIGN ON)
# set(CPACK_APPIMAGE_SIGN_KEY "")

# Debian package configuration
set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libopengl, zlib, mesa, libsdl2, wildmidi, fluidsynth")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/fpiesche/f2bgl")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Florian Piesche")

# RedHat package configuration
set(CPACK_RPM_PACKAGE_REQUIRES "zlib-ng-compat, mesa, SDL2, wildmidi, fluidsynth")

include(CPack)
message(STATUS "CPack configured to build ${CPACK_GENERATOR}")