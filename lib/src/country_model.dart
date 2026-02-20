class Country {
  final String? name;
  final String? iso2;
  final String? iso3;
  final int? m49;
  final String? nameEn;
  final String? nameEs;
  final String? nameFr;
  final String? nameRu;
  final String? namePt;
  final String? nameZh;
  final String? nameAr;

  Country({
    this.name,
    this.iso2,
    this.iso3,
    this.m49,
    this.nameEn,
    this.nameEs,
    this.nameFr,
    this.nameRu,
    this.namePt,
    this.nameZh,
    this.nameAr,
  });

  String getNameForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return nameEn ?? name ?? '';
      case 'es':
        return nameEs ?? name ?? '';
      case 'fr':
        return nameFr ?? name ?? '';
      case 'ru':
        return nameRu ?? name ?? '';
      case 'pt':
        return namePt ?? name ?? '';
      case 'zh':
        return nameZh ?? name ?? '';
      case 'ar':
        return nameAr ?? name ?? '';
      default:
        return nameEn ?? name ?? '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iso2': iso2,
      'iso3': iso3,
      'm49': m49,
      'nameEn': nameEn,
      'nameEs': nameEs,
      'nameFr': nameFr,
      'nameRu': nameRu,
      'namePt': namePt,
      'nameZh': nameZh,
      'nameAr': nameAr,
    };
  }

  @override
  String toString() {
    return 'Country(iso2: $iso2, iso3: $iso3, m49: $m49, name: $name)';
  }
}

