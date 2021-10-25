import 'package:final_project/repositories/file_repository.dart';
import 'package:final_project/models/models.dart';

class Service {
  final repositories = FileRepository();

  void registerUser(User user) {
    repositories.registerUser(user);
  }

  User get user => repositories.user;
}