import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/datasources/content_translations.dart';
import '../../data/models/category_model.dart';
import '../../data/models/process_model.dart';
import '../../providers/locale_provider.dart';

class ContentText {
  const ContentText._();

  static bool _isUrdu(BuildContext context) => context.watch<LocaleProvider>().isUrdu;

  static String processTitle(BuildContext context, ProcessModel process) {
    if (!_isUrdu(context)) return process.title;
    return ContentTranslations.processes[process.id]?[0] ?? process.title;
  }

  static String processSummary(BuildContext context, ProcessModel process) {
    if (!_isUrdu(context)) return process.summary;
    return ContentTranslations.processes[process.id]?[1] ?? process.summary;
  }

  static String categoryName(BuildContext context, CategoryModel category) {
    if (!_isUrdu(context)) return category.name;
    return ContentTranslations.categoryNames[category.id] ?? category.name;
  }
}
