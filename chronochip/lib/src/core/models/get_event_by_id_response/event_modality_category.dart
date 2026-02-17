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

  factory EventModalityCategory.fromMap(Map<String, dynamic> data) {
    return EventModalityCategory(
      id: data['id'] as int?,
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
