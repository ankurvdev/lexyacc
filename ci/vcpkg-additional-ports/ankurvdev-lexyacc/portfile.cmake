vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ankurvdev/lexyacc
    REF "v${VERSION}"
    SHA512 96d2208fd5d654dad5662968296fa363cea0a935fec8474b780717c9303d2dd763833370bcdf02d6d63e264368b0955fa1f13c6e55685280df5fdaf9e72b8c9f
    HEAD_REF main)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

# Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
if(HOST_TRIPLET STREQUAL TARGET_TRIPLET) # Otherwise fails on wasm32-emscripten
    vcpkg_copy_tools(TOOL_NAMES lexyacc AUTO_CLEAN)
endif()

file(READ "${CURRENT_PACKAGES_DIR}/share/lexyacc/LexYaccConfig.cmake" config_contents)
file(WRITE "${CURRENT_PACKAGES_DIR}/share/lexyacc/LexYaccConfig.cmake"
"find_program(
    LEXYACC_EXECUTABLE lexyacc
    PATHS
        \"\${CMAKE_CURRENT_LIST_DIR}/../../../${HOST_TRIPLET}/tools/${PORT}\"
    NO_DEFAULT_PATH
    REQUIRED)
${config_contents}"
)
