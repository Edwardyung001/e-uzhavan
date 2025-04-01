import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("farmers.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // ✅ Ensure it's 2 or higher to trigger onUpgrade()
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // ✅ Create Tables
  Future<void> _createDB(Database db, int version) async {
    print("Creating Database...");

    await db.execute('''
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    role TEXT NOT NULL,  -- 'User' or 'Farmer'
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    farmerId INTEGER UNIQUE, -- NULL for regular users
    profileImage TEXT NULL, -- Allow NULL for normal users
    location TEXT NULL  -- ✅ Store location only for Farmers
  )
''');


    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productName TEXT NOT NULL,
      productPrice REAL NOT NULL,
      productQuantity TEXT NOT NULL,
      productImage TEXT NOT NULL,
      farmerId INTEGER NOT NULL
    )
  ''');

    print("Users Table Created!");
  }


  // ✅ Upgrade Database (Check if Column Exists Before Adding)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      print("✅ Upgrading Database...");

      // Check if "image" column exists before adding it
      List<Map<String, dynamic>> columns = await db.rawQuery("PRAGMA table_info(users)");

      bool columnExists = columns.any((column) => column['name'] == 'image');

      if (!columnExists) {
        await db.execute('ALTER TABLE users ADD COLUMN image TEXT');
        print("✅ Image column added successfully!");
      } else {
        print("⚠️ Image column already exists. No changes made.");
      }
    }
  }

  // ✅ Delete Database (Use for Testing)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "farmers.db");
    await deleteDatabase(path);
    print("✅ Database Deleted!");
  }
}
