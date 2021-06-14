import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:wasteagram/models/food_waste_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  File image;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final currentWastePost = WastePost();

  final numberController = TextEditingController();
  LocationData locationData;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    currentWastePost.longitude = locationData.longitude;
    currentWastePost.latitude = locationData.latitude;
    setState(() {});
  }

  Future uploadImage() async {
    Reference ref = FirebaseStorage.instance.ref().child(DateTime.now().toString());
    await ref.putFile(image);
    currentWastePost.imageURL = await ref.getDownloadURL();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: scaffoldPhoto(image),
    );
  }

  Widget scaffoldPhoto(File image) {
    if (image == null) {
      getImage();
    } else if (locationData == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image),
            SizedBox(height: 40),
            Form(
              key: formKey,
              child: Semantics(
                child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: 'Number of Items', border: OutlineInputBorder()),
                    controller: numberController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a number';
                      } else {
                        return null;
                      }
                    }),
                enabled: true,
                label: 'Number of Items',
                onTapHint: 'Input the number of items',
              ),
            ),
        Expanded(
          child: Semantics(
            enabled: true,
            label: 'Submit information',
            onTapHint: 'Upload image and number of items',
            child: InkWell(
                child: Icon(Icons.cloud_upload, size: 110),
              onTap: () async {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  // Upload image
                  await uploadImage();
                  final variable = int.parse(numberController.text);
                  currentWastePost.quantity = variable;
                  FirebaseFirestore.instance.collection('posts').add({
                    'date': currentWastePost.date,
                    'imageURL': currentWastePost.imageURL,
                    'latitude': currentWastePost.latitude,
                    'longitude': currentWastePost.longitude,
                    'quantity': currentWastePost.quantity,
                  });
                }
                Navigator.pop(context);
              },
            ),
          ),
        )
          ],
        ),
      );
    }
  }
}
