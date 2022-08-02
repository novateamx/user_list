import 'package:user_list/model/user.dart';

abstract class UserState {}

class UserEmptyState extends UserState {}

class UserLoadingState extends UserState {
  final List<User> oldUserList;
  final bool isFirstFetch;

  UserLoadingState(this.oldUserList, {this.isFirstFetch = false});
}

class UserLoadedState extends UserState {
  List<User> loadedUser;

  UserLoadedState({required this.loadedUser});
}

class UserErrorState extends UserState {}
