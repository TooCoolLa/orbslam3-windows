
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
