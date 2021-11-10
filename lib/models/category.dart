class Category {
  late int _categoryId;
  late int _userId;
  late String _categoryName;

  Category(this._categoryName);

  static const keyCategoryId = 'category_id';
  static const keyUserId = 'user_id';
  static const keyCategoryName = 'category_name';

  int get categoryId => _categoryId;
  String get categoryName => _categoryName;
  set setCategoryId(int id) {
    _categoryId = id;
  }

  set setUserId(int id) {
    _userId = id;
  }

  @override
  bool operator ==(Object other) =>
      other is Category && other.categoryName == categoryName;

  @override
  int get hashCode => categoryName.hashCode;

  Category.fromJson(Map<String, dynamic> data) {
    _categoryId = data[keyCategoryId];
    _userId = data[keyUserId];
    _categoryName = data[keyCategoryName];
  }

  Map<String, dynamic> toJson() {
    return {
      keyCategoryId: _categoryId,
      keyUserId: _userId,
      keyCategoryName: _categoryName,
    };
  }
}
