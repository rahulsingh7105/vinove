import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'member.dart';
import 'location_screen.dart';
import 'attendance_screen.dart';

class MemberScreen extends StatelessWidget {
  final List<Member> members = [
    Member(
      name: "Manu",
      currentLocation: const LatLng(37.42796133580664, -122.085749655962),
      attendance: [],
    ),
    Member(
      name: "Rahul Singh",
      currentLocation: const LatLng(37.42996133580664, -122.083749655962),
      attendance: [],
    ),
    Member(
      name: "Anurag Singh",
      currentLocation: const LatLng(37.42696133580664, -122.080749655962),
      attendance: [],
    ),
  ];

  MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Member List",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: members.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[400],
            thickness: 0.8,
            indent: 15,
            endIndent: 15,
          ),
          itemBuilder: (context, index) {
            return _buildMemberCard(context, members[index]);
          },
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, Member member) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            _getInitials(member.name),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.location_on),
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationScreen(member: member),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.check_circle),
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceScreen(member: member),
                  ),
                );
              },
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  String _getInitials(String name) {
    // Extract initials safely
    final parts = name.split(' ');
    return parts.length > 1
        ? parts.first[0].toUpperCase() + parts.last[0].toUpperCase()
        : parts.first[0].toUpperCase();
  }
}
