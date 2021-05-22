import 'dart:typed_data';

import '../utils/ffi_wrapper.dart' as ffi;
import 'package:ffi/ffi.dart';

final _module = ffi.DynamicLibrary.open('sobar.dll');

final _nullString = ffi.Pointer<Utf8>.fromAddress(0);

final sbr_Initialize =
    _module.lookup<ffi.NativeFunction<ffi.Void Function()>>('sbr_Initialize').asFunction<void Function()>();
final sbr_Finalize =
    _module.lookup<ffi.NativeFunction<ffi.Void Function()>>('sbr_Finalize').asFunction<void Function()>();

final _sbr_PdfDocumentOpenFile = _module
    .lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>>('sbr_PdfDocumentOpenFile')
    .asFunction<int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>();

sbr_PdfDocument? sbr_PdfDocumentOpenFile(String fileName, String? password) {
  final fileNamePtr = fileName.toNativeUtf8();
  final passwordPtr = password?.toNativeUtf8() ?? _nullString;
  final ret = _sbr_PdfDocumentOpenFile(fileNamePtr, passwordPtr);
  malloc.free(fileNamePtr);
  malloc.free(passwordPtr);
  return sbr_PdfDocument._fromInt(ret);
}

final _sbr_PdfDocumentOpenMemory = _module
    .lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Uint8>, ffi.Uint32, ffi.Pointer<Utf8>)>>(
        'sbr_PdfDocumentOpenMemory')
    .asFunction<int Function(ffi.Pointer<ffi.Uint8>, int, ffi.Pointer<Utf8>)>();

sbr_PdfDocument? sbr_PdfDocumentOpenMemory(ffi.Pointer<ffi.Uint8> buffer, int size, String? password) {
  final passwordPtr = password?.toNativeUtf8() ?? _nullString;
  final ret = _sbr_PdfDocumentOpenMemory(buffer, size, passwordPtr);
  malloc.free(passwordPtr);
  return sbr_PdfDocument._fromInt(ret);
}

typedef _sbr_ContextReadCallback = ffi.Uint32 Function(ffi.IntPtr, ffi.Pointer<ffi.Uint8>, ffi.Uint32, ffi.Uint32);
typedef _sbr_ContextReleaseCallback = ffi.Void Function(ffi.IntPtr);

final _sbr_PdfDocumentOpenCustom = _module
    .lookup<
        ffi.NativeFunction<
            ffi.IntPtr Function(
                ffi.IntPtr,
                ffi.Uint32,
                ffi.Pointer<ffi.NativeFunction<_sbr_ContextReadCallback>>,
                ffi.Pointer<ffi.NativeFunction<_sbr_ContextReleaseCallback>>,
                ffi.Pointer<Utf8>)>>('sbr_PdfDocumentOpenCustom')
    .asFunction<
        int Function(int, int, ffi.Pointer<ffi.NativeFunction<_sbr_ContextReadCallback>>,
            ffi.Pointer<ffi.NativeFunction<_sbr_ContextReleaseCallback>>, ffi.Pointer<Utf8>)>();

sbr_PdfDocument? sbr_PdfDocumentOpenCustom(
    int context,
    int size,
    int Function(int context, ffi.Pointer<ffi.Uint8> buffer, int offset, int length) read,
    void Function(int context) release,
    String? password) {
  final ffi.Pointer<ffi.NativeFunction<_sbr_ContextReadCallback>> readPtr = ffi.Pointer.fromFunction(read, -1);
  final ffi.Pointer<ffi.NativeFunction<_sbr_ContextReleaseCallback>> releasePtr = ffi.Pointer.fromFunction(release);
  final passwordPtr = password?.toNativeUtf8() ?? _nullString;
  final ret = _sbr_PdfDocumentOpenCustom(context, size, readPtr, releasePtr, passwordPtr);
  malloc.free(passwordPtr);
  return sbr_PdfDocument._fromInt(ret);
}

final sbr_PdfDocumentClose = _module
    .lookup<ffi.NativeFunction<ffi.Void Function(ffi.IntPtr)>>('sbr_PdfDocumentClose')
    .asFunction<void Function(int)>();

final sbr_PdfDocumentGetPageCount = _module
    .lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.IntPtr)>>('sbr_PdfDocumentGetPageCount')
    .asFunction<int Function(int)>();

final sbr_PdfDocumentLoadPage = _module
    .lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.IntPtr, ffi.Uint32)>>('sbr_PdfDocumentLoadPage')
    .asFunction<int Function(int, int)>();

final sbr_PdfPageClose = _module
    .lookup<ffi.NativeFunction<ffi.Void Function(ffi.IntPtr)>>('sbr_PdfPageClose')
    .asFunction<void Function(int)>();

final sbr_PdfPageGetWidth = _module
    .lookup<ffi.NativeFunction<ffi.Double Function(ffi.IntPtr)>>('sbr_PdfPageGetWidth')
    .asFunction<double Function(int)>();

