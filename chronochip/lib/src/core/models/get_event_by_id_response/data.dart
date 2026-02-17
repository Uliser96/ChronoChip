import 'dart:convert';

import 'document.dart';
import 'event_information.dart';
import 'event_modality_category.dart';
import 'physical_folio_block.dart';
import 'pricing_stage.dart';

class Data {
  String? name;
  String? date;
  String? location;
  int? runnerNumberStart;
  bool? finished;
  String? ageCalculationMethod;
  int? maxParticipants;
  String? registrationStartDate;
  String? registrationEndDate;
  bool? allowTshirtSize;
  bool? privateEvent;
  dynamic publishedAt;
  String? coverImgPath;
  String? resultsStatus;
  dynamic preliminaryResultsPublishedAt;
  dynamic finalResultsPublishedAt;
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<EventModalityCategory>? eventModalityCategories;
  List<PricingStage>? pricingStages;
  List<PhysicalFolioBlock>? physicalFolioBlocks;
  EventInformation? eventInformation;
  List<dynamic>? eventTshirtSizes;
  List<Document>? documents;
  String? coverImageUrl;
  bool? hasGenderSpecificSizes;

  Data({
    this.name,
    this.date,
    this.location,
    this.runnerNumberStart,
    this.finished,
    this.ageCalculationMethod,
    this.maxParticipants,
    this.registrationStartDate,
    this.registrationEndDate,
    this.allowTshirtSize,
    this.privateEvent,
    this.publishedAt,
    this.coverImgPath,
    this.resultsStatus,
    this.preliminaryResultsPublishedAt,
    this.finalResultsPublishedAt,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.eventModalityCategories,
    this.pricingStages,
    this.physicalFolioBlocks,
    this.eventInformation,
    this.eventTshirtSizes,
    this.documents,
    this.coverImageUrl,
    this.hasGenderSpecificSizes,
  });

  @override
  String toString() {
    return 'Data(name: $name, date: $date, location: $location, runnerNumberStart: $runnerNumberStart, finished: $finished, ageCalculationMethod: $ageCalculationMethod, maxParticipants: $maxParticipants, registrationStartDate: $registrationStartDate, registrationEndDate: $registrationEndDate, allowTshirtSize: $allowTshirtSize, privateEvent: $privateEvent, publishedAt: $publishedAt, coverImgPath: $coverImgPath, resultsStatus: $resultsStatus, preliminaryResultsPublishedAt: $preliminaryResultsPublishedAt, finalResultsPublishedAt: $finalResultsPublishedAt, id: $id, createdAt: $createdAt, updatedAt: $updatedAt, eventModalityCategories: $eventModalityCategories, pricingStages: $pricingStages, physicalFolioBlocks: $physicalFolioBlocks, eventInformation: $eventInformation, eventTshirtSizes: $eventTshirtSizes, documents: $documents, coverImageUrl: $coverImageUrl, hasGenderSpecificSizes: $hasGenderSpecificSizes)';
  }

