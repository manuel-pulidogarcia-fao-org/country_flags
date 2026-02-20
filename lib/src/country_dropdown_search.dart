import 'package:country_flags/country_flags.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CountryDropdownSearch<T> extends StatelessWidget {
  final String? selectedIso2;
  final void Function(String)? onCountryChanged;
  final String languageCode;
  final String? emptyMessage;
  final String? noneLabel;
  final InputDecoration? decoration;
  final double flagHeight;
  final double flagWidth;
  final bool showSearchBox;
  final List<T>? countries;
  final bool printCountryInfo;
  final String? Function(T)? getIso2;
  final String? Function(T)? getName;
  final Country? Function(T)? toCountryModel;
  final bool unitedNationsFlagOption;

  const CountryDropdownSearch({
    Key? key,
    this.selectedIso2,
    this.onCountryChanged,
    this.languageCode = 'en',
    this.emptyMessage,
    this.noneLabel,
    this.decoration,
    this.flagHeight = 20,
    this.flagWidth = 30,
    this.showSearchBox = true,
    this.countries,
    this.printCountryInfo = true,
    this.getIso2,
    this.getName,
    this.toCountryModel,
    this.unitedNationsFlagOption = false,
  }) : super(key: key);

  List<T> _getCountries() {
    if (countries != null && countries!.isNotEmpty) {
      final result = List<T>.from(countries!);
      if (unitedNationsFlagOption) {
        final unCountry = _createUnitedNationsCountry() as T;
        result.add(unCountry);
      }
      return result;
    }

    final allNames = CountryDataStore.getAllNames(languageCode: languageCode);
    final countryList = <Country>[];

    for (final entry in allNames.entries) {
      final iso2 = entry.key;
      final name = entry.value;
      final countryData = CountryDataStore.getCountryDataByIso2(iso2);

      if (countryData != null) {
        countryList.add(
          Country(
            name: name,
            iso2: iso2,
            iso3: countryData['ISO-alpha3 Code'] as String?,
            m49: countryData['M49 Code'] as int?,
            nameEn: countryData['name_en'] as String?,
            nameEs: countryData['name_es'] as String?,
            nameFr: countryData['name_fr'] as String?,
            nameRu: countryData['name_ru'] as String?,
            namePt: countryData['name_pt'] as String?,
            nameZh: countryData['name_zh'] as String?,
            nameAr: countryData['name_ar'] as String?,
          ),
        );
      }
    }

    if (unitedNationsFlagOption) {
      countryList.add(_createUnitedNationsCountry());
    }

    countryList.sort((a, b) {
      final nameA = a.getNameForLanguage(languageCode);
      final nameB = b.getNameForLanguage(languageCode);
      return nameA.compareTo(nameB);
    });

    return countryList as List<T>;
  }

  Country _createUnitedNationsCountry() {
    return Country(
      name: _getUnitedNationsName(languageCode),
      iso2: 'UN',
      iso3: 'UNO',
      nameEn: 'United Nations',
      nameEs: 'Naciones Unidas',
      nameFr: 'Nations Unies',
      nameRu: 'Организация Объединённых Наций',
      namePt: 'Nações Unidas',
      nameZh: '联合国',
      nameAr: 'الأمم المتحدة',
    );
  }

  String _getUnitedNationsName(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'en':
        return 'United Nations';
      case 'es':
        return 'Naciones Unidas';
      case 'fr':
        return 'Nations Unies';
      case 'ru':
        return 'Организация Объединённых Наций';
      case 'pt':
        return 'Nações Unidas';
      case 'zh':
        return '联合国';
      case 'ar':
        return 'الأمم المتحدة';
      default:
        return 'United Nations';
    }
  }

  String _getCountryName(T country) {
    if (getName != null) {
      return getName!(country) ?? '';
    }
    if (country is Country) {
      return country.getNameForLanguage(languageCode);
    }
    return country.toString();
  }

  String? _getCountryIso2(T country) {
    if (getIso2 != null) {
      return getIso2!(country);
    }
    if (country is Country) {
      return country.iso2;
    }
    return null;
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildFlagWidget(String? iso2) {
    if (iso2 == null || iso2.isEmpty) {
      return _buildUnknownFlag();
    }

    if (iso2.toUpperCase() == 'UN') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          'packages/country_flags/res/png/un_flag.png',
          width: flagWidth,
          height: flagHeight,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildUnknownFlag();
          },
        ),
      );
    }

    final flagCode = FlagCode.fromCountryCode(iso2);
    if (flagCode == null) {
      return _buildUnknownFlag();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CountryFlag.fromCountryCode(
        iso2,
        theme: ImageTheme(
          height: flagHeight,
          width: flagWidth,
        ),
      ),
    );
  }

  Widget _buildUnknownFlag() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: flagWidth,
        height: flagHeight,
        color: Colors.grey[300],
        child: Icon(
          Icons.help_outline,
          size: flagHeight * 0.6,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  InputDecoration _getDefaultDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputDecorationTheme = theme.inputDecorationTheme;

    BorderRadius getBorderRadius(InputBorder? border) {
      if (border is OutlineInputBorder) {
        return border.borderRadius;
      }
      return BorderRadius.circular(4.0);
    }

    final defaultBorderRadius = getBorderRadius(inputDecorationTheme.border);

    final defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: inputDecorationTheme.border is OutlineInputBorder
            ? (inputDecorationTheme.border as OutlineInputBorder)
                .borderSide
                .color
            : colorScheme.onSurface.withOpacity(0.38),
        width: inputDecorationTheme.border is OutlineInputBorder
            ? (inputDecorationTheme.border as OutlineInputBorder)
                .borderSide
                .width
            : 1.0,
      ),
      borderRadius: defaultBorderRadius,
    );

    final enabledBorder = inputDecorationTheme.enabledBorder ?? defaultBorder;
    final focusedBorder = inputDecorationTheme.focusedBorder ??
        OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2.0,
          ),
          borderRadius: defaultBorderRadius,
        );
    final errorBorder = inputDecorationTheme.errorBorder ??
        OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.0,
          ),
          borderRadius: defaultBorderRadius,
        );
    final focusedErrorBorder = inputDecorationTheme.focusedErrorBorder ??
        OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2.0,
          ),
          borderRadius: defaultBorderRadius,
        );

    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
      filled: inputDecorationTheme.filled,
      fillColor: inputDecorationTheme.fillColor ?? Colors.white,
      border: defaultBorder,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      disabledBorder: inputDecorationTheme.disabledBorder ?? defaultBorder,
      labelText: null,
      labelStyle: inputDecorationTheme.labelStyle,
      hintStyle: inputDecorationTheme.hintStyle,
      errorStyle: inputDecorationTheme.errorStyle,
    );
  }

  void _printCountryInfo(T country) {
    if (!printCountryInfo) return;

    Country? countryModel;
    if (toCountryModel != null) {
      countryModel = toCountryModel!(country);
    } else if (country is Country) {
      countryModel = country;
    }

    if (countryModel != null) {
      debugPrint('Selected Country Information:');
      debugPrint('  ISO2: ${countryModel.iso2}');
      debugPrint('  ISO3: ${countryModel.iso3}');
      debugPrint('  M49: ${countryModel.m49}');
      debugPrint(
        '  Name ($languageCode): ${countryModel.getNameForLanguage(languageCode)}',
      );
      debugPrint('  Name (en): ${countryModel.nameEn}');
      debugPrint('  Name (es): ${countryModel.nameEs}');
      debugPrint('  Name (fr): ${countryModel.nameFr}');
      debugPrint('  Name (ru): ${countryModel.nameRu}');
      debugPrint('  Name (pt): ${countryModel.namePt}');
      debugPrint('  Name (zh): ${countryModel.nameZh}');
      debugPrint('  Name (ar): ${countryModel.nameAr}');
    } else {
      final iso2 = _getCountryIso2(country);
      final name = _getCountryName(country);
      debugPrint('Selected Country Information:');
      debugPrint('  ISO2: $iso2');
      debugPrint('  Name: $name');
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryList = _getCountries();

    T? selectedCountry;
    if (selectedIso2 != null && countryList.isNotEmpty) {
      try {
        selectedCountry = countryList.firstWhere(
          (c) =>
              _getCountryIso2(c)?.toUpperCase() == selectedIso2!.toUpperCase(),
        );
      } catch (e) {
        selectedCountry = null;
      }
    }

    return DropdownSearch<T>(
      items: (filter, infiniteScrollProps) => countryList,
      selectedItem: selectedCountry,
      itemAsString: (T country) {
        final name = _getCountryName(country);
        return _capitalize(name);
      },
      filterFn: (T country, String filter) {
        final name = _getCountryName(country);
        final capitalizedName = _capitalize(name);
        return capitalizedName.toLowerCase().startsWith(filter.toLowerCase());
      },
      onChanged: (T? value) {
        if (value != null) {
          final iso2 = _getCountryIso2(value);
          if (iso2 != null) {
            _printCountryInfo(value);
            onCountryChanged?.call(iso2);
          }
        }
      },
      compareFn: (T c1, T c2) => _getCountryIso2(c1) == _getCountryIso2(c2),
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox,
        itemBuilder: (context, T country, bool isDisabled, bool isSelected) {
          final iso2 = _getCountryIso2(country);
          final name = _getCountryName(country);
          return Material(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFlagWidget(iso2),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      _capitalize(name),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            isSelected ? Theme.of(context).primaryColor : null,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        emptyBuilder: (context, string) {
          return Center(
            child: Text(emptyMessage ?? 'No data to display'),
          );
        },
      ),
      dropdownBuilder: (context, T? selectedItem) {
        if (selectedItem == null) {
          return Text(
            noneLabel ?? 'None',
            overflow: TextOverflow.ellipsis,
          );
        }
        final iso2 = _getCountryIso2(selectedItem);
        final name = _getCountryName(selectedItem);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFlagWidget(iso2),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                _capitalize(name),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: (decoration?.copyWith(labelText: null) ??
            _getDefaultDecoration(context)),
      ),
    );
  }
}
