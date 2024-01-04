import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Debt extends HiveObject {
  @HiveField(0)
  final String property1;

  @HiveField(1)
  final int property2;

  Debt({required this.property1, required this.property2});
}