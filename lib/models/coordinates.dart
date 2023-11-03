class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates(this.latitude, this.longitude);

  Map toJson() {
    return {"lat": latitude, "lon": longitude};
  }

  @override
  String toString() {
    return "($latitude,$longitude)";
  }
}
