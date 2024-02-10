class Person {
  const Person(
      {required this.id, this.name = "", this.email = "", this.password = ""});
  final String id;
  final String name;
  final String email;
  final String password;
  factory Person.fromMap(Map<String, dynamic> data) {
    return Person(
        id: data["id"],
        name: data['name'],
        email: data['email'],
        password: data['password']);
  }
}
