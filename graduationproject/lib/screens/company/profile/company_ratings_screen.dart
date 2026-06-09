import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../data/services/rating_service.dart';
import '../../../shared/models/rating.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../core/constants/api_constants.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyRatingsScreen extends StatefulWidget {
  const CompanyRatingsScreen({super.key});

  @override
  State<CompanyRatingsScreen> createState() => _CompanyRatingsScreenState();
}

class _CompanyRatingsScreenState extends State<CompanyRatingsScreen>
    with SingleTickerProviderStateMixin {
  late final RatingService _ratingService;
  late final TabController _tabController;
  final TextEditingController _commentController = TextEditingController();

  List<Rating> _receivedRatings = [];
  List<Rating> _givenRatings = [];
  double _averageRating = 0.0;
  int _totalRatings = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  double _selectedRating = 5.0;
  String _companyId = '';

  @override
  void initState() {
    super.initState();
    _ratingService = RatingService(ApiClient());
    _tabController = TabController(length: 2, vsync: this);
    _initAndLoad();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _initAndLoad() async {
    // Try to get companyId from store; fetch from profile API if missing
    _companyId = CompanyStore.instance.companyId;
    if (_companyId.isEmpty) {
      try {
        final client = ApiClient();
        final res = await client.get(ApiConstants.myCompanyProfile);
        _companyId = res.data['companyId']?.toString() ?? '';
        CompanyStore.instance.setRegistrationData(
          companyId: _companyId,
          companyName: res.data['name']?.toString() ?? '',
          customProfileImage: res.data['logoUrl']?.toString(),
        );
      } catch (e) {
        if (kDebugMode) debugPrint('❌ Could not fetch profile for companyId: $e');
      }
    }
    await _loadRatings();
  }

  Future<void> _loadRatings() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      if (_companyId.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final results = await Future.wait([
        _ratingService.getCompanyRatingsWithStats(_companyId),
        _ratingService.getCompanyGivenRatings(_companyId),
      ]);

      final received = results[0] as ({List<Rating> ratings, double average, int total});
      final given = results[1] as List<Rating>;

      if (mounted) {
        setState(() {
          _receivedRatings = received.ratings;
          _averageRating = received.average;
          _totalRatings = received.total;
          _givenRatings = given;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error loading ratings: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitRating() async {
    if (_selectedRating == 0 || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    final comment = _commentController.text.trim();

    try {
      final rating = await _ratingService.createRating(
        ratingValue: _selectedRating,
        comment: comment.isNotEmpty ? comment : null,
        companyId: _companyId,
        raterType: 'user',
      );

      if (rating != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم إرسال التقييم بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        _commentController.clear();
        setState(() => _selectedRating = 5.0);
        await _loadRatings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ في إرسال التقييم: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: t.tr(en: 'Ratings & Reviews', ar: 'التقييمات والمراجعات'),
      showBack: false,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Average Rating Header ────────────────────────────
                _buildHeader(isAr, cs),
                // ── Tabs ─────────────────────────────────────────────
                TabBar(
                  controller: _tabController,
                  labelColor: cs.primary,
                  unselectedLabelColor: cs.onSurface.withOpacity(0.5),
                  indicatorColor: cs.primary,
                  tabs: [
                    Tab(text: t.tr(en: 'Reviews Received', ar: 'التقييمات الواردة')),
                    Tab(text: t.tr(en: 'Given Ratings', ar: 'التقييمات الصادرة')),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Received ratings + add form
                      RefreshIndicator(
                        onRefresh: _loadRatings,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildAddRatingForm(isAr, cs),
                            const SizedBox(height: 20),
                            _buildRatingsList(_receivedRatings, isAr,
                                emptyMsg: isAr
                                    ? 'لا توجد تقييمات واردة بعد'
                                    : 'No ratings received yet'),
                          ],
                        ),
                      ),
                      // Tab 2: Given ratings
                      RefreshIndicator(
                        onRefresh: _loadRatings,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildRatingsList(_givenRatings, isAr,
                                emptyMsg: isAr
                                    ? 'لم تعطِ أي تقييم بعد'
                                    : 'No ratings given yet'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const CompanyBottomNav(current: CompanyTab.ratings),
    );
  }

  Widget _buildHeader(bool isAr, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primaryContainer, cs.secondaryContainer.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Big rating number
          Text(
            _averageRating == 0
                ? '–'
                : _averageRating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: cs.primary,
              height: 1,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStars(_averageRating, size: 22),
                const SizedBox(height: 4),
                Text(
                  isAr
                      ? '$_totalRatings تقييم'
                      : '$_totalRatings ${_totalRatings == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.65),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  CompanyStore.instance.companyName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(double rating, {double size = 18}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star_rounded, color: Colors.amber, size: size);
        } else if (i < rating) {
          return Icon(Icons.star_half_rounded, color: Colors.amber, size: size);
        }
        return Icon(Icons.star_border_rounded, color: Colors.amber.shade300, size: size);
      }),
    );
  }

  Widget _buildAddRatingForm(bool isAr, ColorScheme cs) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.rate_review_outlined, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  isAr ? 'أضف تقييمك' : 'Add Your Review',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Star Selector
            Row(
              children: List.generate(5, (i) {
                final val = i + 1.0;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = val),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      _selectedRating >= val
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 38,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 4),
            Text(
              _ratingLabel(_selectedRating, isAr),
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _commentController,
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: isAr
                    ? 'شارك تجربتك مع هذه الشركة... (اختياري)'
                    : 'Share your experience with this company... (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                filled: true,
                fillColor: cs.surfaceContainerLowest,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitRating,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(isAr ? 'إرسال التقييم' : 'Submit Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(double rating, bool isAr) {
    if (rating >= 5) return isAr ? 'ممتاز 🌟' : 'Excellent 🌟';
    if (rating >= 4) return isAr ? 'جيد جداً ⭐' : 'Very Good ⭐';
    if (rating >= 3) return isAr ? 'جيد 👍' : 'Good 👍';
    if (rating >= 2) return isAr ? 'مقبول' : 'Fair';
    return isAr ? 'ضعيف' : 'Poor';
  }

  Widget _buildRatingsList(List<Rating> ratings, bool isAr,
      {required String emptyMsg}) {
    if (ratings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.rate_review_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25)),
              const SizedBox(height: 16),
              Text(
                emptyMsg,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ratings.map((r) => _buildRatingCard(r, isAr)).toList(),
    );
  }

  Widget _buildRatingCard(Rating rating, bool isAr) {
    final cs = Theme.of(context).colorScheme;
    final name = rating.rater?.fullName ?? 'Unknown';
    final avatarUrl = rating.rater?.avatarUrl;
    final imageProvider = getAppImageProvider(avatarUrl);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: cs.primaryContainer,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      _buildStars(rating.ratingValue),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rating.ratingValue.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.amber.shade700,
                      ),
                    ),
                    Text(
                      _formatDate(rating.createdAt, isAr),
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (rating.comment != null && rating.comment!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  rating.comment!,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, bool isAr) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return isAr ? 'اليوم' : 'Today';
    if (diff.inDays < 7) {
      return isAr ? 'منذ ${diff.inDays} ${diff.inDays == 1 ? 'يوم' : 'أيام'}' : '${diff.inDays}d ago';
    }
    if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return isAr ? 'منذ $w ${w == 1 ? 'أسبوع' : 'أسابيع'}' : '${w}w ago';
    }
    if (diff.inDays < 365) {
      final m = (diff.inDays / 30).floor();
      return isAr ? 'منذ $m ${m == 1 ? 'شهر' : 'أشهر'}' : '${m}mo ago';
    }
    final y = (diff.inDays / 365).floor();
    return isAr ? 'منذ $y ${y == 1 ? 'سنة' : 'سنوات'}' : '${y}y ago';
  }
}
