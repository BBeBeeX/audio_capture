// Auto-generated file, do not edit.
// Generated by `package:ffigen`.
// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// FFI bindings to the audio capture DLL.
class audio_capture_bindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  audio_capture_bindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  audio_capture_bindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void __va_start(
    ffi.Pointer<va_list> arg0,
  ) {
    return ___va_start(
      arg0,
    );
  }

  late final ___va_startPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<va_list>)>>(
          '__va_start');
  late final ___va_start =
      ___va_startPtr.asFunction<void Function(ffi.Pointer<va_list>)>();

  void __security_init_cookie() {
    return ___security_init_cookie();
  }

  late final ___security_init_cookiePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>(
          '__security_init_cookie');
  late final ___security_init_cookie =
      ___security_init_cookiePtr.asFunction<void Function()>();

  void __security_check_cookie(
    int _StackCookie,
  ) {
    return ___security_check_cookie(
      _StackCookie,
    );
  }

  late final ___security_check_cookiePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          '__security_check_cookie');
  late final ___security_check_cookie =
      ___security_check_cookiePtr.asFunction<void Function(int)>();

  void __report_gsfailure(
    int _StackCookie,
  ) {
    return ___report_gsfailure(
      _StackCookie,
    );
  }

  late final ___report_gsfailurePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          '__report_gsfailure');
  late final ___report_gsfailure =
      ___report_gsfailurePtr.asFunction<void Function(int)>();

  late final ffi.Pointer<ffi.UintPtr> ___security_cookie =
      _lookup<ffi.UintPtr>('__security_cookie');

  int get __security_cookie => ___security_cookie.value;

  set __security_cookie(int value) => ___security_cookie.value = value;

  bool InitializeAudioCapture(
    ffi.Pointer<ffi.Char> deviceId,
  ) {
    return _InitializeAudioCapture(
      deviceId,
    );
  }

  late final _InitializeAudioCapturePtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Char>)>>(
          'InitializeAudioCapture');
  late final _InitializeAudioCapture = _InitializeAudioCapturePtr.asFunction<
      bool Function(ffi.Pointer<ffi.Char>)>();

  bool StartAudioCapture() {
    return _StartAudioCapture();
  }

  late final _StartAudioCapturePtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function()>>('StartAudioCapture');
  late final _StartAudioCapture =
      _StartAudioCapturePtr.asFunction<bool Function()>();

  void StopAudioCapture() {
    return _StopAudioCapture();
  }

  late final _StopAudioCapturePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('StopAudioCapture');
  late final _StopAudioCapture =
      _StopAudioCapturePtr.asFunction<void Function()>();

  bool GetAudioData(
    ffi.Pointer<ffi.Float> buffer,
    int bufferSize,
  ) {
    return _GetAudioData(
      buffer,
      bufferSize,
    );
  }

  late final _GetAudioDataPtr = _lookup<
      ffi.NativeFunction<
          ffi.Bool Function(ffi.Pointer<ffi.Float>, ffi.Int)>>('GetAudioData');
  late final _GetAudioData =
      _GetAudioDataPtr.asFunction<bool Function(ffi.Pointer<ffi.Float>, int)>();

  void GetAudioFormat(
    ffi.Pointer<ffi.Int> sampleRate,
    ffi.Pointer<ffi.Int> channels,
  ) {
    return _GetAudioFormat(
      sampleRate,
      channels,
    );
  }

  late final _GetAudioFormatPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Int>, ffi.Pointer<ffi.Int>)>>('GetAudioFormat');
  late final _GetAudioFormat = _GetAudioFormatPtr.asFunction<
      void Function(ffi.Pointer<ffi.Int>, ffi.Pointer<ffi.Int>)>();

  void CleanupAudioCapture() {
    return _CleanupAudioCapture();
  }

  late final _CleanupAudioCapturePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('CleanupAudioCapture');
  late final _CleanupAudioCapture =
      _CleanupAudioCapturePtr.asFunction<void Function()>();
}

