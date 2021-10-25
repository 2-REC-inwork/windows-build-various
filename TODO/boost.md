
# Boost

The [Boost](https://www.boost.org/) library can be built from source.
Alternatively, precompiled binaries can be downloaded and installed, but it might be difficult to find the adequate/desired version.

Instructions on how to build Boost from source can be found for example [here](https://phylogeny.uconn.edu/tutorial-v2/part-1-ide-project-v2/setting-up-the-boost-c-library-v2/) or [here](https://theboostcpplibraries.com/introduction-installation).
(TODO: or
http://informilabs.com/building-boost-32-bit-and-64-bit-libraries-on-windows/
)
(TODO: other args:
b2 variant=release link=static runtime-link=static stageib
)
These documents cover older versions of the library, but the process shouldn't be very different for newer versions.

(TODO: rephrase)
! -Boost has a lot of dependencies and the default build might not be enough.

Boost 1.73.0 is the version used here (following VFX Reference Platform for CY2021).
Following is a basic description of the build process:
* Download [Boost](https://www.boost.org/) library source code
* Extract the archive to a desired location, which will be referred to as 'BOOST_ROOT'.
  E.g.:
  ```
  BOOST_ROOT = %USERPROFILE%\Documents\boost\boost_1_73_0
  ```
* Execute the script
  ```batch
  %BOOST_ROOT%\bootstrap.bat
  ```
  The compiler to use can be specified as a parameter, for example for 'vc142' (VS2019):
  ```batch
  %BOOST_ROOT%\bootstrap.bat vc142
  ```
* The generated 'project-config.jam' can be edited if want to specify which modules to build.
  By default, the build process will try to build everything (it can take a while).
  Boost.Python will not be built as not set in the config, but can be built after without the need to rebuild Boost.
* Build the Boost library using the following command (for 64 bit version):
  ```batch
  b2.exe link=shared address-model=64 threading=multi
  ```
  Or for static build:
  ```batch
  b2.exe link=static address-model=64 threading=multi
  ```
  (or:
  b2.exe link=static address-model=64 threading=multi runtime-link=static -j 12
  )
  Additional parameters can be set, such as the 'build' and 'stage' locations, though leaving the default values seems to make it easier to find the library.
  ! - The output displays default address model and architecture as respectively "32 bits" and "x86". The built libraries however will be built in 64 bits if it was specified in the command line.
* If the build process is successful, the 2 directories should be displayed:
  * The include files directory should be added to compiler include paths:
    ```batch
    %BOOST_ROOT%
    ```
  * The libraries directory should be added to linker library paths:
    ```batch
    %BOOST_ROOT%\stage\lib
    ```

Debug and release libraries are built simultanously, the debug libraries having an extra "gd" in the name, such as:
```
libboost_atomic-vc142-mt-gd-x64-1_73.lib  # debug library
libboost_atomic-vc142-mt-x64-1_73.lib     # release library
```


#### Boost.Python

By default, [Boost.Python](https://www.boost.org/doc/libs/1_70_0/libs/python/doc/html/building/installing_boost_python_on_your_.html) is not built with Boost (TODO: unless found default install?).

In "boost_src\project-config.jam", add the following line:
```
using python : : <PYTHON_PATH>\\python.exe ;
```
where "<PYTHON_PATH>" is the path to the Python installation

To build the module, the Boost build command can be executed again:
```
b2.exe link=shared address-model=64 threading=multi
```
The already built modules will not be rebuilt.

More details on how to build/install the moule can be found [here](https://valelab4.ucsf.edu/svn/3rdpartypublic/boost/libs/python/doc/building.html).


#### Build script

(TODO: rephrase)
The script should be similar to:
```batch
set BOOST_ROOT=%USERPROFILE%\Documents\boost\boost_1_73_0
cd %BOOST_ROOT%
start /wait /b cmd /c bootstrap.bat vc142
start /wait /b b2.exe link=shared address-model=64 threading=multi
```
(can add "-j 12" to use more threads during build)

(TODO: solve issue!)
However, there seems to be an issue when executing the script as a batch instead of exectuing the commands directly in a terminal window.
The process will raise the following error for several modules:
```
msvc.link.dll bin.v2\libs\python\build\msvc-14.2\debug\address-model-64\python-2.7\threading-multi\boost_python27-vc142-mt-gd-x64-1_73.dll
LINK : fatal error LNK1181: cannot open input file 'shared.obj'
```




#### Default Options

(TODO: rewrite)
    - zlib                     : no
    - bzip2                    : no
    - lzma                     : no
    - zstd                     : no
    - lzma                     : no  (cached)
    - has_lzma_cputhreads builds : no  (cached)
    - iconv (libc)             : no  (cached)
    - iconv (separate)         : no  (cached)
    - icu                      : no  (cached)
    - icu (lib64)              : no  (cached)
    - native-atomic-int32-supported : yes (cached)
    - message-compiler         : yes (cached)
    - native-syslog-supported  : no  (cached)
    - pthread-supports-robust-mutexes : no  (cached)
    - compiler-supports-ssse3  : yes (cached)
    - compiler-supports-avx2   : yes (cached)
    - gcc visibility           : no  (cached)
    - long double support      : yes (cached)
warning: skipping optional Message Passing Interface (MPI) library.
note: to enable MPI support, add "using mpi ;" to user-config.jam.
note: to suppress this message, pass "--without-mpi" to bjam.
note: otherwise, you can safely ignore this message.
    - libbacktrace builds      : no  (cached)
    - addr2line builds         : no  (cached)
    - WinDbg builds            : yes (cached)
    - WinDbgCached builds      : yes (cached)
    - BOOST_COMP_GNUC >= 4.3.0 : no  (cached)
    - zlib                     : no  (cached)
    - bzip2                    : no  (cached)
    - lzma                     : no  (cached)
    - zstd                     : no  (cached)


#### Linking


(TODO: more details?
Can have warnings when linking Boost libraries in a project:
```
New Boost version may have incorrect or missing dependencies and imported
  targets
```
but it doesn't seem to be a problem (from https://github.com/Microsoft/cpprestsdk/issues/1010):
"The warnings that are emitted are because the copy of Boost you're using is newer than the copy of cmake you're using,
 and the static dependency map that shipped inside cmake doesn't know about that version yet."
)


When linking Boost libraries in other projects, a lot of warnings are raised:
(TODO: can ignore? should fix?)
```
non-dll interface used for ...

...\boost/python/list.hpp(19,3):
 warning C4275: non dll-interface class 'boost::python::api::object' used as base for dll-interface struct 'boost::python::detail::list_base'
 [...\build\pxr\usd\bin\sdffilter\sdffilter.vcxproj]
```



(TODO: boost link)


! - Error when building with Boost static libraries: Looking for shared libraries (without "lib" prefix, though prefix is set in configuration options)
=> build pyilmbase with boost shared


python debug/release
https://valelab4.ucsf.edu/svn/3rdpartypublic/boost/libs/python/doc/building.html#python-debugging-builds
https://research.cs.wisc.edu/htcondor/wiki-archive/pages/NotesOnBuildingBoostPythonForWindows/
https://www.boost.org/doc/libs/1_77_0/tools/build/doc/html/index.html#bbv2.reference.tools.libraries.python
others:
https://github.com/pybind/pybind11/issues/1295
https://github.com/RUrlus/carma/pull/87
https://gitlab.kitware.com/cmake/cmake/-/issues/21531
https://stackoverflow.com/questions/56798472/force-linking-against-python-release-library-in-debug-mode-in-windows-visual-stu


(TODO: rephrase/clean)
Boost builds with Python release libraries, even when debug build.
Can be forced by defining "BOOST_DEBUG_PYTHON":
```
b2.exe link=shared address-model=64 threading=multi -j 12 define=BOOST_DEBUG_PYTHON
```
(TODO: OR TRY: (check if arguments are required
b2.exe link=shared address-model=64 threading=multi -j 12 define=BOOST_DEBUG_PYTHON python-debugging=on --debug-configuration
)
BUT: problem with numpy (and probably other libraries)

(TODO: fix issues, by building full python debug...
)
