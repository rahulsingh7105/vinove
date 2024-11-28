import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceRecord {
  final DateTime checkInTime;
  DateTime? checkOutTime;

  AttendanceRecord({required this.checkInTime, this.checkOutTime});

  // Method to calculate the duration
  Duration getDuration() {
    if (checkOutTime == null) return Duration.zero;
    return checkOutTime!.difference(checkInTime);
  }
}

class Member {
  final String name;
  final LatLng currentLocation;
  List<AttendanceRecord> attendance;

  Member({
    required this.name,
    required this.currentLocation,
    required this.attendance,
  });

  // Method to calculate total attendance duration
  Duration totalAttendanceDuration() {
    return attendance.fold(
      Duration.zero,
      (total, record) => total + record.getDuration(),
    );
  }
}
