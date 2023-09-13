//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import  'package:logbook1_0_0/pages/homePage.dart';

final totalProgressProvider = StateProvider<int>((ref) => 0);//used to manage the total progress./
final selectedIndexProvider = StateProvider<int>((ref) => 0);//used to manage the selected index in my navigation
final usernameProvider = StateProvider<String?>((ref) => '...');
//used to manage the username.
final authenticationProvider = Provider<Authentication>((ref) {
  return Authentication();
});
