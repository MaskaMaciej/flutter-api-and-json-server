import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database/moor_database.dart';
import '../../home/bloc/home_bloc.dart';
import '../../form/form_screen.dart';
import 'custom_dialog_alert.dart';
import 'custom_popup_menu_button.dart';
import 'data_search_view.dart';
import 'error_screen.dart';
import 'loading_screen.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API and JSON server'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              int id = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              id == 0
                  ? BlocProvider.of<HomeBloc>(context)
                      .add(HomeRefreshDataEvent(filter: RefreshEnum.all))
                  : BlocProvider.of<HomeBloc>(context)
                      .add(HomeGetSingleUserEvent(id: id));
            },
          ),
          CustomPopupMenuButton(),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeLoadingState) {
          return LoadingScreen();
        } else if (state is HomeLoadedState) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<HomeBloc>(context)
                  .add(HomeRefreshDataEvent(filter: RefreshEnum.all));
            },
            child: UsersList(users: state.users),
          );
        } else if (state is HomeErrorState) {
          return ErrorScreen(error: state.error.toString());
        } else {
          return ErrorScreen(error: 'Coś poszło nie tak!');
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final String name = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return FormScreen();
          }));
          BlocProvider.of<HomeBloc>(context)
              .add(HomeRefreshDataEvent(filter: RefreshEnum.all));
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User $name has been added.')));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class UsersList extends StatelessWidget {
  final List<User> users;

  const UsersList({required this.users});

  String initialsFromName(String? name) {
    if (name == null) return 'N';
    final splotName = '$name'.toUpperCase().split(' ');
    if (splotName.length > 1) {
      return '${splotName[0][0]}${splotName[1][0]}';
    } else {
      return '${splotName[0][0]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length == 0 ? 0 : users.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        return Slidable(
          actionPane: SlidableScrollActionPane(),
          actionExtentRatio: 0.2,
          closeOnScroll: true,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.edit,
              onTap: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return FormScreen(id: users[i].id, name: users[i].name);
                }));
                // context.read<HomeBloc>().add(HomeRefreshDataEvent());
                BlocProvider.of<HomeBloc>(context)
                    .add(HomeRefreshDataEvent(filter: RefreshEnum.all));
              },
            ),
            IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete_forever,
                onTap: () async {
                  bool delete = await showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogAlert();
                      });
                  if (delete == true) {
                    BlocProvider.of<HomeBloc>(context)
                        .add(HomeDeleteUserEvent(id: users[i].id));
                  }
                }),
          ],
          child: ListTile(
            leading: CircleAvatar(
              child: Text(initialsFromName(users[i].name)),
            ),
            title: Row(
              children: [
                Expanded(child: Text('${users[i].name}')),
                IconButton(
                  icon: users[i].isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  color: users[i].isFavorite ? Colors.red : null,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(
                      HomeUpdateIsFavoriteEvent(
                          id: users[i].id, isFavorite: !users[i].isFavorite),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
