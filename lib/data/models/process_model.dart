import 'package:flutter/foundation.dart';
import 'document_item_model.dart';
import 'process_step_model.dart';

/// A single official process, e.g. "Vehicle Ownership Transfer".
@immutable
class ProcessModel {
  const ProcessModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.summary,
    required this.documents,
    required this.office,
    required this.fee,
    required this.submit,
    required this.nextStep,
    required this.source,
  });

  final String id;
  final String categoryId;
  final String title;
  final String summary;
  final List<DocumentItemModel> documents;
  final OfficeInfo office;
  final FeeInfo fee;
  final SubmitInfo submit;
  final NextStepInfo nextStep;
  final SourceInfo source;
}
