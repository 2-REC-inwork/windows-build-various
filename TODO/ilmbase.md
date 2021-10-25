(TODO: see if still necessary - check with openEXR, imath, ilmbase, half, etc.)
(from OIIO, see if about others)


# ILMBASE



Version is not set in "IlmBaseConfig.h", causing issues with Alembic
(TODO: detail + fix)


TODO: add python to build!
old ilmbase+ypilmbase versions
https://download-mirror.savannah.gnu.org/releases/openexr/?C=M&O=A
got v2.0.0, try it...


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

