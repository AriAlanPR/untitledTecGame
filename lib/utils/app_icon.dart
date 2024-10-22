// import 'package:flutter/material.dart';
// import 'package:icony/icony_gameicons.dart';
// import 'package:icony/icony_ikonate.dart';

// class AppIcon extends StatelessWidget{
//   final bool isGame;
//   final String name;
//   final Color? color;
//   final double? size;

//   const AppIcon({
//     super.key,
//     required this.name,
//     this.isGame = true,
//     this.color,
//     this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return isGame ? GameIcons(
//         name,
//         matchTextDirection: true,
//         color: color,
//         width: size,
//         height: size,
//       ) : Ikonate(
//         name,
//         matchTextDirection: true,
//         color: color,
//         width: size,
//         height: size,
//       );
//   }
// }