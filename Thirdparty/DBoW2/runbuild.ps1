
# 检查并清空build目录
$buildPath = "build"
if (Test-Path $buildPath) {
    Write-Host "Cleaning existing build directory..." -ForegroundColor Yellow
    Remove-Item $buildPath -Recurse -Force
}
mkdir $buildPath | Out-Null
cd build
cmake .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_CONFIGURATION_TYPES=Release `
         -DOpenCV_DIR="D:/AI/opencv3/build"
msbuild ALL_BUILD.vcxproj /p:Configuration=Release
cd ..\..\..
