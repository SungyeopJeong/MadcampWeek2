class StudyModel {
  final String name, category, description, max;
  final int id;

  StudyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = json['category'],
        description = json['description'],
        max = json['max'].toString();
}
