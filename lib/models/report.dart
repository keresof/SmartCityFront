
class Report {
  final int id;
  final String description;
  final String status;
  final String imageUrl;

  Report({required this.id, required this.description, required this.status, required this.imageUrl});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      description: json['description'],
      status: json['status'],
      imageUrl: json['imageUrl'],
    );
  }
}

