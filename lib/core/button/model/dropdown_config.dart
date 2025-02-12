class DropdownConfig {
  final String id;
  final String name;
  final String color;

  DropdownConfig({
    required this.id,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
      };

  factory DropdownConfig.fromJson(Map<String, dynamic> json) => DropdownConfig(
        id: json['id'],
        name: json['name'],
        color: json['color'],
      );
}
