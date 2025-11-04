vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ankurvdev/lexyacc
    REF "78e195ddab7165d2e73a61a976e9eecbd7fed274"
    SHA512 ab60ad4ca102247404f4fff97ebbcaa097ce821f30b828ae584181a129eea48c83de7de6a8ad076713b1181b4a975f59249fe60b02f0cc4b63b4f1ad92efa509
    HEAD_REF main)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_find_acquire_program(FLEX)
vcpkg_find_acquire_program(BISON)

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
"
set(FLEX_EXECUTABLE \"${FLEX}\" CACHE PATH "Location of flex")
set(BISON_EXECUTABLE \"${BISON}\" CACHE PATH "Location of bison")

find_program(
    lexyacc_EXECUTABLE lexyacc
    PATHS
        \"\${CMAKE_CURRENT_LIST_DIR}/../../../${HOST_TRIPLET}/tools/${PORT}\"
    NO_DEFAULT_PATH
    REQUIRED)
${config_contents}"
)
