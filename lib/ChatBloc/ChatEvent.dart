part of 'ChatBloc.dart';
abstract class ChatEvent extends Equatable{}
enum BoatStatus{user,boat}
class BotEvent extends ChatEvent{
  final BoatStatus? status;
  final String? msg;
  BotEvent({this.status,this.msg});
  @override
  // TODO: implement props
  List<Object?> get props => [status,msg];
}
