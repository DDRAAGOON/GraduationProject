import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/services/rating_service.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';

/// Acceptance confirmation and delayed star-rating prompt for tradesmen.
class TradesmanRatingPrompt {
  TradesmanRatingPrompt._();

  static final Map<String, Timer> _timers = {};

  static Future<void> showAcceptanceFlow({
    required BuildContext context,
    required String personName,
    required String applicationId,
    required String targetUserId,
  }) async {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Color(0xFF4285F4), size: 48),
        title: Text(t.tr(en: 'Request accepted', ar: 'تم قبول الطلب')),
        content: Text(
          isAr
              ? 'لقد وافقت على طلب $personName بنجاح.'
              : 'You have successfully accepted $personName\'s request.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.tr(en: 'OK', ar: 'حسناً')),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.star_outline, color: Color(0xFFFFB300), size: 48),
        title: Text(t.tr(en: 'Rating reminder', ar: 'تذكير بالتقييم')),
        content: Text(
          isAr
              ? 'سيصلك تذكير لتقييم $personName بالنجوم خلال 24 ساعة.'
              : 'You will receive a reminder to rate $personName with stars within 24 hours.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.tr(en: 'OK', ar: 'حسناً')),
          ),
        ],
      ),
    );

    final store = RecruitmentSyncStore.instance;
    store.scheduleTradesmanRatingPrompt(
      personName: personName,
      applicationId: applicationId,
    );

    _timers[applicationId]?.cancel();
    PendingTradesmanRating? pending;
    for (final item in store.pendingTradesmanRatings) {
      if (item.applicationId == applicationId) {
        pending = item;
        break;
      }
    }
    if (pending == null) return;

    var delay = pending.showAt.difference(DateTime.now());
    if (delay.isNegative) delay = Duration.zero;

    _timers[applicationId] = Timer(delay, () {
      _timers.remove(applicationId);
      if (!context.mounted) return;
      showRatingDialog(
        context,
        personName: personName,
        targetUserId: targetUserId,
      );
      store.consumeDueTradesmanRating();
    });
  }

  static Future<void> showRatingDialog(
    BuildContext context, {
    required String personName,
    required String targetUserId,
  }) async {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    int selectedStars = 0;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                t.tr(en: 'Rate service requester', ar: 'قيّم طالب الخدمة'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAr
                        ? 'كيف كانت تجربتك مع $personName؟'
                        : 'How was your experience with $personName?',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return IconButton(
                        onPressed: () =>
                            setDialogState(() => selectedStars = starIndex),
                        icon: Icon(
                          starIndex <= selectedStars
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFFB300),
                          size: 32,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(t.tr(en: 'Later', ar: 'لاحقاً')),
                ),
                FilledButton(
                  onPressed: selectedStars == 0
                      ? null
                      : () async {
                          Navigator.pop(ctx);
                          try {
                            await RatingService.instance.createRating(
                              ratingValue: selectedStars,
                              targetUserId: targetUserId,
                              raterType: 'tradesman',
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isAr
                                      ? 'شكراً! قيّمت $personName بـ $selectedStars نجوم'
                                      : 'Thanks! You rated $personName $selectedStars stars',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (_) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isAr
                                      ? 'حدث خطأ أثناء إرسال التقييم'
                                      : 'Failed to submit rating',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: Text(t.tr(en: 'Submit rating', ar: 'إرسال التقييم')),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
