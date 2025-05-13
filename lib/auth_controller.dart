import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import 'package:application_medicines/appwrite_config.dart';
import 'package:appwrite/models.dart';

class AuthController extends GetxController {
  final Account account = Account(AppwriteConfig.getClient());
  final Rx<User?> user = Rx<User?>(null);

  Future<bool> checkAuth() async {
    try {
      final userData = await account.get();
      user.value = userData;
      print('Usuario autenticado: ${userData.$id}');
      return true;
    } catch (e) {
      print('Usuario no autenticado: $e');
      // No mostrar snackbar aquí, es normal no estar autenticado
      return false;
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      print('Creando cuenta para: $email');
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      await login(email, password);
    } catch (e) {
      print('Error al crear cuenta: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      print('Intentando login para: $email');
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final userData = await account.get();
      user.value = userData;
      print('Login exitoso. Usuario: ${userData.$id}');

      // Usar offAllNamed para reemplazar toda la pila de navegación
      Get.offAllNamed('/medications');
    } on AppwriteException catch (e) {
      print('AppwriteException en login: ${e.message}');
      print('Código de error: ${e.code}');

      String errorMessage = 'Error al iniciar sesión';
      if (e.code == 401) {
        errorMessage = 'Credenciales incorrectas';
      } else if (e.code == 429) {
        errorMessage = 'Demasiados intentos. Intenta más tarde';
      } else if (e.message?.isNotEmpty ?? false) {
        errorMessage = e.message ?? 'Error desconocido';
      }

      Get.snackbar('Error', errorMessage);
    } catch (e) {
      print('Error general en login: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      user.value = null;
      print('Logout exitoso');
      // Navegación a la pantalla de login sin posibilidad de regresar
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error en logout: $e');
      Get.snackbar('Error', e.toString());
    }
  }
}
