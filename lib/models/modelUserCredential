//Data model class 
//  UserCredential will provide the required methods for working with an SQLite-friendly format by converting
//it into a Dart object that can be used later within the application
class UserCredential {
  int? id;
  String username;
  String password;

  UserCredential({
    this.id,
    required this.username,
    required this.password,
  });

  UserCredential.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        username = res["username"],
        password = res["password"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}