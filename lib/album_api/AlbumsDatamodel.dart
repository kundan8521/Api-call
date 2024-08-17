class AlbumsDatamodel {
  final int userId;
  final int id;
  final String title;

  AlbumsDatamodel({
    required this.userId,
    required this.id,
    required this.title,
  });

  // Factory constructor to create an instance from a JSON map
  factory AlbumsDatamodel.fromJson(Map<String, dynamic> json) {
    return AlbumsDatamodel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

  // Method to convert an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
    };
  }

  // CopyWith method for creating a copy of the instance with some new values
  AlbumsDatamodel copyWith({
    int? userId,
    int? id,
    String? title,
  }) {
    return AlbumsDatamodel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }
}
