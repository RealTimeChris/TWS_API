cmake_minimum_required(VERSION 3.20)

set(PROJECT_NAME "tws_api")

project(
	"${PROJECT_NAME}"
	LANGUAGES CXX
)

set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/Install/${CMAKE_BUILD_TYPE}/" CACHE STRING "" FORCE)
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/CMake;")

set(BUILD_SHARED_LIBS TRUE)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)

if (WIN32)
	set(OS "windows")
	set(TWSAPI_ROOT_DIR "C:/TWS API/source/CppClient")
	set(VCPKG_ROOT_DIR "C:/Vcpkg")
	set(LIB_PREFIX "")
	set(LIB_POSTFIX ".lib")
elseif(APPLE)
	set(OS "osx")
	set(TWSAPI_ROOT_DIR "/home/chris/IBJts/source/cppclient")
	set(VCPKG_ROOT_DIR "/home/chris/Vcpkg")
	set(LIB_PREFIX "lib")
	set(LIB_POSTFIX ".a")
elseif(UNIX)
	set(OS "linux")
	set(TWSAPI_ROOT_DIR "/home/chris/IBJts/source/cppclient")
	set(VCPKG_ROOT_DIR "/home/chris/Vcpkg")
	set(LIB_PREFIX "lib")
	set(LIB_POSTFIX ".a")
endif()

add_subdirectory(Library)