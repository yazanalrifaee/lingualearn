import 'package:flutter/material.dart';

class IntermediatePage extends StatelessWidget {
  const IntermediatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 241, 246, 1.0),
      appBar: AppBar(
        title: const Text(
          'Intermediate Level',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(70, 194, 160, 1.0),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Learn Intermediate Words:',
              style: TextStyle(
                fontSize: 20.0,
                color: Color.fromRGBO(70, 194, 160, 1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            WordTile(word: 'Proficient', translation: 'ماهر', icon: Icons.school),
            SizedBox(height: 12),
            WordTile(word: 'Innovative', translation: 'مبتكر', icon: Icons.lightbulb),
            SizedBox(height: 12),
            WordTile(word: 'Resilient', translation: 'قوي الصمود', icon: Icons.all_inclusive),
            SizedBox(height: 12),
            WordTile(word: 'Diligent', translation: 'مجتهد', icon: Icons.assignment_turned_in),
            SizedBox(height: 12),
            WordTile(word: 'Empathy', translation: 'تعاطف', icon: Icons.favorite),
            SizedBox(height: 12),
            WordTile(word: 'Sophisticated', translation: 'متطور', icon: Icons.stars),
          ],
        ),
      ),
    );
  }
}

class WordTile extends StatelessWidget {
  final String word;
  final String translation;
  final IconData icon;

  const WordTile({Key? key, required this.word, required this.translation, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(226, 241, 246, 1.0),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromRGBO(70, 194, 160, 1.0),
              content: Text('$word in Arabic: $translation', style: const TextStyle(color: Colors.white,fontSize: 16)),
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
