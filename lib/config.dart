import 'package:flutter/widgets.dart';

String getValueFromAttributes(
    Map<dynamic, String> map, String key, String prefix) {
  if (map.containsKey(key)) return map[key];
  final keyWithPrefix = prefix + key;
  if (map.containsKey(keyWithPrefix)) return map[keyWithPrefix];
  return null;
}

int parseInt(String value) {
  if (value?.isEmpty != false) return null;
  return int.parse(value);
}

class Config {
  final Uri baseUrl;
  final Color colorHyperlink;
  final List<double> sizeHeadings;
  final EdgeInsetsGeometry textWidgetPadding;

  const Config({
    this.baseUrl,
    this.colorHyperlink = const Color(0xFF1965B5),
    this.sizeHeadings = const [32.0, 24.0, 20.8, 16.0, 12.8, 11.2],
    this.textWidgetPadding = const EdgeInsets.all(5.0),
  });
}

abstract class ParsedNode {
  var processor;

  bool get isBlockElement => false;
  TextAlign get textAlign => null;
}

class ParsedNodeImage extends ParsedNode {
  final int height;
  final String src;
  final int width;

  ParsedNodeImage({this.height, @required this.src, this.width});

  @override
  bool get isBlockElement => true;

  static ParsedNodeImage fromAttributes(
    Map<dynamic, String> map, {
    String keyHeight = 'height',
    String keyPrefix = 'data-',
    String keySrc = 'src',
    String keyWidth = 'width',
  }) {
    final src = getValueFromAttributes(map, keySrc, keyPrefix);
    if (src?.isEmpty != false) return null;
    return ParsedNodeImage(
      height: parseInt(getValueFromAttributes(map, keyHeight, keyPrefix)),
      src: src,
      width: parseInt(getValueFromAttributes(map, keyWidth, keyPrefix)),
    );
  }
}

class ParsedNodeStyle extends ParsedNode {
  final Color color;
  final TextDecoration decoration;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final bool _isBlockElement;
  final TextAlign _textAlign;

  ParsedNodeStyle({
    this.color,
    this.decoration,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    bool isBlockElement,
    TextAlign textAlign,
  })  : _isBlockElement = isBlockElement,
        _textAlign = textAlign;

  @override
  bool get isBlockElement => _isBlockElement == true;

  @override
  TextAlign get textAlign => _textAlign;
}

class ParsedNodeText extends ParsedNode {
  final String text;

  ParsedNodeText({this.text});

  @override
  set processor(v) {}
}

class ParsedNodeUrl extends ParsedNode {
  final String href;

  ParsedNodeUrl({@required this.href});
}
