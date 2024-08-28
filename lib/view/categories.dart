import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  Future<Map<String, dynamic>> _getBookingDetails(String bookingId) async {
    final bookingDoc = await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .get();
    final bookingData = bookingDoc.data()!;

    final workerDoc = await FirebaseFirestore.instance
        .collection('workers')
        .doc(bookingData['workerId'])
        .get();
    final workerData = workerDoc.data()!;

    final userDoc = await FirebaseFirestore.instance
        .collection('usersDetails')
        .doc(bookingData['userId'])
        .get();
    final userData = userDoc.data()!;

    return {
      'date': bookingData['date'],
      'timeSlot': bookingData['timeSlot'],
      'description': bookingData['description'],
      'workerName': workerData['userName'],
      'userName': userData['userName'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Bookings').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final bookingId = booking.id;

              return FutureBuilder<Map<String, dynamic>>(
                future: _getBookingDetails(bookingId),
                builder: (context, detailsSnapshot) {
                  if (detailsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                        title: Center(child: CircularProgressIndicator()));
                  }
                  if (detailsSnapshot.hasError) {
                    return ListTile(
                        title: Text('Error: ${detailsSnapshot.error}'));
                  }
                  if (!detailsSnapshot.hasData) {
                    return ListTile(title: Text('No details available.'));
                  }

                  final details = detailsSnapshot.data!;

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                          'Booking on ${details['date']} at ${details['timeSlot']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description: ${details['description']}'),
                          Text('Worker: ${details['workerName']}'),
                          Text('User: ${details['userName']}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
