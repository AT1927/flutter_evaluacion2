import 'package:appwrite/appwrite.dart';

class AppwriteConfig {
  static const String endpoint = '❓❓❓❓❓❓❓❓❓❓';
  static const String projectId = '❓❓❓❓❓❓❓❓❓❓';

  static Client getClient() {
    Client client = Client();
    client
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setSelfSigned(status: true);
    return client;
  }
}
