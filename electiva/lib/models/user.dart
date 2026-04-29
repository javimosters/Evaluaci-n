class User {
  final String name;
  final String email;
  final String city;

  User({required this.name, required this.email, required this.city});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json['name'], email: json['email'], city: json['address']['city']);
}