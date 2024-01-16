vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO RealTimeChris/TWS_API
    REF "v${VERSION}"
    SHA512 4de0db4b584655b22ac441dc777382664ee60b6d87236e0c7ed8ad709f0e93adad5b0aaf685b51e428cf15fb7dd8d71a8bf922893b821fd50b4190e557a7412c
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
