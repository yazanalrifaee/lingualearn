import 'package:flutter/material.dart';
import 'beginner_page.dart';
import 'intermediate_page.dart';
import 'advanced_page.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 241, 246, 1.0),
      appBar: AppBar(
        title: const Text(
          'Welcome to Lingua Learn!',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(70, 194, 160, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Your Road To Fluency",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(70, 194, 160, 1.0),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  difficultyCard(
                    title: 'Beginner',
                    image: 'assets/beginner.jpeg',
                    difficultyIcon: Icons.star_border,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BeginnerPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12,),
                  difficultyCard(
                    title: 'Intermediate',
                    image: 'assets/intermediate.jpeg',
                    difficultyIcon: Icons.star_half,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IntermediatePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12,),
                  difficultyCard(
                    title: 'Advanced',
                    image: 'assets/advanced.jpeg',
                    difficultyIcon: Icons.star,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdvancedPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget difficultyCard({
    required String title,
    required String image,
    required IconData difficultyIcon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(
              image,
              width: double.infinity,
              height: 138,
              fit: BoxFit.fitWidth,
            ),
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  color: Color.fromRGBO(70, 194, 160, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                difficultyIcon,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
