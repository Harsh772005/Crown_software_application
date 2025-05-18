class Admission {
  final String registrationMainId;
  final String userCode;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;
  final String phoneCountryCode;
  final String email;

  Admission({
    required this.registrationMainId,
    required this.userCode,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phoneNumber,
    required this.phoneCountryCode,
    required this.email,
  });

  factory Admission.fromJson(Map<String, dynamic> json) {
    return Admission(
      registrationMainId: json['registration_main_id'],
      userCode: json['user_code'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      phoneCountryCode: json['phone_country_code'],
      email: json['email'],
    );
  }
}

