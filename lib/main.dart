import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flag/flag.dart';

void main() => runApp(ThemeStatefulWrapper(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: theme.themeMode,
      home: LoginPage(),
    );
  }
}

class ThemeManager extends InheritedWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  ThemeManager({
    Key? key,
    required this.themeMode,
    required this.onThemeChanged,
    required Widget child,
  }) : super(key: key, child: child);

  static ThemeManager of(BuildContext context) {
    final ThemeManager? result = context.dependOnInheritedWidgetOfExactType<ThemeManager>();
    assert(result != null, 'No ThemeManager found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeManager old) => themeMode != old.themeMode;

  void toggleTheme(ThemeMode mode) => onThemeChanged(mode);
}

class ThemeStatefulWrapper extends StatefulWidget {
  final Widget child;

  ThemeStatefulWrapper({required this.child});

  @override
  _ThemeStatefulWrapperState createState() => _ThemeStatefulWrapperState();
}

class _ThemeStatefulWrapperState extends State<ThemeStatefulWrapper> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      themeMode: _themeMode,
      onThemeChanged: _toggleTheme,
      child: widget.child,
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Light Theme"),
            onTap: () => ThemeManager.of(context).toggleTheme(ThemeMode.light),
          ),
          ListTile(
            title: Text("Dark Theme"),
            onTap: () => ThemeManager.of(context).toggleTheme(ThemeMode.dark),
          ),
          ListTile(
            title: Text("System Default"),
            onTap: () => ThemeManager.of(context).toggleTheme(ThemeMode.system),
          ),
        ],
      ),
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
    Navigator.of(context).pop(); 
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
      appBar: AppBar(
        title: Text("Welcome"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the Language Learning App!", style: Theme.of(context).textTheme.headlineSmall),
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

String languageToCountryCode(String languageName) {
  switch (languageName) {
    case 'Spanish':
      return 'ES';
    case 'French':
      return 'FR';
    case 'German':
      return 'DE';
    case 'Korean':
      return 'KR';
    default:
      return 'US'; 
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  final List<String> languages = [
    'Spanish', 
    'French', 
    'German', 
    'Korean',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Language"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), 
        ),
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
          final countryCode = languageToCountryCode(languages[index]);
          return Card(
            child: InkWell(
              onTap: () {
                if (languages[index] == "Korean") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => KoreanLanguageScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${languages[index]} coming soon!")));
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flag.fromString(countryCode, height: 50, width: 80, fit: BoxFit.fill),
                  Text(languages[index], style: TextStyle(fontSize: 20)),
                ],
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
            _buildfauxNeumorphicButton(context, 'Practice', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PracticeScreen()));
            }),
            SizedBox(height: 20),
            _buildfauxNeumorphicButton(context, 'Quizzes', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PracticeQuizScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildfauxNeumorphicButton(BuildContext context, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(text, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600)),
      ),
    );
  }
}


class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<Flashcard> flashcards = [
    Flashcard(wordInKorean: "사과", wordInEnglish: "Apple", imagePath: "images/apple.png"),
    Flashcard(wordInKorean: "물", wordInEnglish: "Water", imagePath: "images/water.png"),
    Flashcard(wordInKorean: "공", wordInEnglish: "Ball", imagePath: "images/ball.png"),
    Flashcard(wordInKorean: "책", wordInEnglish: "Book", imagePath: "images/book.png"),
    Flashcard(wordInKorean: "바나나", wordInEnglish: "Banana", imagePath: "images/banana.png"),
  ];

  int currentIndex = 0;
  GlobalKey<_FlashcardViewState> _flashcardKey = GlobalKey<_FlashcardViewState>();

  void goToNext() {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
        _flashcardKey.currentState?.resetCard(); // Resets the card view to the front side after every previous and next flashcard.
      }
    });
  }

  void goToPrevious() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        _flashcardKey.currentState?.resetCard(); // Resets the card view to the front side after every previous and next flashcard.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Flashcard currentFlashcard = flashcards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Practice')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlashcardView(
            key: _flashcardKey,
            wordInKorean: currentFlashcard.wordInKorean,
            wordInEnglish: currentFlashcard.wordInEnglish,
            imagePath: currentFlashcard.imagePath,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: currentIndex > 0 ? goToPrevious : null,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: currentIndex < flashcards.length - 1 ? goToNext : null,
              ),
            ],
          ),
        ],
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizResultsScreen(_correctAnswers, _questions.length, _resetQuiz)));
    }
  }

@override
Widget build(BuildContext context) {
  final question = _questions[_currentQuestionIndex];
  return Scaffold(
    appBar: AppBar(title: Text("Korean Quiz")),
    body: SingleChildScrollView( 
      child: Center( 
        child: Column(
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
                )).toList(), 
          ],
        ),
      ),
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
        automaticallyImplyLeading: false, 
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

  FlashcardView({
    Key? key,
    required this.wordInKorean,
    required this.wordInEnglish,
    required this.imagePath,
  }) : super(key: key);

  @override
  _FlashcardViewState createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  bool isFront = true;

  void resetCard() {
    setState(() {
      isFront = true;
    });
  }

  void _flipCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) 
          ..rotateY(isFront ? 0 : pi),
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isFront
            ? Image.asset(widget.imagePath, fit: BoxFit.cover)
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateY(pi), 
                child: Center(
                    child: Text('${widget.wordInKorean} - ${widget.wordInEnglish}',
                        style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 0, 0, 0)))),
              ),
      ),
    );
  }
}

class Flashcard {
  final String wordInKorean;
  final String wordInEnglish;
  final String imagePath;

  Flashcard({required this.wordInKorean, required this.wordInEnglish, required this.imagePath});
}