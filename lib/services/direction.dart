import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicare/models/directionsModel.dart';

class DirectionService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
   final Dio _dio;

  DirectionService ({required Dio? dio}) : _dio =dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
}) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination' : '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyAGBP-BhJHeX5mj_uJD3qLp1R3V9uIh7q4',
      }
    );

    if (response.statusCode==200)
      {
        return Directions.fromMap(response.data);
      }
    return null;
  }
}
