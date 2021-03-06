%include "typemaps.i"

%module LLVM

%{
#include <llvm-c/Core.h>
#include <llvm-c/Analysis.h>
#include <llvm-c/BitReader.h>
#include <llvm-c/BitWriter.h>
#include <llvm-c/Disassembler.h>
#include <llvm-c/ErrorHandling.h>
#include <llvm-c/ExecutionEngine.h>
#include <llvm-c/Initialization.h>
#include <llvm-c/IRReader.h>
#include <llvm-c/Linker.h>
//#include <llvm-c/LinkTimeOptimizer.h>
#include <llvm-c/OrcBindings.h>
#include <llvm-c/Support.h>
#include <llvm-c/Target.h>
#include <llvm-c/TargetMachine.h>
#include <llvm-c/Transforms/IPO.h>
#include <llvm-c/Transforms/PassManagerBuilder.h>
#include <llvm-c/Transforms/Scalar.h>
#include <llvm-c/Transforms/Vectorize.h>
//#include "Additional.h"
#include "llvm-c/DebugInfo.h"
%}

%csmethodmodifiers "public unsafe"

%rename("%(strip:[LLVM])s") "";
%rename("DIFlagPrivate") LLVMDIFlagPrivate;


%include <stdint.i>
%include "LLVMCommon.i"
%include "callback.i"

REF_CLASS(LLVMOrcJITStackRef, OrcJITStackRef)

%cs_callback(LLVMOrcLazyCompileCallbackFn, cppLLVMOrcLazyCompileCallbackFn)
typedef uint64_t (*LLVMOrcLazyCompileCallbackFn)(LLVMOrcJITStackRef JITStack, void *CallbackCtx);

%cs_callback(LLVMOrcSymbolResolverFn, cppLLVMOrcSymbolResolverFn)
typedef uint64_t (*LLVMOrcSymbolResolverFn)(const char *Name, void *LookupCtx);

   
%ignore LLVMContextSetDiagnosticHandler;
%ignore LLVMContextSetYieldCallback;
%ignore LLVMOrcAddObjectFile;
// No GUI, so ignore these functions.
%ignore LLVMViewFunctionCFG;
%ignore LLVMViewFunctionCFGOnly;

// Not sure to handle these. Implement one at a time in future.
%ignore LLVMConstIntOfArbitraryPrecision;
%ignore LLVMGetIndices;
%ignore LLVMDisasmInstruction;
%ignore LLVMCreateDisasm;
%ignore LLVMCreateDisasmCPU;
%ignore LLVMCreateDisasmCPUFeatures;
%ignore LLVMCreateSimpleMCJITMemoryManager;
//%ignore LLVMOrcAddEagerlyCompiledIR;
//%ignore LLVMOrcAddLazilyCompiledIR;
%ignore LLVMInstallFatalErrorHandler;
//%ignore LLVMOrcCreateLazyCompileCallback;
%ignore LLVMContextGetDiagnosticHandler;
%ignore LLVMDumpType; // LLVM 5.0 makes this conditional. Remove for now.

// Ignore for now-- LLVM writers do not care if it's declared wrong,
// which it is, as it's extern "C" in header, but not in lib. So it
// wont link.
%ignore LLVMInitializeInstCombine;

%ignore LLVMGetCurrentDebugLocation2;
%ignore LLVMDebugLocMetadata;

%ignore LLVMDIBuilderCreateBitFieldMemberType;
%ignore LLVMDIBuilderCreateClassType;
%ignore LLVMModuleFlagEntry;
%ignore LLVMCopyModuleFlagsMetadata;
%ignore LLVMDisposeModuleFlagsMetadata;
%ignore LLVMModuleFlagEntriesGetFlagBehavior;
%ignore LLVMModuleFlagEntriesGetKey;
%ignore LLVMModuleFlagEntriesGetMetadata;

%ignore LLVMAddAggressiveInstCombinerPass;
%ignore LLVMCreateOprofileJITEventListener;
%ignore LLVMInitializeAggressiveInstCombiner;



typedef bool LLVMBool;

REF_ARRAY(unsigned, uint)
REF_ARRAY(uint64_t, ulong)
REF_ARRAY(int64_t, long)
REF_ARRAY(uint8_t, byte)

