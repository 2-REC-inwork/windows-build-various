
# DCMTK

(TODO: abandonned for now => not trivial to build on Windows (because of its dependencies), and seems like non-free anyway?)
(
https://bugs.gentoo.org/754216
https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=48384290f8a27812d3c260117d3fc0691748dee5
)


DICOM Toolkit
https://dicom.offis.de/dcmtk.php.en

Version 3.6.6.

Some binaries are provided, but for VS2017, so might be preferable to build the libraries.

(TODO: DCMTK build process should be modified to be more flexible - Python's location, libraries names, etc.)

Dependencies:
- icu4c 68.2
  with-libicuinc (?)
  From 'INSTALL' document:
    "... DCMTK relies
    on one of the following alternatives to be available for being used as the
    underlying implementation: libiconv, the ICU library or the iconv functionality
    included in the C standard library.

    DCMTK detects the availability of these implementations and (in case multiple
    ones are available) chooses one of them automatically as follows: the libiconv
    implementation is currently preferred since its integration is most mature.  If
    it is not available, the ICU implementation is the next best choice.  Otherwise
    the iconv implementation from the C standard library will be selected (if the
    used C standard library provides it)."
  => Can thus ignore this library and provide 'libiconv'.
- libiconv 1.16
  "WITH_LIBICONVINC"
- libpng 1.6.37
  "WITH_LIBPNGINC"
- libxml2 2.9.10
  "WITH_LIBXMLINC"
- libtiff 4.2.0 - 4.3.0?
  "WITH_LIBTIFFINC"
- zlib 1.2.11
  "WITH_ZLIBINC"
- openjpeg 2.4.0
  with-libjpeginc (????)


The dependencies headers and library files are expected to respectively be found in each directories' subdirectories "include" and "lib".
Additionally, the expected names for each library are:
- libxml2:
 "iconv_d.lib"       - debug version
 "iconv_o.lib"       - release version (optimized)
 "libxml2_d.lib"     - debug version
 "libxml2_o.lib"     - release version (optimized)

- libpng:
 "libpng_d.lib"      - debug version
 "libpng_o.lib"      - release version (optimized)

- libtiff:
 "libtiff_d.lib"     - debug version
 "libtiff_o.lib"     - release version (optimized)

- openssl:
 "dcmtkcrypto_d.lib" - debug version
 "dcmtkcrypto_o.lib" - release version (optimized)
 "dcmtkssl_d.lib"    - debug version
 "dcmtkssl_o.lib"    - release version (optimized)

- zlib:
 "zlib_d.lib"        - debug version
 "zlib_o.lib"        - release version (optimized)

- libiconv:
  "libiconv_d.lib"    - debug version
  "libiconv_o.lib"    - release version (optimized)
  "libchset_d.lib"    - debug version
  "libchset_o.lib"    - release version (optimized)


Can turn off with "DCMTK_WITH_XXX" (exmple "DCMTK_WITH_TIFF").

Additionally (not mentionned on website):
- openssl: Should add support? (https://www.openssl.org/)
  "WITH_OPENSSLINC"
- libsndfile: Can probably be ignored here, as related to sound (https://github.com/libsndfile/libsndfile)


#### ICU4C

[International Components for Unicode](https://github.com/unicode-org/icu) for C/C++.
Version 68.2.

https://github.com/unicode-org/icu/releases

Windows binaries are provided, and seem to be up-to-date.

Can also build from source.
Tests require Python 3, which is found by using Python launcher 'py.exe'.
Hence the build process will fail if Python is not installed, unless the test projects (TODO: which project(s) exactly?) are removed/deactivated.
(TODO: find ways to build without tests from cmd line)

(The generated files are not all exactly the same as the provided binaries, however all the 'lib' files are identical.)


#### LIBICONV

https://www.gnu.org/software/libiconv/
https://savannah.gnu.org/projects/libiconv/

Version 1.16.

Only in tar.gz format.


As detailled in the 'INSTALL.windows' document provided with the source code, the suggested way of building the library is using Cygwin.

A portable version can be used:
https://sourceforge.net/projects/cygwin-portable/

Add required packages to install in 'cygwin-portable\cygwin-portable-config.bat' (for 64 bits):
```
set CYGWIN_PACKAGES=make,mingw64-x86_64-gcc-core,mingw64-x86_64-headers,mingw64-x86_64-runtime
```
Then execute the setup script:
cygwin-portable-setup.cmd
to install portable Cygwin.
(requires Internet connection)

Start a terminal with:
cygwin-portable-terminal.cmd

And follow the instructions from the installation document.
(alternatively, can use the provided script, it will build in the 'install' sudirectory)

! - Be careful about the line endings, can use the 'dos2unix' tool to fix:
```
..\cygwin\bin\dos2unix script.sh
```

Rename .a/dll.a to .lib (?)



#### LIBXML2

http://xmlsoft.org/
Version 2.9.10.

http://xmlsoft.org/sources/win32/
Windows binaries are provided, but not for the latest version, so the libraries should be built.

Can get the source archive in ZIP format from the [Gitlab repository](https://gitlab.gnome.org/GNOME/libxml2).


...
(old windows files + requires iconv vproj...)
...
(TODO: abandonned for now)


#### OPENJPEG

See [OpenJPEG](TODO: link to other).
