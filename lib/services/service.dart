import 'package:final_project/repositories/file_repository.dart';
import 'package:final_project/models/models.dart';

class Service {
  final repositories = FileRepository();

  Future<bool> loginUser(User user) async {
    return await repositories.loginUser(user);
  }

  Future<bool> registerUser(User user) async {
    return await repositories.registerUser(user);
  }

  void clearUsers() {
    repositories.clearUsers();
  }

  Future createAccount(Account account) async {
    await repositories.createAccount(account);
  }

  Future<List<Account>> getAccounts() async {
    return await repositories.getAccounts();
  }

  Future createTransaction(Account account, Transaction transaction) async {
    await repositories.createTransaction(account, transaction);
  }

  Future<List<Transaction>> getTransactions() async {
    return await repositories.getTransactions();
  }

  User get user => repositories.user;
}
