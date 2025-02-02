class Notes {
  // Atributos de la clase, he añadido la fecha en el modelo
  int? id;
  int? userId;
  String? title;
  String? description;
  String? createdAt;
  String? date;

  // Constructor con parámetros opcionales
  Notes({this.id, this.userId, this.title, this.description, this.createdAt, this.date});

  // Constructor para inicializar una instancia de Notes a partir de un JSON
  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    date = json['date'];
  }

  // Método para convertir una instancia de Notes en un mapa JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['date'] = date;
    return data;
  }

  // Método estático para convertir una lista de mapas JSON en una lista de objetos Notes
  static List<Notes> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return []; // Retorna una lista vacía si los datos son nulos o vacíos
    return data.map((e) => Notes.fromJson(e)).toList(); // Convierte cada mapa JSON en una instancia de Notes
  }
}
