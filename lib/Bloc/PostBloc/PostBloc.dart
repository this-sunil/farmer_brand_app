import 'package:equatable/equatable.dart';
import 'package:farmer_brand/Model/PostModel.dart';
import 'package:farmer_brand/Repository/PostRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'PostEvent.dart';
part 'PostState.dart';
class PostBloc extends Bloc<PostEvent,PostState>{
  final PostRepository repository;
  PostBloc(this.repository):super(PostState.initial()){
    on<FetchPostEvent>(_fetchPostApi);
  }

  _fetchPostApi(FetchPostEvent event,Emitter<PostState> emit) async{
    emit(state.copyWith(status: PostStatus.loading));
    String url="${dotenv.env["BASE_URL"]}${dotenv.env["FETCH_POSTS"]}";
     final result=await repository.getAllPost(url:url, body:{},header: {
       "Content-Type":"application/json"
     });
     result.fold((l)=>emit(state.copyWith(status: l.status,msg: l.msg)), (r)=>emit(state.copyWith(status: r.status,msg: r.msg,result: r.result)));
  }

}