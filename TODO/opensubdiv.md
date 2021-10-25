
### OpenSubdiv

https://github.com/PixarAnimationStudios/OpenSubdiv

Version 3.4.4.

Information on [Building with CMake](https://graphics.pixar.com/opensubdiv/docs/cmake_build.html) can be found in the documentation .


#### Dependencies

All the dependencies are optional, but should be provided if specific features are desired.
* Ptex: Required to support features for ptex textures and the ptexViewer example.
  Location specified with "PTEX_LOCATION".
  Can be disabled using "NO_PTEX=1".
* Zlib: Required for Ptex under Windows
  Location specified with the usual CMake variables "ZLIB_INCLUDE_DIR" and "ZLIB_LIBRARIES".
  To make it easier, the variable "ZLIB_ROOT" can be used instead, but requires adding the configuration flag "Wno-dev" (to set Policy CMP0074 and allow "XXX_ROOT" variables):
  ```
  -DZLIB_ROOT="%ZLIB_PATH%" -Wno-dev
  ```
  Cannot be disabled, required if using Ptex.
* CUDA
  Location specified with "DCUDA_TOOLKIT_ROOT_DIR".
  Not used. (TODO: add support)
  Can be disabled using "NO_CUDA=1".
* TBB
  Location specified with "TBB_LOCATION".
  Can be disabled using "NO_TBB=1".
* OpenMP
  Should already be installed with Visual Studio (?).
  Can be disabled using "NO_OMP=1".
* OpenGL
  Should already be installed with Windows/VS (?).
  Can be disabled using "NO_OPENGL=1".
* GLEW: Required if using OpenGL (?).
  ??
* OpenCL
  Not used. (TODO: add support)
  Can be disabled using "NO_OPENCL=1".
  https://www.khronos.org/opencl/
  https://github.com/KhronosGroup/Khronosdotorg/blob/main/api/opencl/resources.md
  Old:
  https://streamhpc.com/blog/2015-03-16/how-to-install-opencl-on-windows/
* CLEW: Required if using OpenCL (?).
  Not used. (TODO: add support)
  Can be disabled using "NO_CLEW=1".
* DX11 SDK
  Should already be installed with Visual Studio (?).
* GLFW: Required for standalone examples and some regression tests.
  Location specified with "DGLFW_LOCATION".
  https://www.glfw.org/
  https://github.com/glfw/glfw
  Up-to-date binaries are available.

Additionally some dependencies are required to build the documentation.
Documentation will be removed from the build by using the following configuration option:
```
-DNO_DOC=1
```


#### Build

During the build (linking steps), a number of warnings might be raised about unrecognised option "openmp":
```
LINK : warning LNK4044: unrecognized option '/openmp'; ignored [...\build\opensubdiv\tools\stringify\stringify.vcxproj]
```
This is due to the fact that the configure process adds the compiler flags to the linker.
In "CMakeLists.txt":
```
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_CXX_FLAGS}")
```

The ["openmp"](https://docs.microsoft.com/en-us/cpp/build/reference/openmp-enable-openmp-2-0-support) flag is unknown by the linker, but used by the compiler.
The warnings can thus be ignored.
