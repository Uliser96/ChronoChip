import 'dart:convert';

class Paginator {
  int? currentPage;
  int? pageSize;
  int? totalRecords;

  Paginator({this.currentPage, this.pageSize, this.totalRecords});

  @override
  String toString() {
    return 'Paginator(currentPage: $currentPage, pageSize: $pageSize, totalRecords: $totalRecords)';
  }

  factory Paginator.fromMap(Map<String, dynamic> data) => Paginator(
    currentPage: data['currentPage'] as int?,
    pageSize: data['pageSize'] as int?,
    totalRecords: data['totalRecords'] as int?,
  );

  Map<String, dynamic> toMap() => {
    'currentPage': currentPage,
    'pageSize': pageSize,
    'totalRecords': totalRecords,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Paginator].
  factory Paginator.fromJson(String data) {
    return Paginator.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Paginator] to a JSON string.
  String toJson() => json.encode(toMap());

  Paginator copyWith({int? currentPage, int? pageSize, int? totalRecords}) {
    return Paginator(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }
}
