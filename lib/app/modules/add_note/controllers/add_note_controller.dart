import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNoteController extends GetxController {
  // Estado observable para indicar si el plan se está guardando
  RxBool isLoading = false.obs;

  // Estado observable para controlar si un campo está oculto
  RxBool isHidden = true.obs;

  // Controladores para los campos de título y descripción del plan
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  // Estado observable para almacenar la fecha seleccionada
  Rxn<DateTime> dateC = Rxn<DateTime>();

  // Cliente de Supabase para la comunicación con la base de datos
  SupabaseClient client = Supabase.instance.client;

  // Método para abrir el selector de fecha y actualizar el estado con la fecha seleccionada
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateC.value ?? DateTime.now(), // Usa la fecha actual si no hay una seleccionada
      firstDate: DateTime(2000), // Fecha mínima permitida
      lastDate: DateTime(2100),  // Fecha máxima permitida
    );

    if (picked != null) {
      dateC.value = picked;  // Almacena la fecha seleccionada
    }
  }

  // Método para agregar una nueva nota a la base de datos
  Future<bool> addNote() async {
    // Verifica que los campos requeridos no estén vacíos
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty && dateC.value != null) {
      isLoading.value = true; // Indica que el proceso de guardado ha comenzado

      // Obtiene el ID del usuario actual en la base de datos de Supabase
      List<dynamic> res = await client
          .from("users")
          .select("id")
          .match({"uid": client.auth.currentUser!.id});

      // Convierte el resultado en un mapa y extrae el ID del usuario
      Map<String, dynamic> user = res.first as Map<String, dynamic>;
      int id = user["id"]; // Obtiene y asigna el ID del usuario antes de insertar la nota

      await client.from("tasks").insert({
        "user_id": id,
        "title": titleC.text,
        "description": descC.text,
        "created_at": DateTime.now().toIso8601String(), // Guarda la fecha y hora actual en formato ISO
        "date": dateC.value?.toIso8601String(), // Guarda la fecha seleccionada en formato ISO
      });

      return true; // Indica que la operación fue exitosa
    } else {
      return false; // Indica que la operación falló por campos vacíos
    }
  }
}
