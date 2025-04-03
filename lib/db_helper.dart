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

    await db.execute('''
  CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customerName TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    paymentMethod TEXT NOT NULL,
    status TEXT NOT NULL  -- ✅ Corrected: Added comma before "status"
  )
''');


    print("✅ Tables Created!");


  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final db = await database;
    int count = await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );

    if (count > 0) {
      print("✅ Order $orderId status updated to $newStatus");
    } else {
      print("⚠️ Failed to update order $orderId");
    }
  }

  Future<void> deleteOrder(int orderId) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query("orders");
  }

  Future<void> insertOrder(String name, String phone, String address, String payment, String status) async {
    final db = await database;
    await db.insert(
      'orders',
      {
        'customerName': name,
        'phone': phone,
        'address': address,
        'paymentMethod': payment,
        'status': status, // ✅ Ensure status is stored
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      print("✅ Upgrading Database...");

      // Check if "status" column exists in the orders table
      List<Map<String, dynamic>> orderColumns = await db.rawQuery("PRAGMA table_info(orders)");

      bool statusColumnExists = orderColumns.any((column) => column['name'] == 'status');

      if (!statusColumnExists) {
        await db.execute('ALTER TABLE orders ADD COLUMN status TEXT DEFAULT "Pending"');
        print("✅ 'status' column added successfully!");
      } else {
        print("⚠️ 'status' column already exists. No changes made.");
      }

      // Check if "image" column exists in the users table
      List<Map<String, dynamic>> userColumns = await db.rawQuery("PRAGMA table_info(users)");

      bool imageColumnExists = userColumns.any((column) => column['name'] == 'image');

      if (!imageColumnExists) {
        await db.execute('ALTER TABLE users ADD COLUMN image TEXT');
        print("✅ 'image' column added successfully!");
      } else {
        print("⚠️ 'image' column already exists. No changes made.");
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
