import 'package:hive/hive.dart';
import 'package:user_list/model/user.dart';
import 'package:user_list/services/user_api_provider.dart';

class UserRepository {
  final UserProvider _userProvider = UserProvider();

  Future<List<User>> getAllUsers(int page) => _userProvider.getUsers(page);
}
