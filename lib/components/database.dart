import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String tutahDatabase = "tutah";

  static const String tutahSchool = "tutah_school";
  static const String tutahFaculty = "tutah_faculty";
  static const String tutahFacultyDepartment = "tutah_faculty_department";
  static const String tutahProgram = "tutah_program";
  static const String tutahProgramFaculty = "tutah_program_faculty";
  static const String tutahProgramOther = "tutah_program_other";
  static const String tutahCourse = "tutah_course";

  static Future<Database> _tutahDB() async {
    return openDatabase(
      join(await getDatabasesPath(), tutahDatabase),
      onCreate: (db, version) async {
        // Create school table
        await db.execute("""CREATE TABLE $tutahSchool (
          id INTEGER,
          name TEXT,
          code TEXT,
          mission TEXT
        )""");

        // Create faculty table
        await db.execute("""CREATE TABLE $tutahFaculty (
          id INTEGER,
          school_id INTEGER,
          name TEXT,
          description TEXT
        )""");

        // Create faculty dept table
        await db.execute("""CREATE TABLE $tutahFacultyDepartment (
          id INTEGER,
          faculty_id INTEGER,
          name TEXT,
          description TEXT
        )""");

        // Create program table
        await db.execute("""CREATE TABLE $tutahProgram (
          id INTEGER,
          faculty_id INTEGER,
          faculty_dept_id INTEGER,
          name TEXT,
          code TEXT,
          description TEXT,
          requirements TEXT,
          years INTEGER
        )""");

        // Create program faculty table
        await db.execute("""CREATE TABLE $tutahProgramFaculty (
          id INTEGER,
          faculty_id INTEGER,
          program_id INTEGER
        )""");

        // Create program other table
        await db.execute("""CREATE TABLE $tutahProgramOther (
          id INTEGER,
          program_id INTEGER,
          industry TEXT,
          role_model TEXT,
          description TEXT
        )""");

        // Create course table
        await db.execute("""CREATE TABLE $tutahCourse (
          id INTEGER,
          program_id INTEGER,
          name TEXT,
          code TEXT,
          description TEXT
        )""");
      },
      version: _version,
    );
  }

  // Method to obtain a connection to the 'tutah' database
  static Future<Database> getDatabase() async {
    return _tutahDB();
  }
}
