class UserModel {
  final String email;
  final String name;
  final String? id;

  UserModel({
    required this.email,
    required this.name,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ??
          json['mail'] ??
          json['preferred_username'] ??
          json['upn'] ??
          json['userPrincipalName'] ??
          '',
      name: json['displayName'] ??
          json['name'] ??
          json['given_name'] ??
          json['family_name'] ??
          'No Name',
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'id': id,
    };
  }
}