cmake_minimum_required(VERSION 3.10)
project(ninja.mirea.rtu_mirea_mobile LANGUAGES CXX)

include(GNUInstallDirs)

set(BINARY_NAME ${CMAKE_PROJECT_NAME})
set(FLUTTER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/flutter)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(CMAKE_SKIP_RPATH OFF)
set(CMAKE_INSTALL_RPATH "\$ORIGIN/../share/${BINARY_NAME}/lib")

find_package(PkgConfig REQUIRED)
pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)

add_executable(${BINARY_NAME} main.cpp ${FLUTTER_DIR}/generated_plugin_registrant.cpp)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::FlutterEmbedder)
target_include_directories(${BINARY_NAME} PRIVATE ${FLUTTER_DIR})

include(flutter/generated_plugins.cmake)

set(PACKAGE_INSTALL_DIR    ${CMAKE_INSTALL_DATADIR}/${BINARY_NAME})
set(DESKTOP_INSTALL_DIR    ${CMAKE_INSTALL_DATADIR}/applications)
set(ICONS_INSTALL_ROOT_DIR ${CMAKE_INSTALL_DATADIR}/icons/hicolor)

add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy
                   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/libflutter-embedder.so
                   ${PROJECT_BINARY_DIR}/bundle/lib/libflutter-embedder.so)

install(FILES     ${PROJECT_BINARY_DIR}/bundle/icudtl.dat     DESTINATION ${PACKAGE_INSTALL_DIR})
install(DIRECTORY ${PROJECT_BINARY_DIR}/bundle/flutter_assets DESTINATION ${PACKAGE_INSTALL_DIR})
install(DIRECTORY ${PROJECT_BINARY_DIR}/bundle/lib            DESTINATION ${PACKAGE_INSTALL_DIR})

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES desktop/${BINARY_NAME}.desktop DESTINATION ${DESKTOP_INSTALL_DIR})

foreach(ICONS_SIZE 86x86 108x108 128x128 172x172)
    install(FILES icons/${ICONS_SIZE}.png
            RENAME ${BINARY_NAME}.png
            DESTINATION ${ICONS_INSTALL_ROOT_DIR}/${ICONS_SIZE}/apps/)
endforeach(ICONS_SIZE)
