class TranslationHelper {
  static String translate(String? value, bool isAr) {
    if (value == null || value.isEmpty || !isAr) return value ?? "";
    final low = value.trim().toLowerCase();

    // Egyptian Governorates
    if (low == 'all') return 'الكل';
    if (low == 'cairo') return 'القاهرة';
    if (low == 'giza') return 'الجيزة';
    if (low == 'alexandria') return 'الإسكندرية';
    if (low == 'dakahlia') return 'الدقهلية';
    if (low == 'red sea') return 'البحر الأحمر';
    if (low == 'beheira') return 'البحيرة';
    if (low == 'fayoum') return 'الفيوم';
    if (low == 'gharbia') return 'الغربية';
    if (low == 'ismailia') return 'الإسماعيلية';
    if (low == 'monufia') return 'المنوفية';
    if (low == 'minya') return 'المنيا';
    if (low == 'qalyubia') return 'القليوبية';
    if (low == 'new valley') return 'الوادي الجديد';
    if (low == 'sharqia') return 'الشرقية';
    if (low == 'suez') return 'السويس';
    if (low == 'aswan') return 'أسوان';
    if (low == 'assiut') return 'أسيوط';
    if (low == 'beni suef') return 'بني سويف';
    if (low == 'port said') return 'بورسعيد';
    if (low == 'damietta') return 'دمياط';
    if (low == 'south sinai') return 'جنوب سيناء';
    if (low == 'kafr el sheikh') return 'كفر الشيخ';
    if (low == 'matrouh') return 'مطروح';
    if (low == 'luxor') return 'الأقصر';
    if (low == 'qena') return 'قنا';
    if (low == 'sohag') return 'سوهاج';
    if (low == 'north sinai') return 'شمال سيناء';
    if (low == 'remote') return 'عن بعد';

    // Job Types, Categories & Industries
    if (low == 'full-time' || low == 'full time') return 'دوام كامل';
    if (low == 'part-time' || low == 'part time') return 'دوام جزئي';
    if (low == 'freelance' || low == 'freelancer') return 'عمل حر';
    if (low == 'internship') return 'تدريب';
    if (low == 'one-time' || low == 'one time') return 'عمل لمرة واحدة';
    if (low == 'service' || low == 'services') return 'خدمة';
    if (low == 'technical') return 'تقني';
    if (low == 'non-technical') return 'غير تقني';
    if (low == 'tradesman') return 'حرفي';
    if (low == 'general') return 'عام';

    // Job Titles & Status
    if (low.contains('hire')) return 'تم التوظيف';
    if (low.contains('reject') || low.contains('decline')) return 'تم الرفض';
    if (low.contains('pend')) return 'قيد الانتظار';
    if (low.contains('appli')) return 'تم التقديم';
    if (low.contains('interview')) return 'مقابلة';
    if (low.contains('review')) return 'قيد المراجعة';
    if (low == 'open') return 'مفتوح';
    if (low == 'closed') return 'مغلق';

    return value;
  }
}
