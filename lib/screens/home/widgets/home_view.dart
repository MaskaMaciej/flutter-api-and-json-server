import 'package:api_and_json_server/data/database/moor_database.dart';
import 'package:api_and_json_server/screens/home/widgets/custom_dialog_alert.dart';
import 'package:api_and_json_server/screens/home/widgets/custom_popup_menu_button.dart';
import 'package:api_and_json_server/screens/home/widgets/data_search_view.dart';
import 'package:api_and_json_server/screens/home/widgets/error_screen.dart';
import 'package:api_and_json_server/screens/home/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:api_and_json_server/screens/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_and_json_server/screens/form/form_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('API and JSON server'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: DataSearch(bloc: homeBloc),
              );
            },
          ),
          CustomPopupMenuButton(bloc: homeBloc),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeLoadingState) {
          return LoadingScreen();
        } else if (state is HomeLoadedState) {
          return RefreshIndicator(
            onRefresh: () async {
              homeBloc.add(HomeRefreshDataEvent(filter: RefreshEnum.all));
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
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return FormScreen();
          }));
          homeBloc.add(HomeRefreshDataEvent(filter: RefreshEnum.all));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class UsersList extends StatelessWidget {
  final List<User> users;

  const UsersList({@required this.users});

  String initialsFromName(String name) {
    if (name == null) return 'N';
    final splotName = name.toUpperCase().split(' ') ?? '$name'.split(' ');
    if (splotName.length > 1) {
      return '${splotName[0][0]}${splotName[1][0]}';
    } else {
      return '${splotName[0][0]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return ListView.separated(
      itemCount: users == null ? 0 : users.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
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
                homeBloc.add(HomeRefreshDataEvent(filter: RefreshEnum.all));
              },
            ),
            IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete_forever,
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogAlert(
                            bloc: homeBloc, userId: users[i].id);
                      });
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
                    homeBloc.add(
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
