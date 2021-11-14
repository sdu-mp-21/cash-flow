import 'package:final_project/models/models.dart';
import 'package:final_project/models/transaction.dart';

abstract class Repository {
  loginUser(User user);

  registerUser(User user);

  createAccount(Account account);

  getAccounts();

  createTransaction(Transaction transaction, Account account, Category category);

  getTransactions();

  getTransactionsByAccount(Account account);

  createCategory(Category category);

  getCategories();

  getCategoryById(String id);
}
