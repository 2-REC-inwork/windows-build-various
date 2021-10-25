# TIFF


The 'libtiff.org' webiste seems to be abandonned, and has not been updated in a while (latest released version is v3.6.1).
Later versions can be found [here](http://www.simplesystems.org/libtiff/).
LibTIFF version 4.3.0 is used here.

The TIFF library can easily be [built from source](http://libtiff.maptools.org/build.html).
By default, the build doesn't provide support for external codecs, but depending on requirements, one might add some of them.


TODO: change titles...
#### Default Build

The simplest way to build the library is by executing the following command:
```batch
cmake -S tiff-4.3.0 -B build
```


#### External Codecs

The external codecs used by the TIFF library are the following:
* libdeflate
* JPEG 8/12 bit dual mode
* ISO JBIG
* LERC
* LZMA2
* ZSTD
* WEBP


(TODO: rephrase/check)
The following steps describe essential components for the build:

* Zlib
  See [ZLIB](TODO: link) for a description of how to build the library.

  The following build options need to be added to the TIFF library build command:
  ```batch
  -DZLIB_LIBRARY="%ZLIB_PATH%/lib/zlib.lib"
  -DZLIB_INCLUDE_DIR="%ZLIB_PATH%/include"
  ```
  With 'ZLIB_PATH' being the path where the ZLIB library is located.


* JPEG
  Can use either the classic 'libJPEG' or 'libJPEG-Turbo'.

  The following build options need to be added to the TIFF library build command:
  ```batch
 -DJPEG_LIBRARY="%JPEG_PATH%/lib/%BUILD_TYPE%/jpeg.lib"
 -DJPEG_INCLUDE_DIR="%JPEG_PATH%/include"
  ```

  With 'JPEG_PATH' being the path where the JPEG library is located (either libJPEG or libJPEG-Turbo).


* GLUT
  (TODO: leave here or move to "glut" page?)
  In order for the configure process to detect OpenGL and GLUT, it is required to specify the GLUT location for the OpenGL location, else it will not find the GLUT library (even if specified in the build flags).
  Without it, the process will display:
  ```
  -- Could NOT find GLUT (missing: GLUT_glut_LIBRARY)
  ```

  Additionally, the process will check for the following OpenGL include files, but will not find them, even if 'glut.h" has been copied to 'include/GL'.
  (TODO: these headers are missing, important?)
  check_include_file(GL/gl.h HAVE_GL_GL_H)
  check_include_file(GL/glu.h HAVE_GL_GLU_H)
  check_include_file(GL/glut.h HAVE_GL_GLUT_H)
  check_include_file(GLUT/glut.h HAVE_GLUT_GLUT_H)
  check_include_file(OpenGL/gl.h HAVE_OPENGL_GL_H)
  check_include_file(OpenGL/glu.h HAVE_OPENGL_GLU_H)

  The following configure options need to be added:
  ```batch
  -DOPENGL_LIBRARY_DIR="%GLUT_PATH%/lib/x64"
  -DGLUT_glut_LIBRARY="%GLUT_PATH%/lib/x64/freeglut.lib"
  -DGLUT_INCLUDE_DIR="%GLUT_PATH%/include"
  ```

  (TODO: other error:
  To solve:
    -- Could NOT find SDL (missing: SDL_LIBRARY SDL_INCLUDE_DIR)
  )


The build command including the external codecs will thus have the following form:
```batch
cmake -S %TIFF_SRC_PATH% -B %TIFF_DEST_PATH% ^
 -DZLIB_LIBRARY="%ZLIB_PATH%/lib/zlib.lib" ^
 -DZLIB_INCLUDE_DIR="%ZLIB_PATH%/include" ^
 -DJPEG_LIBRARY="%JPEG_PATH%/lib/%BUILD_TYPE%/jpeg.lib" ^
 -DJPEG_INCLUDE_DIR="%JPEG_PATH%/include" ^
 -DOPENGL_LIBRARY_DIR="%GLUT_PATH%/lib/x64" ^
 -DGLUT_glut_LIBRARY="%GLUT_PATH%/lib/x64/freeglut.lib" ^
 -DGLUT_INCLUDE_DIR="%GLUT_PATH%/include" ^
 "%TIFF_SRC_PATH%"
```
where 'TIFF_SRC_PATH' is the location of the TIFF source.

(TODO: add "install" command instead of opening VS)
Executing the command will generate the Visual Studio project files.
Open 'ALL_BUILD.vcxproj' in Visual Studio, and build the project (can do both 'Release' and 'Debug' if desired).



(TODO: ???? - CHECK!
OIIO configuration:
! - Doesn't find the TIFF library when using the build option 'TIFF_ROOT', and the library version isn't found either.
In order for the library to be found, the following options should be used:
```batch
-DTIFF_INCLUDE_DIR="%TIFF_PATH%\include"
-DTIFF_LIBRARY="%TIFF_PATH%\lib\%BUILD_TYPE%\tiff.lib"
-DTIFF_VERSION=4.3.0
```
There is probably a better (less 'hacky') way, but this works.
)


(TODO: COPY/MOVE LIB TO DEPS DIRECTORY or refer to original location)
The library location can then be added to the OIIO build process:
```batch
set TIFF_ROOT=%USERPROFILE%\Documents\OIIO\deps\tiff
```
