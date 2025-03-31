import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final List<String> savedCards;
  final List<String> favCards;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.savedCards,
    required this.favCards,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    List<String>? savedCards,
    List<String>? favCards,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      savedCards: savedCards ?? this.savedCards,
      favCards: favCards ?? this.favCards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'savedCards': savedCards,
      'favCards': favCards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['\$id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String,
      savedCards: List<String>.from((map['savedCards'])),
      favCards: List<String>.from((map['favCards'])),
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, profilePic: $profilePic, savedCards: $savedCards, favCards: $favCards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.profilePic == profilePic &&
        listEquals(other.savedCards, savedCards) &&
        listEquals(other.favCards, favCards);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePic.hashCode ^
        savedCards.hashCode ^
        favCards.hashCode;
  }
}
