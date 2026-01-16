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

  /// File path: assets/images/mlp.png
  AssetGenImage get mlp => const AssetGenImage('assets/images/mlp.png');

  /// File path: assets/images/setor_sampah.png
  AssetGenImage get setorSampah =>
      const AssetGenImage('assets/images/setor_sampah.png');

  /// File path: assets/images/sirsak_app_icon.png
  AssetGenImage get sirsakAppIcon =>
      const AssetGenImage('assets/images/sirsak_app_icon.png');

  /// File path: assets/images/sirsak_logo_white.png
  AssetGenImage get sirsakLogoWhite =>
      const AssetGenImage('assets/images/sirsak_logo_white.png');

  /// File path: assets/images/sirsak_main_logo_green.png
  AssetGenImage get sirsakMainLogoGreen =>
      const AssetGenImage('assets/images/sirsak_main_logo_green.png');

  /// File path: assets/images/sirsak_main_logo_white.png
  AssetGenImage get sirsakMainLogoWhite =>
      const AssetGenImage('assets/images/sirsak_main_logo_white.png');

  /// File path: assets/images/trash_cans.png
  AssetGenImage get trashCans =>
      const AssetGenImage('assets/images/trash_cans.png');

  /// File path: assets/images/tutorial1.png
  AssetGenImage get tutorial1 =>
      const AssetGenImage('assets/images/tutorial1.png');

  /// File path: assets/images/tutorial2.png
  AssetGenImage get tutorial2 =>
      const AssetGenImage('assets/images/tutorial2.png');

  /// File path: assets/images/tutorial3.png
  AssetGenImage get tutorial3 =>
      const AssetGenImage('assets/images/tutorial3.png');

  /// File path: assets/images/tutorial4.png
  AssetGenImage get tutorial4 =>
      const AssetGenImage('assets/images/tutorial4.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    landingpageBackground,
    mlp,
    setorSampah,
    sirsakAppIcon,
    sirsakLogoWhite,
    sirsakMainLogoGreen,
    sirsakMainLogoWhite,
    trashCans,
    tutorial1,
    tutorial2,
    tutorial3,
    tutorial4,
  ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
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
