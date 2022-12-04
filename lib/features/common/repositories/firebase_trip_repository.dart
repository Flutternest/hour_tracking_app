import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_mvp/features/common/repositories/trip_repository.dart';

import '../providers/trip.dart';

class FirebaseTripRepository implements TripRepository {
  final FirebaseFirestore firestore;

  FirebaseTripRepository({required this.firestore});

  @override
  String get path => 'trips';

  @override
  Future<List<Trip>> getAllTrips(String driverId) async {
    final snapshot = await firestore
        .collection(path)
        .where('driver_id', isEqualTo: driverId)
        .get();
    final trips = snapshot.docs.map((e) => Trip.fromJson(e.data())).toList();
    return trips;
  }

  @override
  Future<Stream<List<Trip>>> getAllTripsStream(String driverId) async {
    final snapshot = firestore
        .collection(path)
        .where('driver_id', isEqualTo: driverId)
        .snapshots();
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
  }) {
    return firestore.collection(path).doc(tripId).update({
      'trip_status': 'completed',
      'end': end.toIso8601String(),
      'payment': totalPayment,
      'miles': distanceInMiles,
    });
  }
}
