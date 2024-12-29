import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final String username;

  QuizPage({required this.username});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the color of Santa’s suit?',
      'options': ['Blue', 'Red', 'Green', 'Black'],
      'answer': 1
    },
    {
      'question': 'How many reindeer does Santa have?',
      'options': ['7', '8', '9', '10'],
      'answer': 2
    },
    {
      'question':
          'What is traditionally placed at the top of a Christmas Tree?',
      'options': ['Star', 'Angel', 'Bow', 'Bell'],
      'answer': 0
    },
    {
      'question': 'How many reindeer pull Santa’s sleigh (excluding Rudolph)?',
      'options': ['6', '7', '8', '9'],
      'answer': 2
    },
    {
      'question':
          'In which country did the tradition of Christmas trees originate?',
      'options': ['England', 'Germany', 'Norway', 'Canada'],
      'answer': 1
    },
    {
      'question': 'What is the name of the snowman in the famous song?',
      'options': ['Frosty', 'Olaf', 'Jack Frost', 'Blizzard'],
      'answer': 0
    },
    {
      'question':
          'In the movie "Home Alone," where are the McCallisters going for Christmas vacation when they leave Kevin behind?',
      'options': ['Paris', 'New York', 'Chicago', 'Florida'],
      'answer': 0
    },
    {
      'question':
          'What is the name of Ebenezer Scrooge’s deceased business partner in A Christmas Carol?',
      'options': ['Bob Cratchit', 'Fezziwig', 'Tiny Tim', 'Jacob Marley'],
      'answer': 3
    },
    {
      'question':
          'Which plant is commonly used as a Christmas decoration and is believed to bring good luck?',
      'options': ['Poinsettia', 'Holly', 'Ivy', 'Mistletoe'],
      'answer': 3
    },
  ];

  int currentQuestion = 0;
  int score = 0;
  int timeRemaining = 120; // 2 minutes
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _shuffleQuestions();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _shuffleQuestions() {
    final random = Random();
    questions.shuffle(random);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        timer.cancel();
        endQuiz();
      }
    });
  }

  void checkAnswer(int index) {
    if (index == questions[currentQuestion]['answer']) {
      score++;
    }
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      endQuiz();
    }
  }

  void endQuiz() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Complete! 🎉'),
        content: Text('You scored $score/${questions.length}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, score); // Return score to previous screen
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s Quiz 🎄'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              questions[currentQuestion]['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...questions[currentQuestion]['options'].asMap().entries.map(
                  (option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => checkAnswer(option.key),
                      child: Text(option.value),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
