
### FREETYPE

(freetype2 ok?)
https://www.freetype.org/

http://gnuwin32.sourceforge.net/packages/freetype.htm
Direct link:
http://gnuwin32.sourceforge.net/downlinks/freetype-bin-zip.php

Dependencies: (don't seem mandatory, but probably better to add if can)
(- HarfBuzz?) (found... - where is it?)
- ZLIB
  (not required? - build seems ok without it...)
- PNG
- BZip2
- BrotliDec (see below)


Quick method (from provided project):
(TODO: add link)
- Copy content of "freetype_win" in "freetype-2.11.0" (overwrite existing files)
- Open 'builds\windows\vs2019\freetype.sln' in Visual Studio 2019
- Select build configuration (eg: "Release Static|x64")
- Build


Full method:
!
~hack:
In 'CMakeLists.txt' (in freetype base directory), add the command to set the 'CMP0074' policy to 'NEW', to allow using 'XXX_ROOT' variables and make the script easier to write.
```
  cmake_policy(SET CMP0074 NEW)
```
This can be added after the line:
```
if (NOT CMAKE_VERSION VERSION_LESS 3.3)
```
Then can use the build options:
```
-DZLIB_ROOT=%ZLIB_PATH%
-DPNG_ROOT=%PNG_PATH%
-DBZip2_ROOT=%BZIP2_PATH%
-DBrotliDec_ROOT=%BROTLI_PATH%
```


(TODO:
!!- CHECK THAT BUILD DOESN'T NEED ZLIB!!
- see how could make command line (avoid opening VS2019)
- check all deps and have correct debug|release, 32|64, STATIC|SHARED files!
- remove build in 'freetype-demos' (when building shared libs (?))
)



(!!!! TODO: add appropriate libraries to each config!)
- Copy 'vc2010' directory to 'vs2019'
- 'dlg'
  => 'dlg' files are already there, so the pre-build script 'script.bat' is useless.
  - Delete the file 'script.bat'
  - Edit the 'vcproj' file:
    - Remove "prebuild" blocks (calling "script.bat")
    - Remove "dlg" stuff
- Dependencies:
  - HarfBuzz: TODO!
  - bzip2
    - Edit "include\freetype\config\ftoption.h"*:
      - Uncommment 'FT_CONFIG_OPTION_USE_BZIP2'
    - Add 'src\bzip2\ftbzip2.c' to source files
      TODO: must be 'better' way to do it
    - Edit 'builds\windows\vs2019\freetype.user.props':
      - Add headers/include path to 'UserIncludeDirectories'
      - Add library path to 'UserLibraryDirectories'
      ?- Add library to 'UserDependencies'
        !? - TODO: check if have same problem as with 'libpng'
  - png
    - Edit "include\freetype\config\ftoption.h"*:
      - Uncommment 'FT_CONFIG_OPTION_USE_PNG'
    - Edit 'builds\windows\vs2019\freetype.user.props':
      - Add headers/include path to 'UserIncludeDirectories'
      - Add library path to 'UserLibraryDirectories'
      X- Add library to 'UserDependencies'
        ! - By doing so, it creates 'LNK2005' errors: "... already defined in libpng16.lib(libpng16.dll)"
          => Because 'libpng16' is already used by OIIO, and thus already defining the symbols (?)
          TODO: Is this normal? How to solve/fix? (not adding the library fixes the issue, but isn't ideal)
            => Must be solved in order to have "clean" build (that can use in other projects without libpng!
  - brotli
    - Edit "include\freetype\config\ftoption.h"*:
      - Uncommment 'FT_CONFIG_OPTION_USE_BROTLI'
    - Edit 'builds\windows\vs2019\freetype.user.props':
      - Add headers/include path to 'UserIncludeDirectories'
        => Required files: 'decode.h', 'port.h', types.h'
      - Add library path to 'UserLibraryDirectories'
      - Add libraries to 'UserDependencies'
        => Required libraries: 'brotlidec-static.lib', 'brotlicommon-static.lib'
  - zlib
    => Currently unused: (?)
        "Included modified  copies of the  ZLib sources in  `src/gzip' in
        order to support  gzip-compressed PCF fonts.  We do  not use the
        system-provided  zlib  for  now,   though  this  is  a  probable
        enhancement for future releases."
    BUT: Need to link the library when building shared 'freetype' library to avoid unresolved externals in 'libpng'!
    - Edit 'builds\windows\vs2019\freetype.user.props':
      - Add headers/include path to 'UserIncludeDirectories'
      - Add library path to 'UserLibraryDirectories'
      - Add library to 'UserDependencies'
- Open VS2019
  - check setting/configs
- Build static lib
  ! - To build the release variant of the library, language extensions must be enabled:
    - Go to:
      'Project' -> 'Properties...' -> 'C/C++' -> 'Language'
    - Enable the extensions:
      'Disable Language Extensions' to "No"


* - If using "freetype-2.11.0\devel\ftoption.h" (instead of "include\freetype\config\ftoption.h") by setting 'UserOptionDirectory' in 'builds\windows\vs2019\freetype.user.props', it seems to remove 'include\freetype\config' from the include paths, and the build process then cannot find the file 'ftmodule.h'.

TODO: see about include files (determine minimum required)


TODO: should fix/remove warnings.



#### BROTLI

https://github.com/google/brotli
v1.0.9
(nothing specific for the build)


