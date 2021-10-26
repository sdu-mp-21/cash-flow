import 'package:final_project/models/models.dart';
import 'package:final_project/services/service.dart';


class Controller {
  final services = Service();

  Future registerUser(String user) async {
    await services.registerUser(user);
  }
  void clearUsers() {
    services.clearUsers();
  }

  User get user => services.user;
}