import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Flags Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CountryListPage(),
    );
  }
}

class CountryListPage extends StatefulWidget {
  const CountryListPage({super.key});

  @override
  State<CountryListPage> createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  String _selectedLanguage = 'en';
  final List<String> _supportedLanguages = [
    'en',
    'es',
    'fr',
    'ru',
    'pt',
    'zh',
    'ar'
  ];

  @override
  Widget build(BuildContext context) {
    final countryNames =
        CountryNames.getAllNames(languageCode: _selectedLanguage);
    final sortedEntries = countryNames.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: _supportedLanguages.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Text(lang.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedLanguage = value;
                });
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: sortedEntries.length,
        itemBuilder: (context, index) {
          final entry = sortedEntries[index];
          final iso2 = entry.key;
          final name = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CountryFlag.fromCountryCode(
                    iso2,
                    theme: const ImageTheme(
                      height: 20,
                      width: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
