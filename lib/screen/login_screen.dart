import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variables reactivas para manejar los errores:
  final RxBool hasEmailError = false.obs;
  final RxBool hasPasswordError = false.obs;

  LoginScreen({super.key});

  void _validateAndLogin() {
    // Valida campo email
    final email = emailController.text.trim();
    if (email.isEmpty) {
      hasEmailError.value = true;
    } else {
      hasEmailError.value = false;
    }

    // Valida campo password
    final password = passwordController.text;
    if (password.isEmpty) {
      hasPasswordError.value = true;
    } else {
      hasPasswordError.value = false;
    }

    // Si no hay encuentra errores de validacion, iniciar sesión
    if (!hasEmailError.value && !hasPasswordError.value) {
      authController.login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: const OutlineInputBorder(),
                    errorText:
                        hasEmailError.value ? 'El correo es obligatorio' : null,
                    errorBorder: hasEmailError.value
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          )
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    // Limpiar error cuando el usuario empiece a escribir
                    if (hasEmailError.value && value.isNotEmpty) {
                      hasEmailError.value = false;
                    }
                  },
                )),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    errorText: hasPasswordError.value
                        ? 'La contraseña es obligatoria'
                        : null,
                    errorBorder: hasPasswordError.value
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          )
                        : null,
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    // Limpiar error cuando el usuario empiece a escribir
                    if (hasPasswordError.value && value.isNotEmpty) {
                      hasPasswordError.value = false;
                    }
                  },
                )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _validateAndLogin,
              child: const Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
