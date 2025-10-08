part of 'WeatherBloc.dart';
abstract class WeatherEvent extends Equatable{}
class FetchWeatherEvent extends WeatherEvent{
  final String lat;
  final String long;
  FetchWeatherEvent(this.lat,this.long);

  @override
  // TODO: implement props
  List<Object?> get props => [lat,long];
}