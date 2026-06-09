/// Models for the ratings system.

class Rating {
  final String ratingId;
  final double ratingValue;
  final String? comment;
  final String? companyId;
  final String? targetUserId;
  final String? jobId;
  final String raterType;
  final RaterInfo? rater;
  final DateTime createdAt;

  Rating({
    required this.ratingId,
    required this.ratingValue,
    this.comment,
    this.companyId,
    this.targetUserId,
    this.jobId,
    required this.raterType,
    this.rater,
    required this.createdAt,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      ratingId: map['ratingId']?.toString() ?? map['id']?.toString() ?? '',
      ratingValue: (map['ratingValue'] ?? map['rating'] ?? 0).toDouble(),
      comment: map['comment']?.toString(),
      companyId: map['companyId']?.toString(),
      targetUserId: map['targetUserId']?.toString(),
      jobId: map['jobId']?.toString(),
      raterType: map['raterType']?.toString() ?? 'user',
      rater: map['rater'] is Map
          ? RaterInfo.fromMap(map['rater'] as Map<String, dynamic>)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ratingValue': ratingValue,
      if (comment != null && comment!.isNotEmpty) 'comment': comment,
      if (companyId != null) 'companyId': companyId,
      if (targetUserId != null) 'targetUserId': targetUserId,
      if (jobId != null) 'jobId': jobId,
      'raterType': raterType,
    };
  }
}

class RaterInfo {
  final String userId;
  final String fullName;
  final String? avatarUrl;

  RaterInfo({required this.userId, required this.fullName, this.avatarUrl});

  factory RaterInfo.fromMap(Map<String, dynamic> map) {
    return RaterInfo(
      userId: map['userId']?.toString() ?? '',
      fullName:
          map['fullName']?.toString() ?? map['name']?.toString() ?? 'Unknown',
      avatarUrl: map['avatarUrl']?.toString(),
    );
  }
}
