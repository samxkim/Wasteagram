class WastePost {
  final DateTime date = DateTime.now();
  String imageURL;
  double latitude;
  double longitude;
  int quantity;

  WastePost({this.imageURL, this.latitude, this.longitude, this.quantity});
}