// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/notes_model.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../controllers/edit_note_controller.dart';

// Vista para editar un task existente, utilizando el controlador EditNoteController
class EditNoteView extends GetView<EditNoteController> {
  // Se obtiene el task seleccionado desde los argumentos de navegación
  Notes note = Get.arguments;

  HomeController homeC = Get.find();

  Color noteColor = Colors.white;

  EditNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    // Se inicializan los campos de texto con los datos del task seleccionado
    controller.titleC.text = note.title!;
    controller.descC.text = note.description!;
    controller.dateC.value =
        note.date != null ? DateTime.parse(note.date!) : DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'), // Título de la pantalla
        centerTitle: true, // Centra el título en la barra de navegación
        backgroundColor: noteColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Campo de texto para editar el título del task
          TextField(
            controller: controller.titleC,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25), // Espaciado entre elementos

          // Campo de texto para editar la descripción del task
          TextField(
            controller: controller.descC,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          // Selector de fecha con un campo de solo lectura
          Obx(() => TextField(
                readOnly: true, // No permite edición manual
                controller: TextEditingController(
                  text: controller.dateC.value != null
                      ? "${controller.dateC.value!.day}/${controller.dateC.value!.month}/${controller.dateC.value!.year}"
                      : "Select Date",
                ),
                decoration: InputDecoration(
                  labelText: "Date",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today), // Icono de calendario
                    onPressed: () => controller.selectDate(context), // Abre el selector de fecha
                  ),
                ),
              )),
          const SizedBox(height: 20),

          // Color picker for the note
          ListTile(
            title: const Text("Pick a color"),
            trailing: CircleAvatar(
              backgroundColor: noteColor,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Pick a color"),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: noteColor,
                      onColorChanged: (color) {
                        noteColor = color;
                        Get.back();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Botón para guardar la edición del task
          Obx(() => ElevatedButton(
                onPressed: () async {
                  // Se verifica que no haya otra operación en curso y que la fecha esté seleccionada
                  if (controller.isLoading.isFalse && controller.dateC.value != null) {
                    bool res = await controller.editNote(note.id!); // Se intenta editar el task
                    if (res == true) {
                      await homeC.getAllNotes(); // Se actualiza la lista de notas
                      Get.back(); // Se cierra la pantalla de edición
                    }
                    controller.isLoading.value = false; // Se restablece el estado de carga
                  }
                },
                child: Text(controller.isLoading.isFalse ? "Edit note" : "Loading..."), // Texto dinámico en el botón
                style: ElevatedButton.styleFrom(
                  backgroundColor: noteColor,
                ),
              )),
        ],
      ),
    );
  }
}