typedef va_list = ffi.Pointer<ffi.Char>;
typedef ptrdiff_t = ffi.LongLong;
typedef Dartptrdiff_t = int;
typedef int_least8_t = ffi.SignedChar;
typedef Dartint_least8_t = int;
typedef int_least16_t = ffi.Short;
typedef Dartint_least16_t = int;
typedef int_least32_t = ffi.Int;
typedef Dartint_least32_t = int;
typedef int_least64_t = ffi.LongLong;
typedef Dartint_least64_t = int;
typedef uint_least8_t = ffi.UnsignedChar;
typedef Dartuint_least8_t = int;
typedef uint_least16_t = ffi.UnsignedShort;
typedef Dartuint_least16_t = int;
typedef uint_least32_t = ffi.UnsignedInt;
typedef Dartuint_least32_t = int;
typedef uint_least64_t = ffi.UnsignedLongLong;
typedef Dartuint_least64_t = int;
typedef int_fast8_t = ffi.SignedChar;
typedef Dartint_fast8_t = int;
typedef int_fast16_t = ffi.Int;
typedef Dartint_fast16_t = int;
typedef int_fast32_t = ffi.Int;
typedef Dartint_fast32_t = int;
typedef int_fast64_t = ffi.LongLong;
typedef Dartint_fast64_t = int;
typedef uint_fast8_t = ffi.UnsignedChar;
typedef Dartuint_fast8_t = int;
typedef uint_fast16_t = ffi.UnsignedInt;
typedef Dartuint_fast16_t = int;
typedef uint_fast32_t = ffi.UnsignedInt;
typedef Dartuint_fast32_t = int;
typedef uint_fast64_t = ffi.UnsignedLongLong;
typedef Dartuint_fast64_t = int;
typedef intmax_t = ffi.LongLong;
typedef Dartintmax_t = int;
typedef uintmax_t = ffi.UnsignedLongLong;
typedef Dartuintmax_t = int;

const int _VCRT_COMPILER_PREPROCESSOR = 1;

const int _SAL_VERSION = 20;

const int __SAL_H_VERSION = 180000000;

const int _USE_DECLSPECS_FOR_SAL = 0;

const int _USE_ATTRIBUTES_FOR_SAL = 0;

const int _CRT_PACKING = 8;

const int _VCRUNTIME_DISABLED_WARNINGS = 4514;

const int _HAS_EXCEPTIONS = 1;

const int _WCHAR_T_DEFINED = 1;

const int NULL = 0;

const int _HAS_CXX17 = 0;

const int _HAS_CXX20 = 0;

const int _HAS_CXX23 = 0;

const int _HAS_NODISCARD = 1;

const int INT8_MIN = -128;

const int INT16_MIN = -32768;

const int INT32_MIN = -2147483648;

const int INT64_MIN = -9223372036854775808;

const int INT8_MAX = 127;

const int INT16_MAX = 32767;

const int INT32_MAX = 2147483647;

const int INT64_MAX = 9223372036854775807;

const int UINT8_MAX = 255;

const int UINT16_MAX = 65535;

const int UINT32_MAX = 4294967295;

const int UINT64_MAX = -1;

const int INT_LEAST8_MIN = -128;

const int INT_LEAST16_MIN = -32768;

const int INT_LEAST32_MIN = -2147483648;

const int INT_LEAST64_MIN = -9223372036854775808;

const int INT_LEAST8_MAX = 127;

const int INT_LEAST16_MAX = 32767;

const int INT_LEAST32_MAX = 2147483647;

const int INT_LEAST64_MAX = 9223372036854775807;

const int UINT_LEAST8_MAX = 255;

const int UINT_LEAST16_MAX = 65535;

const int UINT_LEAST32_MAX = 4294967295;

const int UINT_LEAST64_MAX = -1;

const int INT_FAST8_MIN = -128;

const int INT_FAST16_MIN = -2147483648;

const int INT_FAST32_MIN = -2147483648;

const int INT_FAST64_MIN = -9223372036854775808;

const int INT_FAST8_MAX = 127;

const int INT_FAST16_MAX = 2147483647;

const int INT_FAST32_MAX = 2147483647;

const int INT_FAST64_MAX = 9223372036854775807;

const int UINT_FAST8_MAX = 255;

const int UINT_FAST16_MAX = 4294967295;

const int UINT_FAST32_MAX = 4294967295;

const int UINT_FAST64_MAX = -1;

const int INTPTR_MIN = -9223372036854775808;

const int INTPTR_MAX = 9223372036854775807;

const int UINTPTR_MAX = -1;

const int INTMAX_MIN = -9223372036854775808;

const int INTMAX_MAX = 9223372036854775807;

const int UINTMAX_MAX = -1;

const int PTRDIFF_MIN = -9223372036854775808;

const int PTRDIFF_MAX = 9223372036854775807;

const int SIZE_MAX = -1;

const int SIG_ATOMIC_MIN = -2147483648;

const int SIG_ATOMIC_MAX = 2147483647;

const int WCHAR_MIN = 0;

const int WCHAR_MAX = 65535;

const int WINT_MIN = 0;

const int WINT_MAX = 65535;

const int __bool_true_false_are_defined = 1;

const int false$ = 0;

const int true$ = 1;
