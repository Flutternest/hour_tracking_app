import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final double? amount;
  final String? driverId;
  final String? driverName;
  final String? eldSerialId;
  final DateTime? start;
  final DateTime? end;
  final double? miles;
  final String? tripStatus;
  final String? paymentStatus;
  final int? tripId;

  const Trip({
    this.amount,
    this.driverId,
    this.driverName,
    this.eldSerialId,
    this.start,
    this.end,
    this.miles,
    this.tripStatus,
    this.paymentStatus,
    this.tripId,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        amount: (json['amount'] as num?)?.toDouble(),
        driverId: json['driver_id'] as String?,
        driverName: json['driver_name'] as String?,
        eldSerialId: json['eld_serial_id'] as String?,
        start: json['start'] == null
            ? null
            : DateTime.parse(json['start'] as String),
        end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
        miles: (json['miles'] as num?)?.toDouble(),
        tripStatus: json['trip_status'] as String?,
        paymentStatus: json['payment_status'] as String?,
        tripId: json['trip_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'driver_id': driverId,
        'driver_name': driverName,
        'eld_serial_id': eldSerialId,
        'start': start?.toIso8601String(),
        'end': end?.toIso8601String(),
        'miles': miles,
        'trip_status': tripStatus,
        'payment_status': paymentStatus,
        'trip_id': tripId,
      };

  Trip copyWith({
    double? amount,
    String? driverId,
    String? driverName,
    String? eldSerialId,
    DateTime? start,
    DateTime? end,
    double? miles,
    String? tripStatus,
    String? paymentStatus,
    int? tripId,
  }) {
    return Trip(
      amount: amount ?? this.amount,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      eldSerialId: eldSerialId ?? this.eldSerialId,
      start: start ?? this.start,
      end: end ?? this.end,
      miles: miles ?? this.miles,
      tripStatus: tripStatus ?? this.tripStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      tripId: tripId ?? this.tripId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      amount,
      driverId,
      driverName,
      eldSerialId,
      start,
      end,
      miles,
      tripStatus,
      paymentStatus,
      tripId,
    ];
  }
}
