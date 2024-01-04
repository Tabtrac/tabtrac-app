import 'app_utls.dart';

extension AppStringUtils on String {
  bool get isNum => AppUtils.isNum(this);

  bool get isNumericOnly => AppUtils.isNumericOnly(this);

  bool get isAlphabetOnly => AppUtils.isAlphabetOnly(this);

  bool get isBool => AppUtils.isBool(this);

  bool get isVectorFileName => AppUtils.isVector(this);

  bool get isImageFileName => AppUtils.isImage(this);

  bool get isAudioFileName => AppUtils.isAudio(this);

  bool get isVideoFileName => AppUtils.isVideo(this);

  bool get isTxtFileName => AppUtils.isTxt(this);

  bool get isDocumentFileName => AppUtils.isWord(this);

  bool get isExcelFileName => AppUtils.isExcel(this);

  bool get isPPTFileName => AppUtils.isPPT(this);

  bool get isAPKFileName => AppUtils.isAPK(this);

  bool get isPDFFileName => AppUtils.isPDF(this);

  bool get isHTMLFileName => AppUtils.isHTML(this);

  bool get isURL => AppUtils.isURL(this);

  bool get isEmail => AppUtils.isEmail(this);

  bool get isPhoneNumber => AppUtils.isPhoneNumber(this);

  bool get isDateTime => AppUtils.isDateTime(this);

  bool get isMD5 => AppUtils.isMD5(this);

  bool get isSHA1 => AppUtils.isSHA1(this);

  bool get isSHA256 => AppUtils.isSHA256(this);

  bool get isBinary => AppUtils.isBinary(this);

  bool get isIPv4 => AppUtils.isIPv4(this);

  bool get isIPv6 => AppUtils.isIPv6(this);

  bool get isHexadecimal => AppUtils.isHexadecimal(this);

  bool get isPalindrom => AppUtils.isPalindrom(this);

  bool get isPassport => AppUtils.isPassport(this);

  bool get isCurrency => AppUtils.isCurrency(this);

  bool get isCpf => AppUtils.isCpf(this);

  bool get isCnpj => AppUtils.isCnpj(this);

  bool isCaseInsensitiveContains(String b) =>
      AppUtils.isCaseInsensitiveContains(this, b);

  bool isCaseInsensitiveContainsAny(String b) =>
      AppUtils.isCaseInsensitiveContainsAny(this, b);

  String? get capitalizeN => AppUtils.capitalize(this);

  String? get capitalizeFirst => AppUtils.capitalizeFirst(this);

  String get removeAllWhitespace => AppUtils.removeAllWhitespace(this);

  String? get camelCase => AppUtils.camelCase(this);

  String? get paramCase => AppUtils.paramCase(this);

  String numericOnly({bool firstWordOnly = false}) =>
      AppUtils.numericOnly(this, firstWordOnly: firstWordOnly);

  String createPath([Iterable? segments]) {
    final path = startsWith('/') ? this : '/$this';
    return AppUtils.createPath(path, segments);
  }

  bool isPriceValid() {
    // Define a regular expression for a valid price format
    RegExp regExp = RegExp(r'^\d+(\.\d{1,2})?$');

    // Check if the input matches the regular expression
    return regExp.hasMatch(this);
  }
}
