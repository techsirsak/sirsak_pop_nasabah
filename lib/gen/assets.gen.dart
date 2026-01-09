/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/landingpage_background.png
  AssetGenImage get landingpageBackground =>
      const AssetGenImage('assets/images/landingpage_background.png');

  /// List of all assets
  List<AssetGenImage> get values => [landingpageBackground];
}

class $AssetsVectorsGen {
  const $AssetsVectorsGen();

  /// File path: assets/vectors/landingpage1.svg
  String get landingpage1 => 'assets/vectors/landingpage1.svg';

  /// File path: assets/vectors/landingpage2.svg
  String get landingpage2 => 'assets/vectors/landingpage2.svg';

  /// File path: assets/vectors/landingpage3.svg
  String get landingpage3 => 'assets/vectors/landingpage3.svg';

  /// File path: assets/vectors/landingpage4.svg
  String get landingpage4 => 'assets/vectors/landingpage4.svg';

  /// File path: assets/vectors/sirsak_logo_white.svg
  String get sirsakLogoWhite => 'assets/vectors/sirsak_logo_white.svg';

  /// List of all assets
  List<String> get values =>
      [landingpage1, landingpage2, landingpage3, landingpage4, sirsakLogoWhite];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsVectorsGen vectors = $AssetsVectorsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
