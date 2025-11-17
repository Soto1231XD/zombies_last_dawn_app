import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_routes.dart';
import '../../../services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await SupabaseService().signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      print('Login exitoso: ${response.user?.email}');
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: const Color(0xFFEF4444), 
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error inesperado al iniciar sesión'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          SizedBox.expand(
            child: Image.asset(
              'assets/images/edificio-derruido.png', 
              fit: BoxFit.cover,
            ),
          ),
          // Overlay semitransparente
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          // Efecto blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 2),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          // Formulario
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo o título
                    Text(
                      "Last Dawn",
                      style: const TextStyle(
                        color: Color(0xFF22D3EE), // accent
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Campo de correo electrónico
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Color(0xFFE5E7EB)), // fg
                      decoration: InputDecoration(
                        hintText: "Correo electrónico",
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)), // muted
                        filled: true,
                        fillColor: const Color(0xFF121A2B), // card
                        prefixIcon: const Icon(Icons.email, color: Color(0xFF22D3EE)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu correo';
                        }
                        if (!value.contains('@')) {
                          return 'Por favor ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo de contraseña
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Color(0xFFE5E7EB)),
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFF121A2B),
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF22D3EE)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Botón de login
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22D3EE), // accent
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0B1220), // bg del spinner
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                  color: Color(0xFF0B1220),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Enlace de registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿No tienes cuenta? ",
                          style: TextStyle(color: Color(0xFF94A3B8)), // muted
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(context, AppRoutes.register);
                                },
                          child: const Text(
                            "Regístrate",
                            style: TextStyle(
                              color: Color(0xFF22D3EE), // accent
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