  // Helper to safely parse integers coming as int, double or string
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  factory Data.fromMap(Map<String, dynamic> data) => Data(
    name: data['name'] as String?,
    date: data['date'] as String?,
    location: data['location'] as String?,
    runnerNumberStart: _toInt(data['runnerNumberStart']),
    finished: data['finished'] as bool?,
    ageCalculationMethod: data['ageCalculationMethod'] as String?,
    maxParticipants: _toInt(data['maxParticipants']),
    registrationStartDate: data['registrationStartDate'] as String?,
    registrationEndDate: data['registrationEndDate'] as String?,
    allowTshirtSize: data['allowTshirtSize'] as bool?,
    privateEvent: data['privateEvent'] as bool?,
    publishedAt: data['publishedAt'] as dynamic,
    coverImgPath: data['coverImgPath'] as String?,
    resultsStatus: data['resultsStatus'] as String?,
    preliminaryResultsPublishedAt:
        data['preliminaryResultsPublishedAt'] as dynamic,
    finalResultsPublishedAt: data['finalResultsPublishedAt'] as dynamic,
    id: _toInt(data['id']),
    createdAt: data['createdAt'] == null
        ? null
        : DateTime.parse(data['createdAt'] as String),
    updatedAt: data['updatedAt'] == null
        ? null
        : DateTime.parse(data['updatedAt'] as String),
    eventModalityCategories: (data['eventModalityCategories'] as List<dynamic>?)
        ?.map((e) => EventModalityCategory.fromMap(e as Map<String, dynamic>))
        .toList(),
    pricingStages: (data['pricingStages'] as List<dynamic>?)
        ?.map((e) => PricingStage.fromMap(e as Map<String, dynamic>))
        .toList(),
    physicalFolioBlocks: (data['physicalFolioBlocks'] as List<dynamic>?)
        ?.map((e) => PhysicalFolioBlock.fromMap(e as Map<String, dynamic>))
        .toList(),
    eventInformation: data['eventInformation'] == null
        ? null
        : EventInformation.fromMap(
            data['eventInformation'] as Map<String, dynamic>,
          ),
    eventTshirtSizes: data['eventTshirtSizes'] as List<dynamic>?,
    documents: (data['documents'] as List<dynamic>?)
        ?.map((e) => Document.fromMap(e as Map<String, dynamic>))
        .toList(),
    coverImageUrl: data['coverImageUrl'] as String?,
    hasGenderSpecificSizes: data['hasGenderSpecificSizes'] as bool?,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'date': date,
    'location': location,
    'runnerNumberStart': runnerNumberStart,
    'finished': finished,
    'ageCalculationMethod': ageCalculationMethod,
    'maxParticipants': maxParticipants,
    'registrationStartDate': registrationStartDate,
    'registrationEndDate': registrationEndDate,
    'allowTshirtSize': allowTshirtSize,
    'privateEvent': privateEvent,
    'publishedAt': publishedAt,
    'coverImgPath': coverImgPath,
    'resultsStatus': resultsStatus,
    'preliminaryResultsPublishedAt': preliminaryResultsPublishedAt,
    'finalResultsPublishedAt': finalResultsPublishedAt,
    'id': id,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'eventModalityCategories': eventModalityCategories
        ?.map((e) => e.toMap())
        .toList(),
    'pricingStages': pricingStages?.map((e) => e.toMap()).toList(),
    'physicalFolioBlocks': physicalFolioBlocks?.map((e) => e.toMap()).toList(),
    'eventInformation': eventInformation?.toMap(),
    'eventTshirtSizes': eventTshirtSizes,
    'documents': documents?.map((e) => e.toMap()).toList(),
    'coverImageUrl': coverImageUrl,
    'hasGenderSpecificSizes': hasGenderSpecificSizes,
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

  Data copyWith({
    String? name,
    String? date,
    String? location,
    int? runnerNumberStart,
    bool? finished,
    String? ageCalculationMethod,
    int? maxParticipants,
    String? registrationStartDate,
    String? registrationEndDate,
    bool? allowTshirtSize,
    bool? privateEvent,
    dynamic publishedAt,
    String? coverImgPath,
    String? resultsStatus,
    dynamic preliminaryResultsPublishedAt,
    dynamic finalResultsPublishedAt,
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<EventModalityCategory>? eventModalityCategories,
    List<PricingStage>? pricingStages,
    List<PhysicalFolioBlock>? physicalFolioBlocks,
    EventInformation? eventInformation,
    List<dynamic>? eventTshirtSizes,
    List<Document>? documents,
    String? coverImageUrl,
    bool? hasGenderSpecificSizes,
  }) {
    return Data(
      name: name ?? this.name,
      date: date ?? this.date,
      location: location ?? this.location,
      runnerNumberStart: runnerNumberStart ?? this.runnerNumberStart,
      finished: finished ?? this.finished,
      ageCalculationMethod: ageCalculationMethod ?? this.ageCalculationMethod,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      registrationStartDate:
          registrationStartDate ?? this.registrationStartDate,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      allowTshirtSize: allowTshirtSize ?? this.allowTshirtSize,
      privateEvent: privateEvent ?? this.privateEvent,
      publishedAt: publishedAt ?? this.publishedAt,
      coverImgPath: coverImgPath ?? this.coverImgPath,
      resultsStatus: resultsStatus ?? this.resultsStatus,
      preliminaryResultsPublishedAt:
          preliminaryResultsPublishedAt ?? this.preliminaryResultsPublishedAt,
      finalResultsPublishedAt:
          finalResultsPublishedAt ?? this.finalResultsPublishedAt,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      eventModalityCategories:
          eventModalityCategories ?? this.eventModalityCategories,
      pricingStages: pricingStages ?? this.pricingStages,
      physicalFolioBlocks: physicalFolioBlocks ?? this.physicalFolioBlocks,
      eventInformation: eventInformation ?? this.eventInformation,
      eventTshirtSizes: eventTshirtSizes ?? this.eventTshirtSizes,
      documents: documents ?? this.documents,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      hasGenderSpecificSizes:
          hasGenderSpecificSizes ?? this.hasGenderSpecificSizes,
    );
  }
}
