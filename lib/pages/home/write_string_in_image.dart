import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:image/image.dart' as ui;

class WriteImageInString {
  static ui.Image drowS(
      ui.Image image, BitmapFont font, int x, int y, String string,
      {int color = 0xffffffff}) {
    print("drowS");
    var _r_lut = Uint8List(256);
    var _g_lut = Uint8List(256);
    var _b_lut = Uint8List(256);
    var _a_lut = Uint8List(256);

    /// Draw a string horizontally into [image] horizontally into [image] at position
    /// [x],[y] with the given [color].
    ///
    /// You can load your own font, or use one of the existing ones
    /// such as: [arial_14], [arial_24], or [arial_48].

    if (color != 0xffffffff) {
      final ca = getAlpha(color);
      if (ca == 0) {
        return image;
      }
      final num da = ca / 255.0;
      final num dr = getRed(color) / 255.0;
      final num dg = getGreen(color) / 255.0;
      final num db = getBlue(color) / 255.0;
      for (var i = 1; i < 256; ++i) {
        _r_lut[i] = (dr * i).toInt();
        _g_lut[i] = (dg * i).toInt();
        _b_lut[i] = (db * i).toInt();
        _a_lut[i] = (da * i).toInt();
      }
    }

    final chars = string.codeUnits;
    for (var c in chars) {
      if (!font.characters.containsKey(c)) {
        x += font.base ~/ 2;
        continue;
      }

      final ch = font.characters[c]!;

      final x2 = x + ch.height;
      final y2 = y + ch.width;
      var pi = 0;
      for (var yi = y; yi < y2; ++yi) {
        for (var xi = x; xi < x2; ++xi) {
          // print(ch.image);
          var p = ch.image[pi++];
          print(p);
          if (color != 0xffffffff) {
            p = getColor(_r_lut[getRed(p)], _g_lut[getGreen(p)],
                _b_lut[getBlue(p)], _a_lut[getAlpha(p)]);
          }
          drawPixel(image, xi + ch.xoffset, yi + ch.yoffset, p);
        }
      }

      x += ch.xadvance;
    }
    print("End Function");
    return image;
  }
}
