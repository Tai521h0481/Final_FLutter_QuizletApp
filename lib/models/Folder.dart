class Folder {
  final String id;
  final String userId;
  final String folderNameEnglish;
  final String folderNameVietnamese;
  final int topicCount;
  final List<String> topicInFolderId;

  Folder({
    required this.id,
    required this.userId,
    required this.folderNameEnglish,
    required this.folderNameVietnamese,
    required this.topicCount,
    required this.topicInFolderId,
  });

  // Phương thức từJson để tạo một instance của Folder từ một Map
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['_id'],
      userId: json['userId'],
      folderNameEnglish: json['folderNameEnglish'],
      folderNameVietnamese: json['folderNameVietnamese'] ?? '', // Sử dụng giá trị mặc định nếu null
      topicCount: json['topicCount'],
      topicInFolderId: List<String>.from(json['topicInFolderId']),
    );
  }

  // Phương thức toJson để chuyển đổi một instance của Folder thành một Map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'folderNameEnglish': folderNameEnglish,
      'folderNameVietnamese': folderNameVietnamese,
      'topicCount': topicCount,
      'topicInFolderId': topicInFolderId,
    };
  }
}
