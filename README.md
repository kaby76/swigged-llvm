# Swigged.LLVM

[![Build status](https://ci.appveyor.com/api/projects/status/7sb44ofy24qftk3j?svg=true)](https://ci.appveyor.com/project/kaby76/swigged-llvm)

This project is a [SWIG](http://swig.org)-generated wrapper of LLVM-C for C#.
Swigged.LLVM is based upon [SharpLang](https://github.com/xen2/SharpLang), 
a compiler for Microsoft's [CIL](https://en.wikipedia.org/wiki/Common_Intermediate_Language).
Swigged.LLVM recovers the SWIG wrapper for LLVM-C in Sharplang (now defunct), drops the CIL
reader and compiler, extends the API to contain additional LLVM-C functionality,
cleans up the problems with the original wrapper from SharpLang,
and adds more tests and examples of the API.

While there are downloadables from LLVM.org (http://releases.llvm.org/download.html#5.0.1),
these binaries do not contain the LLVM infrastructure that Swigged.LLVM can use.
Swigged.LLVM is built with binaries built from [https://github.com/kaby76/llvm](https://github.com/kaby76/llvm),
a clone of the LLVM repository, and contains tags, releases, and binaries for LLVM-C.
The build scripts for LLVM itself are in Swigged.LLVM:
[https://github.com/kaby76/swigged.llvm/tree/master/swigged-llvm/llvm](https://github.com/kaby76/swigged.llvm/tree/master/swigged-llvm/llvm).
Cmake is used to create a release, and works on Windows and Ubuntu. What is delivered in Swigged.LLVM is a complete,
self-contained library for LLVM-C.
I specifically chose not to publish the native library swigged-llvm-native.dll (.so)
in Nuget.org as a separate sub-project. It makes no sense to use the native library
without the accompanying C# library Swigged.LLVM.dll. Further, Nuget.org is quite cluttered
with dead and/or dubious sub-projects.

The build scripts in this project were derived mostly
by trial and error, especially for Windows,
from the documentation in LLVM (http://llvm.org/docs/CMake.html ) and
Android cmake (https://developer.android.com/ndk/guides/cmake.html ).

Note, I have found feature creep going across different
releases. The LLVM developers usually check in all changes into
the master branch. When a release is prepared, the developers
create a branch for the new release from the master branch.
Further, the LLVM developers tend to not check fully
builds for regressions.
[33455](https://bugs.llvm.org/show_bug.cgi?id=33455),
[34633](https://bugs.llvm.org/show_bug.cgi?id=34633),
[35947](https://bugs.llvm.org/show_bug.cgi?id=35947).
I found the documentation for LLVM frustrating,
specifically:
the instructions on building LLVM on Windows and Android;
the identification of what is going to be in a release;
bug reporting and fixing.

The examples here were culled and derived from a variety
of sources. The equivalent of the Kaleidoscope example is not provided here because it focuses too much on compiler construction
and little on the API itself. Swigged.LLVM is used in another project I am writing, [Campy](http://campynet.com/),
which compiles CIL into GPU code for parallel programming.

# Targets

* Windows 10 (x64)
* Ubuntu.16.04 (x64)

Swigged.llvm can be built and run in the Linux environment. Swigged.llvm is Net Standard 2.0 assembly.
It is compatible with Net Core 2.0 and Net Framework 4.6.1 and later versions.
Note, Swigged.llvm.native is a platform specific library.

## Using Swigged.llvm (from NuGet):

#### Net Core App on Windows or Linux
````
dotnet add package swigged.llvm
dotnet restore
dotnet build
````
On Linux, you will need to copy swigged-llvm-native.so to the directory containing
your application executable. On Windows, msbuild will perform the copy step automatically.

#### Net Framework App on Windows

Use the Package Manager GUI in VS 2017 to add in the package "swigged.llvm". Or,
download the package from NuGet (https://www.nuget.org/packages/swigged.llvm) and
add the package "swigged.llvm" from the nuget package manager console.

#### Further settings for all platforms

Set up the build of your C# application with Platform = "AnyCPU", Configuration = "Debug" or "Release".
You can do this in VS 2017 in the Properties for the
application: un-check "Prefer 32-bit" to run as 64-bit app.

# Example #

```cs
using System;
using System.Runtime.InteropServices;
using Swigged.LLVM;

namespace core.sanity_test
{
    class Program
    {
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        public delegate int Add(int a, int b);

        static void Main(string[] args)
        {
            ModuleRef mod = LLVM.ModuleCreateWithName("LLVMSharpIntro");
            TypeRef[] param_types = { LLVM.Int32Type(), LLVM.Int32Type() };
            TypeRef ret_type = LLVM.FunctionType(LLVM.Int32Type(), param_types, false);
            ValueRef sum = LLVM.AddFunction(mod, "sum", ret_type);
            BasicBlockRef entry = LLVM.AppendBasicBlock(sum, "entry");
            BuilderRef builder = LLVM.CreateBuilder();
            LLVM.PositionBuilderAtEnd(builder, entry);
            ValueRef tmp = LLVM.BuildAdd(builder, LLVM.GetParam(sum, 0), LLVM.GetParam(sum, 1), "tmp");
            LLVM.BuildRet(builder, tmp);
            MyString error= new MyString();
            LLVM.VerifyModule(mod, VerifierFailureAction.AbortProcessAction, error);
            System.Console.WriteLine(error);
            ExecutionEngineRef engine;
            LLVM.LinkInMCJIT();
            LLVM.InitializeNativeTarget();
            LLVM.InitializeNativeAsmPrinter();
            MCJITCompilerOptions options = new MCJITCompilerOptions();
            var optionsSize = (4 * sizeof(int)) + IntPtr.Size; // LLVMMCJITCompilerOptions has 4 ints and a pointer
            LLVM.InitializeMCJITCompilerOptions(options, (uint)optionsSize);
            LLVM.CreateMCJITCompilerForModule(out engine, mod, options, (uint)optionsSize, error);
            var ptr = LLVM.GetPointerToGlobal(engine, sum);
            IntPtr p = (IntPtr)ptr;
            Add addMethod = (Add)Marshal.GetDelegateForFunctionPointer(p, typeof(Add));
            int result = addMethod(10, 10);
            Console.WriteLine("Result of sum is: " + result);
            if (LLVM.WriteBitcodeToFile(mod, "sum.bc") != 0)
            {
                Console.WriteLine("error writing bitcode to file, skipping");
            }
            LLVM.DumpModule(mod);
            LLVM.DisposeBuilder(builder);
            LLVM.DisposeExecutionEngine(engine);
        }
    }
}
```

For more examples, see .../Examples/NetcoreApp

## Documentation of Swigged.llvm (Docfx):

http://domemtech.com/_site/api/Swigged.LLVM.html

## Documentation of LLVM-C (Doxygen):

http://llvm.org/docs/doxygen/html/modules.html

## Building Swigged.llvm/swigged.llvm.native:

### General requirements to build

* Swig
* Cmake
* Git
* VS 2017, with C++ installed (Windows)
* Python
* WSL Bash (Windows)
* These tools in path variable.

~~~~
# Optimized for DigitalOcean.com
sudo apt-get install git
sudo apt-get update
sudo apt-get install cmake
sudo apt-get install build-essential
~~~~
Make sure to install ("sudo apt-get install ...") gcc, make, 'g++', cmake,
git, build-essential, xz-utils. For Net Core, follow the instructions at
https://www.microsoft.com/net/core#linuxubuntu 

### Instructions

~~~~
git clone https://github.com/kaby76/swigged.llvm.git
cd swigged.llvm/swigged-llvm/llvm
git clone https://github.com/kaby76/llvm.git
~~~~

Note, after cloning LLVM, set the branch for the release you are interested in!

### Windows ###

From Powershell, execute BuildAll.ps1. If you want to generate for a version that is
different than the sources that the master branch is currently targeting, you will
need to run Swig. Further, the build is tuned for the VS2017/Release/x64 target. If you want,
you can target something else using Cmake. But, Cmake generates .SLN files that contain
full path names. This is why the build use Msbuild rather than Cmake on a daily basis. However,
there are build scripts in the source for Swigged.LLVM to use Cmake.

~~~~
cd .swig
cd ..
bash -c ./generate.sh
~~~~

### Ubuntu ###

From Bash, execute ./build.sh in swigged.llvm/.

## Debugging on Windows

Enable unmanaged debugging (<EnableUnmanagedDebugging>true</EnableUnmanagedDebugging>).

## Alternative LLVM Frameworks for C#

##### LLVMSharp (https://www.nuget.org/packages/LLVMSharp/3.9.1-rc3   https://github.com/Microsoft/LLVMSharp )

LLVMSharp is the C# LLVM bindings library from Microsoft. 
I was originally considering using LLVMSharp, but it was over a year out of
date, and had no idea if it was active anymore. Version 4 of LLVM was skipped entirely
when a new version was released for LLVM version 5.0.0, and 
I had no luck linking against a Net Framework application.

##### LLVM.NET (https://github.com/NETMF/Llvm.NET http://netmf.github.io/Llvm.NET/html/47ec5af0-5c1c-443e-b2b3-158a100dc594.htm )

This project is another C# LLVM bindings librarys.

Note, this project should not be confuse with another "LLVM.NET" library (aka "LLVM by Lost"),
https://bitbucket.org/lost/llvm.net/wiki/Home , http://www.nuget.org/packages/LLVM.NativeLibrary/ , which seems to be a wrapper for some LLVM DLLs built within the project.
It hasn't been updated in several years, so I don't think this project is active anymore.
