
###### FLTK

https://www.fltk.org/

Github repo:
https://github.com/fltk/fltk

Version 1.3.7.

* Open ide/....sln in VS2019 (+convert to v142)
Raises this:
```
error : Designtime build failed for project 'C:\Users\2-REC\Documents\fltk\NEW\fltk-release-1.3.7\ide\VisualStudio2019\input_choice.vcxproj' configuration 'Debug|Win32'. IntelliSense might be unavailable.
	Set environment variable TRACEDESIGNTIME = true and restart Visual Studio to investigate.
```
=> Can ignore?

* Add "x64" in configuration types
  + set "IntDir" & "OutDir" for every project!
If not doing this, will have errors of the form:
```
fatal error C1090: PDB API call failed, error code '3': ...\project.dir\Debug\vc142.pdb
```
as by default the output directories and intermediate directories are set common to all projects.
More info on:
https://developercommunity.visualstudio.com/t/fatal-error-c1090-pdb-api-call-failed-error-code-3/552999#T-N793416


* Build

Error when building tests:
The "resizebox" module raises an error due to a defined macro later used for a variable name by a Windows header file ("winnt.h", included by one of the included FL header files):
```
resizebox.cxx
C:\Program Files (x86)\Windows Kits\10\Include\10.0.22000.0\um\winnt.h(6787,11): error C2059: syntax error: 'constant'
C:\Program Files (x86)\Windows Kits\10\Include\10.0.22000.0\um\winnt.h(6787,16): error C2238: unexpected token(s) preceding ';'
1>Done building project "resizebox.vcxproj" -- FAILED.
```
The macro is "B", defined in "test\resizebox.cxx".

To fix this issue, the macro definition should be moved to after the headers inclusion, avoiding the variable name to be substituted by the macro's value.
In the file "test\resizebox.cxx", move the following block to after the "include" lines:
```
#define W1 (big ? 60 : 40)
#define B 0
#define W3 (5*W1+6*B)
```
An alternative is to rename the macro to something unique.


* Install

* Copy the "FL" directory to "include"
* Copy all files from "ide\VisualC2010\FL" to "include"
  (this is currently only one file: abi-version.h)
  !? => Nothing?
* Copy all .lib files from the "lib" directory to "lib"
* Copy "fluid.exe" in the fluid directory to "bin"

It is discouraged to use the shared libraries (DLL) on Windows.
Use the static .lib libraries instead.

