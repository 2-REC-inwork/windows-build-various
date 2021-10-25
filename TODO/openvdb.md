
# OPENVDB


https://www.openvdb.org/

Git:
https://github.com/AcademySoftwareFoundation/openvdb

Version 8.1.0 (VFX Reference Platform recommends 8.x)

In order to use OpenVDB in OpenImageIO, it must be compiled using C++14 minimum.
As we try to follow the VFX Reference Platform, C++17 is used.


Requires:
(- Zlib)
- Boost
- TBB
- Blosc

(TODO :should use VCPKG...)


When building OpenVDB with a more recent version of TBB (e.g. 2021.3.0, instead of 2020 Update 2), some errors occur:
```
...\tbb\x64\Release\include\tbb\../oneapi/tbb/parallel_reduce.h(379): error C2872: 'split': ambiguous symbol [
...\openvdb\openvdb\..\openvdb/math/Coord.h(16,23): message : could be 'tbb::split'
...\include\oneapi\tbb\detail/_range_common.h(36,7): message : or       'tbb::detail::d0::split'
...\include\tbb\../oneapi/tbb/parallel_reduce.h(394): message : see reference to class template instantiation 'tbb::detail::d1::lambda_reduce_body<Range,Value,RealBody,Reduction>' being compiled
```


#### BLOSC

(TODO: try with Blosc2?)

https://github.com/Blosc/c-blosc

Version 1.21.0.

When building OpenVDB with TBB, warrnings about the version are raised:
```
...\openvdb-8.1.0\CMakeLists.txt
"The version of Blosc located is greater than 1.5.0.  There have been
  reported issues with using later versions of Blosc with OpenVDB.  OpenVDB
  has been tested fully against Blosc 1.5.0, it is recommended that you use
  this version where possible."
```
But version 1.5.0 doesn't exist in Github releases!?
