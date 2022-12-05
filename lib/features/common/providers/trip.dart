import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final double? amount;
  final String? eldSerialId;
  final DateTime? start;
  final DateTime? end;
  final double? miles;
  final String? tripStatus;
  final String? paymentStatus;
  final int? tripId;
  final num? payPerMile;
  final int? timeDrivenInSeconds;
  final String? driverId; //for query
  final Driver? driver;

  const Trip({
    this.amount,
    this.eldSerialId,
    this.start,
    this.end,
    this.miles,
    this.tripStatus,
    this.paymentStatus,
    this.tripId,
    this.payPerMile,
    this.timeDrivenInSeconds,
    this.driver,
    this.driverId,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        amount: (json['amount'] as num?)?.toDouble(),
        driver: json['driver'] == null
            ? null
            : Driver.fromJson(json['driver'] as Map<String, dynamic>),
        driverId: json['driver_id'] as String?,
        eldSerialId: json['eld_serial_id'] as String?,
        start: json['start'] == null
            ? null
            : DateTime.parse(json['start'] as String),
        end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
        miles: (json['miles'] as num?)?.toDouble(),
        tripStatus: json['trip_status'] as String?,
        paymentStatus: json['payment_status'] as String?,
        tripId: json['trip_id'] as int?,
        payPerMile: (json['pay_per_mile']) as num?,
        timeDrivenInSeconds: (json['time_driven_in_seconds']) as int?,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'eld_serial_id': eldSerialId,
        'start': start?.toIso8601String(),
        'end': end?.toIso8601String(),
        'miles': miles,
        'trip_status': tripStatus,
        'payment_status': paymentStatus,
        'trip_id': tripId,
        'pay_per_mile': payPerMile,
        'time_driven_in_seconds': timeDrivenInSeconds,
        'driver': driver?.toJson(),
        'driver_id': driverId,
      };

  Trip copyWith({
    double? amount,
    String? eldSerialId,
    DateTime? start,
    DateTime? end,
    double? miles,
    String? tripStatus,
    String? paymentStatus,
    int? tripId,
    num? payPerMile,
    int? timeDrivenInSeconds,
    Driver? driver,
    String? driverId,
  }) {
    return Trip(
      amount: amount ?? this.amount,
      eldSerialId: eldSerialId ?? this.eldSerialId,
      start: start ?? this.start,
      end: end ?? this.end,
      miles: miles ?? this.miles,
      tripStatus: tripStatus ?? this.tripStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      tripId: tripId ?? this.tripId,
      payPerMile: payPerMile ?? this.payPerMile,
      timeDrivenInSeconds: timeDrivenInSeconds,
      driver: driver ?? this.driver,
      driverId: driverId ?? this.driverId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      amount,
      driver,
      eldSerialId,
      start,
      end,
      miles,
      tripStatus,
      paymentStatus,
      tripId,
      payPerMile,
      timeDrivenInSeconds,
      driverId,
    ];
  }
}

class Driver extends Equatable {
  final String? driverId;
  final String? driverName;
  final String? driverEmail;

  const Driver({this.driverId, this.driverName, this.driverEmail});

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json['driver_id'] as String?,
        driverName: json['driver_name'] as String?,
        driverEmail: json['driver_email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'driver_id': driverId,
        'driver_name': driverName,
        'driver_email': driverEmail,
      };

  Driver copyWith({
    String? driverId,
    String? driverName,
    String? driverEmail,
  }) {
    return Driver(
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverEmail: driverEmail ?? this.driverEmail,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      driverId,
      driverName,
      driverEmail,
    ];
  }
}
