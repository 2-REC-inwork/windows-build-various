
# FIELD3D

(TODO: IGNORED FOR NOW
=> move to other doc!

(current "status" in:
F:\shared_folder\usd\20210820\oiio\deps\field3d\WIN_BUILD_TESTS
but cancelled, as not working anyway:
)
!!!! => Should instead try to port to newer openexr/halh!


Version 1.7.3.

Uses external libraries, which should follow the info in README:
* HDF5
  => Need to use older version 1.8.x
* IlmBase
  => Need to use the older [IlmBase](https://github.com/aforsythe/IlmBase), version 2.0.0.
  (TODO: in config 'FindIlmBase.cmake'
    => Look for package/library, but doesn't stop if don't find it.
    ! - Should raise an error!
  )
* Zlib


To specify shared vs static build:
BUILD_SHARED_LIBS



Compilation:

Warning:
```
warning C4275: non dll-interface class 'Iex::...' used as base for dll-interface class 'Iex::...'
```
=> Can ignore them?



Error:
In "Field3D-1.7.3\export\StdMathLib.h", a series of missing include files:
```cpp
#include <OpenEXR/ImathBox.h>
...
```

FIX:
Should port to newer version, but for now using an older version of IlmBase (...) seems to fix the issue.



Error:
"illegal token...

FIX:
Due to definitions in 'windows.h' of 'min' and 'max' macros overriding the definition of the 'std functions.
Define 'NOMINMAX' just before including 'windows.h' file:
```cpp
#define NOMINMAX
#include <Windows.h>
```
The change is required in 2 files:
```
...\include\UtilFoundation.h
...\src\PluginLoader.cpp
```


Error:
```
...\src\Field3DFileHDF5.cpp
error C2660: 'H5Oget_info_by_name3': function does not take 4 arguments
```
(TODO: same error?
https://github.com/imageworks/Field3D/issues/99
)

FIX:
Need older version of hdf5 (1.8.22)


Error:
```
error C2039: '_isnan': is not a member of 'std'
```

FIX:
In:
...\src\FieldMapping.cpp
There is already a (invalid) fix for that error:
```cpp
#ifdef WIN32
#define isnan(__x__) _isnan(__x__) 
#endif
```
This doesn't work, as the compiler will try to find the "std::_isnan" function which desn't exist.
It should look for "_isnan" (without the "std" namespace).
To (temporarily) fix the fix, make specific test for WIN32:
```cpp
  // Catch NaN here
#ifndef WIN32
  if (std::isnan(near) || std::isnan(far)) {
#else
  if (isnan(near) || isnan(far)) {
#endif
```
This is of course bad code, but it fixes the issue.


Error:
```
fatal error C1083: Cannot open include file: 'zlib.h': No such file or directory
```

FIX:
Need Zlib.

=> "FindZlib" fix (cmake file + add variables in 'CMakeLists')


Error:
In "src\Log.cpp":
```
fatal error C1083: Cannot open include file: 'unistd.h': No such file or directory
```

FIX:
Add the following 'WIN32' test in "Log.cpp" (present in other files using 'unistd', but not this one => bug):
```cpp
#ifndef WIN32
#include <unistd.h>
#include <ios>
#include <fstream>
#endif
```




Linking:

Error:
```
LINK : fatal error LNK1181: cannot open input file 'Iex.lib'
 [...\build\Field3D.vcxproj]
```

FIX:
=> Library path isn't the expected one.
(TODO: can also rename the 'lib' directory to 'lib64', but might be problematic if the IlmBase library is used by other projects).
In "cmake\FindILMBase.cmake", rename Zlib library from 'lib64' to 'lib'.
Replace:
```
SET ( ILMBASE_LIBRARY_DIRS ${Ilmbase_Base_Dir}/lib64
```
with:
```
SET ( ILMBASE_LIBRARY_DIRS ${Ilmbase_Base_Dir}/lib
```


Error:
```
LINK : fatal error LNK1181: cannot open input file 'zdll.lib'
 [..\build\Field3D.vcxproj]
```

FIX:
=> Library name isn't the expected one.
(TODO: can also rename the 'zlib' directory to 'zdll', but might be problematic if the Zlib library is used by other projects).
In "CMakeLists.txt", rename Zlib library from 'zdll' to 'zlib'.
Replace:
```
FOREACH ( lib Iex Half IlmThread Imath zdll )
```
with:
```
FOREACH ( lib Iex Half IlmThread Imath zlib )
```



Error:
looking for Boost static libraries

FIX:
In 'CMakeLists', add after "find_package" for Boost:
```
FIND_PACKAGE (Boost COMPONENTS regex thread)
ADD_DEFINITIONS(-DBOOST_ALL_NO_LIB)
ADD_DEFINITIONS(-DBOOST_ALL_DYN_LINK)
```
