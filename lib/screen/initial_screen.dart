import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    _checkAuth(authController);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  void _checkAuth(AuthController authController) async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    final isLoggedIn = await authController.checkAuth();

    if (isLoggedIn) {
      // offAllNamed: para reemplazar toda la pila
      Get.offAllNamed('/medications');
    } else {
      // offAllNamed: para ir al login sin opción de regresar
      Get.offAllNamed('/login');
    }
  }
}
