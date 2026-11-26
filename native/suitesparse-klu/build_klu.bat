@echo off

if exist ./build (
    echo Removing existing build directory...
    rmdir /s /q ./build
)

echo Building KLU...

md /q build
cd build
cmake .. ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX=./dist ^
  -D SUITESPARSE_ENABLE_PROJECTS="suitesparse_config;amd;btf;colamd;klu" ^
  -D KLU_USE_CHOLMOD=OFF ^
  -D BUILD_STATIC_LIBS=OFF ^
  -D BUILD_SHARED_LIBS=ON ^
  -D CMAKE_C_FLAGS="-DNTIMER" ^
  -D CMAKE_CXX_FLAGS="-DNTIMER"

msbuild ALL_BUILD.vcxproj
msbuild INSTALL.vcxproj
cd ..