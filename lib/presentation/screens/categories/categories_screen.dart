import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Armas',
      'Zombies',
      'Mapas',
      'Misiones',
      'Bugs',
      'Guías',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text(categories[index]),
            onTap: () {},
          );
        },
      ),
    );
  }
}
