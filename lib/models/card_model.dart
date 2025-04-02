class CardModel {
  final String id;
  final String uid;
  final String name;
  final String jobTitle;
  final String company;
  final String phone;
  final String email;
  final String website;
  final String address;
  final String avatarUrl;
  final DateTime createdAt;
  final bool isFavorite;
  final String notes;

  const CardModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.jobTitle,
    required this.company,
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
    required this.avatarUrl,
    required this.createdAt,
    required this.isFavorite,
    required this.notes,
  });

  CardModel copyWith({
    String? id,
    String? uid,
    String? name,
    String? jobTitile,
    String? company,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? avatarUrl,
    DateTime? createdAt,
    bool? isFavorite,
    String? notes,
  }) {
    return CardModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      jobTitle: jobTitile ?? this.jobTitle,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'jobTitile': jobTitle,
      'company': company,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isFavorite': isFavorite,
      'notes': notes,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map["\$id"] ?? "",
      uid: map['uid'] as String,
      name: map['name'] as String,
      jobTitle: map['jobTitile'] as String,
      company: map['company'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      website: map['website'] as String,
      address: map['address'] as String,
      avatarUrl: map['avatarUrl'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int,
      ),
      isFavorite: map['isFavorite'] as bool,
      notes: map['notes'] as String,
    );
  }

  @override
  String toString() {
    return 'CardModel(id: $id, uid: $uid, name: $name, jobTitile: $jobTitle, company: $company, phone: $phone, email: $email, website: $website, address: $address, avatarUrl: $avatarUrl, createdAt: $createdAt, isFavorite: $isFavorite, notes: $notes)';
  }

  @override
  bool operator ==(covariant CardModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.name == name &&
        other.jobTitle == jobTitle &&
        other.company == company &&
        other.phone == phone &&
        other.email == email &&
        other.website == website &&
        other.address == address &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt &&
        other.isFavorite == isFavorite &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        name.hashCode ^
        jobTitle.hashCode ^
        company.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        website.hashCode ^
        address.hashCode ^
        avatarUrl.hashCode ^
        createdAt.hashCode ^
        isFavorite.hashCode ^
        notes.hashCode;
  }
}
