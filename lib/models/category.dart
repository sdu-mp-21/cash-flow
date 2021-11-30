class Category {
  static Category empty = Category('Uncategorized');

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

  @override
  bool operator ==(Object other) =>
      other is Category && other.categoryName == categoryName;

  @override
  int get hashCode => categoryName.hashCode;

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
