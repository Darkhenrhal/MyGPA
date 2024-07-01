class Course{
  int? id;
  String title;
  int credit;
  String grade;
  double weight;
  int semester;

  Course({this.id,required this.semester,required this.title,required this.credit, required this.grade, required this.weight});

  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'title':title,
      'credit':credit,
      'grade':grade,
      'weight':weight,
      'semester':semester,
    };
  }

  factory Course.fromMap(Map<String,dynamic>map){
    return Course(
        id: map['id'],
        semester: map['semester'],
        title: map['title'],
        credit: map['credit'],
        grade: map['grade'],
        weight: map['weight']
    );
  }

}