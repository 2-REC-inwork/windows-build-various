(TODO: see if still necessary - check with openEXR, imath, ilmbase, half, etc.)

# IMATH

https://github.com/AcademySoftwareFoundation/Imath

In order for other libraries (OpenEXR, OIIO) to properly detect and use the library, the 'cmake' subdirectory is required.
This directory is generated during the "install" step of the build:
```
cmake --build . --target install
```
A 'lib/cmake' directory will be generated.

Both debug and release builds are generated simultanously and share the same location.

(TODO: add python support:
PyImath:
From ["OpenEXR/Imath Porting Guide"](https://github.com/AcademySoftwareFoundation/Imath/blob/master/docs/PortingGuide2-3.md#background):
"The Imath python bindings are a part of Imath as a configuration option, although support is off by default to simplify the build process for most users."
)
