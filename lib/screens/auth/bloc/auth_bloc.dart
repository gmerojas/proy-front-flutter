
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_one/data/repositories/auth_repository.dart';
import 'package:flutter_bloc_one/screens/auth/bloc/auth_event.dart';
import 'package:flutter_bloc_one/screens/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {

    on<AuthStarted>((event, emit) async {
      final apiResponse = await authRepository.checkLogged();
      apiResponse.fold(
        (failure) => emit(Unauthenticated()), 
        (user) => emit(Authenticated(user)),
      );
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final apiResponse = await authRepository.login(event.params);
      apiResponse.fold(
        (failure) => emit(AuthError(failure.message)), 
        (user) => emit(Authenticated(user)),
      );
    });

    on<AuthLogout>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated());
    });
  }
}
