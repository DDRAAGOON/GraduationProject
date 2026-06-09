import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/api/api_client.dart';
import '../../../../shared/services/rating_service.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../shared/utils/image_helper.dart';
import '../../../../shared/utils/rating_utils.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../profile/edit_profile_screen.dart';
import '../../teardsman/profile/tradesman_ratings_hub_screen.dart';

class ProfileTab extends StatefulWidget {
  final bool isTradesmanMode; // المفتاح الذي يحدد الوضع
  const ProfileTab({super.key, this.isTradesmanMode = false});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  List<Map<String, dynamic>> _allReceived = [];
  List<Map<String, dynamic>> _filteredRatings = [];
  int _givenCount = 0;
  bool _isLoadingRatings = true;

  @override
  void initState() {
    super.initState();
    _loadRatingData();
  }

  // تحديث البيانات فوراً عند تغير الوضع (isTradesmanMode)
  @override
  void didUpdateWidget(ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTradesmanMode != widget.isTradesmanMode) {
      _filterRatings();
    }
  }

  Future<void> _loadRatingData() async {
    final userId = RecruitmentSyncStore.instance.currentUserId.isNotEmpty
        ? RecruitmentSyncStore.instance.currentUserId
        : await ApiClient.getUserId() ?? '';
        
    if (userId.isEmpty) {
      if (mounted) setState(() => _isLoadingRatings = false);
      return;
    }
    try {
      final allReceived = await RatingService.instance.getUserRatings(userId);
      final allGiven = await RatingService.instance.getUserGivenRatings(userId);
      if (!mounted) return;
      setState(() {
        _allReceived = allReceived;
        _givenCount = allGiven.length;
      });
      _filterRatings();
    } catch (_) {
      if (mounted) setState(() => _isLoadingRatings = false);
    }
  }

  void _filterRatings() {
    setState(() {
      _filteredRatings = _allReceived.where((r) {
        final type = r['raterType']?.toString().toLowerCase() ?? '';
        return widget.isTradesmanMode ? type.contains('tradesman') : !type.contains('tradesman');
      }).toList();
      _isLoadingRatings = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final colorScheme = Theme.of(context).colorScheme;

    final String statusLabel = widget.isTradesmanMode
        ? t.tr(en: "Tradesman", ar: "حرفي محترف")
        : t.tr(en: "Job Seeker", ar: "باحث عن عمل");

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Cover & Avatar (Unified Style)
                _buildHeader(store, isAr),

                const SizedBox(height: 75),

                // 2. Primary Identity
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            store.currentUserName,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w900),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(statusLabel, style: TextStyle(color: colorScheme.primary, fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            store.currentUserLocation.isEmpty ? (isAr ? "الموقع غير محدد" : "Location not set") : store.currentUserLocation,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // 3. Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // About Me (Universal)
                      _buildFullWidthCard(
                        child: Column(
                          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(t.aboutMe, Icons.info_outline, isAr),
                            const SizedBox(height: 12),
                            Text(
                              store.currentUserAbout.isEmpty ? (isAr ? "لم تضف نبذة بعد." : "No bio added yet.") : store.currentUserAbout,
                              textAlign: isAr ? TextAlign.right : TextAlign.left,
                              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 📞 CONTACT INFO (Universal)
                      _buildFullWidthCard(
                        child: Column(
                          children: [
                            _buildInfoRow(t.emailAddress, store.currentUserEmail, Icons.email_outlined, isAr),
                            Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
                            _buildInfoRow(t.phoneNumber, store.currentUserPhone, Icons.phone_android_outlined, isAr),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🛠️ SERVICES (Only in Tradesman Mode)
                      if (widget.isTradesmanMode && store.tradesmanServices.isNotEmpty) ...[
                        _buildFullWidthCard(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(isAr ? 'الخدمات المهنية' : 'Professional Services', Icons.handyman_outlined, isAr),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: store.tradesmanServices.map((s) => _buildChip(s.toString(), colorScheme.primary.withOpacity(0.1), colorScheme.primary)).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Experience & Education (Universal)
                      if (store.currentUserExperience.isNotEmpty) ...[
                        _buildFullWidthCard(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(isAr ? 'الخبرات العملية' : 'Experience', Icons.work_outline, isAr),
                              const SizedBox(height: 12),
                              ...store.currentUserExperience.map((exp) => _buildTimelineTile(exp['title'] ?? '', exp['company'] ?? '', isAr)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (store.currentUserEducation.isNotEmpty) ...[
                        _buildFullWidthCard(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(isAr ? 'التعليم' : 'Education', Icons.school_outlined, isAr),
                              const SizedBox(height: 12),
                              ...store.currentUserEducation.map((edu) => _buildTimelineTile(edu['degree'] ?? '', edu['institution'] ?? '', isAr)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Skills Section (Universal)
                      if (store.currentUserSkills.isNotEmpty)
                        _buildFullWidthCard(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(isAr ? 'المهارات' : 'Skills', Icons.psychology_outlined, isAr),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: store.currentUserSkills.map((s) => _buildChip(s.toString(), Colors.grey.withOpacity(0.1), colorScheme.onSurface)).toList(),
                              ),
                            ],
                          ),
                        ),
                      if (store.currentUserSkills.isNotEmpty) const SizedBox(height: 16),

                      // Portfolio (Universal)
                      if (store.portfolioImages.isNotEmpty)
                        _buildFullWidthCard(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(isAr ? "معرض الأعمال" : "Portfolio Gallery", Icons.image_outlined, isAr),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: store.portfolioImages.length,
                                  itemBuilder: (context, index) {
                                    final provider = getAppImageProvider(store.portfolioImages[index]);
                                    return Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      width: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: provider != null ? Image(image: provider, fit: BoxFit.cover) : const Icon(Icons.broken_image),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (store.portfolioImages.isNotEmpty) const SizedBox(height: 16),

                      // ⭐️ RATINGS (Dynamically filtered by mode)
                      _buildFullWidthCard(
                        child: Column(
                          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              widget.isTradesmanMode 
                                  ? (isAr ? 'تقييمات العملاء (كحرفي)' : 'Client Ratings (Tradesman)')
                                  : (isAr ? 'تقييمات الشركات (كباحث عمل)' : 'Company Ratings (Seeker)'),
                              Icons.star_outline, 
                              isAr
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () => _openRatingsHub(context, widget.isTradesmanMode),
                              child: _UserRatingsSection(
                                isAr: isAr, 
                                isTradesmanMode: widget.isTradesmanMode,
                                ratings: _filteredRatings,
                                isLoading: _isLoadingRatings,
                              ),
                            ),
                            const Divider(height: 32),
                            _buildRatingSummaryRow(
                              isAr ? 'إجمالي التقييمات المعطاة' : 'Total given ratings', 
                              _givenCount, 
                              isAr,
                              onTap: () => _openRatingsHub(context, widget.isTradesmanMode),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Helper Widgets (Private) ---

  void _openRatingsHub(BuildContext context, bool isTradesmanMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TradesmanRatingsHubScreen(isTradesmanMode: isTradesmanMode),
      ),
    );
  }

  Widget _buildHeader(RecruitmentSyncStore store, bool isAr) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: getAppImageProvider(store.backgroundImage) == null
                ? const LinearGradient(colors: [Color(0xFF011931), Color(0xFF49769F)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
            image: getAppImageProvider(store.backgroundImage) != null
                ? DecorationImage(image: getAppImageProvider(store.backgroundImage)!, fit: BoxFit.cover)
                : null,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: isAr ? null : 16,
          right: isAr ? 16 : null,
          child: IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
            style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.35)),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: -60,
          right: 24,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage: getAppImageProvider(store.profileImage),
              child: (store.profileImage == null || getAppImageProvider(store.profileImage) == null)
                  ? const Icon(Icons.person, size: 70, color: Color(0xFF49769F))
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullWidthCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isAr) {
    return Row(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Theme.of(context).colorScheme.onSurface))),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, bool isAr) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
              Text(
                value.isEmpty ? "---" : value,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTile(String title, String subtitle, bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ])),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRatingSummaryRow(String label, int count, bool isAr, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          children: [
            const Icon(Icons.star, color: Color(0xFFFF7A2A), size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
            Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF7A2A))),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }
}

class _UserRatingsSection extends StatelessWidget {
  const _UserRatingsSection({
    required this.isAr, 
    required this.isTradesmanMode,
    required this.ratings,
    required this.isLoading,
  });
  
  final bool isAr;
  final bool isTradesmanMode;
  final List<Map<String, dynamic>> ratings;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
    if (ratings.isEmpty) return Text(isAr ? 'لا توجد تقييمات بهذا الوضع' : 'No ratings for this mode', style: const TextStyle(color: Colors.grey, fontSize: 13));
    
    final avg = RatingUtils.average(ratings);
    
    return Column(
      children: [
        Row(
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(avg.toStringAsFixed(1), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF7A2A))),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(children: List.generate(5, (i) => Icon(Icons.star, color: i < avg.round() ? const Color(0xFFFF7A2A) : Colors.grey.shade300, size: 16))),
                Text(isAr ? 'بناءً على ${ratings.length} تقييم' : 'Based on ${ratings.length} reviews', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...ratings.take(2).map((rating) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(radius: 18, child: Icon(Icons.person_outline, size: 18)),
          title: Text(RatingUtils.authorName(rating), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text(RatingUtils.comment(rating), style: const TextStyle(fontSize: 12, color: Colors.grey)),
          trailing: Text(RatingUtils.value(rating).toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF7A2A))),
        )),
      ],
    );
  }
}
