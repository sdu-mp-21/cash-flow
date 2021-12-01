import 'package:cash_flow/models/models.dart';
import 'package:cash_flow/models/transaction.dart';

abstract class Repository {
  // auth
  loginUser(User user);

  registerUser(User user);

  // account
  createAccount(Account account);

  getAccounts();

  getAccountById(String id);

  updateAccount(Account account);

  deleteAccount(Account account);

  // transaction
  createTransaction(
      Transaction transaction, Account account, Category category);

  getTransactionsStream();

  updateTransaction(Transaction old, Transaction updated);

  deleteTransaction(Transaction transaction);

  // category
  createCategory(Category category);

  getCategories();

  getCategoryById(String id);

  updateCategory(Category category);

  deleteCategory(Category category);
}
