import 'dart:convert';

import 'category.dart';
import 'modality.dart';

class ModalityCategory {
  int? id;
  Modality? modality;
  Category? category;

  ModalityCategory({this.id, this.modality, this.category});

  @override
  String toString() {
    return 'ModalityCategory(id: $id, modality: $modality, category: $category)';
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  factory ModalityCategory.fromMap(Map<String, dynamic> data) {
    return ModalityCategory(
      id: _toInt(data['id']),
      modality: data['modality'] == null
          ? null
          : Modality.fromMap(data['modality'] as Map<String, dynamic>),
      category: data['category'] == null
          ? null
          : Category.fromMap(data['category'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'modality': modality?.toMap(),
    'category': category?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ModalityCategory].
  factory ModalityCategory.fromJson(String data) {
    return ModalityCategory.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ModalityCategory] to a JSON string.
  String toJson() => json.encode(toMap());

  ModalityCategory copyWith({int? id, Modality? modality, Category? category}) {
    return ModalityCategory(
      id: id ?? this.id,
      modality: modality ?? this.modality,
      category: category ?? this.category,
    );
  }
}
