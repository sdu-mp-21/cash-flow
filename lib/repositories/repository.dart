import 'package:final_project/models/models.dart';
import 'package:final_project/models/transaction.dart';

abstract class Repository {
  loginUser(User user);

  registerUser(User user);

  createAccount(Account account);

  getAccounts();

  createTransaction(Account account, Transaction transaction);

  getTransactions();
}
