import 'package:flutter/material.dart';

void main() {
  runApp(const GradeApp());
}

String classifyScore(int score) {
  if (score < 0 || score > 100) {
    throw RangeError.range(score, 0, 100, 'score');
  }
  return score >= 70 ? 'Pass' : 'Needs improvement';
}
// Functions used by extra tests.
bool isScoreBlank(String score) {
  return score.trim().isEmpty;
}
bool isScoreWholeNumber(String score) {
  return int.tryParse(score) != null;
}
bool isNameValid(String name) {
  return name.trim().isNotEmpty;
}

class GradeApp extends StatelessWidget {
  const GradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reliable Grade Validator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const GradeHomePage(),
    );
  }
}

class GradeHomePage extends StatefulWidget {
  const GradeHomePage({super.key});

  @override
  State<GradeHomePage> createState() => _GradeHomePageState();
}

class _GradeHomePageState extends State<GradeHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scoreController = TextEditingController();

  String? _resultMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _resultMessage = null;
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final score = int.tryParse(_scoreController.text.trim());

    // Validation should make null unlikely, but guard against it anyway.
    if (score == null) {
      setState(() => _errorMessage = 'Enter a whole-number score.');
      return;
    }

    try {
      final classification = classifyScore(score);
      setState(() {
        _resultMessage = '$name: $score — $classification';
      });
    } on RangeError {
      setState(() {
        _errorMessage = 'Score must be between 0 and 100.';
      });
    } catch (error) {
      // Unexpected errors are not silently ignored.
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
      });
      debugPrint('Unexpected grade validation error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Grade Validator')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter student details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student name',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Student name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _scoreController,
                    decoration: const InputDecoration(
                      labelText: 'Exam score (0–100)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final text = value?.trim() ?? '';

                      if (text.isEmpty) {
                        return 'Exam score is required.';
                      }

                      final score = int.tryParse(text);

                      if (score == null) {
                        return 'Enter a whole number.';
                      }

                      if (score < 0 || score > 100) {
                        return 'Score must be between 0 and 100.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _submit,
                    child: const Text('Validate score'),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  if (_resultMessage != null) ...[
                    const SizedBox(height: 16),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _resultMessage!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
