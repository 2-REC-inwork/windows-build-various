(TODO: see if still necessary - check with openEXR, imath, ilmbase, half, etc.)
(from OIIO, see if about others)


# ILMBASE


Errors/issues:
(TODO: SPECIFY VERSION!)

- library version (output)
If Windows ("WIN32"), the library version is not set in "IlmBaseConfig.h", causing issues with Alembic.
(TODO: detail + fix)
=> modify "CMakeLists.txt"


- python detection
  => with order PythonLibs then PythonInterp, seems to not detect python
FIX:
  in
    ...\PyIlmBase-2.2.0\CMakeLists.txt
  invert order:
    FIND_PACKAGE ( PythonInterp REQUIRED )
    FIND_PACKAGE ( PythonLibs REQUIRED )
  + suggested in doc:
    "If calling both find_package(PythonInterp) and find_package(PythonLibs), call find_package(PythonInterp) first to get the currently active Python version by default with a consistent version of PYTHON_LIBRARIES."
    from:
    https://cmake.org/cmake/help/latest/module/FindPythonLibs.html


- can't find NumPy
  change:
    FIND_PACKAGE ( NumPy )
  to:
    FIND_PACKAGE ( Python COMPONENTS NumPy )


- include boost directories
  - headers:
    INCLUDE_DIRECTORIES (${Boost_INCLUDE_DIR})
  - lib:
    LINK_DIRECTORIES (${Boost_LIBRARY_DIRS})
(+check other changes (?))


- when static boost, looks for "boost_python..." though should link to "libboost_python..."
  check woth:
  add SET(Boost_DEBUG 1) before FIND_PACKAGE and MESSAGE("\${Boost_LIBRARIES} - ${Boost_LIBRARIES}") after FIND_PACKAGE in your CMakeLists.txt. 



----

TODO: add python to build!
old ilmbase+ypilmbase versions
https://download-mirror.savannah.gnu.org/releases/openexr/?C=M&O=A
got v2.0.0, try it...

----

```
warning C4275: non dll-interface class 'Iex::MathExc' used as base for dll-interface class 'Imath::SingMatrixExc'
```
Means the exports are not done properly.
In Windows, seems like need to manually define the export variables for each module:
* HALF_EXPORTS
...


#### PyIlmBase

Dependencies:
* python
* numpy
* boost



Numpy:
python.exe -m pip download -d ...\tmp Numpy


- required python2 (boost w python2)
  => errors with python37
- PyIMath
  - from ilmbase, need to copy "ImathFrustumTest.h" to "include" (required by PyIMath module...)
  - cannot convert pyobject* to pyobject*&... ???



????
- error linking "boost python 27 lib" in PyIex
  (not a dependency though, and others link to "libboost python 27"

