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

  /// File path: assets/images/block.svg
  String get block => 'assets/images/block.svg';

  /// File path: assets/images/chat.svg
  String get chat => 'assets/images/chat.svg';

  /// File path: assets/images/chat_white.svg
  String get chatWhite => 'assets/images/chat_white.svg';

  /// File path: assets/images/chats.svg
  String get chats => 'assets/images/chats.svg';

  /// File path: assets/images/contact_share.svg
  String get contactShare => 'assets/images/contact_share.svg';

  /// File path: assets/images/default_profile.png
  AssetGenImage get defaultProfile =>
      const AssetGenImage('assets/images/default_profile.png');

  /// File path: assets/images/document.svg
  String get document => 'assets/images/document.svg';

  /// File path: assets/images/edit.svg
  String get edit => 'assets/images/edit.svg';

  /// File path: assets/images/email.svg
  String get email => 'assets/images/email.svg';

  /// File path: assets/images/forgot_password.svg
  String get forgotPassword => 'assets/images/forgot_password.svg';

  /// File path: assets/images/group.svg
  String get group => 'assets/images/group.svg';

  /// File path: assets/images/login.svg
  String get login => 'assets/images/login.svg';

  /// File path: assets/images/logo.png
  AssetGenImage get logoPng => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/logo.svg
  String get logoSvg => 'assets/images/logo.svg';

  /// File path: assets/images/logout.svg
  String get logout => 'assets/images/logout.svg';

  /// File path: assets/images/mail_send.svg
  String get mailSend => 'assets/images/mail_send.svg';

  /// File path: assets/images/people.svg
  String get people => 'assets/images/people.svg';

  /// File path: assets/images/phone.svg
  String get phone => 'assets/images/phone.svg';

  /// File path: assets/images/private_chat.svg
  String get privateChat => 'assets/images/private_chat.svg';

  /// File path: assets/images/profile.svg
  String get profile => 'assets/images/profile.svg';

  /// File path: assets/images/register.svg
  String get register => 'assets/images/register.svg';

  /// File path: assets/images/report.svg
  String get report => 'assets/images/report.svg';

  /// File path: assets/images/search.svg
  String get search => 'assets/images/search.svg';

  /// File path: assets/images/security.svg
  String get security => 'assets/images/security.svg';

  /// File path: assets/images/settings.svg
  String get settings => 'assets/images/settings.svg';

  /// File path: assets/images/social_facebook.svg
  String get socialFacebook => 'assets/images/social_facebook.svg';

  /// File path: assets/images/social_google.svg
  String get socialGoogle => 'assets/images/social_google.svg';

  /// File path: assets/images/social_twitter.svg
  String get socialTwitter => 'assets/images/social_twitter.svg';

  /// File path: assets/images/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.png');

  /// File path: assets/images/video_call.svg
  String get videoCall => 'assets/images/video_call.svg';

  /// List of all assets
  List<dynamic> get values => [
        block,
        chat,
        chatWhite,
        chats,
        contactShare,
        defaultProfile,
        document,
        edit,
        email,
        forgotPassword,
        group,
        login,
        logoPng,
        logoSvg,
        logout,
        mailSend,
        people,
        phone,
        privateChat,
        profile,
        register,
        report,
        search,
        security,
        settings,
        socialFacebook,
        socialGoogle,
        socialTwitter,
        splash,
        videoCall
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
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
