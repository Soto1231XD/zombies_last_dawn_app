import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'supabase_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();
  final SupabaseService _supabaseService = SupabaseService();

  // Verificar y solicitar permisos para cámara
  Future<bool> _checkCameraPermissions() async {
    final cameraStatus = await Permission.camera.status;
    
    if (!cameraStatus.isGranted) {
      final cameraResult = await Permission.camera.request();
      return cameraResult.isGranted;
    }
    
    return true;
  }

  // Verificar y solicitar permisos para galería
  Future<bool> _checkGalleryPermissions() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ - usar permiso de photos
        final photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted) {
          final photosResult = await Permission.photos.request();
          return photosResult.isGranted;
        }
        return true;
      } else {
        // Android <13 - usar permiso de storage
        final storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          final storageResult = await Permission.storage.request();
          return storageResult.isGranted;
        }
        return true;
      }
    } else if (Platform.isIOS) {
      // iOS - usar permiso de photos
      final photosStatus = await Permission.photos.status;
      if (!photosStatus.isGranted) {
        final photosResult = await Permission.photos.request();
        return photosResult.isGranted;
      }
      return true;
    }
    
    return true;
  }

  // Tomar foto con cámara
  Future<File?> takePhoto() async {
    try {
      final hasPermission = await _checkCameraPermissions();
      if (!hasPermission) {
        throw Exception('Permisos de cámara denegados. Por favor, habilita los permisos en configuración.');
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      print('Error tomando foto: $e');
      rethrow;
    }
  }

  // Seleccionar de galería
  Future<File?> pickFromGallery() async {
    try {
      final hasPermission = await _checkGalleryPermissions();
      if (!hasPermission) {
        throw Exception('Permisos de galería denegados. Por favor, habilita los permisos en configuración.');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error seleccionando imagen: $e');
      rethrow;
    }
  }

 // Subir imagen a Supabase Storage - VERSIÓN MEJORADA MANEJANDO RESPUESTA NULA
Future<String?> uploadProfileImage(File imageFile) async {
  try {
    final user = _supabaseService.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    
    final String fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = '${user.id}/$fileName';



    // 1. Subir imagen al bucket 'avatars' en Supabase Storage

    try {
      await _supabaseService.client.storage
          .from('avatars')
          .upload(filePath, imageFile);
    } catch (e) {

      throw Exception('Error subiendo imagen: $e');
    }

    // 2. Obtener URL pública de la imagen
    final String publicUrl = _supabaseService.client.storage
        .from('avatars')
        .getPublicUrl(filePath);


    // 3. Actualizar perfil del usuario con la nueva URL del avatar

    final response = await _supabaseService.client
        .from('profiles')
        .update({
          'avatar_url': publicUrl,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', user.id);

    // Manejar la respuesta: puede ser nula, pero no necesariamente un error
    if (response != null && response.error != null) {
      print(' Error en respuesta de Supabase: ${response.error}');
      throw Exception('Error actualizando perfil: ${response.error!.message}');
    }

    // Si la respuesta es nula, asumimos que la actualización fue exitosa
    // porque a veces Supabase devuelve nulo en operaciones de actualización
    print(' Avatar actualizado exitosamente!');

    return publicUrl;
  } catch (e) {
    print(' Error crítico en uploadProfileImage: $e');
    print(' Stack trace: ${e.toString()}');
    rethrow;
  }
}
  // Método completo: tomar foto y subir
  Future<String?> takeAndUploadProfilePicture() async {
    try {
      final File? imageFile = await takePhoto();
      if (imageFile != null) {

        return await uploadProfileImage(imageFile);
      } else {
        print(' No se pudo tomar la foto');
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Método completo: seleccionar de galería y subir
  Future<String?> selectAndUploadProfilePicture() async {
    try {

      final File? imageFile = await pickFromGallery();
      if (imageFile != null) {

        return await uploadProfileImage(imageFile);
      } else {
        print(' No se pudo seleccionar imagen');
        return null;
      }
    } catch (e) {

      rethrow;
    }
  }
}