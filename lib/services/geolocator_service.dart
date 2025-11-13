import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

//servicio de geolocalizacion para obtener la ciudad actual
class GeolocatorService {
  //método para obtener la ciudad actual
  obtenerciudad() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    //obtener la posicion actual
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 100));
    //obtener la ciudad a partir de la posicion
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? ciudad = placemarks[0].locality;

    return ciudad;
  }
}
