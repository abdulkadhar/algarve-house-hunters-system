import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';

class ApiController {
  static String baseUrl = 'https://systems.algarvehousehunters.com/';
  // static String baseUrl = 'http://127.0.0.1:8000/';

  // SECTION Client API calls
  // NOTE API call for post api in client
  static Future<void> sendAddClientData(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-clients",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  // NOTE API for deleting the agent
  static Future<void> deleteAgentData(
    String agentId, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "delete-agent/$agentId",
    );

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response data: $responseData");
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // NOTE API for deleting the agent
  static Future<void> deleteClientData(
    String agentId, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "delete-user/$agentId",
    );

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response data: $responseData");
        onSuccess(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");
        onError(response.body);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // NOTE API getting the client info through ID
  static Future<void> getClientInfoByID(
    String client_id, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-client-info/" + client_id,
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
  //!SECTION

  static Future<void> updateOnBoardStatus(
    String agent_id, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "complete-on-boarding/" + agent_id,
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

  static Future<void> assignedClients(
    String agent_id, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-assigned-agents/" + agent_id,
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

  static Future<void> assignAgent(
    String client_id,
    String agent_id, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-agent/" + client_id + "/" + agent_id,
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

  static Future<void> getAvailableAgents(
    String clientId, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-agent-assignment-detail/$clientId",
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

  static Future<void> requestClient(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "request-client",
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

  static Future<void> addManagerNotes(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-manager-notes",
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

  static Future<void> editManagerNotes(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "edit-manager-notes",
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

  static Future<void> sendAddClientRequest(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-clients",
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

  static Future<void> getCurrentCustomerId({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-client-id",
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

  static Future<void> getAgentInfoById(
    String agent_id, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-agent-info/" + agent_id,
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

  static Future<void> getAllCheckListDataById(
    String agent_id,
    String user_id, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-agent-checklist-data/" + agent_id + "/" + user_id,
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

  static Future<void> getClientCheckListData(
    String client_id, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-client-checklist-data/" + client_id,
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

  static Future<void> downloadFileWeb(String filename) async {
    final url = Uri.parse("${baseUrl}download/$filename");

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

  static Future<void> getUnAssignedClientsData({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-un-assigned-clients",
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
      baseUrl + "get-assigned-client-data",
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

  static Future<void> sendAgentLoginRequest(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "agent-login",
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

  static Future<void> sendPropertyAdditionRequest(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-property",
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

  static Future<void> getAllPropertiesManager({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-all-property",
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

  static Future<void> getAgentProperties(
    String agentId, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-property-id/${agentId}",
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

  static Future<void> getAgentPropertyInfo(
    String propertyId, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-property-data/${propertyId}",
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

  static Future<void> assignProperty({
    required String propertyId,
    required String customerId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "assign-property/$propertyId/$customerId",
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

  static Future<void> sendClientLoginRequest(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "client-login",
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

  static Future<void> getClientProperties({
    required String customerId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-agent-customer-property-details/${customerId}",
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
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getClientRecommendedProperties({
    required String customerId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-customer-assigned-property/${customerId}",
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

  static Future<void> getJotFormData({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "jotform-submissions",
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

  static Future<void> getAgentPasswordUpdateStatus(
    String agentId, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-agent-password-update-status/" + agentId,
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

  static Future<void> updateAgentPassword(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-password",
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
        print("Response data: ${responseData}");
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

  static Future<void> addOfficeNotes(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-office-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> addClientNotes(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-client-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> addAgentNotes(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-agent-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> addRegistrationNotes(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-registration-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> addPropertyContact(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-property-contact",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getAllClientsId({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(baseUrl + "get-all-clients-id");
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
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> addViewingInformation(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-visiting-details",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  // SECTION Manager APIs
  static Future<void> approveCustomer({
    required String clientId,
    required String msg,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(baseUrl + "approve-user/${clientId}/${msg}");
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
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> soldCustomer({
    required String clientId,
    required String msg,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(baseUrl + "sold-user/${clientId}/${msg}");
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
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> rejectCustomer({
    required String clientId,
    required String msg,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(baseUrl + "reject-user/${clientId}/${msg}");
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
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> moveCustomerToInProgress({
    required String clientId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(baseUrl + "in-progress-user/${clientId}");
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
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  //!SECTION
  static String basePathUrl = 'http://localhost:63527';
  static void changePathOnly(String newPath) {
    html.window.location.href = "$basePathUrl/#/$newPath";
  }

  static Future<void> updateAgentProfileInformation(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-agent-profile-information",
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

  static Future<void> updateAgentContactInformation(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-agent-email-address",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> updateAgentProfilePassword(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-agent-password",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getInfocasaPropertyExtraction(
    String propertyUrl, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl +
          "extract-infocasa?url=${propertyUrl}&created_by=AGT-BLR-20250625-0001",
    );
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getCasayesPropertyExtraction(
    String propertyUrl, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl +
          "extract-casayes?url=${propertyUrl}&created_by=AGT-BLR-20250625-0001",
    );
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> initialCallDataUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "edit-first-call-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> initialCallUpdateStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-first-call-statu",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> onBoardingDocumentsUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-on-boarding-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> onBoardingDocumentsMsgUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-on-boarding-status-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> onBoardingDocumentsMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "edit-on-boarding-status-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> firstCallStatusUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-first-call-status-data",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  // SECTION firstCallStatusValue
  static Future<void> firstCallStatusValueUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-first-call-status-value",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }
  //!SECTION

  static Future<void> sendWelcomeEmail(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "send-welcome-mail-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> clientEmailUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-welcome-mail-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> firstCallUpdateNotesEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-first-call-edit-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> updateFiscalStatusData(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-fiscal-status-data",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> firstCallUpdateNotes(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-first-call-notes",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> firstCallUpdateEditStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "edit-first-call-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> firstCallUpdateStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-first-call-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> fiscalUpdateStatusEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-fiscal-status-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> fiscalUpdateStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-fiscal-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> lawyerUpdateStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-lawyer-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> propertySearchUpdateStatusAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-property-search-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> propertySearchUpdateStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-property-search-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> propertySearchUpdateStatusMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-property-search-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> viewingConfirmUpdateStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-viewing-confirmed-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> propertyBookingUpdateStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-viewing-booking-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> propertyFoundStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-property-found-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> propertyFoundStatusAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-property-found-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> propertyFoundStatusMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-property-found-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> offerValueStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-offer-made-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> offerValueStatusAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-offer-made-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> offerValueStatusMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-offer-made-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> offerConfirmedStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-offer-confirmed-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> offerConfirmedStatusAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-offer-confirmed-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> offerConfirmedStatusMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-offer-confirmed-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> CPCVBookedStatusStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-CPCV-booked-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> CPCVBookedStatusStatusAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-CPCV-booked-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> CPCVBookedStatusStatusMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-CPCV-booked-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> KYCStatusUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-KYC-requested-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> KYCStatusUpdateAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-KYC-requested-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> KYCStatusUpdateStatusMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-KYC-requested-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> reviewRequestStatusUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-review-requested-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> reviewRequestStatusUpdateAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-review-requested-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> reviewRequestStatusUpdateMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-review-requested-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> allDocsReviewRequestStatusUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-all-docs-reviewed-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> allDocsReviewRequestStatusUpdateAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-all-docs-reviewed-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> allDocsReviewRequestStatusUpdateMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-all-docs-reviewed-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> deedBookedStatusUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-deed-booked-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> deedBookedStatusUpdateAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-deed-booked-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> deedBookedStatusUpdateMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-deed-booked-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> saleCompletedStatusUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-sale-completed-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> saleCompletedStatusUpdateAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-sale-completed-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> saleCompletedStatusUpdateMsgUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-sale-completed-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> afterCareStatusUpdate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-after-care-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> afterCareStatusUpdateAlone(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-after-care-status-alone",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> afterCareStatusUpdateMsgEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-after-care-status-msg-edit",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  // SECTION CRM Section
  static Future<void> addCrmData(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-crm-person",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> editCrmData(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "edit-crm-person",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> deleteCrmPerson(
    String crmId, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "delete-crm-person/$crmId",
    );

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // NOTE Un-assign agent
  static Future<void> unAssignAgent({
    required String clientId,
    required String agentId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "remove-agent/$clientId/$agentId",
    );

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<void> updateCrmStatus(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-crm-person-status",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> getAllCrmData({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-all-available-crmperson",
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

  static Future<void> getSelectedData({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-selected-crm-person-data",
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

  static Future<void> sendAdvocateInfo(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "share-advocate-info",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> sendMortgageInfo(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "share-mortgage-manager-info",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> sendCurrencyInfo(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "share-currency-manager-info",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  //!SECTION

  // SECTION Email Template Playground
  static Future<void> getAllEmailTemplates({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "get-all-email-template",
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
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  static Future<void> updateEmailTemplate(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "update-template",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  //!SECTION
  // SECTION Newer requirement api handler
  // NOTE API call for post api in client
  static Future<void> sendJotFormRemainder(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "send-jotform-remainder-mail",
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
        print("Response data: ${responseData}");
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
  //!SECTION

  // SECTION User import api
  static Future<void> uploadUserImport(
    List<int> fileBytes,
    String fileName, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final uri = Uri.parse("${baseUrl}user-import");

    // Attach file
    final request = http.MultipartRequest("POST", uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        fileBytes,
        filename: fileName,
        contentType: MediaType("text", "csv"),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      onError(response.body);
    } else {
      onSuccess(response.body);
    }
  }

  // NOTE Addition of user import addition
  static Future<void> addClientDataImport(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "add-client-data-import",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  //!SECTION
  // SECTION Handler for the property edit
  static Future<void> propertyInfoEdit(
    Map<String, dynamic> requestBody, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse(
      baseUrl + "edit-property-details",
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
        onSuccess(response.body);
      } else {
        onError(response.body);
      }
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }
  //!SECTION
}
