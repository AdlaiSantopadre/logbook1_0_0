import "package:logbook1_0_0/models/modelDataBase.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logbook1_0_0/widgets/checklist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logbook1_0_0/models/modelUserCredential.dart';
import 'package:logbook1_0_0/widgets/authentication copy.dart';
import 'widgets/check.dart';

final totalProgressProvider = StateProvider<int>((ref) => 5  );
//used to manage the total progress

/*final onallDonePagePrimoSoccorso = StateProvider<int>((ref)  { 
  return ref.read(totalProgressProvider.notifier).state+= 10;
} );
*/
//SNACK BAR Provider
final snackbarMessageProvider = StateProvider<String>((ref) => '');
final showSnackbarProvider = StateProvider<bool>((ref) => false);



final selectedIndexProvider = StateProvider<int>((ref) => 0);
//used to manage the selected index Navigation Drawer

////USERNAME & PASSWORD PROVIDERS//////////////////////////

final usernameProvider = StateProvider<String?>((ref) => '...');
//used to manage the username.
final passwordProvider = StateProvider<String?>((ref) => '...');
//holds the current user's password.

//DATABASE PROVIDER
//initializes and provides access to the SQflite database
// In  widgets or other providers CAN BE USED  as a dependency.

final databaseProvider = Provider<Future<Database>>((ref) async {
  final databaseHelper = DatabaseHelper();
  return await databaseHelper.initDatabase();
});

//checkProvider who manage the state of a Checklist made of list of Check
final checkProvider = StateNotifierProvider<Checklist, List<Check>>(
  (ref) => Checklist([
    Check(uuid.v4(), "Guanti sterili monouso in nitrile (2 paia).", false),
    Check(
        uuid.v4(),
        "Flacone di soluzione cutanea di iodopovidone al 10% di iodio da 125 ml.",
        false),
    /*Check(
        uuid.v4(),
        "Flacone di soluzione fisiologica (sodio cloruro 0,9%) da 250 ml (1).",
        false),
    Check(uuid.v4(),
        "Compresse di garza sterile 18 x 40 in buste singole (1).", false),
    Check(uuid.v4(), "Compresse di garza sterile 10 x 10 in buste singole (3)",
        false),
    
    Check(uuid.v4(), "Pinzette da medicazione sterili monouso (1).", false),
   
    Check(uuid.v4(), "Confezione di cotone idrofilo (1).", false),
    Check(uuid.v4(), "Confezioni di cerotti di varie misure pronti all'uso (1).", false),
    
    Check(uuid.v4(), "Rotoli di cerotto alto cm. 2,5 (2).", false),
    Check(uuid.v4(), "Rotolo di benda orlata alta cm 10 (1).", false),
    Check(uuid.v4(), "Un paio di forbici (1).", false),
    Check(uuid.v4(), "Un laccio emostatico (1).", false),
    Check(uuid.v4(), "Confezione di ghiaccio pronto uso (1).", false),
    Check(uuid.v4(), "Sacchetti monouso per la raccolta di rifiuti sanitari (1).", false),
    Check(uuid.v4(), "Istruzioni sul modo di usare i presidi suddetti e di prestare i primi soccorsi in attesa del servizio di emergenza.", false),
    Check(uuid.v4(), "Gilet alta visibilità (solo per automezzo)", false),
    Check(uuid.v4(), "Item 10", false),* */
    
    
  ]),
);

final allDoneProvider = Provider<bool>((ref) {
  final checks = ref.watch(checkProvider);
  return checks.every((check) => check.checked);
});


//USER REGISTRATION PROVIDER
//provider for registering new users in the database:
//write the logic to insert a new user's credentials
//(username and password) into the SQLite database.
final userRegistrationProvider = Provider<Future<void>>((ref) async {
  final database = await ref.read(databaseProvider);
  // Insert a new user into the user_credentials table
  final username = ref.watch(usernameProvider);
  final password = ref.watch(passwordProvider);

  final newUserCredentials = {
    //  replace with actual user input
    'username': username,
    'password': password,
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

// Check if the provided credentials (username and password) match a record in the user_credentials tabl
final authenticationProvider = Provider<Future<bool>>((ref) async {
  final database = await ref.read(databaseProvider);
  final username = ref.watch(usernameProvider);
  final password = ref.watch(passwordProvider);

  try {
    final result = await database.query(
      'user_credentials',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    // If a record is found, the credentials are correct
    final isAuthenticated = result.isNotEmpty;
    return isAuthenticated;
  } catch (e) {
    // Handle any errors that may occur during authentication
    print('Error during authentication: $e');
    // You can throw an error here or handle it based on your app's requirements
    rethrow;
  }
});

///MANAGE DATABASE//
//access user credentials from the database
final userCredentialsProvider =
    FutureProvider<List<UserCredential>>((ref) async {
  final database = await ref.read(databaseProvider);
  final data = await database.query('user_credentials');
// Convert the database result into a list of UserCredential objects
  return data.map((row) => UserCredential.fromMap(row)).toList();
});

//PASSWORD VALIDATION PROVIDER
//This provider checks whether the entered password meets the required validation criteria.
final passwordValidationProvider = Provider<bool>((ref) {
  final password = ref.watch(passwordProvider);
  // Implement password validation criteria logic here
  String currentpassword = password!;
  // Define a regular expression pattern for password validation
  const pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  final regExp = RegExp(pattern);
  final isValidPassword = regExp.hasMatch(currentpassword);
  // Check if the password matches the validation criteria

  return isValidPassword; //use isValid
});

//PASSWORD STORAGE PROVIDER THE SAME AS AUTHENTICATION..
//This provider handles storing the user's password securely in the database.
final passwordStorageProvider = Provider<Future<bool>>((ref) async {
  final database = await ref.read(databaseProvider);
  final username = ref.watch(usernameProvider);
  final password = ref.watch(passwordProvider);

  try {
    // Query the user_credentials table to retrieve the stored password for the given username
    final result = await database.query(
      'user_credentials',
      columns: ['password'],
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      final storedPassword = result.first['password'] as String;

      // Compare the stored password with the provided password
      final isPasswordValid = storedPassword == password;

      return isPasswordValid;
    } else {
      // Username not found in the database
      return false;
    }
  } catch (e) {
    // Handle any errors that may occur during password validation
    print('Error during password validation: $e');
    // You can throw an error here or handle it based on your app's requirements
    rethrow;
  }
});
