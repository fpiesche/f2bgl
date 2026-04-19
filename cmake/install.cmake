include(GNUInstallDirs)

if(UNIX AND NOT APPLE)
    install(TARGETS f2bgl
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            PERMISSIONS WORLD_READ WORLD_EXECUTE
                        GROUP_READ GROUP_EXECUTE
                        OWNER_READ OWNER_WRITE OWNER_EXECUTE
    )
    install(FILES ${DIST_PATH}/${FREEDESKTOP_APP_ID}.svg
            DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps/
            PERMISSIONS WORLD_READ
                        GROUP_READ
                        OWNER_READ OWNER_WRITE OWNER_EXECUTE
    )
    install(FILES ${LINUX_PKG_PATH}/${FREEDESKTOP_APP_ID}.metainfo.xml
            DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/metainfo/
            PERMISSIONS WORLD_READ
                        GROUP_READ
                        OWNER_READ OWNER_WRITE OWNER_EXECUTE
    )
    install(FILES ${LINUX_PKG_PATH}/${FREEDESKTOP_APP_ID}.desktop
            DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications/
            PERMISSIONS WORLD_READ WORLD_EXECUTE
                        GROUP_READ GROUP_EXECUTE
                        OWNER_READ OWNER_WRITE OWNER_EXECUTE
    )
endif()
