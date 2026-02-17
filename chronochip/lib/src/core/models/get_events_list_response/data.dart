import 'dart:convert';

import 'paginator.dart';
import 'row.dart';

class Data {
  List<Row>? rows;
  Paginator? paginator;

  Data({this.rows, this.paginator});

  @override
  String toString() => 'Data(rows: $rows, paginator: $paginator)';

  factory Data.fromMap(Map<String, dynamic> data) => Data(
    rows: (data['rows'] as List<dynamic>?)
        ?.map((e) => Row.fromMap(e as Map<String, dynamic>))
        .toList(),
    paginator: data['paginator'] == null
        ? null
        : Paginator.fromMap(data['paginator'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    'rows': rows?.map((e) => e.toMap()).toList(),
    'paginator': paginator?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  Data copyWith({List<Row>? rows, Paginator? paginator}) {
    return Data(
      rows: rows ?? this.rows,
      paginator: paginator ?? this.paginator,
    );
  }
}
