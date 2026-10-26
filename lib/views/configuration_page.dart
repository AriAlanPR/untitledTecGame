import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';
import 'package:untitled_tec_game/widgets/dialog.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';
import 'package:untitled_tec_game/widgets/particles.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> with ValidateMixin {
  final String defaultName = "Guest";
  late final TextEditingController _nombreController;

  bool _bgmEnabled = true;
  bool _sfxEnabled = true;
  double _bgmVolume = 0.7;
  double _sfxVolume = 1.0;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _bgmEnabled = AudioManager.instance.bgmEnabled;
    _sfxEnabled = AudioManager.instance.sfxEnabled;
    _bgmVolume = AudioManager.instance.bgmVolume;
    _sfxVolume = AudioManager.instance.sfxVolume;

    PersistentData.obtain("name").then((savedName) {
      if (savedName != null && mounted) {
        _nombreController.text = savedName;
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Easytext(text: "configuracion".i18n(), size: 40),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppColors.navy,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: calculatedHeight(context),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade600.withValues(alpha: 0.7),
                  Colors.blueGrey.shade800.withValues(alpha: 0.7),
                  Colors.blueGrey.shade600.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Player Name Section
                  Easytext(text: "nombre".i18n(), size: 20),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nombreController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.green.shade900.withValues(alpha: 0.2),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Dialogo.showLoadingDialog(context, message: "guardando".i18n());
                      await PersistentData.save("name", _nombreController.text);
                      if (context.mounted) {
                        Particles(context: context).showCircle();
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                    ),
                    child: Easytext(
                      text: "guardar".i18n(),
                      size: 15,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),

                  // Audio Section
                  Easytext(
                    text: "audio".i18n(),
                    size: 26,
                    bold: true,
                  ),
                  const SizedBox(height: 20),

                  // BGM Toggle
                  SwitchListTile(
                    key: const Key('config_bgm_switch'),
                    title: Easytext(text: "musica".i18n(), size: 18),
                    value: _bgmEnabled,
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: (val) async {
                      setState(() => _bgmEnabled = val);
                      await AudioManager.instance.setBgmEnabled(val);
                    },
                  ),

                  // BGM Volume Slider
                  if (_bgmEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Easytext(text: "volumen_musica".i18n(), size: 14),
                          Expanded(
                            child: Slider(
                              key: const Key('config_bgm_slider'),
                              value: _bgmVolume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (val) {
                                setState(() => _bgmVolume = val);
                                AudioManager.instance.setBgmVolume(val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // SFX Toggle
                  SwitchListTile(
                    key: const Key('config_sfx_switch'),
                    title: Easytext(text: "efectos_sonido".i18n(), size: 18),
                    value: _sfxEnabled,
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: (val) async {
                      setState(() => _sfxEnabled = val);
                      await AudioManager.instance.setSfxEnabled(val);
                    },
                  ),

                  // SFX Volume Slider
                  if (_sfxEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Easytext(text: "volumen_efectos".i18n(), size: 14),
                          Expanded(
                            child: Slider(
                              key: const Key('config_sfx_slider'),
                              value: _sfxVolume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (val) {
                                setState(() => _sfxVolume = val);
                                AudioManager.instance.setSfxVolume(val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
