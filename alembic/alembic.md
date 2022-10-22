# Alembic

https://www.alembic.io/

Git:
https://github.com/alembic/alembic

Version 1.7.16 (as of VFX Platform for CY2021).


----

## DEPENDENCIES

### Components

Following is the list of dependencies as specified in the Alembic [README](https://github.com/alembic/alembic/blob/master/README.txt) document.

#### Required

* Imath 3
OR
* OpenEXR (2.2.0+) (for Imath)

Using version 1.7.x of Alembic requires to use OpenEXR (including Imath) rather than Imath directly.


#### Optional

* HDF5 (1.8.9)

To build the Python bindings
* Boost (1.55+)
* PyImath 3 (part of Imath)
OR
* PyIlmBase (1.0.0+)

As using OpenEXR, PyIlmBase will be used here.

Additional plugins:
* Arnold (3.3+)
* Pixar PRMan (15.x)
* Autodesk Maya (2012+)


### OpenEXR

Version 2.4.3.

(TODO: link to "openexr" page)


### HDF5

TODO version

(TODO: link to "hdf5" page)


### Boost

Using Boost 1.73.

(TODO: link to "boost" page)


If trying to build Alembic with Boost (by using the configuration option "ALEMBIC_LIB_USES_BOOST"), errors are raised:
(TODO: Might be ok with older versions of Boost?)
```
\alembic-1.7.16\lib\Alembic\AbcCoreOgawa\OrData.cpp(68,63): error C2440: '<function-style-cast>':
 cannot convert from 'Alembic::AbcCoreOgawa::v12::OrData::Child *' to 'Alembic::Util::v12::unique_ptr<Alembic::AbcCoreOgawa::v12::OrData::Child []>'
 [\build\lib\Alembic\Alembic.vcxproj]
\alembic-1.7.16\lib\Alembic\AbcCoreOgawa\OrData.cpp(69,45): message : No constructor could take the source type, or constructor overload resolution was ambiguous
 [\build\lib\Alembic\Alembic.vcxproj]
\alembic-1.7.16\lib\Alembic\AbcCoreOgawa\OrData.cpp(75,25): error C2676: binary '[':
'Alembic::Util::v12::unique_ptr<Alembic::AbcCoreOgawa::v12::OrData::Child []>' does not define this operator or a conversion to a type acceptable to the predefined operator
 [\build\lib\Alembic\Alembic.vcxproj]
```
More information about the error can be found in [this issue](https://github.com/alembic/alembic/issues/312).

To avoid using Boost when building OpenEXR, the option "ALEMBIC_LIB_USES_BOOST" should not be set (by default it isn't, so it can just be ignored), or set to "OFF".


Boost is still required to build PyIlmBase (but doesn't require the configuration option to be set).


----

## BUILD

### Configuration

By default, when not providing any dependency and not setting any option, Alembic configuration is as follow:

* USE_ARNOLD                     OFF
* USE_BINARIES                   ON
* USE_EXAMPLES                   OFF
* USE_HDF5                       OFF
* USE_MAYA                       OFF
* USE_PRMAN                      OFF
* USE_PYALEMBIC                  OFF
* USE_STATIC_BOOST               OFF
* USE_STATIC_HDF5                OFF
* USE_TESTS                      ON
* ALEMBIC_ILMBASE_LINK_STATIC    OFF
* ALEMBIC_SHARED_LIBS            ON
* ALEMBIC_LIB_USES_BOOST         OFF
* ALEMBIC_LIB_USES_TR1           OFF
* DOCS_PATH                      OFF

Each component/plugin can be configured depending on the desired features.


(
TODO: add list of configuration options
TODO: add support for maya, arnold, (prman?)
TODO: should add TR1?
)



(TODO: check with:
F:\shared_folder\usd\usd_TODO\build\USD_config_options.txt
+ see if can commit stuff to master)
)



### Errors

Due to the choices of versions for the components, some incompatibilities cause problem during the build.
Some of these incompatibilities have been addressed in more recent releases of Alembic, but in order to follow the VFX Platform Reference, an older version is used.

(TODO: check errors that still applies to current/master version of Alembic)
+add details


(TODO: look at:
in "NEWS.xt":
```
Add the msvc14fixes.cpp for the python bindings if using MSVC 14 2015 Update 3.
```
=> Still required? (related to "missing reference(s) to get_pointer()" and Boost).
)

#### Debug

- OpenEXR libraries
  => _d suffix to add to search
  (only for WIN32 + debug)

(not an error:
- PyImath library
  => must be specified, different for debug and release
  (use: "ALEMBIC_PYILMBASE_PYIMATH_LIB")
)



#### Find Boost

\alembic-1.7.16\cmake\AlembicBoost.cmake
=> find_package boost python needs version if boost >1.63
(TODO: add code?)


#### HDF5 Dependency

(TODO: rephrase/detail)
- hdf5 include directory (+lib dir?)
=> change "PRIVATE" to "PUBLIC"
```
...\lib\Alembic\AbcCoreHDF5\Tests\ArchiveTests.cpp(46,10): fatal error C1083:
 Cannot open include file: 'hdf5.h': No such file or directory
 [...\build\lib\Alembic\AbcCoreHDF5\Tests\AbcCoreHDF5_ArchiveTests.vcxproj]
```
=> in "lib\Alembic\CMakeLists.txt", remove the "PRIVATE" scope from the "HDF5" headers:
```
TARGET_INCLUDE_DIRECTORIES(Alembic
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/lib>
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/lib>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include>
    ${ALEMBIC_ILMBASE_INCLUDE_DIRECTORY}
    ${Boost_INCLUDE_DIRS}
    PRIVATE
    ${HDF5_INCLUDE_DIRS}
    )
```

As well as for the library link (for both "HDF5" and "ZLib"):
(TODO: also required?)
```
TARGET_LINK_LIBRARIES(Alembic
    LINK_PUBLIC
    ${ALEMBIC_ILMBASE_LIBS}
    ${CMAKE_THREAD_LIBS_INIT}
    ${EXTERNAL_MATH_LIBS}
    LINK_PRIVATE
    ${HDF5_LIBRARIES}
    ${ZLIB_LIBRARY}
  )
```


(TODO: also, not error, only typo.
  - README
    -DHDF_ROOT=HDF5Path may need to be specified if HDF5 is not installed in
    => should be 'DHDF5_ROOT'
)


#### IlmBase Version

(TODO: check that correct)
This error only occurs if using Imath, so it can be ignored if using OpenEXR.

(TODO: rephrase/detail)

  - ...\alembic-1.7.16\cmake\Modules\FindIlmBase.cmake
    MESSAGE(WARNING "Could not find \"OpenEXRConfig.h\" in \"${ILMBASE_INCLUDE_DIR}\"")
     => wrong message (filename)

    ELSE()
      MESSAGE(WARNING "Could not determine ILMBase library version, assuming ${_ilmbase_libs_ver_init}.")
    => '_ilmbase_libs_ver_init' isn't defined... (?)

    SET("ILMBASE_VERSION" ${_ilmbase_libs_ver_init} CACHE STRING "Version of OpenEXR lib")
    UNSET(_ilmbase_libs_ver_init)
    => should be inside:
      IF(NOT ILMBASE_VERSION)

    FIND_LIBRARY(ALEMBIC_ILMBASE_${UPPERCOMPONENT}_LIB
      NAMES
        ${COMPONENT}-${_ilmbase_libs_ver} ${COMPONENT}
    => '_ilmbase_libs_ver' might not be defined


#### PyAlembic - bigobj

Error:
```
...\python\PyAlembic\PyIGeomParamVertexPoint.cpp :
 fatal error C1128: number of sections exceeded object file format limit: compile with /bigobj
 [...\build\python\PyAlembic\PyAlembic.vcxproj]
```

Mentionned in "NEWS.txt":
```
Use /bigobj flag for Visual Studio 2008/MSVC15.
```


The flag is already added when using MSVC 15.x (fix related to [issue](https://github.com/alembic/alembic/pull/172)).
However, it seems that the issue is related to the debug build rather than the compiler version.
See about the [same issue in another project](https://github.com/nlohmann/json/issues/1114).

The solution is to check if it is a debug build rather than checking the compiler version.
In "CMakeLists.txt", replace:
```
IF ((CMAKE_CXX_COMPILER_VERSION VERSION_LESS 16) AND
    (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 15))
    # MSVC15/MSVS2009 fix
    SET (CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} /bigobj" )
ENDIF ()
```
with:
```
IF ("${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    SET (CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} /bigobj" )
ENDIF ()
```


##### PyAlembic_Test

###### Unresolved WSAStartup

Error:
```
main.obj : error LNK2019: unresolved external symbol WSAStartup referenced in function main
 [...\build\python\PyAlembic\Tests\PyAlembic_Test.vcxproj]
...\build\python\PyAlembic\Tests\Release\PyAlembic_Test.exe : fatal error LNK1120: 1 unresolved externals
 [...\build\python\PyAlembic\Tests\PyAlembic_Test.vcxproj]
```
  => missing link to library 'Ws2_32.lib' (socket)
    - either add library or set "USE_TESTS=OFF" (but then for every module)
In "python\PyAlembic\Tests\CMakeLists.txt":
```
if(WIN32)
  #TODO: should use "find_library"
  TARGET_LINK_LIBRARIES(PyAlembic_Test ws2_32)
endif()
```

###### PyAlembic Linking

Warning (error):
```
CMake Warning (dev) at python/PyAlembic/Tests/CMakeLists.txt:54 (ADD_DEPENDENCIES):
  Policy CMP0046 is not set: Error on non-existent dependency in
  add_dependencies.  Run "cmake --help-policy CMP0046" for policy details.
  Use the cmake_policy command to set the policy and suppress this warning.

  The dependency target "alembic" of target "PyAlembic_Test" does not exist.
This warning is for project developers.  Use -Wno-dev to suppress it.
```

Mentionned in [issue](https://github.com/alembic/alembic/pull/172).
However, the change hasn't been made in "PyAlembic" module, resulting in an undefined dependency.

FIX:
In "python\PyAlembic\Tests\CMakeLists.txt", replace:
```
ADD_DEPENDENCIES(PyAlembic_Test alembic)
```
with:
```
ADD_DEPENDENCIES(PyAlembic_Test PyAlembic)
```


###### Python Debug

- "PyAlembic_Test" requiring Python debug lib
=> modify "main.cpp" in "PyAlembic_Test" project:
use hack (surround Python include):
#ifdef _DEBUG
#    define DBG_HACK
#    undef _DEBUG
#endif
#include <Python.h>
#ifdef DBG_HACK
#    undef DBG_HACK
#    define _DEBUG
#endif

Same issue in "python\PyAlembic\Foundation.h"


#### PyImath Module

When building OpenEXR with CMake, the output modules don't have the "module" suffix (for example "imath.pyd" instead of "imathmodule.pyd").
Info:
https://github.com/AcademySoftwareFoundation/openexr/issues/725

Also, the Cmake script tries to find the "so" (Linux) file instead of the "pyd".

FIX:
(TODO: quite horrible, temp fix)
In "E:\alembic\NEW\alembic-1.7.16\cmake\Modules\FindPyIlmBase.cmake", add extension and other file name:
```
IF (WIN32)
    SET (EXT ".pyd")
ELSE()
    SET (EXT ".so")
ENDIF()
#TODO: Keep both? (should remove "imathmodule")
SET (ALEMBIC_PYIMATH_MODULE imath${EXT})
SET (ALEMBIC_PYIMATH_MODULE_LONG imathmodule${EXT})
FIND_PATH(ALEMBIC_PYIMATH_MODULE_DIRECTORY
    NAMES
    ${ALEMBIC_PYIMATH_MODULE}
    ${ALEMBIC_PYIMATH_MODULE_LONG}
    PATHS
    ${LIBRARY_PATHS}
    /usr/local/lib/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}/site-packages
    ${ALEMBIC_PYILMBASE_ROOT}/lib/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}/site-packages
    ${ALEMBIC_PYILMBASE_ROOT}/lib64/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}/site-packages
    DOC "The imath Python module directory"
)
```

Additionally, the "site-packages" sub directory containing the module file needs to be added:
```
SET(LIBRARY_PATHS
    ${ALEMBIC_PYILMBASE_ROOT}/lib
    # Added "site-packages" sub directory
    ${ALEMBIC_PYILMBASE_ROOT}/lib/site-packages
    ${ALEMBIC_PYILMBASE_MODULE_DIRECTORY}
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local/lib
    /usr/lib
    /sw/lib
    /opt/local/lib
    /opt/csw/lib
    /opt/lib
    /usr/freeware/lib64
)
```



#### Warning

Many warnings:
```
...\alembic-1.7.16\lib\Alembic/AbcGeom/ONuPatch.h(473,25): warning C4251:
 'Alembic::AbcGeom::v12::ONuPatchSchema::m_numVProperty': class 'Alembic::Abc::v12::OTypedScalarProperty<Alembic::Abc::v12::Int32TPTraits>'
 needs to have dll-interface to be used by clients of class 'Alembic::AbcGeom::v12::ONuPatchSchema'
 [...\build\python\PyAlembic\PyAlembic.vcxproj]
```
(TODO: is it a problem? FIX!)



----

## EXTRAS

(TODO: for VFX CY2022, if using Alembic 1.8, etc.
  => move to other doc for 2022?
Imath 3
+python bindings
https://github.com/AcademySoftwareFoundation/Imath/releases/tag/v3.1.3
https://github.com/AcademySoftwareFoundation/Imath/blob/master/INSTALL.md
)


