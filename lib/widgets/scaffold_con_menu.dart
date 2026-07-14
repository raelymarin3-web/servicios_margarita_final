import 'package:flutter/material.dart';
import 'app_bar_con_menu.dart';
import 'drawer_menu.dart';

class ScaffoldConMenu extends StatelessWidget {
  final String titulo;
  final Widget body;
  final List<Widget>? acciones;

  const ScaffoldConMenu({
    super.key,
    required this.titulo,
    required this.body,
    this.acciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarConMenu(
        titulo: titulo,
        acciones: acciones,
      ),
      drawer: const DrawerMenu(),
      body: body,
    );
  }
}