import 'dart:convert';

import 'modality_category.dart';

class EventModalityCategory {
  int? id;
  ModalityCategory? modalityCategory;

  EventModalityCategory({this.id, this.modalityCategory});

  @override
  String toString() {
    return 'EventModalityCategory(id: $id, modalityCategory: $modalityCategory)';
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  factory EventModalityCategory.fromMap(Map<String, dynamic> data) {
    return EventModalityCategory(
      id: _toInt(data['id']),
      modalityCategory: data['modalityCategory'] == null
          ? null
          : ModalityCategory.fromMap(
              data['modalityCategory'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'modalityCategory': modalityCategory?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventModalityCategory].
  factory EventModalityCategory.fromJson(String data) {
    return EventModalityCategory.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [EventModalityCategory] to a JSON string.
  String toJson() => json.encode(toMap());

  EventModalityCategory copyWith({
    int? id,
    ModalityCategory? modalityCategory,
  }) {
    return EventModalityCategory(
      id: id ?? this.id,
      modalityCategory: modalityCategory ?? this.modalityCategory,
    );
  }
}
