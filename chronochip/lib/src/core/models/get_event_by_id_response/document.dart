import 'dart:convert';

class Document {
  int? id;
  String? documentType;
  String? filePath;
  bool? isMandatory;
  String? documentUrl;

  Document({
    this.id,
    this.documentType,
    this.filePath,
    this.isMandatory,
    this.documentUrl,
  });

  @override
  String toString() {
    return 'Document(id: $id, documentType: $documentType, filePath: $filePath, isMandatory: $isMandatory, documentUrl: $documentUrl)';
  }

  factory Document.fromMap(Map<String, dynamic> data) => Document(
    id: data['id'] as int?,
    documentType: data['documentType'] as String?,
    filePath: data['filePath'] as String?,
    isMandatory: data['isMandatory'] as bool?,
    documentUrl: data['documentUrl'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'documentType': documentType,
    'filePath': filePath,
    'isMandatory': isMandatory,
    'documentUrl': documentUrl,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Document].
  factory Document.fromJson(String data) {
    return Document.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Document] to a JSON string.
  String toJson() => json.encode(toMap());

  Document copyWith({
    int? id,
    String? documentType,
    String? filePath,
    bool? isMandatory,
    String? documentUrl,
  }) {
    return Document(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      filePath: filePath ?? this.filePath,
      isMandatory: isMandatory ?? this.isMandatory,
      documentUrl: documentUrl ?? this.documentUrl,
    );
  }
}
