import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/category_model.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Category>> getCategories() async {
    try {
      print('🟡 CONECTANDO A SUPABASE PARA OBTENER CATEGORÍAS...');
      
      final response = await _supabase
          .from('categories')
          .select()
          .order('created_at', ascending: true);
      
      print('🟢 RESPUESTA DE SUPABASE: ${response.length} elementos');
      print('🔵 DATOS CRUDOS: $response');
      
      if (response.isEmpty) {
        print('🟡 NO SE ENCONTRARON CATEGORÍAS EN LA BASE DE DATOS');
        return [];
      }
      
      final categories = (response as List).map((json) {
        try {
          return Category.fromJson(json);
        } catch (e) {
          print('🔴 ERROR PARSEANDO CATEGORÍA: $e - JSON: $json');
          rethrow;
        }
      }).toList();
      
      print('🟣 CATEGORÍAS PARSEADAS EXITOSAMENTE: ${categories.length}');
      return categories;
    } catch (e) {
      print('🔴 ERROR CRÍTICO EN CategoryService.getCategories(): $e');
      print('🔴 Stack trace: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> createCategory(Category category) async {
    try {
      await _supabase.from('categories').insert({
        'name': category.name,
        'description': category.description,
        'image_url': category.imageUrl,
      });
    } catch (e) {
      print('Error creating category: $e');
      throw e;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _supabase
          .from('categories')
          .update({
            'name': category.name,
            'description': category.description,
            'image_url': category.imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', category.id);
    } catch (e) {
      print('Error updating category: $e');
      throw e;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _supabase.from('categories').delete().eq('id', id);
    } catch (e) {
      print('Error deleting category: $e');
      throw e;
    }
  }
}