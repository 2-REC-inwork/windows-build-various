
# BUILD PYTHON FROM SOURCE

Source:
https://www.python.org/downloads/release/python-2718/


When building the Python debug libraries, it is also required to build every module that will be used by Python.


# Init (?)

* Open "PCBuild/pcbuild.sln" in VS2019
  + Retarget projects to SDK 10 & v142
* Select configuration (e.g.: Debug, 64 bits)
* Fix build errors (see below)
* Build the solution


Fix/patch to build in VS2019:
https://github.com/python-cmake-buildsystem/python-cmake-buildsystem/issues/161

(TODO: might need to also make change for wide character support!)


# Build Errors

A lot of errors when building with VS2019: about half of the modules don't build!

Main build errors failing Python build:
There are many other errors, but fixing the following allows to at least build Python and some of the base libraries.
(TODO: fix to build every module)


(TODO: build full python, and fix all issues
to add: sll, pip, numpy, etc.
)


## Timezone
```
...\Python-2.7.18\Modules\timemodule.c(819,51): error C2065: 'timezone': undeclared identifier
...\Python-2.7.18\Modules\timemodule.c(822,52): error C2065: 'daylight': undeclared identifier
...\Python-2.7.18\Modules\timemodule.c(824,52): error C2065: 'tzname': undeclared identifier
```
FIX:
In the ile:
```
...\Python-2.7.16\Modules\timemodule.c
```
Replace:
```
#if defined(__BORLANDC__)
/* These overrides not needed for Win32 */
```
with:
```
#if defined(__BORLANDC__) || (defined _MSC_VER && _MSC_VER >= 1900)
```


## "pioinfo"
```
posixmodule.obj : error LNK2019: unresolved external symbol __imp___pioinfo referenced in function _PyVerify_fd
...\Python-2.7.18\PCBuild\\amd64\python27_d.dll : fatal error LNK1120: 1 unresolved externals
```

FIX:
In the file:
```
...\Python-2.7.18\Include\fileobject.h
```
Reaplce:
```
#if defined _MSC_VER && _MSC_VER >= 1400
```
with:
```
#if defined _MSC_VER && _MSC_VER >= 1900
#define _PyVerify_fd(fd) (_get_osfhandle(fd) >= 0)
#elif defined _MSC_VER && _MSC_VER >= 1400
```

In the file:
```
...\Python-2.7.18\Modules\posixmodule.c
```
Replace:
```
#if defined _MSC_VER && _MSC_VER >= 1400
```
with:
```
#if defined _MSC_VER && _MSC_VER >= 1900
/* dummy version. _PyVerify_fd() is already defined in fileobject.h */
#define _PyVerify_fd_dup2(A, B) (1)
#elif defined _MSC_VER && _MSC_VER >= 1400
```


## Base Address (warning)

This s not an error, but might as well be fixed.

Warning:
```
LINK : warning LNK4281: undesirable base address 0x1D000000 for x64 image;
 set base address above 4GB for best ASLR optimization
```

Clear the value in (a few projects have the value set):
Project Properties -> Linker -> Advanced -> Base Address


# INSTALL

(TODO: files to copy)
- "include" directory
- "PCBuild" to "libs" (?)
- "PC" ...? (DLLs?) + some at root "python" dir
- "Lib" to "Lib"?
...

