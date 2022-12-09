import 'package:geolocator/geolocator.dart';

Future<bool> hasService()async{
  bool serviceEnabled;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }else{
    return true;
  }
}