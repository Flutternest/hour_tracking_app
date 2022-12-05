import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_mvp/auth/models/auth_user.dart';
import 'package:flux_mvp/features/common/repositories/trip_repository.dart';

import '../providers/trip.dart';

class FirebaseTripRepository implements TripRepository {
  final FirebaseFirestore firestore;

  FirebaseTripRepository({required this.firestore});

  @override
  String get path => 'trips';

  @override
  Future<List<Trip>> getAllTrips(String? driverId,
      {bool includeOngoing = false}) async {
    Query<Map<String, dynamic>> query = firestore.collection(path);

    if (driverId != null) {
      query = query.where('driver_id', isEqualTo: driverId);
    }

    if (!includeOngoing) {
      query = query.where('trip_status', isNotEqualTo: "ongoing");
      query = query.orderBy('trip_status');
    }

    final snapshot =
        await query.orderBy('date_created', descending: true).get();

    final trips = snapshot.docs.map((e) => Trip.fromJson(e.data())).toList();
    return trips;
  }

  @override
  Stream<List<Trip>> getAllTripsStream(String? driverId,
      {bool includeOngoing = false}) {
    Query<Map<String, dynamic>> query = firestore.collection(path);

    if (driverId != null) {
      query = query.where('driver_id', isEqualTo: driverId);
    }
    if (!includeOngoing) {
      query = query.where('trip_status', isNotEqualTo: "ongoing");
      query = query.orderBy('trip_status');
    }

    final snapshot =
        query.orderBy('date_created', descending: true).snapshots();

    final trips = snapshot
        .map((e) => e.docs.map((e) => Trip.fromJson(e.data())).toList());
    return trips;
  }

  @override
  Future<Trip?> getCurrentOnGoingTrip(String driverId) async {
    final snapshot = await firestore
        .collection(path)
        .where('driver_id', isEqualTo: driverId)
        .where('trip_status', whereIn: ["ongoing", "paused"]).get();
    if (snapshot.docs.isEmpty) return null;
    return Trip.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<void> createTrip(Trip trip, {required String tripId}) {
    final tripData = trip.toJson();
    tripData.addAll({"date_created": FieldValue.serverTimestamp()});
    return firestore.collection(path).doc(tripId).set(tripData);
  }

  @override
  Future<int> lastTripIdUsed() async {
    final snapshot = await firestore
        .collection(path)
        .orderBy("date_created", descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return 0;
    final lastTrip = snapshot.docs.first;
    final lastTripId = lastTrip.data()['trip_id'];
    return lastTripId;
  }

  @override
  Future<void> pauseTrip(String tripId) {
    return firestore.collection(path).doc(tripId).update({
      'trip_status': 'paused',
    });
  }

  @override
  Future<void> resumeTrip(String tripId) {
    return firestore.collection(path).doc(tripId).update({
      'trip_status': 'ongoing',
    });
  }

  @override
  Future<void> stopTrip(
    String tripId, {
    required DateTime end,
    required double distanceInMiles,
    required double totalPayment,
    required int timeDrivenInSeconds,
  }) {
    return firestore.collection(path).doc(tripId).update({
      'trip_status': 'completed',
      'end': end.toIso8601String(),
      'amount': totalPayment,
      'miles': distanceInMiles,
      'time_driven_in_seconds': timeDrivenInSeconds,
    });
  }

  @override
  Future<Trip> getTripDetails(String tripId) async {
    final snapshot = await firestore.collection(path).doc(tripId).get();
    return Trip.fromJson(snapshot.data()!);
  }

  @override
  Future<List<Trip>> getAllOngoingTrips() async {
    final snapshot = await firestore
        .collection(path)
        .where('trip_status', isEqualTo: "ongoing")
        .orderBy('date_created', descending: true)
        .get();

    final trips = snapshot.docs.map((e) => Trip.fromJson(e.data())).toList();
    return trips;
  }

  @override
  Future<List<Trip>> getAllTripsWithPendingPayment() async {
    final snapshot = await firestore
        .collection(path)
        .where('payment_status', isEqualTo: "pending")
        .where('trip_status', isEqualTo: "completed")
        .orderBy('date_created', descending: true)
        .get();

    final trips = snapshot.docs.map((e) => Trip.fromJson(e.data())).toList();
    return trips;
  }

  @override
  Stream<List<Trip>> getAllOngoingTripsStream() {
    final snapshot = firestore
        .collection(path)
        .where('trip_status', whereIn: ["ongoing", "paused"])
        .orderBy('date_created', descending: true)
        .snapshots();

    final trips = snapshot
        .map((e) => e.docs.map((e) => Trip.fromJson(e.data())).toList());
    return trips;
  }

  @override
  Stream<List<Trip>> getAllTripsWithPendingPaymentStream() {
    final snapshot = firestore
        .collection(path)
        .where('payment_status', isEqualTo: "pending")
        .where('trip_status', isEqualTo: "completed")
        .orderBy('date_created', descending: true)
        .snapshots();

    final trips = snapshot
        .map((e) => e.docs.map((e) => Trip.fromJson(e.data())).toList());
    return trips;
  }

  @override
  Future<List<AuthUser>> getAllDrivers() async {
    final snapshot = await firestore.collection('users').get();
    final drivers = snapshot.docs
        .map((e) => AuthUser.fromJson(e.data()))
        .where((element) => element.type == "driver")
        .toList();
    return drivers;
  }

  @override
  Future<void> updateDriver(String driverId, AuthUser driver) {
    return firestore.collection('users').doc(driverId).update(driver.toJson());
  }

  @override
  Future<void> markAsPaid(String tripId) {
    return firestore.collection(path).doc(tripId).update({
      'payment_status': 'paid',
    });
  }
}
