import 'package:farmer_brand/Model/WeatherModel.dart';
import 'package:farmer_brand/Repository/WeatherRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'WeatherEvent.dart';
part 'WeatherState.dart';
class WeatherBloc extends Bloc<WeatherEvent,WeatherState>{
  final WeatherRepository repository;
  WeatherBloc(this.repository):super(WeatherState.initial()){
    on<FetchWeatherEvent>(_fetchWeatherInfo);
  }
  _fetchWeatherInfo(FetchWeatherEvent event,Emitter<WeatherState> emit) async{
    emit(state.copyWith(status: WeatherStatus.loading));
    String? url=dotenv.env["WEATHER_URL"];
    final result=await repository.weatherApi(url:url.toString(), body:{
      "lat":event.lat,
      "long":event.long,
    }, header:{"Content-Type":"application/json"});
    result.fold((l)=>emit(state.copyWith(status: l.status,msg: l.msg)), (r)=>emit(state.copyWith(status: r.status,msg: r.msg,model: r.result)));
  }
}
