import 'package:flutter/material.dart';

class AppBarConMenu extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final List<Widget>? acciones;

  const AppBarConMenu({
    super.key,
    required this.titulo,
    this.acciones,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: 'Menú',
        ),
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Text(titulo),
        ],
      ),
      actions: acciones,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}