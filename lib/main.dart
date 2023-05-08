import 'package:bloc_rest_api/blocs/app_bloc.dart';
import 'package:bloc_rest_api/blocs/app_event.dart';
import 'package:bloc_rest_api/blocs/app_state.dart';
import 'package:bloc_rest_api/model/user_model.dart';
import 'package:bloc_rest_api/resources/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main(List<String> args) {
  runApp(const MyAppBloc());
}

class MyAppBloc extends StatefulWidget {
  const MyAppBloc({super.key});

  @override
  State<MyAppBloc> createState() => _MyAppBlocState();
}

class _MyAppBlocState extends State<MyAppBloc> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RepositoryProvider(
          create: (context) => ApiRepository(),
          child: const Home(),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(RepositoryProvider.of<ApiRepository>(context))
            ..add(LoadUserEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("test"),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UserLoadedState) {
              List<Welcome> user = state.user;

              return ListView.builder(
                itemCount: user.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: user[index].results.length,
                        itemBuilder: (context, resultIndex) {
                          final result = user[index].results[resultIndex];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(result.picture.thumbnail),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${result.name.first} ${result.name.last}'),
                                      Text(result.email),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              );
            }
            if (state is UserErrorState) {
              return const Center(child: Text("Error"));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
