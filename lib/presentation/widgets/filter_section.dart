import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final String? selectedLanguage;
  final String? selectedYear;
  final Function(String?) onLanguageChanged;
  final Function(String?) onYearChanged;
  final List<String> availableLanguages;
  final List<String> availableYears;

  const FilterSection({
    super.key,
    this.selectedLanguage,
    this.selectedYear,
    required this.onLanguageChanged,
    required this.onYearChanged,
    required this.availableLanguages,
    required this.availableYears,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtrar por:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLanguageDropdown(context),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildYearDropdown(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                onLanguageChanged(null);
                onYearChanged(null);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Restablecer filtros'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Idioma',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedLanguage,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
            ),
            hint: const Text('Seleccionar idioma'),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todos los idiomas'),
              ),
              ...availableLanguages.map((language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(_getLanguageName(language)),
                );
              }).toList(),
            ],
            onChanged: (value) => onLanguageChanged(value),
          ),
        ),
      ],
    );
  }

  Widget _buildYearDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Año',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedYear,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
            ),
            hint: const Text('Seleccionar año'),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todos los años'),
              ),
              ...availableYears.map((year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
            ],
            onChanged: (value) => onYearChanged(value),
          ),
        ),
      ],
    );
  }

  String _getLanguageName(String languageCode) {
    final Map<String, String> languageNames = {
      'en': 'Inglés',
      'es': 'Español',
      'fr': 'Francés',
      'de': 'Alemán',
      'it': 'Italiano',
      'ja': 'Japonés',
      'ko': 'Coreano',
      'pt': 'Portugués',
      'ru': 'Ruso',
      'zh': 'Chino',
    };

    return languageNames[languageCode] ?? languageCode;
  }
}
