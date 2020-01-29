class Category {
  int id;
  String name;

  Category(
      this.id,
      this.name,

      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];

  }
}
