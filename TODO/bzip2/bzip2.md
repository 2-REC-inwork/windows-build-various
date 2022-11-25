
### BZIP2

https://gitlab.com/bzip2/bzip2

Version 1.0.8.

(TODO: valid for v1.0.8? want?
Can add Python 3 support:
```
-DPython3_EXECUTABLE="%PYTHON_PATH%\python.exe"
```
where 'PYTHON_PATH' is the path to Python 3 installation.
)


Can build by simply executing the command (after setting the VC environment with 'vcvars'):
(TODO: see how to specify debug|release, if possible?)
```
nmake -f makefile.msc
```
This will also generate the executables and perform tests.
If only want to build the library, the 'lib' parameter can be added:
```
nmake -f makefile.msc lib
```

(TODO: see how to specify release/debug, static/shared, 32/64, ...)

(TODO: solve how to make DLL with export symbols - need to modify code?
Can add rule in makefile:
```
dll: $(OBJS)
	$(CC) /D_USRDLL /D_WINDLL $(OBJS) /MT /link /DLL /out:libbz2.dll
```
but symbols are not exported in the DLL (there is however a "DEF" file provided...)
)

(TODO: where did get the DLLs from?)

