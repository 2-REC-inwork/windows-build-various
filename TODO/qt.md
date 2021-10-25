
# QT


TODO: MAKE SEPARATE DOC/PROJECT!


Downloads:
https://www.qt.io/offline-installers

Build instructions:
https://doc.qt.io/qt-5/windows-building.html


It is essential to determine which components are required/desired, as the build process can take very long and require a lot of free space.
To considerably reduce build time and required disk space, documentation and examples can be removed from the build process

Additionally, depending on the needs, the Qt tools (such as Qt Assistant, Qt Creator, etc.) can be removed from the build.
To disable the build of the Qt tools, the following option can be used:
```
-skip qttools
```

There is another option to disable the tools:
```
-nomake tools
```
However, it seems that this option has no effect.
(TODO: Find out what it is doing, as the option is apparently valid)


(TODO: How to build debug libraries?
By default, seems like Qt is built in both release+debug:
```
Build options:
  Mode ................................... debug and release; default link: debug; optimized tools
```
=> Is this correct?
)


(TODO: where/how to specify 32 or 64 bits?)


#### REQUIREMENTS

Dependencies (as described in the [documentation](https://doc.qt.io/qt-5/windows-requirements.html)):
* OpenSSL Toolkit
  For secure network communication.
  Not mandatory in build. (skipped)
* ICU
  Without ICU support, self-contained applications are considerably smaller.
  Not set by default. Add '-icu' to configure command.
  Not mandatory, but recommended. (skipped)
  (TODO: Add ICU support (?))
* ANGLE
  Implementation of the OpenGL ES 2.0 API on top of DirectX 11 or DirectX 9.
  A version is included with Qt installers.
  Should be included in build.
  It is recommended to use dynamic OpenGL binding, by using '-opengl dynamic'.

Additionally, required for the build:
* ActivePerl: Executable must be in PATH
Strawberry PERL
  (! - TODO: can use 'ActivePERL'? - Recommended to build Qt, so better if possible to use same PERL)
* Python: Executable must be in PATH
  Using same version as for other builds: 3.7.9.
  (TODO: or should use Python 2.7 to allow QtWebEngine?)
* For ANGLE (they are provided in the 'gnuwin32/bin' folder):
  * GPerf from the GnuWin32 project
  * Bison, Flex from the Win flex-bison project
  The 'gnuwin32/bin' folder should be added to the PATH variable.

If want to build the doc, Clang is necessary.
    
Other 3rd party libraries are used by Qt:
* zlib
* libjpeg
* libpng
* freetype
* PCRE
* HarfBuzz-NG
Each library is provided with Qt, and used by default.
If preferred, the system versions can be used instead.
(TODO: see how to specify locations of libraries, to use other built versions)
Each library can also be disabled.


#### Modules

Qt5 is huge, and comes with a lot of [modules](https://doc.qt.io/qt-5/qtmodules.html).
Building the libraries with every module is generally not the best idea: A default build already takes more than 30GB.
It is thus advised to remove some modules from the build, as all of them aren't useful anyway.

The list of Qt modules can be obtained with:
```batch
configure -list-modules
```

Disabling a module can be done using the "skip" configuration option:
```batch
-skip <module_name>
```
where "<module_name>" is the module to skip.

(TODO: keep? - Would be better to provide way to display the list instead)


In our case of Windows build to be used with OIIO, a few modules should be skipped.
! - This is not an exhaustive list, and one might want to add or remove different modules.

OS specific modules (to skip, as building the libraries for Windows):
* qtandroidextras
* qtmacextras
* qtx11extras

Unnecessary modules (?):
* qtdoc
* qtgamepad
* qtlocation
* qtpurchasing
* qtsensors
* qtserialbus
* qtserialport
* qtspeech
* qtvirtualkeyboard
* qtwayland

Network related (skip for now):
* qtconnectivity
* qtwebchannel
* qtwebengine
* qtwebsockets
* qtwebview
* qtnetworkauth


##### QtWebEngine

QtWebEngine requires Python 2.7 and is not compatible with Python 3.
The recommended way seems to build the module separately linked with Python 2, and then [integrate it](https://www.qt.io/blog/building-qt-webengine-against-other-qt-versions) in th Qt build with Python 3.
(TODO: Test building QtWebEngine module independently and integrating with Qt)

For now, the module will be skipped by using:
```batch
-skip qtwebengine
```


#### Features

As with modules, Qt comes with a huge set of features, most of them not being required depending on the desired use of Qt.

The list of features can be obtained with:
```batch
configure -list-features
```

Disabling a feature can be done using a 'no-feature' configuration option specific to each feature:
```batch
-no-feature-<feature_name>
```
where '<feature_name>' is the feature to disable.


(TODO:
- Should add support for Autodesk FBX ('Qt 3D GeometryLoaders')
  => How?
)

