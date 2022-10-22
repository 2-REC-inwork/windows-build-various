@echo off

:: To specify Python version (or none), edit "project-config.jam" in Boost install directory.

REM set BUILD_SHARED_LIBS=OFF

set BOOST_PATH=%cd%

set BOOST_SRC=%BOOST_PATH%\boost_src


if not "%BUILD_SHARED_LIBS%" == "OFF" (
    set BUILD_SHARED_LIBS=ON
)



if not "%BUILD_SHARED_LIBS%" == "OFF" (
    set LINK=shared
) else (
    set LINK=static
)

cd %BOOST_SRC%
b2.exe link=%LINK% address-model=64 threading=multi

pause
exit /b