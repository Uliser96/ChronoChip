import 'dart:convert';

class User {
  int? id;
  String? email;
  String? firstName;
  String? lastName;

  User({this.id, this.email, this.firstName, this.lastName});

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName)';
  }

  factory User.fromMap(Map<String, dynamic> data) {
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return User(
      id: _toInt(data['id']),
      email: data['email'] as String?,
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith({int? id, String? email, String? firstName, String? lastName}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
