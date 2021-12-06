import 'package:cash_flow/models/models.dart';
import 'package:cash_flow/repositories/firebase_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() async {
  final repository = FirebaseRepository(
    firebaseAuthInstance: MockFirebaseAuth(),
    firestoreInstance: FakeFirebaseFirestore(),
  );

  group('Testing Repository: Category', () {
    test('Create Category', () async {
      final category = Category('Test Category 1');
      var id = await repository.createCategory(category);

      final loadedCategory = await repository.getCategoryById(id);
      expect(loadedCategory.categoryName, category.categoryName);
    });
  });
}
