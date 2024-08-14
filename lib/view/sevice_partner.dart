import 'package:fix_mates_admin/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_mates_admin/widget/side_menu_widget.dart';

class SevricePartner extends StatelessWidget {
  const SevricePartner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Partners'),
      ),
      drawer: !isDesktop
          ? const SizedBox(
              width: 250,
              child: SideMenuWidget(),
            )
          : null,
      body: ResponsiveBuilder(
        builder: (context, size) {
          if (Responsive.isMobile(context)) {
            return _buildMobileLayout();
          } else if (Responsive.isTablet(context)) {
            return _buildTabletLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return _buildWorkersList();
  }

  Widget _buildTabletLayout() {
    return _buildWorkersList();
  }

  Widget _buildDesktopLayout() {
    return _buildWorkersList();
  }

  Widget _buildWorkersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workers').snapshots(),
      builder: (context, workersSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('blockedWorkers')
              .snapshots(),
          builder: (context, blockedWorkersSnapshot) {
            if (workersSnapshot.connectionState == ConnectionState.waiting ||
                blockedWorkersSnapshot.connectionState ==
                    ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var workers = workersSnapshot.data?.docs ?? [];
            var blockedWorkers = blockedWorkersSnapshot.data?.docs ?? [];

            if (workers.isEmpty && blockedWorkers.isEmpty) {
              return Center(
                  child: Text('No workers found.',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)));
            }

            var allWorkers = workers + blockedWorkers;

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: allWorkers.length,
              itemBuilder: (context, index) {
                var worker = allWorkers[index].data() as Map<String, dynamic>;
                String id = allWorkers[index].id; // Get the ID of the document
                bool isBlocked = blockedWorkers.any((doc) => doc.id == id);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: worker['photoUrl'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(worker['photoUrl'],
                                width: 60, height: 60, fit: BoxFit.cover),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white)),
                    title: Text(worker['userName'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(worker['userEmail']),
                        SizedBox(height: 4),
                        Text('Category: ${worker['category']}',
                            style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 4),
                        Text('ID: $id',
                            style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 4),
                        worker['idCardUrl'] != null
                            ? GestureDetector(
                                onTap: () =>
                                    _showImage(context, worker['idCardUrl']),
                                child: Text('ID Card Available',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                              )
                            : Text('No ID Card Available',
                                style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isBlocked ? Icons.check_circle : Icons.block,
                        color: isBlocked ? Colors.green : Colors.red,
                      ),
                      onPressed: () {
                        if (isBlocked) {
                          _unblockWorker(id, worker);
                        } else {
                          _blockWorker(id, worker);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _blockWorker(String id, Map<String, dynamic> workerData) {
    FirebaseFirestore.instance
        .collection('blockedWorkers')
        .doc(id)
        .set(workerData)
        .then((_) {
      FirebaseFirestore.instance.collection('workers').doc(id).delete();
    });
  }

  void _unblockWorker(String id, Map<String, dynamic> workerData) {
    FirebaseFirestore.instance
        .collection('workers')
        .doc(id)
        .set(workerData)
        .then((_) {
      FirebaseFirestore.instance.collection('blockedWorkers').doc(id).delete();
    });
  }

  void _showImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ID Card'),
          content: Image.network(imageUrl),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Size size) builder;

  const ResponsiveBuilder({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builder(context, size);
  }
}
