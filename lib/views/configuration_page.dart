import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';

class ConfigurationPage extends StatelessWidget with ValidateMixin {
  final String defaultName = "Guest";

  ConfigurationPage({
    super.key,  
  });

  @override
  Widget build(BuildContext context) {
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
            height: calculatedHeight(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade600.withOpacity(0.7),
                  Colors.blueGrey.shade800.withOpacity(0.7),
                  Colors.blueGrey.shade600.withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Easytext(text: "ingrese_nombre".i18n(), size: 20),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Easytext(
                          text: "Guardar".i18n(),
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}