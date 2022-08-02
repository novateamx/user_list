import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list/bloc/user_bloc.dart';
import 'package:user_list/bloc/user_event.dart';
import 'package:user_list/pages/widgets/user_list.dart';
import 'package:user_list/services/user_hive_repository.dart';
import 'package:user_list/services/user_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => UserHiveRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: ((context) => UserBloc(
                    userRepository:
                        RepositoryProvider.of<UserRepository>(context),
                    userHiveRepository:
                        RepositoryProvider.of<UserHiveRepository>(context),
                  )..add(UserLoadEvent()))),
        ],
        child: UserList(),
      ),
    );
  }
}
