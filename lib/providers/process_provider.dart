import 'package:flutter/foundation.dart';
import '../data/models/category_model.dart';
import '../data/models/process_model.dart';
import '../data/repositories/process_repository.dart';

enum LoadStatus { idle, loading, loaded, error }

/// Owns category/process data and search state for the Home and Process
/// List screens. Depends only on the [ProcessRepository] abstraction.
class ProcessProvider extends ChangeNotifier {
  ProcessProvider({required ProcessRepository repository})
      : _repository = repository;

  final ProcessRepository _repository;

  LoadStatus status = LoadStatus.idle;
  List<CategoryModel> categories = [];
  List<ProcessModel> allProcesses = [];
  List<ProcessModel> searchResults = [];
  String searchQuery = '';

  Future<void> loadHome() async {
    status = LoadStatus.loading;
    notifyListeners();
    try {
      categories = await _repository.getCategories();
      allProcesses = await _repository.getProcesses();
      status = LoadStatus.loaded;
    } catch (_) {
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  List<ProcessModel> processesFor(String categoryId) {
    return allProcesses.where((p) => p.categoryId == categoryId).toList();
  }

  CategoryModel? categoryById(String id) {
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> search(String query) async {
    searchQuery = query;
    if (query.trim().isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }
    searchResults = await _repository.search(query);
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    searchResults = [];
    notifyListeners();
  }
}
