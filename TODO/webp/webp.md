
# WEBP

https://developers.google.com/speed/webp

Version 1.2.1.

Windows binaries are available for the latest version on th [download page](https://developers.google.com/speed/webp/download).
The provided binaries however are only for the 64 bits release build.


Uses (optional):
* zlib
* png
* jpeg
* tiff
* gif
* glut
* sdl
  => Needed?

(TODO: Missing PDB files for each dependency... => provide PDB with debug libs)


When building the shared libraries in Windows, no symbols are exported (due to missing export directives).
This causes the build to fail (essentially for the example apps), as the required symbols are not found by other modules, resulting in 'unresolved references'.

Some information about building shared libraries can be found:
https://github.com/imazen/libwebp-net/blob/master/libwebp-build-instructions.txt
https://developers.google.cn/speed/webp/faq?hl=zh-cn
But this seems obsolete and "broken" (see "makefile.vc")

FIX:
* Define a variable in "CMakeLists.txt" to indicate the build process.
  => For example "DLLBUILD".
* Define a specific Win32 case in "types.h", defining "__declspec(dllexport)" when building the libraries (when "DLLBUILD").
* Replace occurrences of "extern" in with "WEBP_EXTERN"
  => The change should be made to every occurrence of extern (Currently only done to the used functions causing problems).

The fix available on my [WebP Github fork](https://github.com/2-REC-forks/libwebp/tree/1.2.1_win_build).
(TODO: CHECK + COMMIT TO WEBP! - GoogleGit
https://chromium.googlesource.com/webm/libwebp/+/refs/tags/v1.2.1
https://www.webmproject.org/code/contribute/submitting-patches/
)


Additionally, some warnings are produced during the static build:
```
LINK : warning LNK4098: defaultlib 'LIBCMT' conflicts with use of other libs; use /NODEFAULTLIB:library
 [...\build\get_disto.vcxproj]
LINK : warning LNK4098: defaultlib 'LIBCMT' conflicts with use of other libs; use /NODEFAULTLIB:library
 [...\build\img2webp.vcxproj]
```
Can be removed by adding the following in "CMakeLists.txt":
* For 'img2webp', in the code block 'if(WEBP_BUILD_IMG2WEBP)':
  ```
  if( WIN32 )
    set_target_properties(img2webp PROPERTIES LINK_FLAGS "/NODEFAULTLIB:libcmt.lib")
  endif()
  ```
* For 'get_disto', in the code block 'if(WEBP_BUILD_EXTRAS)':
  ```
  if( WIN32 )
    set_target_properties(get_disto PROPERTIES LINK_FLAGS "/NODEFAULTLIB:libcmt.lib")
  endif()
  ```
