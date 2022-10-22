@echo off

set BUILD_TYPE=Release
set ARCH=x64

REM - TODO: find way to automate (dir with lib name (parent dir) in it?
set LIB_DIR=5.15.2
set LIB_PATH=%cd%

set LIB_SRC_PATH=%LIB_PATH%\%LIB_DIR%
set BUILD_PATH=%LIB_PATH%\build
set INSTALL_PATH=%LIB_PATH%\install\%BUILD_TYPE%


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


set "BUILD_OPTIONS="


:: OpenSSL
REM - TODO: not using openssl for now

:: ICU
REM - TODO: not using icu for now

:: ANGLE (dynamic link)
set BUILD_OPTIONS=%BUILD_OPTIONS% -opengl dynamic

:: Add Python to PATH (at begin, to make sure another version is not used)
if "%PYTHON_PATH%" == "" (
    set PYTHON_PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python37
)
REM - TODO: check that Python is installed... (should detect install location)
set PATH=%PYTHON_PATH%;%PATH%

:: Add Perl to PATH
if "%PERL_PATH%" == "" (
	REM - TODO: set "nicer" path (more like default?)
    set PERL_PATH=E:\perl\perl
)
set PATH=%PERL_PATH%;%PATH%

:: Add other binaries paths (GPerf, Bison, Flex, etc.)
SET PATH=%LIB_SRC_PATH%\qtbase\bin;%_ROOT%\gnuwin32\bin;%PATH%
REM Uncomment the below line when using a git checkout of the source repository
REM SET PATH=%LIB_SRC_PATH%\qtrepotools\bin;%PATH%


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


:: Add build type
if "%BUILD_TYPE%" == "Debug" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -debug
) else (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -release
)

REM - TODO: Define variables at top of file, and use them here
:: Add modules to skip
set "SKIP_MODULES="

:: Skip tools
set SKIP_MODULES=%SKIP_MODULES% -skip qttools

:: Network modules (TODO: should include them!)
set SKIP_MODULES=%SKIP_MODULES% -skip qtconnectivity -skip qtnetworkauth
set SKIP_MODULES=%SKIP_MODULES% -skip qtwebengine -skip qtwebview -skip qtwebsockets -skip qtwebchannel

:: Other unnecessary modules (TODO: CHECK!)
set SKIP_MODULES=%SKIP_MODULES% -skip qtdoc
set SKIP_MODULES=%SKIP_MODULES% -skip qtlocation -skip qtpurchasing
set SKIP_MODULES=%SKIP_MODULES% -skip qtspeech
set SKIP_MODULES=%SKIP_MODULES% -skip qtsensors -skip qtserialbus -skip qtserialport
set SKIP_MODULES=%SKIP_MODULES% -skip qtgamepad -skip qtvirtualkeyboard
set SKIP_MODULES=%SKIP_MODULES% -skip qtwayland

:: OS specific modules
set SKIP_MODULES=%SKIP_MODULES% -skip qtandroidextras -skip qtmacextras -skip qtx11extras


set BUILD_OPTIONS=%BUILD_OPTIONS% %SKIP_MODULES%

:: Add features to disable
set DISABLE_FEATURES=
REM set DISABLE_FEATURES=-no-feature-accessibility
set BUILD_OPTIONS=%BUILD_OPTIONS% %DISABLE_FEATURES%


:: Build libraries, don't build tools
set BUILD_OPTIONS=%BUILD_OPTIONS% -make libs -nomake tools

:: Don't build examples, tests and demos
set BUILD_OPTIONS=%BUILD_OPTIONS% -nomake tests
set BUILD_OPTIONS=%BUILD_OPTIONS% -nomake examples -no-compile-examples


:: Add build location prefix
set BUILD_OPTIONS=%BUILD_OPTIONS% -prefix %BUILD_PATH:\=/%

:: Build the open source Qt version
set BUILD_OPTIONS=%BUILD_OPTIONS% -opensource

set BUILD_OPTIONS=%BUILD_OPTIONS% -confirm-license



pushd %LIB_SRC_PATH%

echo Build options: %BUILD_OPTIONS%

:: Clean previous configure/build
:: (might take long)
REM - TODO: should test if required (eg: presence of a specific directory/file?)
REM nmake distclean


echo.
echo Configure
configure %BUILD_OPTIONS%

REM - TODO: add check for error

echo.
echo Build
nmake

REM - TODO: add check for error

REM - TODO: doesn't get executed?
nmake install

popd

pause
exit /b