
# HDF5

https://www.hdfgroup.org/solutions/hdf5/

The source code can be downloaded from:
https://www.hdfgroup.org/downloads/hdf5/source-code/


(XXXX => PROBLEMS WITH PREBUILT (?!)
However, it seems like pre-built binaries are kept up-to-date, so they can be used here.
(TODO: should build from source)

To download the binaries without the need to log in, the binaries can be downloaded from the FTP site:
https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.1/bin/windows/

The MSI can be extracted without the need to install by executing the following command:
```batch
msiexec /a HDF5-1.12.1-win64.msi /qb TARGETDIR=<TARGET>
```

The pre-built binaries are built in release mode with debug information enabled.
(TODO: is this enough for debug build?)
)

(TODO: check!)
Requires ZLIB.
(TODO: add link)


From source:
* simple cmake script
* Need PERL? (doesn't seem to be required)
* Some features can be disabled if not required:
  * tools
  * utils
  * examples
  * Fortran bindings
  * Java bindings

Shared build by default.

