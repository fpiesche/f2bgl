function(get_version_from_git)
    message(STATUS "Getting version data from git...")
    set(BUILD_TAG "none")
    set(BUILD_BRANCH "detached")
    set(GIT_COMMIT_HASH "unknown")
    set(GIT_COMMIT_SHORT_HASH "unknown")

    find_package(Git)
    if(${Git_FOUND})
        execute_process(
            COMMAND ${GIT_EXECUTABLE} symbolic-ref --short -q HEAD
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            OUTPUT_VARIABLE BUILD_BRANCH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        if(NOT BUILD_BRANCH)
            set(BUILD_BRANCH "detached")
        endif()
        message(STATUS "    Build branch: ${BUILD_BRANCH}")

        execute_process(
            COMMAND ${GIT_EXECUTABLE} log -1 --format=%H
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            OUTPUT_VARIABLE GIT_COMMIT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        message(STATUS "    Git hash: ${GIT_COMMIT_HASH}")

        execute_process(
            COMMAND ${GIT_EXECUTABLE} log -1 --format=%h
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            OUTPUT_VARIABLE GIT_COMMIT_SHORT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        message(STATUS "    Git hash (short): ${GIT_COMMIT_SHORT_HASH}")

        # Get version number from tag
        execute_process(
            COMMAND ${GIT_EXECUTABLE} tag --points-at HEAD
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            OUTPUT_VARIABLE BUILD_TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        if(BUILD_TAG AND BUILD_TAG MATCHES "^v([0-9]+)\\.([0-9]+)\\.([0-9]+)(-.*)?$")
          set(PROJECT_VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")
          set(PROJECT_VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}" PARENT_SCOPE)
          set(PROJECT_VERSION_MAJOR ${CMAKE_MATCH_1})
          set(PROJECT_VERSION_MAJOR ${CMAKE_MATCH_1} PARENT_SCOPE)
          set(PROJECT_VERSION_MINOR ${CMAKE_MATCH_2})
          set(PROJECT_VERSION_MINOR ${CMAKE_MATCH_2} PARENT_SCOPE)
          set(PROJECT_VERSION_PATCH ${CMAKE_MATCH_3})
          set(PROJECT_VERSION_PATCH ${CMAKE_MATCH_3} PARENT_SCOPE)
          set(FULL_VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}+${GIT_COMMIT_SHORT_HASH}")
          message(STATUS "   Build tag: ${BUILD_TAG}")
        else()
          set(FULL_VERSION ${GIT_COMMIT_SHORT_HASH})
          message(WARNING "Tag '${BUILD_TAG}' does not match semver format")
        endif()

    else()
        message(WARNING "Failed to find git; cannot determine branch and commit!")
    endif()

    if($ENV{GITHUB_REF} MATCHES "refs\/pull\/.*")
        string(REGEX REPLACE "refs\/pull\/([0-9]+)\/.*" "\\1" BUILD_PR_NUMBER $ENV{GITHUB_REF})
        set(FULL_VERSION "github-pr-${BUILD_PR_NUMBER}+${GIT_COMMIT_SHORT_HASH}")
        message(STATUS "    PR number: ${BUILD_PR_NUMBER}")
    endif()

    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/version.h.in ${CMAKE_CURRENT_SOURCE_DIR}/src/version.h @ONLY)
endfunction()
