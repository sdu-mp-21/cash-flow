import 'package:final_project/models/category.dart';

class User {
  String _username;
  String phoneNumber;
  Map<String, int> categories = <String, int>{
    'chill': 0,
    'tech': 0,
  };

  User(this._username, {this.phoneNumber = '7776665544'});

  String get username => _username;

  void addCategory(String categoryName, {int moneyAmount = 0}) {
    if (!categories.containsKey(categoryName)) {
      categories[categoryName] = moneyAmount;
    }
    categories[categoryName] = (categories[categoryName])! + moneyAmount;
  }
}
