vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ankurvdev/lexyacc
    REF "21c77cd6a283047f5add015653463ba99c1f4cd5"
    SHA512 afc70dcfcbf31b1b45c70dd67b322bf10b971b672dc3a9609b368f2821cc5a25455cf73f5fb07893e62c38ad3fe334ce3e7a80983c8900d2c323421ff8d50934
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
else()
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin")
endif()

file(READ "${CURRENT_PACKAGES_DIR}/share/lexyacc/LexYaccConfig.cmake" config_contents)
file(WRITE "${CURRENT_PACKAGES_DIR}/share/lexyacc/LexYaccConfig.cmake"
"find_program(
    lexyacc_EXECUTABLE lexyacc
    PATHS
        \"\${CMAKE_CURRENT_LIST_DIR}/../../../${HOST_TRIPLET}/tools/${PORT}\"
    NO_DEFAULT_PATH
    REQUIRED)
${config_contents}"
)
