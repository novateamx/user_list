import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
class UserData extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String gender;
  @HiveField(4)
  final String status;

  UserData(this.id, this.name, this.email, this.gender, this.status);
}
