import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/notes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controlador para gestionar las tareas en la aplicación
class HomeController extends GetxController {
  // Lista reactiva que almacenará todos las tareas
  RxList allNotes = List<Notes>.empty().obs;

  // Cliente de Supabase para interactuar con la base de datos
  SupabaseClient client = Supabase.instance.client;

  // Método para obtener todos las tareas del usuario actual
  Future<void> getAllNotes() async {
    // Se obtiene el ID del usuario desde la tabla "users" filtrando por el UID de autenticación actual
    List<dynamic> res = await client
        .from("users")
        .select("id")
        .match({"uid": client.auth.currentUser!.id});

    // Se extrae el primer resultado de la consulta como un mapa
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;

    // Se obtiene el ID del usuario
    int id = user["id"]; // Obtener el ID del usuario antes de recuperar las tareas

    // Se obtienen todos las tareas de la tabla "tasks" que pertenecen a este usuario
    var notes = await client.from("tasks").select().match(
      {"user_id": id}, // Filtrar las tareas por el ID del usuario
    );

    // Convertir la lista obtenida en una lista de objetos Notes
    List<Notes> notesData = Notes.fromJsonList((notes as List));

    // Actualizar la lista reactiva con los datos obtenidos
    allNotes(notesData);
    allNotes.refresh(); // Refrescar la lista para reflejar los cambios en la UI
  }

  // Método para eliminar un task por su ID
  Future<void> deleteNote(int id) async {
    await client.from("tasks").delete().match({
      "id": id, // Buscar el task por su ID y eliminarlo
    });

    // Volver a obtener la lista de tasks después de la eliminación
    getAllNotes();
  }
}
