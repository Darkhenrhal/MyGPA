import 'dart:convert';

class User {
  final int? id;
  final String name;
  final String email;
  final String gpaMethod;
  final int totalSemesters;
  final int totalCourseCredits;
  final double currentGPA;
  final Map<String, dynamic> customGradeWeights;
  final Map<String, dynamic> defaultGradeWeights;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.gpaMethod,
    required this.currentGPA,
    required this.totalSemesters,
    required this.totalCourseCredits,
    required this.customGradeWeights,
    required this.defaultGradeWeights,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      currentGPA: map['currentGPA'] ?? 0,
      gpaMethod: map['gpaMethod'],
      totalSemesters: map['totalSemesters'] ?? 0, // Handle null case here
      totalCourseCredits: map['totalCourseCredits'] ?? 0, // Handle null case here
      customGradeWeights: map['customGradeWeights'] != null
          ? Map<String, dynamic>.from(jsonDecode(map['customGradeWeights']))
          : {}, // Handle null case here
      defaultGradeWeights: map['defaultGradeWeights'] != null
          ? Map<String, dynamic>.from(jsonDecode(map['defaultGradeWeights']))
          : {}, // Handle null case here
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'currentGPA':currentGPA,
      'gpaMethod': gpaMethod,
      'totalSemesters': totalSemesters,
      'totalCourseCredits': totalCourseCredits,
      'customGradeWeights': jsonEncode(customGradeWeights),
      'defaultGradeWeights': jsonEncode(defaultGradeWeights),
    };
  }
}
