import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class ApiController {
  static String baseUrl = 'http://127.0.0.1:8000/';

  static Future<void> downloadFileWeb(String filename) async {
    final url = Uri.parse("http://127.0.0.1:8000/download/$filename");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
        print("Download triggered for $filename");
      } else {
        print("Failed to download: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
  }

  static Future<void> trainingDocumentDownload(
    String fileUrl, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      // baseUrl + "get-all-training-documents",
      fileUrl,
    );
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getAllOnBoardingDocuments({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-all-training-documents",
    );
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> sendAddAgentRequest(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-agents",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Access Token: ${responseData['access_token']}");
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getCurrentAgentId({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-agent-id",
    );
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getLatestPropertyData({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-latest-property",
    );
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getManagerData({
    required String managerId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "manager/" + managerId,
    );
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getAllAgentData({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-all-agents",
    );
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getAllClientsData({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-all-clients",
    );
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> sendLoginRequest(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "manager-login",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Access Token: ${responseData['access_token']}");
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }
}
