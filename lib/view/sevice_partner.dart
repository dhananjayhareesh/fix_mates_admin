import 'package:fix_mates_admin/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SevricePartner extends StatelessWidget {
  const SevricePartner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Partners'),
      ),
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No workers found.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
        }

        var workers = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: workers.length,
          itemBuilder: (context, index) {
            var worker = workers[index].data() as Map<String, dynamic>;
            String id = workers[index].id; // Get the ID of the document
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
                    Text('ID: $id', style: TextStyle(color: Colors.grey[600])),
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No workers found.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
        }

        var workers = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: workers.length,
          itemBuilder: (context, index) {
            var worker = workers[index].data() as Map<String, dynamic>;
            String id = workers[index].id; // Get the ID of the document
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: worker['photoUrl'] != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(worker['photoUrl'],
                                width: double.infinity, fit: BoxFit.cover),
                          )
                        : Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: Center(
                                child: Icon(Icons.person,
                                    color: Colors.white, size: 50)),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(worker['userName'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(worker['userEmail']),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text('Category: ${worker['category']}',
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text('ID: $id',
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: worker['idCardUrl'] != null
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No workers found.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
        }

        var workers = snapshot.data!.docs;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  var worker = workers[index].data() as Map<String, dynamic>;
                  String id = workers[index].id; // Get the ID of the document
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
                                  width: 80, height: 80, fit: BoxFit.cover),
                            )
                          : Container(
                              width: 80,
                              height: 80,
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
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
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
