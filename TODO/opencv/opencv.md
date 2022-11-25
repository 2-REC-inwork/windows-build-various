
# OPENCV

https://opencv.org/
https://github.com/opencv

Information on how to build from source:
https://docs.opencv.org/4.5.2/d3/d52/tutorial_windows_install.html

Can build from master, but latest tag is probably more stable.
Tag 4.5.3 will be used here.

Has a lot of dependencies, so should do the build with an Internet access to let the automatic download+buimd of each library.
Many not found during build (see logs) - TODO: check if problematic.
(TODO: might want to add OpenCL support?)
+should add cuda, freetype, hdf, ... (?)



Requires Python 2 & 3 (?)
```
PYTHON3_EXECUTABLE
PYTHON2_EXECUTABLE
```
+numpy (distutils) (both Python 2 & 3)


! - OpenCV build requires a lot of free space (~6.5GB in debug!).

Can check OpenCV configuration information using the generated tool 'opencv_version_win32.exe'.


To build OpenCV as separate libraries (instead of the single 'world' library):
```batch
-DBUILD_opencv_world=OFF
```

The libraries are located in 'x64/vc16' subdirectory of the nuild.
These libraries can be moved to a 'lib' subdirectory next to the 'include' directory.
