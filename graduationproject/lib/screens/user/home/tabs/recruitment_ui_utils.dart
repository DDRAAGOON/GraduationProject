import 'package:flutter/material.dart';
import '../../../../shared/utils/image_helper.dart';

String translateValue(String? value, bool isAr) {
  if (value == null || value.isEmpty || !isAr) return value ?? "";
  final low = value.trim().toLowerCase();

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

  if (low == 'full-time' || low == 'full time') return 'دوام كامل';
  if (low == 'part-time' || low == 'part time') return 'دوام جزئي';
  if (low == 'freelance' || low == 'freelancer') return 'عمل حر';
  if (low == 'internship') return 'تدريب';
  if (low == 'one-time' || low == 'one time') return 'عمل لمرة واحدة';
  if (low == 'service' || low == 'services') return 'خدمة';
  if (low == 'technical') return 'تقني';
  if (low == 'non-technical') return 'غير تقني';
  if (low == 'engineering') return 'هندسة';
  if (low == 'administrative' || low == 'management') return 'إدارية';
  if (low == 'design') return 'تصميم';
  if (low == 'medical' || low == 'healthcare') return 'طبية';
  if (low == 'general') return 'عام';

  if (low.contains('manager')) return 'مدير';
  if (low.contains('developer')) return 'مطور';
  if (low.contains('engineer')) return 'مهندس';
  if (low.contains('designer')) return 'مصمم';
  if (low.contains('accountant')) return 'محاسب';
  if (low.contains('technician')) return 'فني';
  if (low.contains('teacher')) return 'مدرس';
  if (low.contains('doctor')) return 'طبيب';
  if (low.contains('assistant')) return 'مساعد';
  if (low.contains('specialist')) return 'أخصائي';
  if (low.contains('programmer')) return 'مطور برمجيات';
  if (low == 'مبرمج') return 'مطور';

  if (low.contains('hire')) return 'تم التوظيف';
  if (low.contains('reject') || low.contains('decline')) return 'تم الرفض';
  if (low.contains('pend')) return 'قيد الانتظار';
  if (low.contains('appli')) return 'تم التقديم';
  if (low.contains('interview')) return 'مقابلة';
  if (low.contains('review')) return 'قيد المراجعة';

  return value;
}

Widget buildWhiteTag(String t) => Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        t,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );

Widget buildCompanyLogo(BuildContext context, String? logoUrl) {
  final provider = getAppImageProvider(logoUrl);
  return Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(10),
    ),
    child: provider == null
        ? const Icon(Icons.business, size: 24, color: Color(0xFF49769F))
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(image: provider, fit: BoxFit.cover),
          ),
  );
}
