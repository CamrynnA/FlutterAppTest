import 'package:flutter_test/flutter_test.dart';
import 'package:lab_8/main.dart';

void main() {
  group('classifyScore', () {
    test('score 0 needs improvement', () {
      expect(classifyScore(0), 'Needs improvement');
    });

    test('score 69 needs improvement', () {
      expect(classifyScore(69), 'Needs improvement');
    });

    test('score 70 is a pass', () {
      expect(classifyScore(70), 'Pass');
    });

    test('score 100 is a pass', () {
      expect(classifyScore(100), 'Pass');
    });

    test('negative score is rejected', () {
      expect(() => classifyScore(-1), throwsRangeError);
    });

    test('score above 100 is rejected', () {
      expect(() => classifyScore(101), throwsRangeError);
    });
  });
}

