
# GIF

http://giflib.sourceforge.net/

Version 5.2.1.


(TODO: add details for build - look at "infos.txt" in "OIIO/deps")
(had to create own VS sln+vcproj, +settings)
OIIO seems to require the static build, as when providing the dynamic library the following error occurs (amongst others:
```
gifinput.obj : error LNK2019: unresolved external symbol GifErrorString referenced in
 function "private: void __cdecl OpenImageIO_v2_2::GIFInput::report_last_error(void)"
 ...
```

