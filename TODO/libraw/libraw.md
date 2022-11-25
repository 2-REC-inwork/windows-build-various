
# LIBRAW


https://www.libraw.org/

The [Git repository](https://github.com/LibRaw/LibRaw) doesn't have the most recent releases.
Up-to-date [Windows binaries](https://www.libraw.org/download) are available.
To have the debug libraries, it is necessary to build from source.

Version 0.20.2 is used here.


Libraw uses the following libraries:
* OpenMP
* lcms2 (or LCMS)
* ZLIB
  => To add "DNG deflate codec support".
* JPEG
* Jasper
As well as the "RawSpeed" project.

A Visual Studio solution file is provided with the project.
A [separate Git](https://github.com/LibRaw/LibRaw-cmake) provides files to build the project using CMake.
(TODO: error in link to cmake project in README.cmake)
(TODO: (in cmake project) Error in 'CMakeLists.txt' when installing 'pdb' files: wrong path is used, omitting the configuration (debug|release).
=> fix + merge to git!
)

Available options to Cmake are:
```
-DENABLE_OPENMP=ON/OFF
-DENABLE_LCMS=ON/OFF
-DENABLE_EXAMPLES=ON/OFF
-DENABLE_RAWSPEED=ON/OFF
-DRAWSPEED_RPATH=FOLDERNAME
-DENABLE_DCRAW_DEBUG=ON/OFF
```
For more details look at ["INSTALL.CMAKE"](https://github.com/LibRaw/LibRaw-cmake/blob/master/INSTALL.CMAKE) in the CMake repository.


The build produces hundreds(!) of warnings, so the library might have issues.
When building shared libraries, many warnings complain about dll exports problems:
```
warning C4251: 'LibRaw::Canon_wbi2std': class 'libraw_static_table_t' needs to have dll-interface to be used by clients of class 'LibRaw'
```
(TODO: fix issue... +see if problematic)


The debug libraries have a 'd' suffix, so when using them in other projects, they should either be explicitly specified or renamed.

