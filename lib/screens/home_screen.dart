import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final void Function(bool) onThemeChanged;

  const HomeScreen({required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Atores e Filmes'),
        actions: [
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: onThemeChanged,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Gerenciar Atores'),
              onPressed: () {
                // Navegar para tela de atores
              },
            ),
            ElevatedButton(
              child: Text('Gerenciar Filmes'),
              onPressed: () {
                // Navegar para tela de filmes
              },
            ),
          ],
        ),
      ),
    );
  }
}
