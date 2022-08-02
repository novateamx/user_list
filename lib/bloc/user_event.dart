import 'package:user_list/model/user.dart';

abstract class UserEvent {}

class UserLoadEvent extends UserEvent {}

class UserRemoveEvent extends UserEvent {
  final User user;

  UserRemoveEvent(this.user);
}
