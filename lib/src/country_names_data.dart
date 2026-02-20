import 'country_data.dart';

class CountryNamesData {
  static String? getName(String countryCode, {String languageCode = 'en'}) {
    final iso2 = CountryDataStore.getIso2FromIso3(countryCode) ??
        countryCode.toUpperCase();
    return CountryDataStore.getName(iso2, languageCode: languageCode);
  }

  static Map<String, String> getAllNames({String languageCode = 'en'}) {
    return CountryDataStore.getAllNames(languageCode: languageCode);
  }

  static String? getNameByM49Code(int m49Code, {String languageCode = 'en'}) {
    return CountryDataStore.getNameByM49Code(m49Code,
        languageCode: languageCode);
  }
}
