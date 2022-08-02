import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_list/bloc/user_bloc.dart';
import 'package:user_list/bloc/user_event.dart';
import 'package:user_list/bloc/user_state.dart';
import 'package:user_list/model/user.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool _enabledShimmer = true;

  final scrollController = ScrollController();

  //ScrollController of Infinite List
  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          context.read<UserBloc>().add(UserLoadEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    setupScrollController(context);
    return Scaffold(
      appBar: AppBar(title: const Text('User List'), centerTitle: true),
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        List<User> users = [];
        bool isLoading = false;

        if (state is UserLoadingState && state.isFirstFetch) {
          return _shimmerLoading();
        } else if (state is UserLoadingState) {
          users = state.oldUserList;
          isLoading = true;
        } else if (state is UserLoadedState) {
          users = state.loadedUser;
        } else if (state is UserErrorState) {
          return const Center(child: Text('Error fetching users'));
        }

        return ListView.builder(
          controller: scrollController,
          itemBuilder: ((context, index) {
            if (index < users.length) {
              return Dismissible(
                key: ValueKey<User>(users[index]),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (direction) {
                  _userBloc.add(UserRemoveEvent(users[index]));
                  setState(() {
                    users.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User deleted')));
                },
                child: SizedBox(
                  height: 100,
                  child: Card(
                    child: ListTile(
                      leading: Text(
                        'ID: ${users[index].id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        '${users[index].name}',
                      ),
                      subtitle: Text(
                        '${users[index].email}',
                      ),
                    ),
                  ),
                ),
              );
            } else {
              Timer(const Duration(milliseconds: 30), () {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              });
              return _loadingIndicator();
            }
          }),
          itemCount: users.length + (isLoading ? 1 : 0),
        );
      }),
    );
  }

// Widget is Shimmer effect.
  Widget _shimmerLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: _enabledShimmer,
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 48.0,
                        height: 48.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: 40.0,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BottomLoader of Infinite List
  Widget _loadingIndicator() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
