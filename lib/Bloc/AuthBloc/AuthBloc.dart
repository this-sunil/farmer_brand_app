import 'package:farmer_brand/Model/AuthModel.dart';
import 'package:farmer_brand/Repository/AuthRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'AuthEvent.dart';
part 'AuthState.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthState.initial()) {
    on<LoginEvent>(_loginApi);
    on<RegisterEvent>(_registerApi);
  }
  _registerApi(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await repository.registerRepo(
        url: "${dotenv.env["BASE_URL"]}${dotenv.env["REGISTER"]}",
        body: {"name":event.name,"phone": event.phone, "pass": event.pass,"state":event.state,"city":event.city},
        header: {
          "Content-Type":"application/json"
        }
    );

    result.fold(
          (l) => emit(state.copyWith(status: l.status, msg: l.msg)),
          (r) => emit(state.copyWith(msg: r.msg, status: r.status, result: r.result)),
    );
  }
  _loginApi(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await repository.loginRepo(
      url: "${dotenv.env["BASE_URL"]}${dotenv.env["LOGIN"]}",
      body: {"phone": event.phone, "pass": event.pass},
      header: {
        "Content-Type":"application/json"
      }
    );

    result.fold(
      (l) => emit(state.copyWith(status: l.status, msg: l.msg)),
      (r) => emit(state.copyWith(msg: r.msg, status: r.status, result: r.result)),
    );
  }
}
