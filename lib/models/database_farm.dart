class DataBaseFarmModel {
  final int id;
  final String name;

  DataBaseFarmModel({
    required this.id,
    required this.name,
  });

  DataBaseFarmModel.fromRow(Map<String, Object?> map)
      : id = map['id'] as int,
        name = map['name'] as String;

  @override
  String toString() => 'Farm = $id, name = $name';

  @override
  bool operator ==(covariant DataBaseFarmModel other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
