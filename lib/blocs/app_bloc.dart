import 'package:bloc_rest_api/blocs/app_event.dart';
import 'package:bloc_rest_api/blocs/app_state.dart';
import 'package:bloc_rest_api/resources/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiRepository apiRepository;
  UserBloc(this.apiRepository) : super(UserLoadingState()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final user = await apiRepository.getUser();
        emit(UserLoadedState(user));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
