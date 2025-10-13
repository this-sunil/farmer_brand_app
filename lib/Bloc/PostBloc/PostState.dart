part of 'PostBloc.dart';
enum PostStatus{initial,loading,completed,error}

class PostState extends Equatable{
  final PostStatus? status;
  final String? msg;
  final PostModel? result;
  const PostState({
     this.status,
     this.msg,
     this.result
  });

  factory PostState.initial(){
    return PostState(status:PostStatus.initial);
  }

  PostState copyWith({PostStatus? status, String? msg,PostModel? result}){
    return PostState(status: status??status, msg: msg??msg, result: result??result);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,result];

}