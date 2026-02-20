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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Flags Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Country List'),
              subtitle: const Text('View all countries with flags'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CountryListPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Country Dropdown Search'),
              subtitle: const Text('Searchable dropdown with flags'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CountryDropdownExamplePage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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

class CountryDropdownExamplePage extends StatefulWidget {
  const CountryDropdownExamplePage({super.key});

  @override
  State<CountryDropdownExamplePage> createState() =>
      _CountryDropdownExamplePageState();
}

class _CountryDropdownExamplePageState
    extends State<CountryDropdownExamplePage> {
  String? _selectedIso2;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Dropdown Search'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Country',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            CountryDropdownSearch(
              unitedNationsFlagOption: true,
              selectedIso2: _selectedIso2,
              onCountryChanged: (iso2) {
                setState(() {
                  _selectedIso2 = iso2;
                });
              },
              languageCode: _selectedLanguage,
              emptyMessage: 'No countries found',
              noneLabel: 'Select a country',
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedIso2 != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Selected Country Information:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('ISO2 Code: $_selectedIso2'),
              const SizedBox(height: 8),
              Text(
                'Name (${_selectedLanguage.toUpperCase()}): ${CountryNames.getName(_selectedIso2!, languageCode: _selectedLanguage) ?? 'N/A'}',
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('• Searchable dropdown with country flags'),
            const Text('• Multi-language support'),
            const Text('• Displays flag and country name'),
            const Text('• Prints full country info when selected'),
            const Text('• Works with built-in country data'),
            const Text('• Can work with custom country lists from API'),
          ],
        ),
      ),
    );
  }
}
