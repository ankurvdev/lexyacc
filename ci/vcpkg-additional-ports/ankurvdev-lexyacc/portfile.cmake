vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ankurvdev/lexyacc
    REF "3130ff6487c837ce70171588eedfba6e686c9c47"
    SHA512 dcba079b8b7ef90b3f6e6d9b00e73d90c23b0a7ce435d3f9c698b24ac00dfb0e05663a9da9c73ee9f87f96f04a60c084fb33e6b128a35e41499416c42c9b1cbf
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
