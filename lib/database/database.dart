import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  // Factory constructor to return the same instance
  factory DatabaseHelper() {
    return _instance;
  }

  // Database initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), 'my_database.db');
    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        print(path);
        await db.execute('PRAGMA foreign_keys = ON');
        // await db.execute(
        //   'ALTER TABLE client ADD COLUMN isFlexible INTEGER DEFAULT 0',
        // );
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute('''
      CREATE TABLE agent(
        agentId INTEGER PRIMARY KEY AUTOINCREMENT,
        agentName TEXT,
        email TEXT,
        contactNo TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE client(
        clientId INTEGER PRIMARY KEY AUTOINCREMENT,
        clientName TEXT NOT NULL,
        loanAmount REAL NOT NULL,
        loanTerm INTEGER NOT NULL,
        interestRate REAL NOT NULL,
        loanDate TEXT NOT NULL,
        agentId INTEGER NOT NULL,
        agentInterest REAL NOT NULL,
        isFlexible INTEGER DEFAULT 0,
        FOREIGN KEY (agentId) REFERENCES agent(agentId) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE payment(
        paymentId INTEGER PRIMARY KEY AUTOINCREMENT,
        paymentSchedule TEXT NOT NULL,
        principalBalance REAL NOT NULL,
        monthlyPayment REAL NOT NULL,
        interestPaid REAL NOT NULL,
        capitalPayment REAL NOT NULL,
        agentShare REAL NOT NULL,
        paymentDate TEXT,
        modeOfPayment TEXT,
        remarks TEXT,
        clientId INTEGER NOT NULL,
        FOREIGN KEY (clientId) REFERENCES client(clientId) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE partial(
        partialId INTEGER PRIMARY KEY AUTOINCREMENT,
        interestPaid REAL NOT NULL,
        capitalPayment REAL NOT NULL,
        agentShare REAL NOT NULL,
        paymentDate TEXT,
        modeOfPayment TEXT,
        remarks TEXT,
        paymentId INTEGER NOT NULL,
        FOREIGN KEY (paymentId) REFERENCES payment(paymentId) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE balanceSheet(
        balanceSheetId INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        inAmount REAL NOT NULL Default 0,
        outAmount REAL NOT NULL Default 0,
        balance REAL NOT NULL Default 0,
        remarks TEXT,
        paymentId INTEGER,
        clientId INTEGER,
        partialId INTEGER,
        FOREIGN KEY (partialId) REFERENCES partial(partialId) ON DELETE CASCADE,
        FOREIGN KEY (clientId) REFERENCES client(clientId) ON DELETE CASCADE,
        FOREIGN KEY (paymentId) REFERENCES payment(paymentId) ON DELETE CASCADE
      )
    ''');
  }
}
