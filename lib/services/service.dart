import 'package:final_project/repositories/file_repository.dart';
import 'package:final_project/models/models.dart';

class Service {
  final repositories = FileRepository();

  Future<bool> loginUser(User user) async {
    return await repositories.loginUser(user);
  }

  Future registerUser(User user) async {
    await repositories.registerUser(user);
  }
  void clearUsers() {
    repositories.clearUsers();
  }

  User get user => repositories.user;
}