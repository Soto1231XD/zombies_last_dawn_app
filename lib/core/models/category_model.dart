import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Getter para el icono
  IconData get icon {
    switch (name.toLowerCase()) {
      case 'armas':
        return Icons.security;
      case 'zombies':
        return Icons.bug_report;
      case 'mapas':
        return Icons.map;
      case 'misiones':
        return Icons.flag;
      case 'bugs':
        return Icons.warning_amber_rounded;
      case 'guías':
        return Icons.menu_book;
      default:
        return Icons.category;
    }
  }

  // Getter para el color
  Color get color {
    switch (name.toLowerCase()) {
      case 'armas':
        return Colors.redAccent;
      case 'zombies':
        return Colors.greenAccent;
      case 'mapas':
        return Colors.lightBlueAccent;
      case 'misiones':
        return Colors.orangeAccent;
      case 'bugs':
        return Colors.yellowAccent;
      case 'guías':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }
}