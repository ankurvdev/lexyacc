cmake_minimum_required(VERSION 3.26)
include(CMakePackageConfigHelpers)
include(cmake/BuildEnv.cmake)
set(CMAKE_CXX_STANDARD 17)
option(LEXYACC_SKIP_INSTALL "Do not install lexyacc" OFF)

project(lexyacc VERSION 0.0.1)
EnableStrictCompilation()

add_executable(lexyacc lexyacc.cpp)
set_target_properties(lexyacc PROPERTIES PUBLIC_HEADER "FlexLexer.h")

configure_package_config_file(cmake/LexYaccConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/LexYaccConfig.cmake
    INSTALL_DESTINATION share/lexyacc
)

include(cmake/LexYaccTargets.cmake) # For add_subdirectory mode
if (NOT LEXYACC_SKIP_INSTALL)
    install(
        TARGETS lexyacc
        EXPORT LexYaccTargets
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION include/lexyacc
    )

    install(FILES
        cmake/LexYaccTargets.cmake
        cmake/FindOrBuildTool.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/generated/LexYaccConfig.cmake
        DESTINATION share/lexyacc
    )
endif()

#
# CPACK
#
set (CPACK_GENERATOR ZIP)
set (CPACK_PACKAGE_NAME                 ${PROJECT_NAME})
set (CPACK_PACKAGE_VENDOR               "Ankur Verma")
set (CPACK_PACKAGE_DESCRIPTION_SUMMARY  "LexYacc")
set (CPACK_PACKAGE_VERSION              ${PROJECT_VERSION})

include(CPack)
