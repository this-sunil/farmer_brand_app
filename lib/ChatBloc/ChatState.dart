part of 'ChatBloc.dart';
enum ChatStatus{initial,loading,completed,error}
class ChatState extends Equatable{
  final ChatStatus? status;
  final String? msg;
  final List<Map<String, String>> chats;
  const ChatState({this.status,this.msg,required this.chats});

  factory ChatState.initial(){
    return ChatState(status: ChatStatus.initial,chats: []);
  }

  ChatState copyWith({ChatStatus? status, String? msg, required List<Map<String,String>> chats}){
    return ChatState(status: status??status,msg: msg??msg,chats: chats??chats);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,chats];
}