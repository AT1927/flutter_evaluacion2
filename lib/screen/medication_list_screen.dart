import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:application_medicines/medication.dart';

class MedicationListScreen extends StatelessWidget {
  final MedicationController medicationController =
      Get.find<MedicationController>();

  // Variable reactiva para controlar el tipo de ordenamiento
  final RxString sortBy = 'time'.obs; // 'time' o 'name'

  MedicationListScreen({super.key});

  List<Medication> _getSortedMedications() {
    List<Medication> medications = List.from(medicationController.medications);

    if (sortBy.value == 'time') {
      // Ordenar por hora (de menor a mayor)
      medications.sort((a, b) {
        final timeA = a.time.hour * 60 + a.time.minute;
        final timeB = b.time.hour * 60 + b.time.minute;
        return timeA.compareTo(timeB);
      });
    } else {
      // Ordenar por nombre (alfabéticamente)
      medications
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    return medications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Medicamentos'),
        actions: [
          // Botón para cambiar el tipo de ordenamiento
          Obx(() => PopupMenuButton<String>(
                onSelected: (String value) {
                  sortBy.value = value;
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'time',
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: sortBy.value == 'time' ? Colors.blue : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ordenar por hora',
                          style: TextStyle(
                            fontWeight:
                                sortBy.value == 'time' ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'name',
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_by_alpha,
                          color: sortBy.value == 'name' ? Colors.blue : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ordenar por nombre',
                          style: TextStyle(
                            fontWeight:
                                sortBy.value == 'name' ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.sort),
              )),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      body: Obx(
        () {
          final medications = _getSortedMedications();

          if (medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.medication,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes medicamentos registrados',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Presiona el botón + para agregar tu primer medicamento',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Mostrar el tipo de ordenamiento actual
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.grey[100],
                child: Obx(() => Text(
                      sortBy.value == 'time'
                          ? 'Ordenados por hora del día'
                          : 'Ordenados alfabéticamente',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    )),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final medication = medications[index];
                    return MedicationCard(medication: medication);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-medication'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(medication.name),
        subtitle: Text('Dosis: ${medication.dosage}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${medication.time.hour}:${medication.time.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ),
        onTap: () => Get.toNamed('/edit-medication/${medication.id}'),
      ),
    );
  }
}
