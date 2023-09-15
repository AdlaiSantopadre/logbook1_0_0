import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logbook1_0_0/providers.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; //https://medium.com/@CavinMac/mastering-hooks-in-flutter-dca896d97d47#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjdjMGI2OTEzZmUxMzgyMGEzMzMzOTlhY2U0MjZlNzA1MzVhOWEwYmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDA4NjEzNTM1ODEyNTQzNzQ5ODAiLCJlbWFpbCI6ImFkaWVnaXVsaUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmJmIjoxNjk0NTE2MTkzLCJuYW1lIjoiQWRsYWkgUyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKWlRZN3pRWXBscmJNMkVaTlFDaWNiTm4xLWhjZVdtdUVwR1NTUVV5d2syYURQPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkFkbGFpIiwiZmFtaWx5X25hbWUiOiJTIiwibG9jYWxlIjoiaXQiLCJpYXQiOjE2OTQ1MTY0OTMsImV4cCI6MTY5NDUyMDA5MywianRpIjoiMTRlYzljMjU1ZmNlM2UxYjgwMDMyMjAwNDkxZGM5YWYxNzhlOTM4YyJ9.T64Qpd3eqsBFwGjYGGE8aeMXb-De-2U5vcQ2TEDoe0BLLGvCrRkm57KiPZ4wgPJFJjBzjvrguDz0x6lBFmUmFdRSWcXkM2t81FPCEsc1IXbeUDwoO-TjVar1AdFDx2kLpeLNfLVjY-DqalHZM3EJD21GDyeqlq473i00HFoQTW1CTfS1C-FQ_NeMV_pgzkzj0sLBB52Evdl7iXPleuy2hfCrVeimn1BEiZsD_yhHosrUyOXZtTmQ_zi9X3nnNMT1i5QG2dRFI-Amthkj466g00vxK9PPnE-DFV45lyrDTzFCWrmpn0uW1QUTmPa4jO7odCwoRl6YPYV6oesjinvNSg
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';




class DatabaseHelper {
  DatabaseHelper();

   Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_credentials.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }



  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'password_manager.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the user_credentials table
    await db.execute('''
      CREATE TABLE user_credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }
/*insertCredential: Inserts a new user credential into the user_credentials table. It takes a
 Map<String, dynamic> containing the username and password fields as arguments.*/
  Future<int> insertCredential(Map<String, dynamic> credential) async {
    final database = await initDatabase();
    return await database.insert('user_credentials', credential);
  }
/*getAllCredentials: Retrieves all user credentials from the user_credentials
 table and returns them as a list of Map<String, dynamic> */
  Future<List<Map<String, dynamic>>> getAllCredentials() async {
    final database = await initDatabase();
    return await database.query('user_credentials');
  }
/*updateCredential: Updates an existing user credential in the user_credentials table. It takes a Map<String, dynamic> containing the updated fields,
 including the id to identify the record to update. */
  Future<int> updateCredential(Map<String, dynamic> credential) async {
    final database = await initDatabase();
    return await database.update(
      'user_credentials',
      credential,
      where: 'id = ?',
      whereArgs: [credential['id']],
    );
  }
/*deleteCredential: Deletes a user credential 
from the user_credentials table based on its id. */
  Future<int> deleteCredential(int id) async {
    final database = await initDatabase();
    return await database.delete(
      'user_credentials',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}




