class StudentData {
  final String name;
  final String sId;
  final String userId;
  final String collegeId;
  final String sectionId;
  final String pSectionId;
  final String semester;

  final String section;
  final String phone;
  final String email;
  final String dob;
  final String tempAddress;
  final String permanentAddress;

  StudentData({
    required this.name,
    required this.sId,
    required this.userId,
    required this.collegeId,
    required this.sectionId,
    required this.pSectionId,
    required this.semester,
    required this.section,
    required this.phone,
    required this.email,
    required this.dob,
    required this.tempAddress,
    required this.permanentAddress,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    DateTime? bDate;
    if (json['Date_of_Birth'] != null) {
      bDate = DateTime.parse(json['Date_of_Birth']);
    }
    return StudentData(
      name: json['Student_Name'].toString(),
      sId: json['Student_Id'].toString(),
      userId: json['University_RollNo'].toString(),
      collegeId: json['Institute'].toString(),
      sectionId: json['SectionId'].toString(),
      pSectionId: json['PSectionId'].toString(),
      semester: json['Semester'].toString(),
      section: json['Section'] == null? '' : json['Section'].toString(),
      phone:  json['MobileNumber'] == null? '' : json['MobileNumber'].toString(),
      email:  json['PEmail'] == null? '' : json['PEmail'].toString().toLowerCase(),
      dob: bDate == null ? '' : '${bDate.day}/${bDate.month}/${bDate.year}',
      tempAddress: json['Local_Address'] == null? '' : json['Local_Address'].toString(),
      permanentAddress: json['Permanent_Address'] == null? '' : json['Permanent_Address'].toString(),
    );
  }
}
