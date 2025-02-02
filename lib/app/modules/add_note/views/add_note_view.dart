// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';
import '../controllers/add_note_controller.dart';

class AddNoteView extends GetView<AddNoteController> {
  HomeController homeC = Get.find();

  AddNoteView({super.key}); // get controller from another controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'), //Cambio nota por task
        centerTitle: true,
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
              )),
        ],
      ),
    );
  }
}
