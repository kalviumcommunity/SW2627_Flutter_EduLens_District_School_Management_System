class SchoolModel {
  final String schoolId;
  final String schoolName;
  final String location;

  const SchoolModel({
    required this.schoolId,
    required this.schoolName,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'schoolName': schoolName,
      'location': location,
    };
  }

  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      schoolId: map['schoolId'] as String? ?? '',
      schoolName: map['schoolName'] as String? ?? '',
      location: map['location'] as String? ?? '',
    );
  }

  SchoolModel copyWith({
    String? schoolId,
    String? schoolName,
    String? location,
  }) {
    return SchoolModel(
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      location: location ?? this.location,
    );
  }
}
