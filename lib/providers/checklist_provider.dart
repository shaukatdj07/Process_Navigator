import 'package:flutter/foundation.dart';
import '../data/repositories/checklist_repository.dart';

class ChecklistProvider extends ChangeNotifier {
  ChecklistProvider({required ChecklistRepository repository})
      : _repository = repository;

  final ChecklistRepository _repository;
  final Map<String, Set<String>> _checked = {};

  Set<String> checkedFor(String processId) => _checked[processId] ?? {};

  Future<void> loadFor(String processId) async {
    _checked[processId] = await _repository.getCheckedItems(processId);
    notifyListeners();
  }

  bool isChecked(String processId, String itemId) =>
      checkedFor(processId).contains(itemId);

  Future<void> toggle(String processId, String itemId) async {
    final set = _checked.putIfAbsent(processId, () => {});
    final nowChecked = !set.contains(itemId);
    if (nowChecked) {
      set.add(itemId);
    } else {
      set.remove(itemId);
    }
    notifyListeners();
    await _repository.setChecked(processId, itemId, nowChecked);
  }

  double progressFor(String processId, int totalItems) {
    if (totalItems == 0) return 0;
    return checkedFor(processId).length / totalItems;
  }
}
