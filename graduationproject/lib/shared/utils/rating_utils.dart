class RatingUtils {
  RatingUtils._();

  static List<Map<String, dynamic>> parseList(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (raw is Map<String, dynamic>) {
      for (final key in ['data', 'ratings', 'items', 'results']) {
        final nested = raw[key];
        if (nested is List) return parseList(nested);
      }
    }
    return [];
  }

  static double value(Map<String, dynamic> rating) {
    final raw = rating['ratingValue'] ?? rating['rating'] ?? rating['stars'];
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '') ?? 0;
  }

  static String comment(Map<String, dynamic> rating) {
    return rating['comment']?.toString() ??
        rating['text']?.toString() ??
        rating['review']?.toString() ??
        '';
  }

  static String authorName(Map<String, dynamic> rating) {
    final user = rating['user'];
    if (user is Map) {
      return user['fullName']?.toString() ??
          user['name']?.toString() ??
          'User';
    }
    final rater = rating['rater'];
    if (rater is Map) {
      return rater['fullName']?.toString() ??
          rater['name']?.toString() ??
          'User';
    }
    return rating['userName']?.toString() ??
        rating['name']?.toString() ??
        rating['raterName']?.toString() ??
        'User';
  }

  static String targetName(Map<String, dynamic> rating) {
    final target = rating['targetUser'];
    if (target is Map) {
      return target['fullName']?.toString() ??
          target['name']?.toString() ??
          'User';
    }
    final company = rating['company'];
    if (company is Map) {
      return company['name']?.toString() ??
          company['companyName']?.toString() ??
          'Company';
    }
    return rating['targetUserName']?.toString() ??
        rating['companyName']?.toString() ??
        'User';
  }

  static DateTime? date(Map<String, dynamic> rating) {
    final raw = rating['createdAt'] ?? rating['updatedAt'] ?? rating['date'];
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString())?.toLocal();
  }

  static double average(List<Map<String, dynamic>> ratings) {
    if (ratings.isEmpty) return 0;
    final total = ratings.fold<double>(0, (sum, r) => sum + value(r));
    return total / ratings.length;
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatRelativeDate(DateTime date, {required bool isAr}) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return isAr ? 'اليوم' : 'Today';
    if (diff.inDays == 1) return isAr ? 'أمس' : 'Yesterday';
    if (diff.inDays < 7) {
      return isAr ? 'منذ ${diff.inDays} أيام' : '${diff.inDays} days ago';
    }
    return formatDate(date);
  }
}
