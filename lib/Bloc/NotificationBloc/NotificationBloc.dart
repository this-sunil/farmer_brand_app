import 'package:farmer_brand/Model/NotificationModel.dart';
import 'package:farmer_brand/Repository/NotificationRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'NotificationEvent.dart';
part 'NotificationState.dart';
class NotificationBloc extends Bloc<NotificationEvent,NotificationState>{
  final NotificationRepository repository;
  NotificationBloc(this.repository):super(NotificationState.initial()){
    on<FetchNotificationEvent>(_fetchNotification);
  }
  _fetchNotification(FetchNotificationEvent event,Emitter<NotificationState> emit) async{
    emit(state.copyWith(status: NotificationStatus.initial));
    String url='${dotenv.env['BASE_URL']}${dotenv.env['FETCH_NOTIFICATION']}';
    final result=await repository.fetchNotification(url: url);
    result.fold((l)=>emit(state.copyWith(status: NotificationStatus.error,msg: l.msg)), (r)=>emit(state.copyWith(status: r.status,msg: r.msg,result: r.result)));
  }
}