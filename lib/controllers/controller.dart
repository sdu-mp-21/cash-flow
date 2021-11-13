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

  Future createTransaction(Transaction transaction, Account account, Category category) async {
    services.createTransaction(transaction, account, category);
  }

  Future<List<Transaction>> getTransactions() async {
    return await services.getTransactions();
  }

  Future<List<Transaction>> getTransactionsByAccount(Account acc) async {
    return await services.getTransactionsByAccount(acc);
  }

  Future createCategory(Category category) async {
    await services.createCategory(category);
  }

  Future<Category> getCategoryById(String id) async {
    return await services.getCategoryById(id);
  }

  Future<List<Category>> getCategories() async {
    return await services.getCategories();
  }
}
