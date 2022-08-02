import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list/bloc/user_event.dart';
import 'package:user_list/bloc/user_state.dart';
import 'package:user_list/model/user.dart';
import 'package:user_list/services/user_hive_repository.dart';
import 'package:user_list/services/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final UserHiveRepository userHiveRepository;
  int page = 1;

  UserBloc({required this.userRepository, required this.userHiveRepository})
      : super(UserEmptyState()) {
    on<UserLoadEvent>((event, emit) async {
      if (state is UserLoadingState) return;

      final currentState = state;

      var oldUser = <User>[];
      if (currentState is UserLoadedState) {
        oldUser = currentState.loadedUser;
      }

      emit(UserLoadingState(oldUser, isFirstFetch: page == 1));

      await userHiveRepository.init();
      try {
        final List<User> list = await userRepository.getAllUsers(page);

        if (page == 1) {
          userHiveRepository.removeUsers();
        }
        page++;
        userHiveRepository.addAllUsers(list);
        emit(UserLoadedState(loadedUser: userHiveRepository.getUsers()));
      } catch (_) {
        emit(UserErrorState());
      }
    });

    on<UserRemoveEvent>((event, emit) async {
      await userHiveRepository.removeUser(event.user);
    });
  }
}
