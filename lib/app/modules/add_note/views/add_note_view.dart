// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../controllers/add_note_controller.dart';

class AddNoteView extends GetView<AddNoteController> {
  HomeController homeC = Get.find();
  Color noteColor = Colors.white;

  AddNoteView({super.key}); // get controller from another controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'), 
        centerTitle: true,
        backgroundColor: noteColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.titleC,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: controller.descC,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          
          // Seleccionador de Fecha
          Obx(() => ListTile(
      title: Text(controller.dateC.value != null
          ? "Fecha: ${controller.dateC.value!.toLocal()}".split(' ')[0]
          : "Seleccionar fecha"),
      leading: const Icon(Icons.calendar_today),
      onTap: () => controller.selectDate(context), // Llama al método de selección de fecha
    )),
          const SizedBox(height: 25),
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
          // Botón para agregar task
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    bool res = await controller.addNote();
                    if (res == true) {
                      await homeC.getAllNotes();
                      Get.back();
                    }
                    controller.isLoading.value = false;
                  }
                },
                child: Text(controller.isLoading.isFalse ? "Add note" : "Loading..."),
                style: ElevatedButton.styleFrom(
                  backgroundColor: noteColor,
                ),
              )),
        ],
      ),
    );
  }
}
