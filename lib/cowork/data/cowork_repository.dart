import 'dart:convert';

import 'package:rtu_mirea_app/cowork/models/cowork_booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class CoworkRepository {
  Future<CoworkBooking?> loadBooking();

  Future<void> saveBooking(CoworkBooking? booking);
}

class LocalCoworkRepository implements CoworkRepository {
  const LocalCoworkRepository();

  static const storageKey = 'cowork.booking';

  @override
  Future<CoworkBooking?> loadBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return null;
    final json = jsonDecode(raw);
    if (json is! Map) throw const FormatException('Booking is invalid');
    return CoworkBooking.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> saveBooking(CoworkBooking? booking) async {
    final prefs = await SharedPreferences.getInstance();
    if (booking == null) {
      if (!await prefs.remove(storageKey)) {
        throw StateError('Could not remove saved seat');
      }
      return;
    }
    if (!await prefs.setString(storageKey, jsonEncode(booking.toJson()))) {
      throw StateError('Could not save seat');
    }
  }
}
