import 'dart:convert';

class PhysicalFolioBlock {
  int? id;
  int? startNumber;
  int? endNumber;
  String? type;

  PhysicalFolioBlock({this.id, this.startNumber, this.endNumber, this.type});

  @override
  String toString() {
    return 'PhysicalFolioBlock(id: $id, startNumber: $startNumber, endNumber: $endNumber, type: $type)';
  }

  factory PhysicalFolioBlock.fromMap(Map<String, dynamic> data) {
    return PhysicalFolioBlock(
      id: data['id'] as int?,
      startNumber: data['startNumber'] as int?,
      endNumber: data['endNumber'] as int?,
      type: data['type'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'startNumber': startNumber,
    'endNumber': endNumber,
    'type': type,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PhysicalFolioBlock].
  factory PhysicalFolioBlock.fromJson(String data) {
    return PhysicalFolioBlock.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [PhysicalFolioBlock] to a JSON string.
  String toJson() => json.encode(toMap());

  PhysicalFolioBlock copyWith({
    int? id,
    int? startNumber,
    int? endNumber,
    String? type,
  }) {
    return PhysicalFolioBlock(
      id: id ?? this.id,
      startNumber: startNumber ?? this.startNumber,
      endNumber: endNumber ?? this.endNumber,
      type: type ?? this.type,
    );
  }
}
