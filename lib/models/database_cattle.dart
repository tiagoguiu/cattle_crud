class DataBaseCattleModel {
  final int id;
  final int farmId;
  final String tag;

  DataBaseCattleModel({
    required this.id,
    required this.farmId,
    required this.tag,
  });

  DataBaseCattleModel.fromRow(Map<String, Object?> map)
      : id = map['id'] as int,
        farmId = map['farm_id'] as int,
        tag = map['tag'] as String;

  @override
  String toString() => 'Cattle = $id, tag = $tag, farm = $farmId';

  @override
  bool operator ==(covariant DataBaseCattleModel other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
