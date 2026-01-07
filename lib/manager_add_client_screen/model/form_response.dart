import 'package:algarve_house_hunters_system/manager_add_client_screen/model/answer_filed.dart';
import 'package:flutter/foundation.dart';

class FormResponse {
  final String formId;
  final int total;
  final List<Submission> submissions;

  const FormResponse({
    required this.formId,
    required this.total,
    required this.submissions,
  });

  factory FormResponse.fromJson(Map<String, dynamic> json) {
    return FormResponse(
      formId: (json['form_id'] ?? '').toString(),
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      submissions: (json['submissions'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(Submission.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'form_id': formId,
        'total': total,
        'submissions': submissions.map((s) => s.toJson()).toList(),
      };

  FormResponse copyWith({
    String? formId,
    int? total,
    List<Submission>? submissions,
  }) {
    return FormResponse(
      formId: formId ?? this.formId,
      total: total ?? this.total,
      submissions: submissions ?? this.submissions,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormResponse &&
          runtimeType == other.runtimeType &&
          formId == other.formId &&
          total == other.total &&
          listEquals(submissions, other.submissions);

  @override
  int get hashCode => Object.hash(formId, total, Object.hashAll(submissions));
}

class Submission {
  final String id;
  final String formId;
  final String ip;
  final String createdAt;
  final String status;
  final String updatedAt;
  final Map<String, AnswerField> answers;

  const Submission({
    required this.id,
    required this.formId,
    required this.ip,
    required this.createdAt,
    required this.status,
    required this.updatedAt,
    required this.answers,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    final rawAnswers = (json['answers'] as Map<String, dynamic>? ?? const {});
    final parsedAnswers = <String, AnswerField>{};

    for (final entry in rawAnswers.entries) {
      final key = entry.key.toString();
      final val = entry.value;
      if (val is Map<String, dynamic>) {
        parsedAnswers[key] = AnswerField.fromJson(val, fieldId: key);
      }
    }

    return Submission(
      id: (json['id'] ?? '').toString(),
      formId: (json['form_id'] ?? '').toString(),
      ip: (json['ip'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      updatedAt: (json['updated_at'] ?? '').toString(),
      answers: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'form_id': formId,
        'ip': ip,
        'created_at': createdAt,
        'status': status,
        'updated_at': updatedAt,
        'answers': answers.map((k, v) => MapEntry(k, v.toJson())),
      };

  Submission copyWith({
    String? id,
    String? formId,
    String? ip,
    String? createdAt,
    String? status,
    String? updatedAt,
    Map<String, AnswerField>? answers,
  }) {
    return Submission(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      ip: ip ?? this.ip,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      answers: answers ?? this.answers,
    );
  }

  /// Returns fields sorted by numeric order.
  List<AnswerField> sortedAnswers() {
    final list = answers.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  /// Convenience to fetch human text for a field using its `name` (not fieldId).
  /// Prefers `prettyFormat`, falls back to String `answer`.
  String? answerTextByName(String name) {
    try {
      final item = answers.values.firstWhere((a) => a.name == name);
      final pv = item.prettyFormat?.trim();
      if (pv != null && pv.isNotEmpty) return pv;
      if (item.answer is String) return (item.answer as String).trim();
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Submission &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          formId == other.formId &&
          ip == other.ip &&
          createdAt == other.createdAt &&
          status == other.status &&
          updatedAt == other.updatedAt &&
          mapEquals(answers, other.answers);

  @override
  int get hashCode => Object.hash(
        id,
        formId,
        ip,
        createdAt,
        status,
        updatedAt,
        // stable hash for map:
        Object.hashAll(answers.entries.map((e) => Object.hash(e.key, e.value))),
      );
}
