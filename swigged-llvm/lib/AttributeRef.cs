//------------------------------------------------------------------------------
// <auto-generated />
//
// This file was automatically generated by SWIG (http://www.swig.org).
// Version 3.0.12
//
// Do not make changes to this file unless you know what you are doing--modify
// the SWIG interface file instead.
//------------------------------------------------------------------------------

namespace CSLLVM {

public partial struct AttributeRef : System.IEquatable<AttributeRef> {
		public AttributeRef(global::System.IntPtr cPtr)
		{
			Value = cPtr;
		}

		public System.IntPtr Value;

		public bool Equals(AttributeRef other)
		{
			return Value.Equals(other.Value);
		}

		public override bool Equals(object obj)
		{
			if (ReferenceEquals(null, obj)) return false;
			return obj is AttributeRef && Equals((AttributeRef)obj);
		}

		public override int GetHashCode()
		{
			return Value.GetHashCode();
		}

		public static bool operator ==(AttributeRef left, AttributeRef right)
		{
			return left.Equals(right);
		}

		public static bool operator !=(AttributeRef left, AttributeRef right)
		{
			return !left.Equals(right);
		}
	
}

}