part of 'WeatherBloc.dart';
enum WeatherStatus{initial,loading,completed,error}
class WeatherState extends Equatable{
  final WeatherStatus? status;
  final String? msg;
  final WeatherModel? model;
  const WeatherState({this.status,this.msg,this.model});

  factory WeatherState.initial(){
    return WeatherState(status: WeatherStatus.initial);
  }

  WeatherState copyWith({WeatherStatus? status,String? msg,WeatherModel? model}){
    return WeatherState(status: status??status,msg: msg??msg,model: model??model);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,model];

}