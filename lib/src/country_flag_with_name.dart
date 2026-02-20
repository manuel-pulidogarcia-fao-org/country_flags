import 'country_flags.dart';
import 'country_names.dart';
import 'country_data.dart';
import 'flag_code.dart';
import 'package:flutter/material.dart';

/// {@template country_flag_with_name}
/// A widget that displays a country flag with its localized name.
///
/// The widget supports multiple languages: 'en', 'es', 'fr', 'ru', 'pt', 'zh', 'ar'.
///
/// Example:
/// ```dart
/// CountryFlagWithName.fromCountryCode(
///   'US',
///   languageCode: 'pt',
///   flagSize: 32,
/// )
/// ```
/// {@endtemplate}
class CountryFlagWithName extends StatelessWidget {
  /// Creates a [CountryFlagWithName] widget with a country code.
  ///
  /// The [countryCode] should be a valid ISO 3166-1 alpha-2 code (e.g., 'US', 'BR').
  /// The [languageCode] determines the language for the country name ('en', 'es', 'fr', 'ru', 'pt', 'zh', 'ar').
  const CountryFlagWithName({
    required this.countryCode,
    required this.languageCode,
    super.key,
    this.flagTheme = const ImageTheme(),
    this.textStyle,
    this.flagSize,
    this.spacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : _languageCodeForFlag = null,
        _m49Code = null;

  /// Creates a [CountryFlagWithName] widget from a language code.
  ///
  /// The [languageCodeForFlag] is used to determine which country flag to display.
  /// The [languageCode] determines the language for the country name.
  const CountryFlagWithName.fromLanguageCode(
    String languageCodeForFlag, {
    required this.languageCode,
    super.key,
    this.flagTheme = const ImageTheme(),
    this.textStyle,
    this.flagSize,
    this.spacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : countryCode = null,
        _languageCodeForFlag = languageCodeForFlag,
        _m49Code = null;

  /// Creates a [CountryFlagWithName] widget from a country code.
  ///
  /// This is a convenience constructor that's equivalent to the main constructor.
  const CountryFlagWithName.fromCountryCode(
    String countryCode, {
    required this.languageCode,
    super.key,
    this.flagTheme = const ImageTheme(),
    this.textStyle,
    this.flagSize,
    this.spacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : countryCode = countryCode,
        _languageCodeForFlag = null,
        _m49Code = null;

  /// Creates a [CountryFlagWithName] widget from an M49 code.
  const CountryFlagWithName.fromM49Code(
    int m49Code, {
    required this.languageCode,
    super.key,
    this.flagTheme = const ImageTheme(),
    this.textStyle,
    this.flagSize,
    this.spacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : countryCode = null,
        _languageCodeForFlag = null,
        _m49Code = m49Code;

  final String? countryCode;
  final String languageCode;
  final String? _languageCodeForFlag;
  final int? _m49Code;
  final FlagTheme flagTheme;
  final TextStyle? textStyle;
  final double? flagSize;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  String? _getFlagCode() {
    if (countryCode != null) {
      return FlagCode.fromCountryCode(countryCode!.toUpperCase());
    } else if (_languageCodeForFlag != null) {
      return FlagCode.fromLanguageCode(_languageCodeForFlag!.toLowerCase());
    } else if (_m49Code != null) {
      return FlagCode.fromM49Code(_m49Code!);
    }
    return null;
  }

  String? _getCountryCode() {
    if (countryCode != null) {
      return countryCode!.toUpperCase();
    } else if (_m49Code != null) {
      return CountryDataStore.getIso2FromM49(_m49Code!);
    } else if (_languageCodeForFlag != null) {
      final flagCode =
          FlagCode.fromLanguageCode(_languageCodeForFlag!.toLowerCase());
      if (flagCode != null) {
        return flagCode.toUpperCase();
      }
    }
    return null;
  }

  String? _getCountryName() {
    if (_m49Code != null) {
      return CountryNames.getNameByM49Code(_m49Code!,
          languageCode: languageCode);
    }
    final code = _getCountryCode();
    if (code != null) {
      return CountryNames.getName(code, languageCode: languageCode);
    }
    return null;
  }

  Widget _buildFlag() {
    final flagCode = _getFlagCode();
    if (flagCode == null) {
      return const SizedBox.shrink();
    }

    if (flagSize != null) {
      if (flagTheme is ImageTheme) {
        final imageTheme = flagTheme as ImageTheme;
        return CountryFlag.fromCountryCode(
          flagCode.toUpperCase(),
          theme: ImageTheme(
            width: flagSize,
            height: flagSize,
            shape: imageTheme.shape,
          ),
        );
      } else if (flagTheme is EmojiTheme) {
        return CountryFlag.fromCountryCode(
          flagCode.toUpperCase(),
          theme: EmojiTheme(size: flagSize),
        );
      }
    }

    return CountryFlag.fromCountryCode(
      flagCode.toUpperCase(),
      theme: flagTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final countryName = _getCountryName();
    final flag = _buildFlag();

    if (countryName == null) {
      return flag;
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        flag,
        SizedBox(width: spacing),
        Flexible(
          child: Text(
            countryName,
            style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