final sbr_PdfPageGetHeight = _module
    .lookup<ffi.NativeFunction<ffi.Double Function(ffi.IntPtr)>>('sbr_PdfPageGetHeight')
    .asFunction<double Function(int)>();

final sbr_PdfPageGetRotation = _module
    .lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.IntPtr)>>('sbr_PdfPageGetRotation')
    .asFunction<int Function(int)>();

enum sbr_PixelFormat {
  invalid,
  gray,
  bgr,
  bgra,
  rgb,
  rgba,
}

const _pf2int = {
  sbr_PixelFormat.invalid: 0,
  sbr_PixelFormat.gray: 1,
  sbr_PixelFormat.bgr: 2,
  sbr_PixelFormat.bgra: 3,
  sbr_PixelFormat.rgb: 4,
  sbr_PixelFormat.rgba: 5,
};

final _int2pf = _pf2int.reverseMap();

typedef _sbr_PdfBitmapOnReleaseCallback = ffi.Void Function(ffi.IntPtr context);

enum sbr_RotateClockwise {
  cw0, // normal
  cw90, // 90 degree clockwise
  cw180, // 180 degree
  cw270, // 270 degree clockwise
}

const _rot2int = {
  sbr_RotateClockwise.cw0: 0,
  sbr_RotateClockwise.cw90: 1,
  sbr_RotateClockwise.cw180: 2,
  sbr_RotateClockwise.cw270: 3,
};

enum sbr_RenderFlags {
  // Set if annotations are to be rendered.
  annot,
  // Set if using text rendering optimized for LCD display.
  textLCD,
  // Don't use the native text output available on some platforms
  noNativeTextRendering,
  // Grayscale output.
  grayscale,
  // Set if you want to get some debug info.
  debug,
  // Set if you don't want to catch exceptions.
  noCatch,
  // Limit image cache size.
  limitedCache,
  // Always use halftone for image stretching.
  halfTone,
  // Render for printing.
  forPrinting,
  // Set to disable anti-aliasing on text.
  noSmoothText,
  // Set to disable anti-aliasing on images.
  noSmoothImage,
  // Set to disable anti-aliasing on paths.
  noSmoothPath,
  // Set whether to render in a reverse Byte order, this flag is only used when
  // rendering to a bitmap.
  reverseByteOrder,
  // Don't white-fill before rendering actual image.
  noWhiteFill,
}

const _flag2int = {
  // Set if annotations are to be rendered.
  sbr_RenderFlags.annot: 1,
  // Set if using text rendering optimized for LCD display.
  sbr_RenderFlags.textLCD: 2,
  // Don't use the native text output available on some platforms
  sbr_RenderFlags.noNativeTextRendering: 4,
  // Grayscale output.
  sbr_RenderFlags.grayscale: 8,
  // Set if you want to get some debug info.
  sbr_RenderFlags.debug: 0x80,
  // Set if you don't want to catch exceptions.
  sbr_RenderFlags.noCatch: 0x100,
  // Limit image cache size.
  sbr_RenderFlags.limitedCache: 0x200,
  // Always use halftone for image stretching.
  sbr_RenderFlags.halfTone: 0x400,
  // Render for printing.
  sbr_RenderFlags.forPrinting: 0x800,
  // Set to disable anti-aliasing on text.
  sbr_RenderFlags.noSmoothText: 0x1000,
  // Set to disable anti-aliasing on images.
  sbr_RenderFlags.noSmoothImage: 0x2000,
  // Set to disable anti-aliasing on paths.
  sbr_RenderFlags.noSmoothPath: 0x4000,
  // Set whether to render in a reverse Byte order, this flag is only used when
  // rendering to a bitmap.
  sbr_RenderFlags.reverseByteOrder: 0x10,
  // Don't white-fill before rendering actual image.
  sbr_RenderFlags.noWhiteFill: 0x20,
};

final _sbr_PdfPageRender = _module
    .lookup<
        ffi.NativeFunction<
            ffi.Uint32 Function(ffi.IntPtr, ffi.IntPtr, ffi.Uint32, ffi.Uint32, ffi.Uint32, ffi.Uint32, ffi.Uint32,
                ffi.Uint32)>>('sbr_PdfPageRender')
    .asFunction<int Function(int, int, int, int, int, int, int, int)>();

int sbr_PdfPageRender(int page, int bmp, int x, int y, int width, int height, sbr_RotateClockwise rotate,
        List<sbr_RenderFlags> flags) =>
    _sbr_PdfPageRender(
        page, bmp, x, y, width, height, _rot2int[rotate]!, flags.fold(0, (all, f) => all += _flag2int[f]!));

