import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

abstract class ChecklistRepository {
  Future<Set<String>> getCheckedItems(String processId);
  Future<void> setChecked(String processId, String itemId, bool checked);
}

class HiveChecklistRepository implements ChecklistRepository {
  Box get _box => Hive.box(AppConstants.checklistBox);

  @override
  Future<Set<String>> getCheckedItems(String processId) async {
    final raw = _box.get(processId);
    if (raw == null) return <String>{};
    return Set<String>.from(raw as List);
  }

  @override
  Future<void> setChecked(String processId, String itemId, bool checked) async {
    final current = await getCheckedItems(processId);
    if (checked) {
      current.add(itemId);
    } else {
      current.remove(itemId);
    }
    await _box.put(processId, current.toList());
  }
}
