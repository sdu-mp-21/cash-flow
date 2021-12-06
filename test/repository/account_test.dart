import 'package:cash_flow/models/account.dart';
import 'package:cash_flow/repositories/firebase_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() async {
  final repository = FirebaseRepository(
    firebaseAuthInstance: MockFirebaseAuth(),
    firestoreInstance: FakeFirebaseFirestore(),
  );

  group('Testing Repository: Account', () {
    test('Create Account', () async {
      final account = Account('Test Account 1', 101010);
      final id = await repository.createAccount(account);

      final loadedAccount = await repository.getAccountById(id);
      expect(loadedAccount.accountName, account.accountName);
      expect(loadedAccount.balance, account.balance);
    });
  });

  test('DeleteAccount', () async {
    final account = Account('Test Account 2', 111000);
    final id = await repository.createAccount(account);
    account.setAccountId = id;

    await repository.deleteAccount(account);
    final loadedAccount = await repository.getAccountById(id);
    expect(loadedAccount, Account.empty);
  });
}
