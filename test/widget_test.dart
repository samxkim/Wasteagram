// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/food_waste_post.dart';

import 'package:wasteagram/main.dart';

void main() {
  test("FoodWastePost with no information", () {
    final currentFoodPost = WastePost();
    expect(currentFoodPost.date, DateTime.now());
    expect(currentFoodPost.imageURL, null);
    expect(currentFoodPost.latitude, null);
    expect(currentFoodPost.longitude, null);
    expect(currentFoodPost.quantity, null);
  });

  test("FoodWastePost with some information", () {
    String testImageURL = 'google.com';
    double testLatitude = 168.2;
    double testLongitude = 170.7;
    int testQuantity = 2;
    final currentFoodPost = WastePost(imageURL: testImageURL,
        latitude: testLatitude, longitude: testLongitude,
        quantity: testQuantity);
    expect(currentFoodPost.date, DateTime.now());
    expect(currentFoodPost.imageURL, testImageURL);
    expect(currentFoodPost.latitude, testLatitude);
    expect(currentFoodPost.longitude, testLongitude);
    expect(currentFoodPost.quantity, testQuantity);
  });
}