final _sbr_PdfBitmapCreate = _module
    .lookup<
        ffi.NativeFunction<
            ffi.IntPtr Function(ffi.Uint32, ffi.Uint32, ffi.Uint32, ffi.Int32, ffi.Pointer<ffi.Uint8>,
                ffi.Pointer<ffi.NativeFunction<_sbr_PdfBitmapOnReleaseCallback>>, ffi.IntPtr)>>('sbr_PdfBitmapCreate')
    .asFunction<
        int Function(int, int, int, int, ffi.Pointer<ffi.Uint8>,
            ffi.Pointer<ffi.NativeFunction<_sbr_PdfBitmapOnReleaseCallback>>, int)>();

final sbr_PdfBitmapRelease = _module
    .lookup<ffi.NativeFunction<ffi.Void Function(ffi.IntPtr)>>('sbr_PdfBitmapRelease')
    .asFunction<void Function(int)>();

final _sbr_PdfBitmapGetPixelFormat = _module
    .lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.IntPtr)>>('sbr_PdfBitmapGetPixelFormat')
    .asFunction<int Function(int)>();

final sbr_PdfBitmapGetScan0Pointer = _module
    .lookup<ffi.NativeFunction<ffi.Pointer<ffi.Uint8> Function(ffi.IntPtr)>>('sbr_PdfBitmapGetScan0Pointer')
    .asFunction<ffi.Pointer<ffi.Uint8> Function(int)>();

final sbr_PdfBitmapGetStride = _module
    .lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.IntPtr)>>('sbr_PdfBitmapGetStride')
    .asFunction<int Function(int)>();

final sbr_PdfBitmapGetWidth = _module
    .lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.IntPtr)>>('sbr_PdfBitmapGetWidth')
    .asFunction<int Function(int)>();

final sbr_PdfBitmapGetHeight = _module
    .lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.IntPtr)>>('sbr_PdfBitmapGetHeight')
    .asFunction<int Function(int)>();

class sbr_PdfDocument {
  final int handle;
  const sbr_PdfDocument._(this.handle);
  static sbr_PdfDocument? _fromInt(int handle) => handle == 0 ? null : sbr_PdfDocument._(handle);

  static sbr_PdfDocument? openFile(String fileName, String? password) => sbr_PdfDocumentOpenFile(fileName, password);
  static sbr_PdfDocument? openData(Uint8List data, String? password) {
    return sbr_PdfDocumentOpenCustom(0, data.length, (context, buffer, offset, length) {
      for (int i = 0; i < length; i++) {
        buffer[i] = data[offset + i];
      }
      return length;
    }, (context) {}, password);
  }

  void dispose() => sbr_PdfDocumentClose(handle);

  int get pageCount => sbr_PdfDocumentGetPageCount(handle);

  sbr_PdfPage? loadPage(int pageNumber) => sbr_PdfPage._fromInt(sbr_PdfDocumentLoadPage(handle, pageNumber));
}

class sbr_PdfPage {
  final int handle;
  const sbr_PdfPage._(this.handle);
  static sbr_PdfPage? _fromInt(int handle) => handle == 0 ? null : sbr_PdfPage._(handle);

  void dispose() => sbr_PdfPageClose(handle);

  double get width => sbr_PdfPageGetWidth(handle);
  double get height => sbr_PdfPageGetHeight(handle);
  int get rotation => sbr_PdfPageGetRotation(handle);

  int render(
    sbr_PdfBitmap bmp,
    int x,
    int y,
    int width,
    int height,
    sbr_RotateClockwise rotate,
    List<sbr_RenderFlags> flags,
  ) =>
      sbr_PdfPageRender(
        handle,
        bmp.handle,
        x,
        y,
        width,
        height,
        rotate,
        flags,
      );
}

class sbr_PdfBitmap {
  final int handle;
  const sbr_PdfBitmap._(this.handle);
  static sbr_PdfBitmap? _fromInt(int handle) => handle == 0 ? null : sbr_PdfBitmap._(handle);

  static sbr_PdfBitmap? allocate(int width, int height, sbr_PixelFormat format) =>
      sbr_PdfBitmap._fromInt(_sbr_PdfBitmapCreate(
          width, height, _pf2int[format]!, 0, ffi.Pointer.fromAddress(0), ffi.Pointer.fromAddress(0), 0));

  void dispose() => sbr_PdfBitmapRelease(handle);

  sbr_PixelFormat get pixelFormat => _int2pf[_sbr_PdfBitmapGetPixelFormat(handle)]!;

  ffi.Pointer<ffi.Uint8> get scan0 => sbr_PdfBitmapGetScan0Pointer(handle);

  int get width => sbr_PdfBitmapGetWidth(handle);

  int get height => sbr_PdfBitmapGetHeight(handle);
}

extension MapExtension<K, V> on Map<K, V> {
  Map<V, K> reverseMap() => Map.fromEntries(entries.map((e) => MapEntry(e.value, e.key)));
}
