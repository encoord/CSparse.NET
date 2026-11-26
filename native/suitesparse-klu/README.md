# SuiteSparse KLU for SAInt (Windows x64)

SAInt for Windows ships these SuiteSparse libraries for its KLU linear solver option. CSparse.Interop loads them at
run time; they are separate DLLs and can be replaced with a compatible build.

| File | Library | License |
| --- | --- | --- |
| `klu.dll` | KLU 2.3.5 | LGPL-2.1-or-later |
| `btf.dll` | BTF 2.3.2 | LGPL-2.1-or-later |
| `amd.dll` | AMD 3.3.3 | BSD-3-Clause |
| `colamd.dll` | COLAMD 3.3.4 | BSD-3-Clause |
| `suitesparseconfig.dll` | SuiteSparse_config 7.10.1 | BSD-3-Clause |

## Source

The library source code is **SuiteSparse 7.10.1, unmodified**:
https://github.com/DrTimothyAldenDavis/SuiteSparse/tree/v7.10.1

`suitesparse-7.10.1-build-config.patch` holds the only changes made to that tree, all in build files:

- `CMakeLists.txt`: the SPEX project is commented out (it is not built for SAInt).
- `SuiteSparse_config/cmake_modules/SuiteSparseBLAS.cmake` and `SuiteSparseLAPACK.cmake`: point to a local
  OpenBLAS 0.3.29 build in `OpenBLAS-0.3.29_x64`. KLU, BTF, AMD and COLAMD do not use BLAS, and the shipped DLLs
  do not link to it; if CMake reports a missing BLAS library, place an OpenBLAS build there or drop those two lines.

## Build

Requirements: Visual Studio 2022 or later with the C++ workload, CMake 3.22 or later.

```powershell
git clone --branch v7.10.1 --depth 1 https://github.com/DrTimothyAldenDavis/SuiteSparse.git
cd SuiteSparse
git apply <path to this folder>\suitesparse-7.10.1-build-config.patch
copy <path to this folder>\build_klu.bat .
# In a Developer PowerShell for Visual Studio:
.\build_klu.bat
```

The DLLs are installed to the `bin` folder below `CMAKE_INSTALL_PREFIX` (`./dist` in the script). The script builds the Release configuration with
`SUITESPARSE_ENABLE_PROJECTS="suitesparse_config;amd;btf;colamd;klu"`, `KLU_USE_CHOLMOD=OFF` and shared libraries
only. To use a modified build with SAInt, replace the DLLs of the same names in the SAInt installation folder.
