import "package:equatable/equatable.dart";

class DynamicSetting extends Equatable {
  const DynamicSetting({
    required this.id,
    required this.key,
    required this.type,
    required this.parent,
    required this.title,
    required this.description,
    required this.meta,
  });

  factory DynamicSetting.fromMap(Map<String, dynamic> map) => DynamicSetting(
        id: (map["id"] ?? "") as String,
        key: (map["key"] ?? "") as String,
        type: (map["type"] ?? "") as String,
        parent: map["parent"] != null ? map["parent"] as String : null,
        title: map["title"] != null ? map["title"] as String : null,
        description:
            map["description"] != null ? map["description"] as String : null,
        meta: map["meta"] ?? <String, dynamic>{},
      );

  final String id;
  final String key;
  final String type;
  final String? parent;
  final String? title;
  final String? description;
  final Map<String, dynamic> meta;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        "key": key,
        "type": type,
        "parent": parent,
        "title": title,
        "description": description,
        "meta": meta,
      };

  @override
  List<Object?> get props => [id, key, type, parent, title, description, meta];
}

///
class DynamicSettingsNamespace {
  DynamicSettingsNamespace({
    required this.namespace,
    required this.settingCount,
  });

  factory DynamicSettingsNamespace.fromMap(Map<String, dynamic> map) =>
      DynamicSettingsNamespace(
        namespace: (map["namespace"] ?? "") as String,
        settingCount: (map["settingCount"] ?? 0) as int,
      );
  final String namespace;
  final int settingCount;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "namespace": namespace,
        "settingCount": settingCount,
      };
}
