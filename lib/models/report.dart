class Report {
  final String? id;
  final String title;
  final String description;
  final List<String> location;
  final int status;
  final List<String> mediaUrls;
  final List<double> coordinates;
  final String userId;
  final DateTime? created;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final String? createdBy;

  Report({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.mediaUrls,
    required this.coordinates,
    required this.userId,
    this.created,
    this.lastModified,
    this.lastModifiedBy,
    this.createdBy,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: List<String>.from(json['location']),
      status: json['status'],
      mediaUrls: List<String>.from(json['mediaUrls']),
      coordinates: List<double>.from(json['coordinates']),
      userId: json['userId'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : null,
      lastModifiedBy: json['lastModifiedBy'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'status': status,
      'mediaUrls': mediaUrls,
      'coordinates': coordinates,
      'userId': userId,
      'created': created?.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'createdBy': createdBy,
    };
  }
}