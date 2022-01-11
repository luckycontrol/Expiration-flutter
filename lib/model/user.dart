class User {
  String email;
  String token;
  DateTime time;

  User({ 
    required this.email,
    required this.token,
    required this.time
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "token": token,
      "time": time
    };
  }
}