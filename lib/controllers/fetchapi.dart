import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fishmaster/controllers/marineweatherController/apiurl.dart'
    as marine_api;
import 'package:fishmaster/controllers/weatherController/weatherapiurl.dart'
    as weather_api;
import 'package:fishmaster/models/Marine/finalmarineData/marine_current.dart';
import 'package:fishmaster/models/Marine/finalmarineData/marine_daily.dart';
import 'package:fishmaster/models/Marine/finalmarineData/marine_data.dart';
import 'package:fishmaster/models/Marine/finalmarineData/marine_hourly.dart';
import 'package:fishmaster/models/WeatherGeneral/finalweatherData/weather_current.dart';
import 'package:fishmaster/models/WeatherGeneral/finalweatherData/weather_daily.dart';
import 'package:fishmaster/models/WeatherGeneral/finalweatherData/weather_data.dart';
import 'package:fishmaster/models/WeatherGeneral/finalweatherData/weather_hourly.dart';

class FetchAPI {
  Future<MarineWeatherData?> fetchMarineData(double lat, double long) async {
    return await _fetchData<MarineWeatherData>(marine_api.apiURL(lat, long),
        (jsonString) {
      return MarineWeatherData(
        MarineDataCurrent.fromJson(jsonString),
        MarineDataHourly.fromJson(jsonString),
        MarineDataDaily.fromJson(jsonString),
      );
    });
  }

  Future<WeatherData?> fetchWeatherData(double lat, double long) async {
    return await _fetchData<WeatherData>(weather_api.apiURL(lat, long),
        (jsonString) {
      return WeatherData(
        WeatherDataCurrent.fromJson(jsonString),
        WeatherDataHourly.fromJson(jsonString),
        WeatherDataDaily.fromJson(jsonString),
      );
    });
  }

  Future<T?> _fetchData<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        print("Got response");
        return fromJson(jsonString);
      } else {
        print("Failed to fetch data: \${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return null;
  }
}
