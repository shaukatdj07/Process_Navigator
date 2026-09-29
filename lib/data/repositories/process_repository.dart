import '../datasources/local_process_data.dart';
import '../models/category_model.dart';
import '../models/process_model.dart';

abstract class ProcessRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProcessModel>> getProcesses({String? categoryId});
  Future<List<ProcessModel>> search(String query);
  Future<ProcessModel?> getProcessById(String id);
}

class LocalProcessRepository implements ProcessRepository {
  @override
  Future<List<CategoryModel>> getCategories() async {
    return LocalProcessData.categories;
  }

  @override
  Future<List<ProcessModel>> getProcesses({String? categoryId}) async {
    if (categoryId == null) return LocalProcessData.processes;
    return LocalProcessData.processes
        .where((p) => p.categoryId == categoryId)
        .toList();
  }

  @override
  Future<List<ProcessModel>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return LocalProcessData.processes
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.summary.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<ProcessModel?> getProcessById(String id) async {
    for (final p in LocalProcessData.processes) {
      if (p.id == id) return p;
    }
    return null;
  }
}
