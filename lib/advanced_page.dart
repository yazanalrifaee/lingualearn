import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Map<String, String> languageCodes = {
  'Arabic': 'ar',
  'Spanish': 'es',
  'French': 'fr',
};

class AdvancedPage extends StatefulWidget {
  final String selectedLanguage;

  const AdvancedPage({Key? key, required this.selectedLanguage})
      : super(key: key);

  @override
  _advancedPageState createState() => _advancedPageState();
}

class _advancedPageState extends State<AdvancedPage> {
  late Future<List<String>> intermediateWords;

  @override
  void initState() {
    super.initState();
    intermediateWords = fetchAdvancedWords();
  }

  Future<List<String>> fetchAdvancedWords() async {
    final response = await http.get(
        Uri.parse('https://llinguallearn.000webhostapp.com/getAdvanced.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => item['word'] as String).toList();
    } else {
      throw Exception('Failed to load advanced words');
    }
  }

  Future<String> fetchTranslation(String word) async {
    String languageCode = languageCodes[widget.selectedLanguage] ?? 'ar';
    final response = await http.get(
        Uri.parse('https://api.mymemory.translated.net/get?q=$word&langpair=en|$languageCode'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['responseData']['translatedText'];
    } else {
      throw Exception('Failed to load translation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 241, 246, 1.0),
      appBar: AppBar(
        title: const Text(
          'Advanced Level',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(70, 194, 160, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: intermediateWords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Failed to fetch advanced words');
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Learn Advanced Words:',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromRGBO(70, 194, 160, 1.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...snapshot.data!
                      .map((word) => FutureWordTile(
                            word: word,
                            icon: Icons.help,
                            fetchTranslationCallback: fetchTranslation,
                          ))
                      .toList(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class FutureWordTile extends StatelessWidget {
  final String word;
  final IconData icon;
  final Future<String> Function(String) fetchTranslationCallback;

  const FutureWordTile({
    Key? key,
    required this.word,
    required this.icon,
    required this.fetchTranslationCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchTranslationCallback(word),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Failed to fetch translation for $word');
        } else {
          return WordTile(
              word: word, translation: snapshot.data ?? '', icon: icon);
        }
      },
    );
  }
}

class WordTile extends StatelessWidget {
  final String word;
  final String translation;
  final IconData icon;

  const WordTile(
      {Key? key,
        required this.word,
        required this.translation,
        required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(226, 241, 246, 1.0),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromRGBO(70, 194, 160, 1.0),
              content: Text('$word in your selected language: $translation',
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40.0,
                color: const Color.fromRGBO(70, 194, 160, 1.0),
              ),
              const SizedBox(height: 8),
              Text(
                word,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromRGBO(70, 194, 160, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
