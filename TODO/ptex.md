
# PTEX


https://ptex.us/

Git:
https://github.com/wdas/ptex

Version 2.3.2 (VFX Reference Platform).


#### BUILD ISSUES

(TODO: rephrase?)
The Windows build process for this version has some issues.
In more recent versions of the PTex library (from 2.4.1), a [fix](https://github.com/wdas/ptex/commit/8090536218986baeb56e43dfe391a6374dfd8d76) has been made.

Following is a step-by-step approach to manually fix these issues.
The modifications are based on [this patch](https://github.com/microsoft/vcpkg/tree/master/ports/ptex).


##### STATIC vs SHARED

###### Conflict

By default, both static and dynamic versions of the libraries are built.
However, building both simultaneously causes issues, as the libraries conflict with each other (the second one built overwrites the first).
This can be changed by setting the following 2 flags to 'ON' or 'OFF' depending on the desired build (in this case to build the shared libraries):
```
PTEX_BUILD_STATIC_LIBS=OFF
PTEX_BUILD_SHARED_LIBS=ON
```
Both should not be set to 'ON' to avoid potential issues.


###### Tests

The tests are automatically built using the static Ptex libraries, even if not building them.
To build the tests with the correct library variant, a check on the library type should be made.

In the file 'src\tests\CMakeLists.txt', the command:
```
add_definitions(-DPTEX_STATIC)
```
should be replaced by:
```
if(PTEX_BUILD_STATIC_LIBS)
 add_definitions(-DPTEX_STATIC)
endif ()
```


###### Static Use

(TODO: rephrase/rewrite)
When importing the static Ptex library in another project, the following error will occur:
```
error LNK2019: unresolved external symbol "__declspec(dllimport) public: static class Ptex::v2_3::PtexTexture * __cdecl Ptex::v2_3::PtexTexture::open(char const *,class Ptex::v2_3::String &,bool)"
 (__imp_?open@PtexTexture@v2_3@Ptex@@SAPEAV123@PEBDAEAVString@23@_N@Z) ...
```
This happens as the importing project is looking for the shared library definitions.

The problem is due to a missing definition of the 'PTEX_STATIC' variable when using the static build, which should helps determining which header to include.


To allow using the static library in other projects, the following modification is required in 'src\ptex\CMakeLists.txt'.
In the block starting with:
```
if(PTEX_BUILD_STATIC_LIBS)
```
Add the following command:
```
    target_compile_definitions(Ptex_static PUBLIC PTEX_STATIC)
```
This will define the 'PTEX_STATIC' variable for the static build, specifying the correct header definitions in the include file 'Ptexture.h'.


###### Shared or Static

To specify which variant to use when importing the library into another project, the namespace 'Ptex::Ptex_dynamic' or 'Ptex::Ptex_static' should be specified.

OpenImageIO is by default expecting the shared library of PTex.
In 'src\ptex.imageio\CMakeLists.txt':
```
if (Ptex_FOUND)
    add_oiio_plugin (ptexinput.cpp
                     LINK_LIBRARIES Ptex::Ptex_dynamic ZLIB::ZLIB
                     DEFINITIONS "-DUSE_PTEX")
endif ()
```

To force the use of static libraries, 'Ptex_dynamic' should be changed to 'Ptex_static'.
Replacing:
```
LINK_LIBRARIES Ptex::Ptex_dynamic ZLIB::ZLIB
```
with:
```
LINK_LIBRARIES Ptex::Ptex_static ZLIB::ZLIB
```
By doing so, OpenImageIO build will use the static library.


##### PKGCONFIG

The build process also expects to find the 'PkgConfig' tool installed on the system.
On Windows, this tool can be difficult tp set up, and isn't really necessary.

To avoid the need for 'PkgConfig', the following modification can be made to 'CMakeLists.txt'.
It will use an alternative method if the tool is not installed.

Replace the following block of code:
```
# Use pkg-config to create a PkgConfig::Ptex_ZLIB imported target
find_package(PkgConfig REQUIRED)
pkg_checK_modules(Ptex_ZLIB REQUIRED zlib IMPORTED_TARGET)
```
with:
```
find_package(PkgConfig)
if (PkgConfig_FOUND)
    # Use pkg-config to create a PkgConfig::Ptex_ZLIB imported target
    pkg_checK_modules(Ptex_ZLIB REQUIRED zlib IMPORTED_TARGET)
else ()
    # Avoid using pkg-config and map ZLIB::ZLIB to PkgConfig::Ptex_ZLIB imported target
    find_package(ZLIB REQUIRED)
    add_library(PkgConfig::Ptex_ZLIB INTERFACE IMPORTED)
    set_property(TARGET PkgConfig::Ptex_ZLIB PROPERTY INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)
endif ()
```

The modification is based on [this patch](https://github.com/conan-io/conan-center-index/blob/master/recipes/ptex/all/patches/0001-fix-cmake.patch).


The same modification should be made to allow using the files generated from the build in 'share/cmake' (which will be used by projects importing the library through CMake).
To avoid the need for 'PkgConfig', in the file 'src\build\ptex-config.cmake', replace:
```
find_package(PkgConfig REQUIRED)
pkg_checK_modules(Ptex_ZLIB REQUIRED zlib IMPORTED_TARGET)
```
with:
```
find_package(PkgConfig)
if (PkgConfig_FOUND)
    pkg_checK_modules(Ptex_ZLIB REQUIRED zlib IMPORTED_TARGET)
else ()
    find_package(ZLIB REQUIRED)
    add_library(PkgConfig::Ptex_ZLIB INTERFACE IMPORTED)
    set_property(TARGET PkgConfig::Ptex_ZLIB PROPERTY INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)
endif ()
```


#### SHA KEY & VERSION

When building PTex, it looks for the SHA key in the '.git' directory.
This file is not present when downloading the PTex release archive (ZIP).

The repository can be cloned using the following command:
```
git clone --depth 1 --branch v2.3.2 https://github.com/wdas/ptex.git
```

Alternatively, the SHA key can be provided using the 'PTEX_SHA' option to the configure process.
The value of this option is the 'commit ID' corresponding to the tag. It can be seen in the Github page corresponding to the release.
For tag v2.3.2, the commit ID is the following:
```
1b8bc985a71143317ae9e4969fa08e164da7c2e5
```

Similarly, the version string is determined from the '.git' data.
It can instead be provided using the 'PTEX_VER' option with value:
```
v2.3.2
```


#### REQUIREMENTS

Requires:
- Zlib
(TODO: need .pdb' files for debug build)
