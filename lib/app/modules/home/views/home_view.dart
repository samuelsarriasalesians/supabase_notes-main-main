import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/notes_model.dart';
import 'package:supabase_notes/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';

// Vista principal donde se muestran las tareas del usuario
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HOME'),
          centerTitle: true,
          actions: [
            // Search bar
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: NotesSearchDelegate(controller));
              },
            ),
            // Botón para navegar al perfil del usuario
            IconButton(
              onPressed: () async {
                Get.toNamed(Routes.PROFILE);
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: FutureBuilder(
            future: controller.getAllNotes(), // Cargar las tareas al iniciar la pantalla
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Mostrar indicador de carga mientras se obtienen los datos
                return const Center(child: CircularProgressIndicator());
              }
              return Obx(() => controller.allNotes.isEmpty
                  ? const Center(
                      child: Text("NO DATA"), // Mensaje si no hay tareas disponibles
                    )
                  : ListView.builder(
                      itemCount: controller.allNotes.length,
                      itemBuilder: (context, index) {
                        Notes task = controller.allNotes[index];

                        // Formatear la fecha del task en formato dd/MM/yyyy
                        final DateFormat formatter = DateFormat('dd/MM/yyyy');
                        final String formattedDate = formatter.format(DateTime.parse(task.date.toString()));

                        return ListTile(
                          // Al tocar un task, se abre la pantalla de edición
                          onTap: () => Get.toNamed(
                            Routes.EDIT_NOTE,
                            arguments: task,
                          ),
                          leading: CircleAvatar(
                            child: Text("t${task.id}"), // Identificador del task
                          ),
                          title: Text("title: ${task.title}"), // Título del task
                          subtitle: Text(
                              "description: ${task.description}\ndate: ${formattedDate}"), // Descripción y fecha del task
                          trailing: IconButton(
                            // Botón para eliminar el task
                            onPressed: () async =>
                                await controller.deleteNote(task.id!),
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    ));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_NOTE),
          child: const Icon(Icons.add),
        ));
  }
}

class NotesSearchDelegate extends SearchDelegate {
  final HomeController controller;

  NotesSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = controller.allNotes.where((note) => note.title!.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        Notes task = results[index];
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        final String formattedDate = formatter.format(DateTime.parse(task.date.toString()));

        return ListTile(
          onTap: () {
            Get.toNamed(Routes.EDIT_NOTE, arguments: task);
            close(context, null);
          },
          leading: CircleAvatar(
            child: Text("t${task.id}"),
          ),
          title: Text("title: ${task.title}"),
          subtitle: Text("description: ${task.description}\ndate: ${formattedDate}"),
          trailing: IconButton(
            onPressed: () async => await controller.deleteNote(task.id!),
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = controller.allNotes.where((note) => note.title!.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Notes task = suggestions[index];
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        final String formattedDate = formatter.format(DateTime.parse(task.date.toString()));

        return ListTile(
          onTap: () {
            Get.toNamed(Routes.EDIT_NOTE, arguments: task);
            close(context, null);
          },
          leading: CircleAvatar(
            child: Text("t${task.id}"),
          ),
          title: Text("title: ${task.title}"),
          subtitle: Text("description: ${task.description}\ndate: ${formattedDate}"),
          trailing: IconButton(
            onPressed: () async => await controller.deleteNote(task.id!),
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
