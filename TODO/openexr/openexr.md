(TODO: possible shared with others? (usd, oiio, ocio?))
+check with other ilmbase, imath, etc


# OpenEXR

https://www.openexr.com/

Version 2.4.3.


https://github.com/AcademySoftwareFoundation/openexr

More details:
https://github.com/AcademySoftwareFoundation/openexr/blob/master/INSTALL.md


* Build both shared and static for IlmBase and for OpenEXR.
  => For now, only shared+release, problems with static and debug.
  (TODO: FIX ISSUES!)
* Can build with both Python 2 and 3 simultaneously.
  => Provide "Python2_EXECUTABLE" and "Python3_EXECUTABLE" to avoid conflicts.


Includes "Imath" library.
(TODO: add info/link to changes about half/ilmbase))


##### Third Party Libraries

Requires:
* Zlib
* Python 2 & 3
* Numpy
  Required for each Python version used.
* Boost
  Required by "PyIlmBase".
  (TODO: option to disable PyIlmBase?)
* FLTK
  Required by "exrdisplay"
  (TODO: option to disable exrdisplay?)



###### Python

OpenEXR debug build requires the Python debug libraries.

But this causes a problem with Boost, as the libraries are built with release Python, even when in debug.
(TODO: add link to doc stating that)

=> when building in debug, LINK error "cannot open file "python27.lib"
BUT if remove/rename file, the error isn't raised... Is the file used/required????

FIX:
2 possibilities:
1. Build Python debug from source (as well as release build to avoid inconsistences).
2. "Hack" the Python debug (such as done in Boost).
(TODO: links + details)


1. BUILD PYTHON FROM SOURCE
(TODO: link to "python" page)


2. "HACK" PYTHON DEBUG

XXXXXX
NO:
openexr:
- PyImath_Python2_7
  => add python27.lib in deps
(same for python3)
- imath_python2
  => add python27.lib in deps
(same for python3)
PROBLEM: link both debug+release libs, NO NO!


=> INSTEAD:
Enclose:
#include <Python.h>
(in every file ~40 files)

in:
#ifdef _DEBUG
#    define DBG_HACK
#    undef _DEBUG
#endif
#include <Python.h>
#ifdef DBG_HACK
#    undef DBG_HACK
#    define _DEBUG
#endif



PyIlmBase\PyImath:
In
C/C++ -> Command Line -> Additional Options
Add:
/bigobj
https://docs.microsoft.com/en-us/cpp/build/reference/bigobj-increase-number-of-sections-in-dot-obj-file?view=msvc-160



###### Boost

Version 1.73.

(TODO: link to "fltk" page)


###### FLTK

Version 1.3.7.

(TODO: link to "fltk" page)


##### Build

Possibility to build both shared and static libraries simultaneously with the options (both for "OpenEXR" and "IlmBase"):
```
OPENEXR_BUILD_BOTH_STATIC_SHARED=ON
ILMBASE_BUILD_BOTH_STATIC_SHARED=ON
```

However, in Windows this raise errors:
```
... 'identifier' : definition of dllimport function not allowed
```
when building the static libraries (in "OpenEXR" and "IlmBase").


The import/export macros are defined in:
```
...\openexr-2.4.3\OpenEXR\IlmImf\ImfExport.h
```

(TODO: rephrase)
The settings for DLL exports are set in:
...\openexr-2.4.3\OpenEXR\config\LibraryDefine.cmake
...\openexr-2.4.3\IlmBase\config\LibraryDefine.cmake

Adding the compile definition "OPENEXR_DLL":
```
target_compile_definitions(${objlib} PUBLIC OPENEXR_DLL)
```
Adding this definition as "PUBLIC" adds it to the other projects using the same configuration, such as the static build defined in the same file.
This can be avoided by adding the definition as "PRIVATE".
However, this causes issues with other dependent projects.
(TODO: find solution!)



TODO: check:
"If you are using any OpenEXR DLLs, however, you must
  define OPENEXR_DLL in your project's preprocessor directives."
(from: "CHANGES.md")



##### Install

Error:
```
Cannot open include file "PyIlmBaseConfig"
```
(TODO: OK? - normal? - should be done by cmake?)
=> must manually rename the file "PyIlmBaseConfigInternal.h.in" to "PyIlmBaseConfigInternal.h" and copy it to the "include" directory of the build.




++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TO REMOVE/DELETE! (?)

xxxxxxxxxxx
* PkgConfig
  Can be ignored (?).
* Header file GL/glu.h
* ZLIB
* JPEG
  If not provided, will use build-in version.
* PNG
  If not provided, will use build-in version.

(TODO: Should provide JPEG and PNG libraries to avoid potential incompaibilities/conflicts with other libraries)


Static / shared:
- Static libraries built by default
- Shared libraries built if setting "OPTION_BUILD_SHARED_LIBS=ON"


* Missing "GL/glu.h" warning can be ignored:
  ...\fltk-release-1.3.7\CMake\resources.cmake

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TO REMOVE/DELETE!

xxxxxxxxxxx
Version 2.3.0.

Latest repository:
https://git.soundcontactstudio.com/enpinion/openexr

Requires:
* Zlib
* IlmBase
  Part of OpenEXR, it will be built automatically if required.
  IlmBase can be built separately and provided by using "ILMBASE_PACKAGE_PREFIX".
* Python 2.7
  Incompatibilities with Python 3 in "PyIlmBase".
  ! - Debug build requires Python debug libraries!
    (TODO: where to find? - or should disable link to debug library?)
* Boost
  OpenEXR can be built using Boost. PyIlmBase requires Boost.
  However, errors are raised when building OpenEXR with Boost (see below).
* Error when building with Boost static libraries: Looking for shared libraries (without "lib" prefix, though prefix is set in configuration options)
  => build pyilmbase with boost shared

Remarks:
      - with shared Boost libs!
    - common build for static and shared?

PROBLEM:
  - BUT: problem with  => Python3 incompatibilities => need to use Python2
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
