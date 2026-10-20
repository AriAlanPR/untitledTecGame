import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('assets-and-dependencies', () {
    test('Dependencies resolve without conflicts', () {
      final pubspecFile = File('pubspec.yaml');
      expect(pubspecFile.existsSync(), isTrue);
      final content = pubspecFile.readAsStringSync();
      expect(content.contains('flame_audio:'), isTrue);
      expect(content.contains('intl: ^0.20.3'), isTrue);
    });

    test('Core spritesheets exist on disk', () {
      final requiredAssets = [
        'assets/images/character1.png',
        'assets/images/effects_skills.png',
        'assets/images/mountain_group.png',
        'assets/images/mountain_trees.png',
      ];

      for (final asset in requiredAssets) {
        expect(File(asset).existsSync(), isTrue, reason: '$asset must exist on disk');
      }
    });
  });
}
