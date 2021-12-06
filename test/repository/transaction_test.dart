import 'package:cash_flow/models/account.dart';
import 'package:cash_flow/models/models.dart';
import 'package:cash_flow/repositories/firebase_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() async {
  // final repository = FirebaseRepository(
  //   firebaseAuthInstance: MockFirebaseAuth(),
  //   firestoreInstance: FakeFirebaseFirestore(),
  // );

  // group('Testing Repository: Transaction', () {
  //   test('Create Transaction', () async {
  //     final account = Account('Test Account 1', 110011);
  //     var accountId = await repository.createAccount(account);
  //     account.setAccountId = accountId;
  //
  //     final category = Category('Test Category 1');
  //     await repository.createCategory(category).then((id) => category.setCategoryId = id);
  //
  //     final transaction = Transaction(300, true, 'Test Transaction');
  //     var transactionId = repository.createTransaction(transaction, account, category);
  //
  //     var l = await repository.getTransactionsStream().length;
  //     expect(l, 1);
  //     // expect(list.first.transactionId, transactionId);
  //   });
  // });
}
