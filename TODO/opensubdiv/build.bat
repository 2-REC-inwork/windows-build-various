@echo off
setlocal enabledelayedexpansion

set BUILD_TYPE=Release
set ARCH=x64
REM set BUILD_SHARED_LIBS=OFF

REM - TODO: find way to automate (dir with lib name (parent dir) in it?
set LIB_DIR=OpenSubdiv-3_4_4
set LIB_PATH=%cd%

set LIB_SRC_PATH=%LIB_PATH%\%LIB_DIR%
set BUILD_PATH=%LIB_PATH%\build
set INSTALL_PATH=%LIB_PATH%\install\%ARCH%\%BUILD_TYPE%


:: Third party libraries paths (optional)
set DEPS_PATH=%LIB_PATH:\=/%/deps
REM - TODO: get from input arguments and set defaults if not set
:: TBB
set TBB_PATH=%DEPS_PATH%/tbb/%ARCH%/%BUILD_TYPE%
:: PTEX
set PTEX_PATH=%DEPS_PATH%/ptex/%ARCH%/%BUILD_TYPE%
:: ZLIB
set ZLIB_PATH=%DEPS_PATH%/zlib/%ARCH%/%BUILD_TYPE%
:: OpenCL
REM set OPENCL_PATH=%DEPS_PATH%/opencl/%ARCH%/%BUILD_TYPE%
:: CUDA
REM set CUDA_PATH=%DEPS_PATH%/cuda/%ARCH%/%BUILD_TYPE%
:: GLFW (no debug/release)
set GLFW_PATH=%DEPS_PATH%/glfw/%ARCH%
REM - TODO: other varaibles/modules:
REM -DNO_OMP=1        // disable OpenMP
REM -DNO_OPENGL=1     // disable OpenGL
REM -DNO_CLEW=1       // if using OpenCL?


REM set NO_EXAMPLES=1
REM set NO_TUTORIALS=1
REM set NO_REGRESSION=1
set NO_DOC=1


if "%LIB_DIR%" == "" (
    echo 'LIB_DIR' is not set!
    pause
    exit /b
)


echo Build path: %BUILD_PATH%
if not exist %BUILD_PATH% (
    mkdir %BUILD_PATH%
)
cd %BUILD_PATH%


:: Set default build configuration Release|64 (if not set)
if not "%ARCH%" == "Win32" (
    set ARCH=x64
)
if not "%BUILD_TYPE%" == "Debug" (
    set BUILD_TYPE=Release
)

:: Build Options
set "BUILD_OPTIONS="

if not "%BUILD_SHARED_LIBS%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DBUILD_SHARED_LIBS=%BUILD_SHARED_LIBS%
)


if not "%NO_DOC%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_DOC=%NO_DOC%
)
if not "%NO_EXAMPLES%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_EXAMPLES=%NO_EXAMPLES%
)
if not "%NO_TUTORIALS%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_TUTORIALS=%NO_TUTORIALS%
)
if not "%NO_REGRESSION%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_REGRESSION=%NO_REGRESSION%
)

if not "%PTEX_PATH%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DPTEX_LOCATION="%PTEX_PATH%"
    set BUILD_OPTIONS=!BUILD_OPTIONS! -DZLIB_ROOT="%ZLIB_PATH%" -Wno-dev
) else (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_PTEX=1
)
if not "%TBB_PATH%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DTBB_LOCATION="%TBB_PATH%"
) else (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_TBB=1
)
if not "%OPENCL_PATH%" == "" (
    REM - TODO: correct variables?
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DOPENCL_LOCATION="%OPENCL_PATH%"
) else (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_OPENCL=1
)
if not "%CUDA_PATH%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DCUDA_TOOLKIT_ROOT_DIR="%CUDA_PATH%"
) else (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DNO_CUDA=1
)
REM - TODO: should be onyl if using OpenGL?
if not "%GLFW_PATH%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DGLFW_LOCATION="%GLFW_PATH%"
)

REM - TODO: get path from input argument
if "%VCVARS_PATH%" == "" (
    set VCVARS_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build"
)
:: ~Hack to remove quotes (will be added later)
set VCVARS_PATH=%VCVARS_PATH:"=%

if "%ARCH%" == "x64" (
    set VCVARS=vcvars64.bat
) else (
    set VCVARS=vcvars32.bat
)

:: Initialise VC environment
call "%VCVARS_PATH%\%VCVARS%"

echo Build options: %BUILD_OPTIONS%

echo.
echo Configure
cmake -G "Visual Studio 16 2019" -A %ARCH% ^
 -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
 -DCMAKE_INSTALL_PREFIX="%INSTALL_PATH%" ^
 %BUILD_OPTIONS% ^
 "%LIB_SRC_PATH%"

REM - TODO: add check for error

echo.
echo Build
cmake --build . --target install --config %BUILD_TYPE%

pause
exit /b