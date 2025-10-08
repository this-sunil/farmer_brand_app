part of "AuthBloc.dart";
abstract class AuthEvent extends Equatable{}
class LoginEvent extends AuthEvent{
  final String phone;
  final String pass;
  LoginEvent({required this.phone,required this.pass});
  @override
  // TODO: implement props
  List<Object?> get props => [phone,pass];
}

class RegisterEvent extends AuthEvent{
  final String name;
  final String phone;
  final String pass;
  final String state;
  final String city;
  RegisterEvent({required this.name,required this.phone,required this.pass,required this.state,required this.city});
  @override
  // TODO: implement props
  List<Object?> get props => [name,phone,pass,state,city];
}
