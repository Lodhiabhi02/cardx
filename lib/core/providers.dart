import 'package:appwrite/appwrite.dart';
import 'package:cardx/constants/constants.dart';
import 'package:riverpod/riverpod.dart';

final appwriteClinetProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: true);
});

final appwriteAccountProvider = Provider((ref) {
  final client = ref.watch(appwriteClinetProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClinetProvider);
  return Databases(client);
});

final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClinetProvider);
  return Storage(client);
});

final appwriteRealTimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClinetProvider);
  return Realtime(client);
});
