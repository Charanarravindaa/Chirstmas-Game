import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'quizpage.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int userScore = 0;
  List<Map<String, dynamic>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard(); // Load leaderboard when the page initializes
  }

  /// Load the leaderboard from Firestore
  Future<void> _loadLeaderboard() async {
    final leaderboardSnapshot = await FirebaseFirestore.instance
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .get();

    setState(() {
      leaderboard = leaderboardSnapshot.docs
          .map((doc) => {
                'name': doc['name'],
                'score': doc['score'],
              })
          .toList();
    });
  }

  /// Save the user's score to Firestore
  Future<void> _saveScore(int score) async {
    await FirebaseFirestore.instance.collection('leaderboard').add({
      'name': widget.username,
      'score': score,
    });

    // Reload leaderboard after saving the score
    _loadLeaderboard();
  }

  /// Method to start the quiz and receive the score
  Future<void> startQuiz() async {
    final score = await Navigator.push<int>(
      context,
      MaterialPageRoute(
          builder: (context) => QuizPage(username: widget.username)),
    );

    if (score != null) {
      setState(() {
        userScore = score;
      });

      // Save the user's score to Firestore
      await _saveScore(userScore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎄 Hello, ${widget.username} 🎅'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: startQuiz,
            child: Text('Start Quiz'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final player = leaderboard[index];
                return ListTile(
                  title: Text(player['name']),
                  trailing: Text('Score: ${player['score']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
