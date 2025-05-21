# 清理并重新生成所有项目
cd Thirdparty\DBoW2
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

cd Thirdparty\g2o
# 封装目录检查逻辑
function Reset-BuildDir {
    param($path)
    if (Test-Path $path) {
        Write-Host "Cleaning $path..." -ForegroundColor Yellow
        Remove-Item $path -Recurse -Force -ErrorAction Stop
    }
    New-Item -ItemType Directory -Path $path | Out-Null
}
Reset-BuildDir "build"
cd build
cmake .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_CONFIGURATION_TYPES=Release `
         -DCMAKE_CXX_FLAGS="/D_CRT_SECURE_NO_WARNINGS"
msbuild ALL_BUILD.vcxproj /p:Configuration=Release
cd ..\..\..
# 编译Pangolin
cd Thirdparty\Pangolin
Reset-BuildDir "build"
cd build
cmake .. -G "Visual Studio 17 2022" -A x64 `
         -DCMAKE_CONFIGURATION_TYPES=Release `
         -DBUILD_TESTS=OFF `
         -DBUILD_EXAMPLES=OFF
msbuild ALL_BUILD.vcxproj /p:Configuration=Release
cd ..\..\..

# 主项目编译
# 主项目目录检查
$mainBuild = "build"
if (Test-Path $mainBuild) {
    Write-Host "WARNING: Cleaning main build directory in 5 seconds..." -ForegroundColor Red
    Start-Sleep -Seconds 5  # 防止误删保护
    Remove-Item $mainBuild -Recurse -Force
}
# 创建并进入build目录
mkdir $buildPath | Out-Null
cd build
cmake .. -G "Visual Studio 17 2022" -A x64 `
         -DCMAKE_PREFIX_PATH="E:/Git/vcpkg/installed/x64-windows;${PWD}/Thirdparty/Pangolin/build" `
         -DOpenCV_DIR="D:/AI/opencv3/build" `
         -DBUILD_WITH_STATIC_CRT=ON
msbuild ORB_SLAM3.sln /p:Configuration=Release /m
cd ../