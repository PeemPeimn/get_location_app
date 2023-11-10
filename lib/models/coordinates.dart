import 'package:hive/hive.dart';

part 'coordinates.g.dart';

@HiveType(typeId: 1)
class CoordinatesList {
  @HiveField(0)
  final List<Coordinates> list;

  const CoordinatesList(this.list);
}

@HiveType(typeId: 0)
class Coordinates {
  @HiveField(0, defaultValue: 0)
  final double latitude;

  @HiveField(1, defaultValue: 0)
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
