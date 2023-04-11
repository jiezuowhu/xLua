mkdir build64_51 & pushd build64_51
cmake -DLUA_VERSION=5.1.5 -G "Visual Studio 16 2019" -A x64 ..
popd
cmake --build build64_51 --config Release
md plugin_lua51\Plugins\x86_64
copy /Y build64_51\Release\xlua.dll plugin_lua51\Plugins\x86_64\xlua.dll
pause