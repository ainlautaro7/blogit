class User {
  final int id;
  final String? firstName;
  final String? lastName;
  final String username;
  final String? email;
  final String password;
  final String profilePhotoUrl;
  final String? aboutMe;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.profilePhotoUrl,
    required this.aboutMe,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
      'profilePhotoUrl': profilePhotoUrl,
      'aboutMe': aboutMe,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'] ?? '', // Si es null, usar un valor por defecto
      lastName: json['lastName'] ?? '',   // Lo mismo para 'lastName'
      username: json['username'] ?? '',    // Aquí también, asegurándote de que nunca sea null
      email: json['email'] ?? '',          // Si el email es null, usar una cadena vacía
      password: json['password'] ?? '',    // Lo mismo con la contraseña
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',  // Si es null, usar una cadena vacía
      aboutMe: json['aboutMe'] ?? '',     // Lo mismo con 'aboutMe'
    );
  }
}
