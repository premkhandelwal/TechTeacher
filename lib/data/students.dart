import 'dart:convert';

class Students {
  String? id;
  String? studentName;
  String? dateofBirth;
  String? studentGender;
  String? emailId;
  Students({
    this.id,
    this.studentName,
    this.dateofBirth,
    this.studentGender,
    this.emailId
  });



  Students copyWith({
    String? id,
    String? studentName,
    String? dateofBirth,
    String? studentGender,
    String? emailId,
  }) {
    return Students(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      dateofBirth: dateofBirth ?? this.dateofBirth,
      studentGender: studentGender ?? this.studentGender,
      emailId: emailId ?? this.emailId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'dateofBirth': dateofBirth,
      'studentGender': studentGender,
      'emailId': emailId,
    };
  }

  factory Students.fromMap(Map<String, dynamic> map) {
    return Students(
      id: map['id'],
      studentName: map['studentName'],
      dateofBirth: map['dateofBirth'],
      studentGender: map['studentGender'],
      emailId: map['emailId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Students.fromJson(String source) => Students.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Students(id: $id, studentName: $studentName, dateofBirth: $dateofBirth, studentGender: $studentGender, emailId: $emailId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Students &&
      other.id == id &&
      other.studentName == studentName &&
      other.dateofBirth == dateofBirth &&
      other.studentGender == studentGender &&
      other.emailId == emailId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      studentName.hashCode ^
      dateofBirth.hashCode ^
      studentGender.hashCode ^
      emailId.hashCode;
  }
}
