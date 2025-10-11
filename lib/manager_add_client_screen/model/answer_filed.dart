import 'package:flutter/foundation.dart';

class AnswerField {
  /// Optional: the outer key in the "answers" map (e.g. "11", "34", ...)
  final String? fieldId;

  final String name; // e.g. "howMany"
  final int order; // parsed from "order"
  final String text; // question label
  final String type; // e.g. "control_textbox", "control_checkbox"
  final dynamic answer; // String | List | Map | null
  final String? prettyFormat; // Optional prettified value (JotForm)
  final String? timeFormat; // For appointment fields
  final String? selectedField;
  final String? optionsArray; // Sometimes "{}" in payloads

  const AnswerField({
    this.fieldId,
    required this.name,
    required this.order,
    required this.text,
    required this.type,
    required this.answer,
    this.prettyFormat,
    this.timeFormat,
    this.selectedField,
    this.optionsArray,
  });

  /// Prefer `prettyFormat` if available; otherwise return `answer`.
  dynamic get preferredValue {
    final pf = prettyFormat?.trim();
    if (pf != null && pf.isNotEmpty) return pf;
    return answer;
  }

  /// True if there is any usable value (after preferring prettyFormat).
  bool get hasValue {
    final v = preferredValue;
    if (v == null) return false;
    if (v is String) return v.trim().isNotEmpty;
    if (v is List) return v.isNotEmpty;
    if (v is Map) return v.isNotEmpty;
    return true;
  }

  /// Minimal, human-readable string for quick previews (safe fallback).
  String get previewText {
    final v = preferredValue;
    if (v == null) return '';
    if (v is String) return v;
    if (v is List) return v.join(', ');
    if (v is Map)
      return v.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    return v.toString();
  }

  AnswerField copyWith({
    String? fieldId,
    String? name,
    int? order,
    String? text,
    String? type,
    dynamic answer,
    String? prettyFormat,
    String? timeFormat,
    String? selectedField,
    String? optionsArray,
  }) {
    return AnswerField(
      fieldId: fieldId ?? this.fieldId,
      name: name ?? this.name,
      order: order ?? this.order,
      text: text ?? this.text,
      type: type ?? this.type,
      answer: answer ?? this.answer,
      prettyFormat: prettyFormat ?? this.prettyFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      selectedField: selectedField ?? this.selectedField,
      optionsArray: optionsArray ?? this.optionsArray,
    );
  }

  Map<String, dynamic> toJson() => {
        if (fieldId != null) 'fieldId': fieldId,
        'name': name,
        'order': order,
        'text': text,
        'type': type,
        'answer': answer,
        if (prettyFormat != null) 'prettyFormat': prettyFormat,
        if (timeFormat != null) 'timeFormat': timeFormat,
        if (selectedField != null) 'selectedField': selectedField,
        if (optionsArray != null) 'options_array': optionsArray,
      };

  /// If you have the outer key (like "11"), pass it as [fieldId].
  static AnswerField fromJson(Map<String, dynamic> json, {String? fieldId}) {
    final rawOrder = json['order']?.toString() ?? '9999';
    return AnswerField(
      fieldId: fieldId,
      name: (json['name'] ?? '').toString(),
      order: int.tryParse(rawOrder) ?? 9999,
      text: (json['text'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      answer: json.containsKey('answer') ? json['answer'] : null,
      prettyFormat: json['prettyFormat']?.toString(),
      timeFormat: json['timeFormat']?.toString(),
      selectedField: json['selectedField']?.toString(),
      optionsArray: json['options_array']?.toString(),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AnswerField &&
            runtimeType == other.runtimeType &&
            fieldId == other.fieldId &&
            name == other.name &&
            order == other.order &&
            text == other.text &&
            type == other.type &&
            _deepEquals(answer, other.answer) &&
            prettyFormat == other.prettyFormat &&
            timeFormat == other.timeFormat &&
            selectedField == other.selectedField &&
            optionsArray == other.optionsArray;
  }

  @override
  int get hashCode => Object.hash(
        fieldId,
        name,
        order,
        text,
        type,
        _deepHash(answer),
        prettyFormat,
        timeFormat,
        selectedField,
        optionsArray,
      );

  @override
  String toString() =>
      'AnswerField(fieldId: $fieldId, name: $name, order: $order, text: $text, type: $type, answer: $answer, prettyFormat: $prettyFormat)';

  // ---------- Deep equality helpers for dynamic answer ----------

  static bool _deepEquals(dynamic a, dynamic b) {
    if (a == b) return true;
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (!_deepEquals(a[i], b[i])) return false;
      }
      return true;
    }
    if (a is Map && b is Map) {
      if (!mapEquals(a, b)) return false;
      return true;
    }
    return false;
  }

  static int _deepHash(dynamic v) {
    if (v == null) return 0;
    if (v is List) {
      return Object.hashAll(v.map(_deepHash));
    }
    if (v is Map) {
      return Object.hashAll(
        v.entries.map((e) => Object.hash(e.key, _deepHash(e.value))),
      );
    }
    return v.hashCode;
  }
}
