set(LIB_NAME "tws_api")

set(PRODUCT_VERSION "1.0.0")

include(GenerateProductVersion)
generate_product_version(
	PRODUCT_INFO
	DESCRIPTION  "TwsSocketClient DLL"
	NAME "${LIB_NAME}"
	ORIGINAL_FILENAME "TwsSocketClient.dll"
	COMPANY_NAME "RealTimeChris Inc."
	VERSION_MAJOR "10"
	VERSION_MINOR "27"
	VERSION_PATCH "1"
)

if (NOT DEFINED BUILD_SHARED_LIBS)
	set(BUILD_SHARED_LIBS TRUE)
endif()

file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS "${TWSAPI_ROOT_DIR}/client/*.h")
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "${TWSAPI_ROOT_DIR}/client/*.cpp")

if (BUILD_SHARED_LIBS)
		add_library("${LIB_NAME}" SHARED "${SOURCES}" "${PRODUCT_INFO}")
else()
		add_library("${LIB_NAME}" STATIC "${SOURCES}" "${PRODUCT_INFO}")
endif()

set_target_properties(
	"${LIB_NAME}" PROPERTIES 
	LINKER_LANGUAGE CXX
	OUTPUT_NAME "TwsSocketClient"
)

if (NOT WIN32)
	find_package(Threads REQUIRED)
endif()

target_include_directories("${LIB_NAME}" PUBLIC "$<BUILD_INTERFACE:${TWSAPI_ROOT_DIR}/client>" "${TWSAPI_ROOT_DIR}/")

add_library("INTEL_DECIMAL" STATIC IMPORTED)
set_target_properties(
	"INTEL_DECIMAL" 
	PROPERTIES 
	LINKER_LANGUAGE CXX
	IMPORTED_LOCATION_DEBUG "${VCPKG_ROOT_DIR}/installed/x64-${OS}/debug/lib/${LIB_PREFIX}intel_decimal128${LIB_POSTFIX}"
	IMPORTED_LOCATION_RELEASE "${VCPKG_ROOT_DIR}/installed/x64-${OS}/lib/${LIB_PREFIX}intel_decimal128${LIB_POSTFIX}"
)

target_link_libraries(
	"${LIB_NAME}" PUBLIC 
	"INTEL_DECIMAL" 
)

target_compile_definitions(
	"${LIB_NAME}" PUBLIC 
	"$<$<CXX_COMPILER_ID:MSVC>:TWSAPIDLL>"
)

add_library("${LIB_NAME}::${LIB_NAME}" ALIAS "${LIB_NAME}")

target_include_directories(
	"${LIB_NAME}" PUBLIC
	"$<INSTALL_INTERFACE:include>"
)

include(ProcessorCount)
ProcessorCount(N)
MATH(EXPR THREAD_COUNT "${N} / 3")

target_compile_options(
	"${LIB_NAME}" PUBLIC
	"$<$<CXX_COMPILER_ID:MSVC>:$<$<STREQUAL:${ASAN_ENABLED},TRUE>:/fsanitize=address>>"
	"$<$<CXX_COMPILER_ID:MSVC>:/MP${THREAD_COUNT}>"
	"$<$<CXX_COMPILER_ID:CLANG>:-Wextra>"
	"$<$<CXX_COMPILER_ID:MSVC>:/bigobj>"
	"$<$<CXX_COMPILER_ID:CLANG>:-Wall>"
	"$<$<CXX_COMPILER_ID:GNU>:-Wextra>"
	"$<$<CXX_COMPILER_ID:MSVC>:/Wall>"
	"$<$<CXX_COMPILER_ID:MSVC>:/EHsc>"
	"$<$<CXX_COMPILER_ID:GNU>:-Wall>"
	"$<$<CXX_COMPILER_ID:MSVC>:/Zi>"
)

target_link_options(
	"${LIB_NAME}" PUBLIC
	"$<$<CXX_COMPILER_ID:GNU>:$<$<STREQUAL:${ASAN_ENABLED},TRUE>:-fsanitize=address>>"
	"$<$<CXX_COMPILER_ID:MSVC>:/DEBUG>"
)

set(CONFIG_FILE_NAME "${PROJECT_NAME}Config.cmake")
set(EXPORTED_TARGETS_NAME "${PROJECT_NAME}Targets")
set(EXPORTED_TARGETS_FILE_NAME "${EXPORTED_TARGETS_NAME}.cmake")
set(EXPORTED_TARGETS_FILE_PATH "share/tws_api/${EXPORTED_TARGETS_FILE_NAME}")
set(VERSION_FILE_NAME "${PROJECT_NAME}ConfigVersion.cmake")
set(RELEASE_PDB_FILE_PATH "bin/TwsSocketClient.pdb")
set(DEBUG_PDB_FILE_PATH "bin/TwsSocketClient.pdb")

include(CMakePackageConfigHelpers)
configure_package_config_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/../CMake/${CONFIG_FILE_NAME}.in"
	"${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_FILE_NAME}"
	INSTALL_DESTINATION "share/tws_api"
	PATH_VARS
	EXPORTED_TARGETS_FILE_PATH
	RELEASE_PDB_FILE_PATH
	DEBUG_PDB_FILE_PATH
)

write_basic_package_version_file(
	"${CMAKE_CURRENT_BINARY_DIR}/${VERSION_FILE_NAME}"
	VERSION "${PRODUCT_VERSION}"
	COMPATIBILITY AnyNewerVersion
)

install(
	FILES
	"${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_FILE_NAME}"
	"${CMAKE_CURRENT_BINARY_DIR}/${VERSION_FILE_NAME}"
	DESTINATION "share/tws_api"
)

install(
	FILES
	${HEADERS}
	DESTINATION "include"
)

install(
	TARGETS "${LIB_NAME}"
	EXPORT "${EXPORTED_TARGETS_NAME}"
	RUNTIME DESTINATION "$<$<NOT:$<PLATFORM_ID:Linux>>:bin>"
	ARCHIVE DESTINATION "lib"
)

install(
	EXPORT "${EXPORTED_TARGETS_NAME}"
	FILE "${EXPORTED_TARGETS_FILE_NAME}"
	NAMESPACE "${PROJECT_NAME}::"
	DESTINATION "share/tws_api"
)

if (WIN32 AND "${BUILD_SHARED_LIBS}")
	install(
		FILES 
		"$<TARGET_PDB_FILE:${LIB_NAME}>"
		DESTINATION "bin"
		OPTIONAL
	)
endif()