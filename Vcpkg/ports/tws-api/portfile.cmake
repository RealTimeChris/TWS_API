vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO RealTimeChris/TWS_API
    REF "v${VERSION}"
    SHA512 2cdb17c9ade75d557620b0b3c58c8fa3157adf4e73173b935ad307e3b392e1c2d32f4d2930caef060df5952b60de71ce07449ac63f7a58e5fa7a8aa7b83d9d94
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(NO_PREFIX_CORRECTION)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.md")
