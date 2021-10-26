import 'package:final_project/models/models.dart';
import 'package:final_project/services/service.dart';

class Controller {
  final services = Service();

  Future<bool> loginUser(User user) async {
    return await services.loginUser(user);
  }

  Future<bool> registerUser(User user) async {
    return await services.registerUser(user);
  }

  void clearUsers() {
    services.clearUsers();
  }

  Future createAccount(Account account) async {
    await services.createAccount(account);
  }

  Future<List<Account>> getAccounts() async {
    return await services.getAccounts();
  }

  User get user => services.user;
}
