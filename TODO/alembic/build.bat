@echo off
setlocal enabledelayedexpansion

set BUILD_TYPE=Release
set ARCH=x64
REM set BUILD_SHARED_LIBS=OFF

REM set USE_TESTS=OFF

REM - TODO: find way to automate (dir with lib name (parent dir) in it?
set LIB_DIR=alembic-1.7.16
set LIB_PATH=%cd%

set LIB_SRC_PATH=%LIB_PATH%\%LIB_DIR%
set BUILD_PATH=%LIB_PATH%\build
set INSTALL_PATH=%LIB_PATH%\install\%ARCH%\%BUILD_TYPE%

:: Third party libraries paths.
set DEPS_PATH=%LIB_PATH:\=/%/deps
:: IlmBase
REM set IMATH_PATH=%DEPS_PATH%/imath/%ARCH%/%BUILD_TYPE%
REM set ILMBASE_PATH=%DEPS_PATH%/ilmbase/%ARCH%/%BUILD_TYPE%
set ILMBASE_PATH=%DEPS_PATH%/openexr/%ARCH%/%BUILD_TYPE%
:: HDF5
set HDF5_PATH=%DEPS_PATH%/hdf5/%ARCH%/%BUILD_TYPE%
:: Zlib (required by HDF5?)
set ZLIB_PATH=%DEPS_PATH%/zlib/%ARCH%/%BUILD_TYPE%
:: Boost (optional)
REM set BOOST_PATH=%USERPROFILE:\=/%/Documents/boost/boost_src
REM set BOOST_PATH=e:/boost/boost_src
set BOOST_PATH=E:/boost/x64/x64_shared



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

set "PREFIX_PATH="
REM set BUILD_OPTIONS=%BUILD_OPTIONS% -DImath_ROOT=%IMATH_PATH%
REM set BUILD_OPTIONS=%BUILD_OPTIONS% -DILMBASE_ROOT="%ILMBASE_PATH%"
set PREFIX_PATH=%PREFIX_PATH%;%ILMBASE_PATH%

REM - TODO: want static IlmBase? (probably yes)
REM set BUILD_OPTIONS=%BUILD_OPTIONS% -DALEMBIC_ILMBASE_LINK_STATIC=ON

if not "%BOOST_PATH%" == "" (
    REM REM - Don't set "ALEMBIC_LIB_USES_BOOST=ON", causes issues with recent Boost (?)
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DALEMBIC_LIB_USES_BOOST=ON
    REM REM - TODO: problem using static boost... TO SOLVE!
    REM REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DUSE_STATIC_BOOST=ON
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DBOOST_ROOT="%BOOST_PATH%"
    set PREFIX_PATH=!PREFIX_PATH!;%BOOST_PATH%
)

if not "%HDF5_PATH%" == "" (
    REM REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DUSE_HDF5=ON -DHDF5_ROOT=%HDF5_PATH%
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DUSE_HDF5=ON -DHDF5_ROOT="%HDF5_PATH%"
    set BUILD_OPTIONS=!BUILD_OPTIONS! -DUSE_HDF5=ON
    set PREFIX_PATH=!PREFIX_PATH!;%HDF5_PATH%
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DZLIB_ROOT="%ZLIB_PATH%"
    set PREFIX_PATH=!PREFIX_PATH!;%ZLIB_PATH%
    REM REM - TODO: move upper level?
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -Wno-dev
)


set BUILD_OPTIONS=%BUILD_OPTIONS% -DUSE_PYALEMBIC=ON
set BUILD_OPTIONS=%BUILD_OPTIONS% -DPYILMBASE_ROOT="%ILMBASE_PATH%"
REM - TODO: needed? (not found if not specified, but required?)
set BUILD_OPTIONS=%BUILD_OPTIONS% -DALEMBIC_PYILMBASE_PYIMATH_LIB="%ILMBASE_PATH%/lib/PyImath_Python3_7-2_4.lib"

REM - TODO: set as input arg
if not "%USE_TESTS%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DUSE_TESTS=%USE_TESTS%
)


set PYTHON_PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python37
REM set PYTHON_PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python27
set PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%PATH%

echo Build options: %BUILD_OPTIONS%


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


echo.
echo Configure
cmake -G "Visual Studio 16 2019" -A %ARCH% ^
 -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
 -DCMAKE_INSTALL_PREFIX="%INSTALL_PATH%" ^
 -DCMAKE_PREFIX_PATH="%PREFIX_PATH%" ^
 %BUILD_OPTIONS% ^
 "%LIB_SRC_PATH%"

REM - TODO: add check for error

echo.
echo Build
cmake --build . --target install --config %BUILD_TYPE%

REM pause
exit /b