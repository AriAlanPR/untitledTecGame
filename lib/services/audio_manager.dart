import 'package:flame_audio/flame_audio.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';

abstract class AudioPlayerDelegate {
  Future<void> playSfx(String file, {double volume = 1.0});
  Future<void> playBgm(String file, {double volume = 1.0});
  Future<void> stopBgm();
  Future<void> pauseBgm();
  Future<void> resumeBgm();
}

class FlameAudioDelegate implements AudioPlayerDelegate {
  @override
  Future<void> playSfx(String file, {double volume = 1.0}) async {
    try {
      await FlameAudio.play(file, volume: volume);
    } catch (_) {
      // In headless environments or missing audio outputs, safely ignore
    }
  }

  @override
  Future<void> playBgm(String file, {double volume = 1.0}) async {
    try {
      if (!FlameAudio.bgm.isPlaying) {
        await FlameAudio.bgm.play(file, volume: volume);
      }
    } catch (_) {
      // Safely ignore
    }
  }

  @override
  Future<void> stopBgm() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {}
  }

  @override
  Future<void> pauseBgm() async {
    try {
      await FlameAudio.bgm.pause();
    } catch (_) {}
  }

  @override
  Future<void> resumeBgm() async {
    try {
      await FlameAudio.bgm.resume();
    } catch (_) {}
  }
}

class AudioManager {
  static final AudioManager instance = AudioManager._internal();
  AudioPlayerDelegate delegate;

  bool _sfxEnabled = true;
  bool _bgmEnabled = true;
  double _sfxVolume = 1.0;
  double _bgmVolume = 0.7;
  bool _isInitialized = false;

  bool get sfxEnabled => _sfxEnabled;
  bool get bgmEnabled => _bgmEnabled;
  double get sfxVolume => _sfxVolume;
  double get bgmVolume => _bgmVolume;

  AudioManager._internal({AudioPlayerDelegate? delegate})
      : delegate = delegate ?? FlameAudioDelegate();

  factory AudioManager({AudioPlayerDelegate? delegate}) {
    if (delegate != null) {
      instance.delegate = delegate;
    }
    return instance;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    _bgmEnabled = await PersistentData.getBgmEnabled();
    _sfxEnabled = await PersistentData.getSfxEnabled();
    _bgmVolume = await PersistentData.getBgmVolume();
    _sfxVolume = await PersistentData.getSfxVolume();
    _isInitialized = true;
  }

  Future<void> setBgmEnabled(bool value) async {
    _bgmEnabled = value;
    await PersistentData.setBgmEnabled(value);
    if (!value) {
      await stopBgm();
    } else {
      await startBgm();
    }
  }

  Future<void> setSfxEnabled(bool value) async {
    _sfxEnabled = value;
    await PersistentData.setSfxEnabled(value);
  }

  Future<void> setBgmVolume(double value) async {
    _bgmVolume = value.clamp(0.0, 1.0);
    await PersistentData.setBgmVolume(_bgmVolume);
  }

  Future<void> setSfxVolume(double value) async {
    _sfxVolume = value.clamp(0.0, 1.0);
    await PersistentData.setSfxVolume(_sfxVolume);
  }

  void playLaser() {
    if (!_sfxEnabled) return;
    delegate.playSfx('sfx/laser.wav', volume: _sfxVolume);
  }

  void playExplosion() {
    if (!_sfxEnabled) return;
    delegate.playSfx('sfx/explosion.wav', volume: _sfxVolume);
  }

  void playDamage() {
    if (!_sfxEnabled) return;
    delegate.playSfx('sfx/damage.wav', volume: _sfxVolume);
  }

  void playGameOver() {
    if (!_sfxEnabled) return;
    delegate.playSfx('sfx/game_over.wav', volume: _sfxVolume);
  }

  void playPowerUp() {
    if (!_sfxEnabled) return;
    delegate.playSfx('sfx/powerup.wav', volume: _sfxVolume);
  }

  Future<void> startBgm() async {
    if (!_bgmEnabled) return;
    await delegate.playBgm('music/space_theme.wav', volume: _bgmVolume);
  }

  Future<void> stopBgm() async {
    await delegate.stopBgm();
  }

  Future<void> pauseBgm() async {
    await delegate.pauseBgm();
  }

  Future<void> resumeBgm() async {
    if (!_bgmEnabled) return;
    await delegate.resumeBgm();
  }
}
