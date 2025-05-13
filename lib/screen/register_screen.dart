import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Variables reactivas para manejar los errores
  final RxBool hasEmailError = false.obs;
  final RxBool hasPasswordError = false.obs;
  final RxBool hasConfirmPasswordError = false.obs;
  final RxBool hasPasswordMismatch = false.obs;

  // Mensajes de error
  final RxString emailErrorMessage = ''.obs;
  final RxString passwordErrorMessage = ''.obs;
  final RxString confirmPasswordErrorMessage = ''.obs;

  RegisterScreen({super.key});

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _validateAndRegister() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validar email
    if (email.isEmpty) {
      hasEmailError.value = true;
      emailErrorMessage.value = 'El correo es obligatorio';
    } else if (!_isValidEmail(email)) {
      hasEmailError.value = true;
      emailErrorMessage.value = 'Correo inválido';
    } else {
      hasEmailError.value = false;
    }

    // Validar password
    if (password.isEmpty) {
      hasPasswordError.value = true;
      passwordErrorMessage.value = 'La contraseña es obligatoria';
    } else if (password.length < 8) {
      hasPasswordError.value = true;
      passwordErrorMessage.value =
          'La contraseña debe tener al menos 8 caracteres';
    } else {
      hasPasswordError.value = false;
    }

    // Validar confirmación de password
    if (confirmPassword.isEmpty) {
      hasConfirmPasswordError.value = true;
      confirmPasswordErrorMessage.value = 'Confirmar contraseña(Obligatorio!)';
    } else if (password != confirmPassword) {
      hasConfirmPasswordError.value = true;
      hasPasswordMismatch.value = true;
      confirmPasswordErrorMessage.value = 'Las contraseñas no coinciden';
    } else {
      hasConfirmPasswordError.value = false;
      hasPasswordMismatch.value = false;
    }

    // Si no hay errores, proceder con el registro
    if (!hasEmailError.value &&
        !hasPasswordError.value &&
        !hasConfirmPasswordError.value) {
      authController.createAccount(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
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
                        hasEmailError.value ? emailErrorMessage.value : null,
                    errorBorder: hasEmailError.value
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          )
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
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
                        ? passwordErrorMessage.value
                        : null,
                    errorBorder: hasPasswordError.value
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          )
                        : null,
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    if (hasPasswordError.value && value.isNotEmpty) {
                      hasPasswordError.value = false;
                    }
                    // Si las contraseñas no coincidían, revisar si ahora coinciden
                    if (hasPasswordMismatch.value &&
                        value == confirmPasswordController.text) {
                      hasConfirmPasswordError.value = false;
                      hasPasswordMismatch.value = false;
                    }
                  },
                )),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    border: const OutlineInputBorder(),
                    errorText: hasConfirmPasswordError.value
                        ? confirmPasswordErrorMessage.value
                        : null,
                    errorBorder: hasConfirmPasswordError.value
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          )
                        : null,
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    if (hasConfirmPasswordError.value && value.isNotEmpty) {
                      hasConfirmPasswordError.value = false;
                    }
                    // Revisar si las contraseñas coinciden cuando el usuario escribe
                    if (hasPasswordMismatch.value &&
                        value == passwordController.text) {
                      hasConfirmPasswordError.value = false;
                      hasPasswordMismatch.value = false;
                    }
                  },
                )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _validateAndRegister,
              child: const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('¿Ya tienes cuenta? Inicia Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
