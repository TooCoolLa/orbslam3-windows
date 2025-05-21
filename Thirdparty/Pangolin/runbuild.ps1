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
cmake .. -G "Visual Studio 17 2022" -A x64 `
         -DCMAKE_CONFIGURATION_TYPES=Release `
         -DBUILD_TESTS=OFF `
         -DBUILD_EXAMPLES=OFF
msbuild ALL_BUILD.vcxproj /p:Configuration=Release
cd ..\..\..