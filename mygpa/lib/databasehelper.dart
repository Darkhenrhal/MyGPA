import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'course.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'course_database.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        credit INTEGER NOT NULL DEFAULT 0,
        grade TEXT, 
        semester INTEGER)
      '''
    );

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        gpaMethod TEXT,
        currentGPA REAL NOT NULL DEFAULT 0,
        totalSemesters INTEGER NOT NULL DEFAULT 0,
        totalCourseCredits INTEGER NOT NULL DEFAULT 0,
        customGradeWeights TEXT NOT NULL DEFAULT '{}',
        defaultGradeWeights TEXT NOT NULL DEFAULT '{}'
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN totalSemesters INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE users ADD COLUMN totalCourseCredits INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE users ADD COLUMN customGradeWeights TEXT NOT NULL DEFAULT "{}"');
      await db.execute('ALTER TABLE users ADD COLUMN defaultGradeWeights TEXT NOT NULL DEFAULT "{}"');
    }
  }


  // Course Methods
  Future<int> insertCourse(Course course) async {
    Database db = await database;
    return await db.insert('courses', course.toMap());
  }

  Future<List<Course>> getCourses() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('courses');

    return List.generate(maps.length, (i) {
      return Course.fromMap(maps[i]);
    });
  }

  Future<int> updateCourse(Course course) async {
    Database db = await database;
    return await db.update('courses', course.toMap(), where: 'id = ?', whereArgs: [course.id]);
  }

  Future<int> deleteCourse(int id) async {
    Database db = await database;
    return await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getCurrentTotalCourseCredits() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT SUM(credit) as currentTotalCourseCredits FROM courses');

    if (result.isNotEmpty && result.first['currentTotalCourseCredits'] != null) {
      return result.first['currentTotalCourseCredits'] as int;
    }
    return 0;
  }

  Future<double> getCurrentGPA() async {
    Database db = await database;
    User? userFromFuture=await getUser();
    User? user= userFromFuture;
    List<Course> coursesList = await getCourses();
    String? gpaMethodFromFuture= await getGPAMethod();
    String gpaMethod  = gpaMethodFromFuture ?? '';
    double sumOfMultiplyOfWeightCredit = 0.0;
    int sumOfCurrentTotalCredits = await getCurrentTotalCourseCredits();

    if(gpaMethod=="default"){
      Map<String,dynamic> courseWeightMap=user!.defaultGradeWeights;
      for (Course course in coursesList){
        for(MapEntry<String,dynamic> item in courseWeightMap.entries){
          if(item.key==course.grade){
            print('Key: ${item.key}, Value: ${item.value}');
            double multiplyOfWeightCredit =item.value  * course.credit;
            sumOfMultiplyOfWeightCredit+=multiplyOfWeightCredit;
          }
        }
      }
      print('sum of multiply $sumOfMultiplyOfWeightCredit and sum of total credits $sumOfCurrentTotalCredits');
      double newCurrentGpa = sumOfCurrentTotalCredits > 0
          ? sumOfMultiplyOfWeightCredit / sumOfCurrentTotalCredits
          : 0.0;
      print("new GPA is $newCurrentGpa");
      return newCurrentGpa;
    }else if(gpaMethod=="custom"){
      Map<String,dynamic> courseWeightMap=user!.customGradeWeights;
      for (Course course in coursesList){
        for(MapEntry<String,dynamic> item in courseWeightMap.entries){
          if(item.key==course.grade){
            print('Key: ${item.key}, Value: ${item.value}');
            double multiplyOfWeightCredit =item.value  * course.credit;
            sumOfMultiplyOfWeightCredit+=multiplyOfWeightCredit;
          }
        }
      }
      print('sum of multiply $sumOfMultiplyOfWeightCredit and sum of total credits $sumOfCurrentTotalCredits');
      double newCurrentGpa = sumOfCurrentTotalCredits > 0
          ? sumOfMultiplyOfWeightCredit / sumOfCurrentTotalCredits
          : 0.0;
      print("new GPA is $newCurrentGpa");
      return newCurrentGpa;
    }
    return 0;
  }


  // User Methods
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }


  Future<List<User>> getUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUser() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM users LIMIT 1');

    if (maps.isNotEmpty) {
      User user = User.fromMap(maps.first);
      print(user.name);
      return user;
    } else {
      print("User not found");
      return null;
    }
  }


  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getTotalSemesters() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT totalSemesters FROM users LIMIT 1');
    if (result.isNotEmpty) {
      return result.first['totalSemesters'] as int;
    }
    return 0;
  }

  Future<String?> getEmail() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT email FROM users LIMIT 1');
    if (result.isNotEmpty) {
      return result.first['email'] as String;
    }
    return null;
  }

  Future<String?> getGPAMethod() async{
    Database db=await database;
    var result = await db.rawQuery('SELECT gpaMethod From users Limit 1');
    if (result.isNotEmpty){
      return result.first['gpaMethod'] as String;
    }
    return null;
  }

  Future<String?> getName() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT name FROM users LIMIT 1');
    if (result.isNotEmpty) {
      return result.first['name'] as String;
    }
    return null;
  }

  Future<int> getTotalCourseCredits() async{
    Database db=await database;
    var result=await db.rawQuery('SELECT totalCourseCredits FROM users LIMIT 1');
    if(result.isNotEmpty){
      return result.first['totalCourseCredits'] as int;
    }
    return 0;
  }

  Future<Map<String,dynamic>?> retrieveDefaultGradeWeights() async{
    DatabaseHelper dbHelper =DatabaseHelper();
    List<User> users=await dbHelper.getUsers();

    if(users.isNotEmpty){
      User user =users.first;
      if(user.gpaMethod=="default") {
        Map<String, dynamic> defaultWeights = user.defaultGradeWeights;
        return defaultWeights;
      }else{
        Map<String, dynamic> customWeights = user.customGradeWeights;
        return customWeights;
      }
    // Return default grade weights from the first user in the list
    } else {
      return null; // Return null if no users are found
    }
  }

}



