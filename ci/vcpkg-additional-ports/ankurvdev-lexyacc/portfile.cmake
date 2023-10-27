vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ankurvdev/lexyacc
    REF "1c9321dde20ff86870c1c72259614158d13e894d"
    SHA512 7021c861406b413e579ced9a839169d86bc3e09e1e97272e8acb1f954a1136836c281aa70bb8bad2611c3af0f2da2071a610e17ce4533e6168031185e03d7d8d
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
