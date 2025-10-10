part of "AuthBloc.dart";
enum AuthStatus{initial,loading,login,register,update,refresh,fetch,error}
class AuthState extends Equatable{
  final AuthStatus? status;
  final String? msg;
  final AuthModel? result;
  const AuthState({this.status, this.msg, this.result});
  factory AuthState.initial(){
    return AuthState(status: AuthStatus.initial);
  }
  AuthState copyWith({AuthStatus? status,String? msg,AuthModel? result}){
    return AuthState(
      status: status??status,
      msg: msg??msg,
      result: result??result
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,result];

}

