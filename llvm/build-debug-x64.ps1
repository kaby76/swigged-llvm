# BUILD SCRIPT FOR WINDOWS TARGETS

$ErrorActionPreference = "Stop"

# Invokes a Cmd.exe shell script and updates the environment.
function Invoke-CmdScript {
  param(
    [String] $scriptName
  )
  $cmdLine = """$scriptName"" $args & set"
  & $Env:SystemRoot\system32\cmd.exe /c $cmdLine |
  select-string '^([^=]*)=(.*)$' | foreach-object {
    $varName = $_.Matches[0].Groups[1].Value
    $varValue = $_.Matches[0].Groups[2].Value
    set-item Env:$varName $varValue
  }
}

Get-Date
Get-Location
rm x64-Debug -Recurse -Force -erroraction 'silentlycontinue'
rm x64-Debug.tar -Force -erroraction 'silentlycontinue'
rm x64-Debug.tar.gz -Force -erroraction 'silentlycontinue'
mkdir x64-Debug
Invoke-CmdScript "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvarsall.bat" x64
cd x64-Debug
cmake -Thost=x64 -DCMAKE_BUILD_TYPE=Debug -G "Visual Studio 15 2017 Win64" ..\llvm
msbuild LLVM.sln /p:Configuration=Debug /p:Platform=x64

exit 0

# If all works, then clean up everything, and create .tar.gz file.
rm Debug\bin\BuildingAJIT*.exe -Force -erroraction 'silentlycontinue'
rm Debug\bin\Fibonacci.exe -Force -erroraction 'silentlycontinue'
rm Debug\bin\HowToUseJIT.exe -Force -erroraction 'silentlycontinue'
rm Debug\bin\Kaleidoscope-*.exe -Force -erroraction 'silentlycontinue'
rm Debug\bin\llvm-c-test.exe -Force -erroraction 'silentlycontinue'
rm Debug\bin\llvm-lto*.exe -Force -erroraction 'silentlycontinue'
rm tools -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Analysis -Recurse -Force -erroraction 'silentlycontinue'
rm lib\AsmParser -Recurse -Force -erroraction 'silentlycontinue'
rm lib\BinaryFormat -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Bitcode -Recurse -Force -erroraction 'silentlycontinue'
rm lib\CodeGen -Recurse -Force -erroraction 'silentlycontinue'
rm lib\DebugInfo -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Demangle -Recurse -Force -erroraction 'silentlycontinue'
rm lib\ExecutionEngine -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Fuzzer -Recurse -Force -erroraction 'silentlycontinue'
rm lib\IR -Recurse -Force -erroraction 'silentlycontinue'
rm lib\IRReader -Recurse -Force -erroraction 'silentlycontinue'
rm lib\LineEditor -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Linker -Recurse -Force -erroraction 'silentlycontinue'
rm lib\LTO -Recurse -Force -erroraction 'silentlycontinue'
rm lib\MC -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Object -Recurse -Force -erroraction 'silentlycontinue'
rm lib\ObjectYAML -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Option -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Passes -Recurse -Force -erroraction 'silentlycontinue'
rm lib\ProfileData -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Support -Recurse -Force -erroraction 'silentlycontinue'
rm lib\TableGen -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Target -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Testing -Recurse -Force -erroraction 'silentlycontinue'
rm lib\ToolDrivers -Recurse -Force -erroraction 'silentlycontinue'
rm lib\Transforms -Recurse -Force -erroraction 'silentlycontinue'
rm lib\XRay -Recurse -Force -erroraction 'silentlycontinue'
rm examples -Recurse -Force -erroraction 'silentlycontinue'
rm Debug -Recurse -Force -erroraction 'silentlycontinue'
rm docs -Recurse -Force -erroraction 'silentlycontinue'
rm test -Recurse -Force -erroraction 'silentlycontinue'
rm unittests -Recurse -Force -erroraction 'silentlycontinue'
rm utils -Recurse -Force -erroraction 'silentlycontinue'
cd ..

bash -lc "mkdir x64-Debug/llvm"
bash -lc "cp -r ./llvm/include x64-Debug/llvm"
bash -lc "pwd"
bash -lc "ls -l x64-Debug"
bash -lc "tar cvf x64-Debug.tar x64-Debug"
bash -lc "gzip -9 x64-Debug.tar"

