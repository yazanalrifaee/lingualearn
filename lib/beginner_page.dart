import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

final Map<String, String> languageCodes = {
  'Arabic': 'ar',
  'Spanish': 'es',
  'French': 'fr',
  'German': 'de',
  'Chinese': 'zh',
  'Italian': 'it',
  'Russian': 'ru',
  'Portuguese': 'pt',
  'Japanese': 'ja'
};

class BeginnerPage extends StatefulWidget {
  final String selectedLanguage;

  const BeginnerPage({Key? key, required this.selectedLanguage})
      : super(key: key);

  @override
  _BeginnerPageState createState() => _BeginnerPageState();
}

class _BeginnerPageState extends State<BeginnerPage> {
  late Future<List<Map<String, dynamic>>> beginnerWords;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    beginnerWords = fetchBeginnerWords();
    flutterTts = FlutterTts();
  }

  Future<List<Map<String, dynamic>>> fetchBeginnerWords() async {
    final response = await http.get(
        Uri.parse('https://llinguallearn.000webhostapp.com/getBeginner.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((item) => {
                'word': item['word'] as String,
                'emoji': item['emoji'] as String,
              })
          .toList();
    } else {
      throw Exception('Failed to load beginner words');
    }
  }

  Future<String> fetchTranslation(String word) async {
    String languageCode = languageCodes[widget.selectedLanguage] ?? 'ar';
    final response = await http.get(Uri.parse(
        'https://api.mymemory.translated.net/get?q=$word&langpair=en|$languageCode'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['responseData']['translatedText'];
    } else {
      throw Exception('Failed to load translation');
    }
  }

  void playTranslatedWord(String translatedText) async {
    String languageCode = languageCodes[widget.selectedLanguage] ?? 'en';
    await flutterTts.setLanguage(languageCode);
    await flutterTts.speak(translatedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 241, 246, 1.0),
      appBar: AppBar(
        title: const Text('Beginner Level', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(70, 194, 160, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: beginnerWords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Text('Failed to fetch beginner words');
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Learn Basic Words:',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromRGBO(70, 194, 160, 1.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...snapshot.data!
                      .map((element) => FutureWordTile(
                            word: element['word'] as String,
                            emoji: element['emoji'] as String,
                            fetchTranslationCallback: fetchTranslation,
                            playTranslatedWordCallback: playTranslatedWord,
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
  final String emoji;
  final Future<String> Function(String) fetchTranslationCallback;
  final Function(String) playTranslatedWordCallback;

  const FutureWordTile({
    Key? key,
    required this.word,
    required this.emoji,
    required this.fetchTranslationCallback,
    required this.playTranslatedWordCallback,
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
            word: word,
            translation: snapshot.data ?? '',
            emoji: emoji,
            playTranslatedWordCallback: playTranslatedWordCallback,
          );
        }
      },
    );
  }
}

class WordTile extends StatelessWidget {
  final String word;
  final String translation;
  final String emoji;
  final Function(String) playTranslatedWordCallback;

  const WordTile({
    Key? key,
    required this.word,
    required this.translation,
    required this.emoji,
    required this.playTranslatedWordCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(226, 241, 246, 1.0),
      child: InkWell(
        onTap: () {
          playTranslatedWordCallback(translation);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromRGBO(70, 194, 160, 1.0),
              content: Text(
                '$word in your selected language: $translation',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              Text(
                emoji,
                style: const TextStyle(
                  fontSize: 40.0,
                ),
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
