class User {
  User(
      {required this.id,
      required this.name,
      required this.age,
      required this.birthday});

  final String id;
  final String name;
  final String age;
  final String birthday;

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'age': age, "birthday": birthday};
}
