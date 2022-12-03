import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String? name;
  final String? uid;
  final String? driverId;
  final String? eldSerialId;
  final String? email;
  final String? type;

  const AuthUser({
    this.name,
    this.uid,
    this.driverId,
    this.eldSerialId,
    this.email,
    this.type,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        name: json['name'] as String?,
        uid: json['uid'] as String?,
        driverId: json['driver_id'] as String?,
        eldSerialId: json['eld_serial_id'] as String?,
        email: json['email'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'driver_id': driverId,
        'eld_serial_id': eldSerialId,
        'email': email,
        'type': type,
      };

  AuthUser copyWith({
    String? name,
    String? uid,
    String? driverId,
    String? eldSerialId,
    String? email,
    String? type,
  }) {
    return AuthUser(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      driverId: driverId ?? this.driverId,
      eldSerialId: eldSerialId ?? this.eldSerialId,
      email: email ?? this.email,
      type: type ?? this.type,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, uid, driverId, eldSerialId, email, type];
}
