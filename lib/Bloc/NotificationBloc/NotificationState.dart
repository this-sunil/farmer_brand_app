part of 'NotificationBloc.dart';

enum NotificationStatus{
  initial,
  loading,
  completed,
  error
}

class NotificationState extends Equatable{
  final NotificationStatus? status;
  final String? msg;
  final NotificationModel? result;
  const NotificationState({this.status,this.msg,this.result});

  factory NotificationState.initial(){
    return NotificationState(
      status: NotificationStatus.initial
    );
  }

  NotificationState copyWith({NotificationStatus? status,String? msg,NotificationModel? result}){
    return NotificationState(
      status: status??status,
      msg: msg??msg,
      result: result??result
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,result];

}