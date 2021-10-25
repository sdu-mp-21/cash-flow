import 'package:final_project/models/models.dart';
import 'package:final_project/services/service.dart';


class Controller {
  final services = Service();

  void registerUser(User user) {
    services.registerUser(user);
  }

  User get user => services.user;
}