class Category {
  late int _category_id;
  late int _user_id;
  late String _category_name;

  Category(this._category_name);

  static const keyCategoryId = 'category_id';
  static const keyUserId = 'user_id';
  static const keyCategoryName = 'category_name';

  int get categoryId => _category_id;
  String get categoryName => _category_name;
  set setCategoryId(int id) {
    _category_id = id;
  }

  set setUserId(int id) {
    _user_id = id;
  }

  @override
  bool operator ==(Object other) =>
      other is Category && other.categoryName == categoryName;

  @override
  int get hashCode => categoryName.hashCode;

  Category.fromJson(Map<String, dynamic> data) {
    _category_id = data[keyCategoryId];
    _user_id = data[keyUserId];
    _category_name = data[keyCategoryName];
  }

  Map<String, dynamic> toJson() {
    return {
      keyCategoryId: _category_id,
      keyUserId: _user_id,
      keyCategoryName: _category_name,
    };
  }
}
