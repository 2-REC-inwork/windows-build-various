# ZLIB

The [Zlib](https://zlib.net/) library should be built from source.
Zlib version 1.2.11 is used here.

The build process is based on the script from the [zlib.install](https://github.com/horta/zlib.install) repository.
However, the provided PowerShell command in "Usage" can have issues and fail (problems with large file support somehow not defined, and errors with "off64_t" definition).

The library can be built using the script (install.bat)[https://github.com/horta/zlib.install/blob/master/install.bat].

(TODO: all this can be omitted, generic to all libraries... - could make a "generic cmake" doc)
However, 2 steps are required before using the script:

1. Define the CMake environment.
  As usual, the "vcvars" script provided with Visual Studio can be used for that.
    ```batch
    call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
    ```
2. (optional) Change the location where the library will be installed.
  By default, the copy will be installed in "%PROGRAMFILES%\zlib" (or "%PROGRAMFILES(X86)%\zlib" for the 32 bits version).
  To avoid potential write permission issues, changing the location to a user writable location might be preferrable.
  By changing the following lines in "install.bat":
    ```batch
    set PREFIX=-DCMAKE_INSTALL_PREFIX="%PROGRAMFILES%\zlib"
    set PREFIX=-DCMAKE_INSTALL_PREFIX="%PROGRAMFILES(X86)%\zlib"
    ```
    to:
    ```batch
    set PREFIX=-DCMAKE_INSTALL_PREFIX="%TMPDIR%\zlib"
    set PREFIX=-DCMAKE_INSTALL_PREFIX="%TMPDIR%\zlib86"
    ```
    Where 'TMPDIR' is the location where to generate the libraries.

(TODO: link)
Alternatively, the provided 'install_nodl.bat' script can be used for the build.
(it also checks for a local zip archive before downloading)


(TODO: COPY/MOVE LIB TO DEPS DIRECTORY or refer to original location)
The library location can then be added to the OIIO build process:
```batch
set ZLIB_ROOT=%USERPROFILE%\zlib_tmp\zlib\x64
```
