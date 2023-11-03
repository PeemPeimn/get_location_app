class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates(this.latitude, this.longitude);

  List<double> toJson() {
    return [latitude, longitude];
  }

  @override
  String toString() {
    return "($latitude,$longitude)";
  }
}
