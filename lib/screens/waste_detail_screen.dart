import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/models/food_waste_details.dart';

class WasteDetailScreen extends StatelessWidget {
  final WasteDetail currentWasteDetails;

  WasteDetailScreen({Key key, @required this.currentWasteDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: Column(
              children: [
                Text('Date: ${currentWasteDetails.date}'),
                Text(DateFormat('yyyy-MM-dd').format(currentWasteDetails.date).toString()),
                Image.network(currentWasteDetails.imageURL),
                Text('latitude: ${currentWasteDetails.latitude}'),
                Text('longitude: ${currentWasteDetails.longitude}'),
                Text('quantity: ${currentWasteDetails.quantity}')
              ],
            )));
  }
}
