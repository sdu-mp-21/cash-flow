class Category {
  String _categoryId = '';
  late String _categoryName;

  Category(this._categoryName);

  static const keyCategoryId = 'category_id';
  static const keyCategoryName = 'category_name';

  String get categoryId => _categoryId;

  String get categoryName => _categoryName;

  set setCategoryId(String id) {
    _categoryId = id;
  }

  Category.fromJson(Map<String, dynamic> data) {
    _categoryId = data[keyCategoryId];
    _categoryName = data[keyCategoryName];
  }

  Map<String, dynamic> toJson() {
    return {
      keyCategoryId: _categoryId,
      keyCategoryName: _categoryName,
    };
  }
}
