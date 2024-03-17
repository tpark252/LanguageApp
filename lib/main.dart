import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  final String _presetEmail = "user@example.com";
  final String _presetPassword = "password123";

  void _login() {
    if (emailController.text == _presetEmail && passwordController.text == _presetPassword) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
            ),
            ElevatedButton(onPressed: _login, child: Text("Login")),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage())),
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  void _signup() {
    // Placeholder for signup logic
    Navigator.of(context).pop(); // Go back to login page after signup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
            ),
            ElevatedButton(onPressed: _signup, child: Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the Language Learning App!", style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSelectionScreen())),
              child: Text("Start Learning"),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> languages = ['Spanish', 'French', 'German', 'Korean'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Language"),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                if (languages[index] == "Korean") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => KoreanLanguageScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${languages[index]} coming soon!")));
                }
              },
              child: Center(
                child: Text(languages[index], style: TextStyle(fontSize: 20)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class KoreanLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Korean'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Practice'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PracticeScreen()));
              },
            ),
            ElevatedButton(
              child: Text('Quizzes'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PracticeQuizScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice'),
      ),
      body: Center(
        child: FlashcardView(
          imagePath: "images/apple.png",
          wordInKorean: "사과",
          wordInEnglish: "Apple",
        ),
      ),
    );
  }
}

class PracticeQuizScreen extends StatefulWidget {
  @override
  _PracticeQuizScreenState createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> {
  final _random = Random();
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _resetQuiz();
  }

  void _resetQuiz() {
    _questions = [
      Question('사과', ['pear', 'apple', 'bear', 'drink'], 'apple'),
      Question('물', ['water', 'fire', 'air', 'earth'], 'water'),
      Question('책', ['book', 'desk', 'chair', 'door'], 'book'),
      Question('바나나', ['panama', 'silence', 'banana', 'door'], 'banana'),
      Question('공', ['gong', 'study', 'wood', 'ball'], 'ball'),
    ];
    _questions.shuffle(_random);
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
  }

  void _nextQuestion({required bool isCorrect}) {
    if (isCorrect) {
      _correctAnswers++;
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Quiz finished, navigate to results screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizResultsScreen(_correctAnswers, _questions.length, _resetQuiz)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Korean Practice")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}: What is "${question.word}" in English?',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          ...question.options.map((option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 60),
                child: ElevatedButton(
                  onPressed: () => _nextQuestion(isCorrect: option == question.correctAnswer),
                  child: Text(option, style: TextStyle(fontSize: 20)),
                ),
              )),
        ],
      ),
    );
  }
}

class QuizResultsScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final VoidCallback resetQuiz;

  QuizResultsScreen(this.correctAnswers, this.totalQuestions, this.resetQuiz);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Results"),
        automaticallyImplyLeading: false, // Removes back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You scored $correctAnswers out of $totalQuestions", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetQuiz();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PracticeQuizScreen()));
              },
              child: Text("Retry Quiz"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
                (Route<dynamic> route) => false,
              ),
              child: Text("Back to Language Selection"),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String word;
  final List<String> options;
  final String correctAnswer;

  Question(this.word, this.options, this.correctAnswer);
}

class FlashcardView extends StatefulWidget {
  final String wordInKorean;
  final String wordInEnglish;
  final String imagePath;

  FlashcardView({required this.wordInKorean, required this.wordInEnglish, required this.imagePath});

  @override
  _FlashcardViewState createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isFront = !isFront;
          });
          _controller.reset();
        }
      });
  }

  void _flipCard() {
    if (_controller.isAnimating) return;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(pi * _animation.value),
            alignment: FractionalOffset.center,
            child: isFront
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.blue,
                    child: Text('${widget.wordInKorean} - ${widget.wordInEnglish}', style: TextStyle(fontSize: 24, color: Colors.white)),
                    alignment: Alignment.center,
                  ),
          );
        },
      ),
    );
  }
}