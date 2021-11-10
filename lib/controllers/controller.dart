import 'package:final_project/models/models.dart';
import 'package:final_project/services/service.dart';

class Controller {
  final services = Service();

  User get user => services.user;

  Future<bool> loginUser(User user) async {
    return await services.loginUser(user);
  }

  Future<bool> registerUser(User user) async {
    return await services.registerUser(user);
  }

  Future createAccount(Account account) async {
    await services.createAccount(account);
  }

  Future<List<Account>> getAccounts() async {
    return services.getAccounts();
  }

  Future createTransaction(Account account, Transaction transaction) async {
    services.createTransaction(account, transaction);
  }

  Future<List<Transaction>> getTransactions() async {
    return <Transaction>[];
  }

  Future<List<Transaction>> getTransactionsByAccount(Account acc) async {
    return <Transaction>[];
  }

  Future createCategory(Category category) async {}

  Future<Category> getCategory(int id) async {
    return Category("default");
  }

  Future<List<Category>> getCategories() async {
    return <Category>[];
  }
}
