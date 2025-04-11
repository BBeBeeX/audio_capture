mkdir build\windows
cd build\windows

cmake ..\.. ^
  -DCMAKE_INSTALL_PREFIX="..\..\build\windows" ^
  -DCMAKE_TOOLCHAIN_FILE="..\..\windows.toolchain.cmake" ^
  -DOS=WINDOWS ^
  -DSHARED=YES

cmake --build . --config Release
cmake --install . --config Release

cd ..\..

mkdir prebuilt\windows

copy "build\windows\Release\audio_capture.dll" prebuilt\windows\audio_capture.dll

rmdir /s /q build\windows

echo Windows DLL build completed and output to the prebuilt\windows folder.
