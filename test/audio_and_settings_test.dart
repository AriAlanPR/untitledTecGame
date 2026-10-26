import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';

class FakeAudioPlayerDelegate implements AudioPlayerDelegate {
  final List<String> playedSfx = [];
  final List<String> playedBgm = [];
  bool isBgmPlaying = false;
  bool isBgmPaused = false;

  void clear() {
    playedSfx.clear();
    playedBgm.clear();
    isBgmPlaying = false;
    isBgmPaused = false;
  }

  @override
  Future<void> playSfx(String file, {double volume = 1.0}) async {
    playedSfx.add(file);
  }

  @override
  Future<void> playBgm(String file, {double volume = 1.0}) async {
    playedBgm.add(file);
    isBgmPlaying = true;
    isBgmPaused = false;
  }

  @override
  Future<void> stopBgm() async {
    isBgmPlaying = false;
    isBgmPaused = false;
  }

  @override
  Future<void> pauseBgm() async {
    isBgmPaused = true;
  }

  @override
  Future<void> resumeBgm() async {
    isBgmPaused = false;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAudioPlayerDelegate fakeDelegate;
  late AudioManager audioManager;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PersistentData.init();
    fakeDelegate = FakeAudioPlayerDelegate();
    audioManager = AudioManager(delegate: fakeDelegate);
    await audioManager.init();
    await audioManager.setSfxEnabled(true);
    await audioManager.setBgmEnabled(true);
    fakeDelegate.clear();
  });

  group('audio-and-settings', () {
    test('Laser shot triggers laser sound effect', () {
      final player = PlayerComponent(position: Vector2(500, 1000));
      expect(fakeDelegate.playedSfx, isEmpty);

      player.fireLaser();

      expect(fakeDelegate.playedSfx, contains('sfx/laser.wav'));
    });

    test('Asteroid explosion triggers explosion sound effect', () {
      final asteroid = AsteroidComponent(
        position: Vector2(500, 1000),
        velocity: Vector2.zero(),
      );
      expect(fakeDelegate.playedSfx, isEmpty);

      asteroid.hitByLaser();

      expect(fakeDelegate.playedSfx, contains('sfx/explosion.wav'));
    });

    test('Player damage triggers damage sound effect', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        customGame: game,
      );
      expect(fakeDelegate.playedSfx, isEmpty);

      player.takeDamage();

      expect(fakeDelegate.playedSfx, contains('sfx/damage.wav'));
    });

    test('Game over triggers game over sound effect', () {
      final game = TecGame();
      expect(fakeDelegate.playedSfx, isEmpty);

      game.triggerGameOver();

      expect(fakeDelegate.playedSfx, contains('sfx/game_over.wav'));
      expect(fakeDelegate.isBgmPaused, isTrue);
    });

    test('Gameplay starts background music', () {
      final game = TecGame();
      expect(fakeDelegate.playedBgm, isEmpty);

      game.onMount();

      expect(fakeDelegate.playedBgm, contains('music/space_theme.wav'));
      expect(fakeDelegate.isBgmPlaying, isTrue);
    });

    test('Toggling audio setting persists configuration', () async {
      expect(await PersistentData.getBgmEnabled(), isTrue);

      await audioManager.setBgmEnabled(false);
      expect(await PersistentData.getBgmEnabled(), isFalse);
      expect(audioManager.bgmEnabled, isFalse);

      await audioManager.setSfxVolume(0.4);
      expect(await PersistentData.getSfxVolume(), 0.4);
      expect(audioManager.sfxVolume, 0.4);
    });
  });
}
