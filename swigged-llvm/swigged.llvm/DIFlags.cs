//------------------------------------------------------------------------------
// <auto-generated />
//
// This file was automatically generated by SWIG (http://www.swig.org).
// Version 3.0.12
//
// Do not make changes to this file unless you know what you are doing--modify
// the SWIG interface file instead.
//------------------------------------------------------------------------------

namespace Swigged.LLVM {

public enum DIFlags {
  DIFlagZero = 0,
  DIFlagPrivate = 1,
  DIFlagProtected = 2,
  DIFlagPublic = 3,
  DIFlagFwdDecl = 1 << 2,
  DIFlagAppleBlock = 1 << 3,
  DIFlagBlockByrefStruct = 1 << 4,
  DIFlagVirtual = 1 << 5,
  DIFlagArtificial = 1 << 6,
  DIFlagExplicit = 1 << 7,
  DIFlagPrototyped = 1 << 8,
  DIFlagObjcClassComplete = 1 << 9,
  DIFlagObjectPointer = 1 << 10,
  DIFlagVector = 1 << 11,
  DIFlagStaticMember = 1 << 12,
  DIFlagLValueReference = 1 << 13,
  DIFlagRValueReference = 1 << 14,
  DIFlagReserved = 1 << 15,
  DIFlagSingleInheritance = 1 << 16,
  DIFlagMultipleInheritance = 2 << 16,
  DIFlagVirtualInheritance = 3 << 16,
  DIFlagIntroducedVirtual = 1 << 18,
  DIFlagBitField = 1 << 19,
  DIFlagNoReturn = 1 << 20,
  DIFlagMainSubprogram = 1 << 21,
  DIFlagIndirectVirtualBase = (1 << 2)|(1 << 5),
  DIFlagAccessibility = DIFlagPrivate|DIFlagProtected|DIFlagPublic,
  DIFlagPtrToMemberRep = DIFlagSingleInheritance|DIFlagMultipleInheritance|DIFlagVirtualInheritance
}

}
