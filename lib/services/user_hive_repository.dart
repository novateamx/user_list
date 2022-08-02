import 'package:hive/hive.dart';
import 'package:user_list/model/user.dart';
import 'package:user_list/model/user_data.dart';

class UserHiveRepository {
  late Box<UserData> _users;

  isExists() async {
    print('length: ${_users.length}');
    bool length = _users.length != 0;
    return length;
  }

  Future<void> init() async {
    _users = await Hive.openBox('UsersBox');
  }

  List<User> getUsers() {
    List<User> users = [];
    for (var item in _users.values.toList()) {
      users.add(User(
        id: item.id,
        name: item.name,
        email: item.email,
        gender: item.gender,
        status: item.status,
      ));
    }
    return users;
  }

  void addAllUsers(List<User> list) {
    List<UserData> users = [];
    for (var item in list) {
      users.add(UserData(
        item.id ?? 1,
        item.name ?? '',
        item.email ?? '',
        item.gender ?? '',
        item.status ?? '',
      ));
    }
    _users.addAll(users);
  }

  Future<void> removeUsers() async {
    await _users.deleteAll(_users.keys);
  }

  Future<void> removeUser(User item) async {
    final userToRemove =
        _users.values.firstWhere((element) => element.id == item.id);
    await userToRemove.delete();
  }
}