REF_CLASS(LLVMJITEventListenerRef, JITEventListenerRef)
REF_CLASS(LLVMMCJITMemoryManagerRef, MCJITMemoryManagerRef)
REF_CLASS(LLVMAttributeRef, AttributeRef)
REF_CLASS(LLVMBasicBlockRef, BasicBlockRef)
REF_CLASS(LLVMBuilderRef, BuilderRef)
REF_CLASS(LLVMContextRef, ContextRef)
REF_CLASS(LLVMDiagnosticInfoRef, DiagnosticInfoRef)
REF_CLASS(LLVMMemoryBufferRef, MemoryBufferRef)
REF_CLASS(LLVMMetadataRef, MetadataRef)
REF_CLASS(LLVMModuleProviderRef, ModuleProviderRef)
REF_CLASS(LLVMModuleRef, ModuleRef)
REF_CLASS(LLVMExecutionEngineRef, ExecutionEngineRef)
REF_CLASS(LLVMGenericValueRef, GenericValueRef)
REF_CLASS(LLVMPassManagerBuilderRef, PassManagerBuilderRef)
REF_CLASS(LLVMPassManagerRef, PassManagerRef)
REF_CLASS(LLVMObjectFileRef, ObjectFileRef)
REF_CLASS(LLVMDisasmContextRef, DisasmContextRef)
REF_CLASS(LLVMPassRegistryRef, PassRegistryRef)
REF_CLASS(LLVMTargetDataRef, TargetDataRef)
REF_CLASS(LLVMTargetLibraryInfoRef, TargetLibraryInfoRef)
REF_CLASS(LLVMTargetMachineRef, TargetMachineRef)
REF_CLASS(LLVMTargetRef, TargetRef)
REF_CLASS(LLVMTypeRef, TypeRef)
REF_CLASS(LLVMUseRef, UseRef)
REF_CLASS(LLVMValueRef, ValueRef)
REF_CLASS(LLVMOpInfoSymbol1,OpInfoSymbol1)
REF_CLASS(LLVMOpInfo1,OpInfo1)

REF_CLASS(LLVMSharedModuleRef, SharedModuleRef)
REF_CLASS(LLVMSharedObjectBufferRef, SharedObjectBufferRef)
//REF_CLASS(LLVMOrcJITStackRef, OrcJITStackRef)
REF_CLASS(LLVMDIBuilderRef, DIBuilderRef)

%include "MCJITCompilerOptions.i"


%apply (LLVMTypeRef *ARRAY) {(LLVMTypeRef *Dest)};
%apply (LLVMTypeRef *ARRAY, unsigned ARRAYSIZE) {(LLVMTypeRef *ElementTypes, unsigned ElementCount)};
%apply (LLVMTypeRef *ARRAY, unsigned ARRAYSIZE) {(LLVMTypeRef *ParamTypes, unsigned ParamCount)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *Vals, unsigned Count)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *ConstantVals, unsigned Count)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *ConstantVals, unsigned Length)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *ScalarConstantVals, unsigned Size)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *ConstantIndices, unsigned NumIndices)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *Args, unsigned NumArgs)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *RetVals, unsigned N)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *Indices, unsigned NumIndices)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *Ptr, unsigned Count)};
%apply (LLVMValueRef *ARRAY, unsigned ARRAYSIZE) {(LLVMValueRef *AddrOps, unsigned AddrOpsCount)};
%apply (LLVMValueRef *ARRAY) {(LLVMValueRef *IncomingValues)};
%apply (LLVMDIDescriptor *ARRAY, unsigned ARRAYSIZE) {(LLVMDIDescriptor *Ptr, unsigned Count)};
%apply (LLVMBasicBlockRef *ARRAY, unsigned ARRAYSIZE) {(LLVMBasicBlockRef *IncomingBlocks, unsigned Count)};
%apply (unsigned *ARRAY, unsigned ARRAYSIZE) {(unsigned *IdxList, unsigned NumIdx)};
%apply (unsigned ARRAYSIZE, const uint64_t ARRAY[]) {(unsigned NumWords, const uint64_t Words[])};
%apply (int64_t *ARRAY, unsigned ARRAYSIZE) {(int64_t *Addresses, unsigned NumAddresses)};
%apply LLVMBool *OUTPUT { LLVMBool *losesInfo };

%include "llvm-c/Core.h"
%include "llvm-c/Analysis.h"
%include "llvm-c/BitReader.h"
%include "llvm-c/BitWriter.h"
%include "llvm-c/Disassembler.h"
%include "llvm-c/ErrorHandling.h"
%include "llvm-c/ExecutionEngine.h"   
%include "llvm-c/Initialization.h"
%include "llvm-c/IRReader.h"
%include "llvm-c/Linker.h"
//%include "llvm-c/LinkTimeOptimizer.h"
%include "llvm-c/OrcBindings.h"
%include "llvm-c/Support.h"
%include "llvm-c/Target.h"
%include "llvm-c/TargetMachine.h"
%include "llvm-c/Transforms/IPO.h"
%include "llvm-c/Transforms/PassManagerBuilder.h"
%include "llvm-c/Transforms/Scalar.h"
%include "llvm-c/Transforms/Vectorize.h"
//%include "Additional.h"
%include "llvm-c/DebugInfo.h"
   
