import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/category_model.dart';
import '../../../../services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  List<Category> _categories = [];
  String? _selectedCategoryId;
  bool _isLoading = false;
  bool _categoriesLoading = false;

  final PostService _postService = PostService(Supabase.instance.client);

  // Palette (as constants for clarity)
  static const Color bgColor = Color(0xFF0B1220); // base bg
  static const Color cardColor = Color(0xFF121A2B); // card
  static const Color fgColor = Color(0xFFE5E7EB); // foreground
  static const Color mutedForeground = Color(0xFFA8B3C7); // muted-foreground
  static const Color accentColor = Color(0xFF22D3EE); // accent
  static final Color borderColor = Colors.white.withOpacity(0.12); // border
  static final Color inputOverlay = Colors.white.withOpacity(0.15); // input overlay

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _categoriesLoading = true);

    try {
      final categories = await _postService.fetchAllCategories();
      setState(() => _categories = categories);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    } finally {
      setState(() => _categoriesLoading = false);
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una categoría')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para publicar')),
        );
        return;
      }

      await _postService.createPost(
        title: _titleController.text,
        content: _contentController.text,
        categoryId: _selectedCategoryId!,
        authorId: user.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicación creada exitosamente')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear publicación: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Nueva Publicación',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: accentColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TÍTULO
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: fgColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    labelText: 'Título',
                    labelStyle: const TextStyle(color: accentColor),
                    border: InputBorder.none,
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Ingresa un título' : null,
                ),
              ),

              const SizedBox(height: 20),

              // CATEGORÍAS (Dropdown)
              _categoriesLoading
                  ? const CircularProgressIndicator(color: accentColor)
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        dropdownColor: cardColor,
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                          labelStyle: TextStyle(color: accentColor),
                          border: InputBorder.none,
                        ),
                        items: _categories.map((Category category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(
                              category.name,
                              style: const TextStyle(color: fgColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedCategoryId = value),
                        validator: (value) => value == null ? 'Selecciona una categoría' : null,
                      ),
                    ),

              const SizedBox(height: 20),

              // CONTENIDO (expandable)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: TextFormField(
                    controller: _contentController,
                    style: const TextStyle(color: fgColor),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      labelText: 'Contenido',
                      labelStyle: const TextStyle(color: accentColor),
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      border: InputBorder.none,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Escribe algo' : null,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÓN PUBLICAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor, // accent
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Publicar',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
