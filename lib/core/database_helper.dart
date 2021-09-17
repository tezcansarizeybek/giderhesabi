import 'package:sqflite/sqflite.dart';

openExpenseDb() async {
  String file = await getDatabasesPath();
  Database db = await openDatabase(
    "$file/expenseDb.db",
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE EXPENSE(
      UUID TEXT PRIMARY KEY NOT NULL,
      DESCRIPTION TEXT NOT NULL,
      TOTAL REAL NOT NULL,
      DATE TEXT NOT NULL,
      CATEGORY TEXT NOT NULL,
      GPSX REAL,
      GPSY REAL)''');
      await db.execute('''CREATE TABLE CATEGORY(
      CODE TEXT PRIMARY KEY NOT NULL,
      NAME TEXT NOT NULL)''');
    },
  );
  return db;
}
