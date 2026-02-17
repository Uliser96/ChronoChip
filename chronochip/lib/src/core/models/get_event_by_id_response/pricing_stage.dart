import 'dart:convert';

class PricingStage {
  int? id;
  String? startDate;
  String? endDate;
  int? price;

  PricingStage({this.id, this.startDate, this.endDate, this.price});

  @override
  String toString() {
    return 'PricingStage(id: $id, startDate: $startDate, endDate: $endDate, price: $price)';
  }

  factory PricingStage.fromMap(Map<String, dynamic> data) => PricingStage(
    id: data['id'] as int?,
    startDate: data['startDate'] as String?,
    endDate: data['endDate'] as String?,
    price: data['price'] as int?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'startDate': startDate,
    'endDate': endDate,
    'price': price,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PricingStage].
  factory PricingStage.fromJson(String data) {
    return PricingStage.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PricingStage] to a JSON string.
  String toJson() => json.encode(toMap());

  PricingStage copyWith({
    int? id,
    String? startDate,
    String? endDate,
    int? price,
  }) {
    return PricingStage(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      price: price ?? this.price,
    );
  }
}
