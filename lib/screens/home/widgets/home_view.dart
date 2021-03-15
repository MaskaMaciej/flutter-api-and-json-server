import 'package:api_and_json_server/data/database/moor_database.dart';
import 'package:api_and_json_server/screens/home/widgets/data_search_view.dart';
import 'package:api_and_json_server/screens/home/widgets/error_screen.dart';
import 'package:api_and_json_server/screens/home/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:api_and_json_server/screens/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_and_json_server/screens/form/form_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeView extends StatelessWidget {
  //TODO: Methods which returns widgets should NEVER be longer then 70-80 lines, here you have 100 lines, please split this to some separate widgets
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeLoadingState) {
        return LoadingScreen();
      } else if (state is HomeLoadedState) {
        //TODO: You were supposed to remove this scaffolds.
        return Scaffold(
          appBar: AppBar(
            title: Text('API and JSON server'),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  //TODO: Pick full users from db, do not pass state.users here.
                  var id = await showSearch(
                    context: context,
                    delegate: DataSearch(users: state.users),
                  );
                  context.read<HomeBloc>().add(HomeGetSingleUserEvent(id: id));
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ElevatedButton(
                      child: const Text('Show all'),
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeRefreshDataEvent());
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ElevatedButton(
                      child: const Text('Show alphabetical'),
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeRefreshDataEvent(
                            filter: RefreshEnum.alphabetical));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ElevatedButton(
                      child: const Text('Show favorites'),
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeRefreshDataEvent(
                            filter: RefreshEnum.favorites));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ElevatedButton(
                      child: const Text('Show not favorites'),
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeRefreshDataEvent(
                            filter: RefreshEnum.notFavorites));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(HomeRefreshDataEvent());
            },
            child: UsersList(users: state.users),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return FormScreen();
              }));
              context.read<HomeBloc>().add(HomeRefreshDataEvent());
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        );
      } else if (state is HomeErrorState) {
        return ErrorScreen(error: state.error.toString());
      } else {
        // return ErrorScreen(error: 'Coś poszło nie tak!');
        return LoadingScreen();
      }
    });
  }
}

class UsersList extends StatelessWidget {
  final List<User> users;

  const UsersList({this.users});

  String initialsFromName(String name) {
    if (name == null) return 'N';
    final splotName = name.toUpperCase().split(' ') ?? '$name'.split(' ');
    if (splotName.length > 1) {
      return '${splotName[0][0]}${splotName[1][0]}';
    } else {
      return '${splotName[0][0]}';
    }
  }

  //TODO: Methods which returns widgets should NEVER be longer then 70-80 lines, here you have 100 lines, please split this to some separate widgets
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users == null ? 0 : users.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
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
                context.read<HomeBloc>().add(HomeRefreshDataEvent());
              },
            ),
            IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete_forever,
                onTap: () async {
                  bool flag = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              'Are you sure you want to delete this user?'),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  //TODO: You should just run deletion event here, you dont need this 'flag' and if awaited after dialog disposal.
                                }),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                ),
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                }),
                          ],
                        );
                      });
                  if (flag) {
                    context
                        .read<HomeBloc>()
                        .add(HomeDeleteUserEvent(id: users[i].id));
                    //TODO: Double refresh?
                    context.read<HomeBloc>().add(HomeRefreshDataEvent());
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
                    context.read<HomeBloc>().add(
                          HomeUpdateIsFavoriteEvent(
                              id: users[i].id,
                              isFavorite: !users[i].isFavorite),
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
