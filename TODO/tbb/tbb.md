
# TBB

(oneAPI Threading Building Blocks)[https://github.com/oneapi-src/oneTBB]

TBB is also required to allow the OpenVDB module.


XXX -version 2021.3.0
Version 2020 Update 2 (VFX Reference Platform CY2021).

https://github.com/oneapi-src/oneTBB/releases/tag/v2020.2
Get the source package (not the Windows specific 'tbb-2020.2-win.zip').


- Extract the archive
- Go to 'build' directory
- Copy vs2013 directory to vs2019, open 'makefile.sln' in vs2019
  => Convert the VS solution as well as the VC projects
- Select config (x64|Release)
- Build solution
(could be done with command line)

To use the library:
- Copy the generated 'x64' or 'win32' directory
- Copy the 'include' directory
