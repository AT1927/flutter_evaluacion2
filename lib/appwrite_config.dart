import 'package:appwrite/appwrite.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String projectId = '68228cc7001c4f85515b';

  static Client getClient() {
    Client client = Client();
    client
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setSelfSigned(status: true);
    return client;
  }
}
