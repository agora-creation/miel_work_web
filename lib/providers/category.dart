import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/services/category.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String name,
  }) async {
    String? error;
    if (organization == null) return 'カテゴリの追加に失敗しました';
    if (name == '') return 'カテゴリ名を入力してください';
    try {
      String id = _categoryService.id();
      _categoryService.create({
        'id': id,
        'organizationId': organization.id,
        'name': name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'カテゴリの追加に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required CategoryModel category,
  }) async {
    String? error;
    try {
      _categoryService.delete({
        'id': category.id,
      });
    } catch (e) {
      error = 'カテゴリの削除に失敗しました';
    }
    return error;
  }
}
