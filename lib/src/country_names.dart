import 'country_names_data.dart';

class CountryNames {
  static String? getName(String countryCode, {String languageCode = 'en'}) {
    return CountryNamesData.getName(countryCode, languageCode: languageCode);
  }

  static Map<String, String> getAllNames({String languageCode = 'en'}) {
    return CountryNamesData.getAllNames(languageCode: languageCode);
  }

  static String? getNameByM49Code(int m49Code, {String languageCode = 'en'}) {
    return CountryNamesData.getNameByM49Code(m49Code,
        languageCode: languageCode);
  }

  static List<String> getSupportedLanguages() {
    return ['en', 'es', 'fr', 'ru', 'pt', 'zh', 'ar'];
  }
}
