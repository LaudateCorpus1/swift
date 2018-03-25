
// RUN: %target-swift-frontend -swift-version 4 -module-name properties -Xllvm -sil-full-demangle -parse-as-library -emit-silgen -disable-objc-attr-requires-foundation-module %s | %FileCheck %s

var zero: Int = 0

protocol ForceAccessors {
  var a: Int { get set }
}

struct DidSetWillSetTests: ForceAccessors {
  static var defaultValue: DidSetWillSetTests {
    return DidSetWillSetTests(a: 0)
  }

  var a: Int {
    // CHECK-LABEL: sil hidden @$S10properties010DidSetWillC5TestsV1a{{[_0-9a-zA-Z]*}}vw
    willSet(newA) {
      // CHECK: bb0(%0 : $Int, %1 : $*DidSetWillSetTests):

      a = zero  // reassign, but don't infinite loop.

      // CHECK: // function_ref properties.zero.unsafeMutableAddressor : Swift.Int
      // CHECK-NEXT: [[ZEROFN:%.*]] = function_ref @$S10properties4zero{{[_0-9a-zA-Z]*}}vau
      // CHECK-NEXT: [[ZERORAW:%.*]] = apply [[ZEROFN]]() : $@convention(thin) () -> Builtin.RawPointer
      // CHECK-NEXT: [[ZEROADDR:%.*]] = pointer_to_address [[ZERORAW]] : $Builtin.RawPointer to [strict] $*Int
      // CHECK-NEXT: [[READ:%.*]] = begin_access [read] [dynamic] [[ZEROADDR]] : $*Int
      // CHECK-NEXT: [[ZERO:%.*]] = load [trivial] [[READ]]
      // CHECK-NEXT: end_access [[READ]] : $*Int
      // CHECK-NEXT: [[WRITE:%.*]] = begin_access [modify] [unknown] %1
      // CHECK-NEXT: [[AADDR:%.*]] = struct_element_addr [[WRITE]] : $*DidSetWillSetTests, #DidSetWillSetTests.a
      // CHECK-NEXT: assign [[ZERO]] to [[AADDR]]

      var unrelatedValue = DidSetWillSetTests.defaultValue

      // CHECK: [[BOX:%.*]] = alloc_box ${ var DidSetWillSetTests }, var, name "unrelatedValue"
      // CHECK-NEXT: [[BOXADDR:%.*]] = project_box [[BOX]] : ${ var DidSetWillSetTests }, 0
      // CHECK-NEXT: [[METATYPE:%.*]] = metatype $@thin DidSetWillSetTests.Type
      // CHECK-NEXT: // function_ref static properties.DidSetWillSetTests.defaultValue.getter : properties.DidSetWillSetTests
      // CHECK-NEXT: [[DEFAULTVALUE_FN:%.*]] = function_ref @$S10properties{{[_0-9a-zA-Z]*}}vgZ : $@convention(method) (@thin DidSetWillSetTests.Type) -> DidSetWillSetTests
      // CHECK-NEXT: [[DEFAULTRESULT:%.*]] = apply [[DEFAULTVALUE_FN]]([[METATYPE]]) : $@convention(method) (@thin DidSetWillSetTests.Type) -> DidSetWillSetTests
      // CHECK-NEXT: store [[DEFAULTRESULT]] to [trivial] [[BOXADDR]] : $*DidSetWillSetTests

      // Access directly even when calling on another instance in order to maintain < Swift 5 behaviour.
      unrelatedValue.a = zero

      // CHECK-NEXT: // function_ref properties.zero.unsafeMutableAddressor : Swift.Int
      // CHECK-NEXT: [[ZEROFN:%.*]] = function_ref @$S10properties4zero{{[_0-9a-zA-Z]*}}vau
      // CHECK-NEXT: [[ZERORAW:%.*]] = apply [[ZEROFN]]() : $@convention(thin) () -> Builtin.RawPointer
      // CHECK-NEXT: [[ZEROADDR:%.*]] = pointer_to_address [[ZERORAW]] : $Builtin.RawPointer to [strict] $*Int
      // CHECK-NEXT: [[READ:%.*]] = begin_access [read] [dynamic] [[ZEROADDR]] : $*Int
      // CHECK-NEXT: [[ZERO:%.*]] = load [trivial] [[READ]]
      // CHECK-NEXT: end_access [[READ]] : $*Int

      // CHECK-NEXT: [[WRITE:%.*]] = begin_access [modify] [unknown] [[BOXADDR]] : $*DidSetWillSetTests
      // CHECK-NEXT: [[ELEMADDR:%.*]] = struct_element_addr [[WRITE]] : $*DidSetWillSetTests, #DidSetWillSetTests.a
      // CHECK-NEXT: assign [[ZERO]] to [[ELEMADDR]] : $*Int
      // CHECK-NEXT: end_access [[WRITE]] : $*DidSetWillSetTests
    }

    // CHECK-LABEL: sil hidden @$S10properties010DidSetWillC5TestsV1a{{[_0-9a-zA-Z]*}}vW
    didSet {
      (self).a = zero  // reassign, but don't infinite loop.

      // CHECK: // function_ref properties.zero.unsafeMutableAddressor : Swift.Int
      // CHECK-NEXT: [[ZEROFN:%.*]] = function_ref @$S10properties4zero{{[_0-9a-zA-Z]*}}vau
      // CHECK-NEXT: [[ZERORAW:%.*]] = apply [[ZEROFN]]() : $@convention(thin) () -> Builtin.RawPointer
      // CHECK-NEXT: [[ZEROADDR:%.*]] = pointer_to_address [[ZERORAW]] : $Builtin.RawPointer to [strict] $*Int
      // CHECK-NEXT: [[READ:%.*]] = begin_access [read] [dynamic] [[ZEROADDR]] : $*Int
      // CHECK-NEXT: [[ZERO:%.*]] = load [trivial] [[READ]]
      // CHECK-NEXT: end_access [[READ]] : $*Int
      // CHECK-NEXT: [[WRITE:%.*]] = begin_access [modify] [unknown] %1
      // CHECK-NEXT: [[AADDR:%.*]] = struct_element_addr [[WRITE]] : $*DidSetWillSetTests, #DidSetWillSetTests.a
      // CHECK-NEXT: assign [[ZERO]] to [[AADDR]]

      var unrelatedValue = DidSetWillSetTests.defaultValue

      // CHECK: [[BOX:%.*]] = alloc_box ${ var DidSetWillSetTests }, var, name "unrelatedValue"
      // CHECK-NEXT: [[BOXADDR:%.*]] = project_box [[BOX]] : ${ var DidSetWillSetTests }, 0
      // CHECK-NEXT: [[METATYPE:%.*]] = metatype $@thin DidSetWillSetTests.Type
      // CHECK-NEXT: // function_ref static properties.DidSetWillSetTests.defaultValue.getter : properties.DidSetWillSetTests
      // CHECK-NEXT: [[DEFAULTVALUE_FN:%.*]] = function_ref @$S10properties{{[_0-9a-zA-Z]*}}vgZ : $@convention(method) (@thin DidSetWillSetTests.Type) -> DidSetWillSetTests
      // CHECK-NEXT: [[DEFAULTRESULT:%.*]] = apply [[DEFAULTVALUE_FN]]([[METATYPE]]) : $@convention(method) (@thin DidSetWillSetTests.Type) -> DidSetWillSetTests
      // CHECK-NEXT: store [[DEFAULTRESULT]] to [trivial] [[BOXADDR]] : $*DidSetWillSetTests

      // Access directly even when calling on another instance in order to maintain < Swift 5 behaviour.
      unrelatedValue.a = zero

      // CHECK-NEXT: // function_ref properties.zero.unsafeMutableAddressor : Swift.Int
      // CHECK-NEXT: [[ZEROFN:%.*]] = function_ref @$S10properties4zero{{[_0-9a-zA-Z]*}}vau
      // CHECK-NEXT: [[ZERORAW:%.*]] = apply [[ZEROFN]]() : $@convention(thin) () -> Builtin.RawPointer
      // CHECK-NEXT: [[ZEROADDR:%.*]] = pointer_to_address [[ZERORAW]] : $Builtin.RawPointer to [strict] $*Int
      // CHECK-NEXT: [[READ:%.*]] = begin_access [read] [dynamic] [[ZEROADDR]] : $*Int
      // CHECK-NEXT: [[ZERO:%.*]] = load [trivial] [[READ]]
      // CHECK-NEXT: end_access [[READ]] : $*Int

      // CHECK-NEXT: [[WRITE:%.*]] = begin_access [modify] [unknown] [[BOXADDR]] : $*DidSetWillSetTests
      // CHECK-NEXT: [[ELEMADDR:%.*]] = struct_element_addr [[WRITE]] : $*DidSetWillSetTests, #DidSetWillSetTests.a
      // CHECK-NEXT: assign [[ZERO]] to [[ELEMADDR]] : $*Int
      // CHECK-NEXT: end_access [[WRITE]] : $*DidSetWillSetTests


      var other = self

      // CHECK: [[BOX:%.*]] = alloc_box ${ var DidSetWillSetTests }, var, name "other"
      // CHECK-NEXT: [[BOXADDR:%.*]] = project_box [[BOX]] : ${ var DidSetWillSetTests }, 0
      // CHECK-NEXT: [[READ_SELF:%.*]] = begin_access [read] [unknown] %1 : $*DidSetWillSetTests
      // CHECK-NEXT: copy_addr [[READ_SELF]] to [initialization] [[BOXADDR]] : $*DidSetWillSetTests
      // CHECK-NEXT: end_access [[READ_SELF]] : $*DidSetWillSetTests

      other.a = zero

      // CHECK-NEXT: // function_ref properties.zero.unsafeMutableAddressor : Swift.Int
      // CHECK-NEXT: [[ZEROFN:%.*]] = function_ref @$S10properties4zero{{[_0-9a-zA-Z]*}}vau
      // CHECK-NEXT: [[ZERORAW:%.*]] = apply [[ZEROFN]]() : $@convention(thin) () -> Builtin.RawPointer
      // CHECK-NEXT: [[ZEROADDR:%.*]] = pointer_to_address [[ZERORAW]] : $Builtin.RawPointer to [strict] $*Int
      // CHECK-NEXT: [[READ:%.*]] = begin_access [read] [dynamic] [[ZEROADDR]] : $*Int
      // CHECK-NEXT: [[ZERO:%.*]] = load [trivial] [[READ]]
      // CHECK-NEXT: end_access [[READ]] : $*Int

      // CHECK-NEXT: [[WRITE:%.*]] = begin_access [modify] [unknown] [[BOXADDR]] : $*DidSetWillSetTests
      // CHECK-NEXT: [[ELEMADDR:%.*]] = struct_element_addr [[WRITE]] : $*DidSetWillSetTests, #DidSetWillSetTests.a
      // CHECK-NEXT: assign [[ZERO]] to [[ELEMADDR]] : $*Int
      // CHECK-NEXT: end_access [[WRITE]] : $*DidSetWillSetTests
    }
  }
}
