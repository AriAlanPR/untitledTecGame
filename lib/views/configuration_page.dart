import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';
import 'package:untitled_tec_game/widgets/particles.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> with ValidateMixin {
  late final TextEditingController _nombreController;
  bool _bgmEnabled = true;
  bool _sfxEnabled = true;
  double _bgmVolume = 0.7;
  double _sfxVolume = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final savedName = await PersistentData.obtain("name") ?? "";
    final bgmEnabled = AudioManager.instance.bgmEnabled;
    final sfxEnabled = AudioManager.instance.sfxEnabled;
    final bgmVol = AudioManager.instance.bgmVolume;
    final sfxVol = AudioManager.instance.sfxVolume;

    if (mounted) {
      setState(() {
        _nombreController.text = savedName;
        _bgmEnabled = bgmEnabled;
        _sfxEnabled = sfxEnabled;
        _bgmVolume = bgmVol;
        _sfxVolume = sfxVol;
        _isLoading = false;
      });
    }
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
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, color: theme.colorScheme.primary, size: 26),
            const SizedBox(width: 8),
            Easytext(
              text: "configuracion".i18n(),
              size: 24,
              bold: true,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile / Name Section
                    _buildSectionCard(
                      context,
                      title: "nombre".i18n(),
                      icon: Icons.person_outline,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            key: const Key('config_player_name_field'),
                            controller: _nombreController,
                            style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "ingrese_nombre".i18n(),
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                              ),
                              prefixIcon: Icon(Icons.badge_outlined, color: theme.colorScheme.primary),
                            ),
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            key: const Key('config_save_name_btn'),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              await PersistentData.save("name", _nombreController.text);
                              if (context.mounted) {
                                Particles(context: context).showCircle();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("exito".i18n()),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: Text("guardar".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Audio Section
                    _buildSectionCard(
                      context,
                      title: "audio".i18n(),
                      icon: Icons.volume_up_outlined,
                      child: Column(
                        children: [
                          // BGM
                          SwitchListTile(
                            key: const Key('config_bgm_switch'),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "musica".i18n(),
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: _bgmEnabled,
                            activeThumbColor: theme.colorScheme.primary,
                            onChanged: (val) async {
                              setState(() => _bgmEnabled = val);
                              await AudioManager.instance.setBgmEnabled(val);
                            },
                          ),
                          if (_bgmEnabled) ...[
                            Row(
                              children: [
                                Text("volumen_musica".i18n(), style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                                const Spacer(),
                                Text('${(_bgmVolume * 100).toInt()}%', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            Slider(
                              key: const Key('config_bgm_slider'),
                              value: _bgmVolume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (val) {
                                setState(() => _bgmVolume = val);
                                AudioManager.instance.setBgmVolume(val);
                              },
                            ),
                          ],
                          const Divider(height: 24),
                          // SFX
                          SwitchListTile(
                            key: const Key('config_sfx_switch'),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "efectos_sonido".i18n(),
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: _sfxEnabled,
                            activeThumbColor: theme.colorScheme.primary,
                            onChanged: (val) async {
                              setState(() => _sfxEnabled = val);
                              await AudioManager.instance.setSfxEnabled(val);
                            },
                          ),
                          if (_sfxEnabled) ...[
                            Row(
                              children: [
                                Text("volumen_efectos".i18n(), style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                                const Spacer(),
                                Text('${(_sfxVolume * 100).toInt()}%', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            Slider(
                              key: const Key('config_sfx_slider'),
                              value: _sfxVolume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (val) {
                                setState(() => _sfxVolume = val);
                                AudioManager.instance.setSfxVolume(val);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
