class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String picture;
  final String nationality;
  final String city;
  final String country;
  final String state;
  final String postcode;
  final String street;
  final String username;
  final String gender;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.picture,
    required this.nationality,
    required this.city,
    required this.country,
    required this.state,
    required this.postcode,
    required this.street,
    required this.username,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['name']['first'] ?? 'N/A',
      lastName: json['name']['last'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      picture: json['picture']['large'] ?? '',
      nationality: json['nat'] ?? 'N/A',
      city: json['location']['city'] ?? 'N/A',
      country: json['location']['country'] ?? 'N/A',
      state: json['location']['state'] ?? 'N/A',
      postcode: json['location']['postcode'] ?? 'N/A',
      street: '${json['location']['street']['number']} ${json['location']['street']['name']}',
      username: json['login']['username'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
    );
  }

  String get fullName => '$firstName $lastName';
}
