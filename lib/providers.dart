import "package:logbook1_0_0/models/modelDataBase.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final totalProgressProvider =
    StateProvider<int>((ref) => 0); //used to manage the total progress./

final selectedIndexProvider = StateProvider<int>(
    (ref) => 0); //used to manage the selected index in my navigation

final usernameProvider = StateProvider<String?>((ref) => '...');
//used to manage the username.

/*This provider initializes and provides access to the SQLite database*/
final databaseProvider = Provider<Future<Database>>((ref) async {
  final databaseHelper = DatabaseHelper();
  return await databaseHelper.initDatabase();
});
//holds the current user's password. It can be updated when a user enters their password.
// In your widget or other providers, you can use the databaseProvider as a dependency.
final exampleProvider = Provider<int>((ref) {
  final database = ref.watch(databaseProvider);
  // Use the database connection here
  // ...
});

//provider for registering new users in the database:
final userRegistrationProvider = Provider<Future<void>>((ref) async {
  final database = await ref.read(databaseProvider);
  // Implement user registration logic here
  // Insert a new user into the user_credentials table
});
//write the logic to insert a new user's credentials 
//(username and password) into the SQLite database.

final passwordProvider = StateProvider<String?>((ref) => null);

final userAuthenticationProvider = Provider<Future<bool>>((ref) async {
  final database = await ref.read(databaseProvider);
  // Implement user authentication logic here
  // Check if the provided credentials (username and password) match a record in the user_credentials table
});

//access user credentials from the database
final userCredentialsProvider = FutureProvider<List<UserCredential>>((ref) async {
  final database = await ref.read(databaseProvider);
  final data = await database.query('user_credentials');
// Convert the database result into a list of UserCredential objects
  return data.map((row) => UserCredential.fromMap(row)).toList();
});

//Data model class UserCredential will provide the required methods for working with an SQLite-friendly format by converting 
//it into a Dart object that can be used later within the application
class UserCredential {
  int? id;
  String username;
  String password;
  

  UserCredential({this.id, required this.username, required this.password,});

  UserCredential.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        username = res["username"],
        password = res["password"];
        

  Map<String, Object?> toMap() {
    return {'id': id, 'username': username, 'password': password,};
  }
}

/*final userRegistrationProvider = Provider<Future<void>>((ref) async {
  final database = await ref.read(databaseProvider);

  // Example user credentials (replace with actual user input)
  final newUserCredentials = {
    'username': 'new_username',
    'password': 'new_password',
  };

  try {
    // Check if the username already exists (optional)
    final existingCredentials = await database.query(
      'user_credentials',
      where: 'username = ?',
      whereArgs: [newUserCredentials['username']],
    );

    if (existingCredentials.isEmpty) {
      // Username doesn't exist, proceed with registration
      await database.insert('user_credentials', newUserCredentials);
    } else {
      // Username already exists, handle accordingly (e.g., show an error)
      throw Exception('Username already exists');
    }
  } catch (e) {
    // Handle any errors that may occur during registration
    print('Error during registration: $e');
    // You can throw an error here or handle it based on your app's requirements
    throw e;
  }
});
*/