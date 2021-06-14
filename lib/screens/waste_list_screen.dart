import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/new_waste_screen.dart';
import 'package:wasteagram/screens/waste_detail_screen.dart';
import 'package:wasteagram/models/food_waste_details.dart';

class WasteListScreen extends StatefulWidget {
  @override
  _WasteListScreenState createState() => _WasteListScreenState();
}

class _WasteListScreenState extends State<WasteListScreen> {

  int numberOfWasteItems = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.docs != null && snapshot.data.docs.length > 0) {
          return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text('Wasteagram - ' + totalQuantity(snapshot).toString()),
                ),
              ),
            body: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var post = snapshot.data.docs[index];
                  return ListTile(
                      title: Text(DateFormat('MMMM dd').format(post['date'].toDate()).toString()),
                      trailing: Text(post['quantity'].toString()),
                      onTap: () {
                        WasteDetail currentWasteDetail = WasteDetail(date: post['date'].toDate(),
                            imageURL: post['imageURL'], latitude: post['latitude'], longitude: post['longitude'],
                            quantity: post['quantity']);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WasteDetailScreen(
                            currentWasteDetails: currentWasteDetail,
                        )),);
                    },
                  );
                }
            ),
            floatingActionButton: Semantics(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
              },
                child: Icon(Icons.camera_alt),
              ),
              button: true,
              enabled: true,
              label: 'Camera',
              onTapHint: 'Select an image',
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        } else {
          return Scaffold(
              appBar: AppBar(),
              body: Center(child: CircularProgressIndicator()));
        }
      }
    );
  }

  int totalQuantity(snapshot) {
    numberOfWasteItems = 0;
    for (int i = 0; i < snapshot.data.docs.length; i++){
      numberOfWasteItems += snapshot.data.docs[i]['quantity'];
    }
    return numberOfWasteItems;
  }
}
