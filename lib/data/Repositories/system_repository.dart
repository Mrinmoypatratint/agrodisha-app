import '../../utils/api.dart';

class SystemRepository {

  Future<Map<String, dynamic>> fetchSystemSettings() async {
    Map<String, dynamic> parameters = {};

    try {
      Map<String, dynamic> response = await Api.get(
        queryParameters: parameters,
        url: Api.getSystemSettingsApi,
      );

      print("Hi ${response.toString()}");

      return response;
    } catch (e) {
      print("Error fetching system settings: $e");

      return {
        "status": false,
        "message": "Something went wrong",
        "data": null
      };
    }
  }

}