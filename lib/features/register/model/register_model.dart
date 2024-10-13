class RegisterRequestBody {
  String email;
  String password;
  String name;
  String phoneNumber;

  RegisterRequestBody({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'phone_number': phoneNumber,
    };
  }

  factory RegisterRequestBody.fromJson(Map<String, dynamic> json) {
    return RegisterRequestBody(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}
