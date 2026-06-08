import 'package:flutter/material.dart';
import '../../../../data/api/api_client.dart';
import '../../../../shared/services/rating_service.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../shared/utils/image_helper.dart';
import '../../../../shared/utils/rating_utils.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: store.backgroundImage == null ? const LinearGradient(colors: [Color(0xFF011931), Color(0xFF49769F)]) : null,
                      image: store.backgroundImage != null && getAppImageProvider(store.backgroundImage) != null
                        ? DecorationImage(
                            image: getAppImageProvider(store.backgroundImage)!, 
                            fit: BoxFit.cover
                          )
                        : null,
                    ),
                    child: store.backgroundImage != null && getAppImageProvider(store.backgroundImage) == null
                        ? const Icon(Icons.broken_image, color: Colors.white30)
                        : null,
                  ),
                  Positioned(
                    bottom: -50,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: getAppImageProvider(store.profileImage),
                        child: (store.profileImage == null || getAppImageProvider(store.profileImage) == null)
                            ? const Icon(Icons.person, size: 60, color: Color(0xFF213E75))
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              Text(
                store.currentUserName,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    store.currentUserLocation.isEmpty ? (isAr ? 'غير محدد' : 'Not specified') : store.currentUserLocation,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildProfileInfoCard(
                  isDark,
                  Column(
                    children: [
                      _buildDetailRow(Icons.email_outlined, isAr ? 'البريد الإلكتروني' : 'Email', store.currentUserEmail, isDark),
                      const Divider(),
                      _buildDetailRow(Icons.phone_android_outlined, isAr ? 'رقم الهاتف' : 'Phone', store.currentUserPhone, isDark),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              _buildSectionHeader(isAr ? 'نبذة عني' : 'About Me', isDark),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _buildProfileInfoCard(
                  isDark,
                  Text(
                    store.currentUserAbout.isEmpty 
                      ? (isAr ? 'لا يوجد نبذة تعريفية مضافة حالياً.' : 'No about me added yet.')
                      : store.currentUserAbout,
                    style: TextStyle(height: 1.6, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
              ),

              _buildSectionHeader(isAr ? 'الخبرات' : 'Experience', isDark),
              if (store.currentUserExperience.isEmpty)
                 _buildEmptyState(isAr ? 'لا توجد خبرات مضافة' : 'No experience added', isDark)
              else
                ...store.currentUserExperience.map((exp) => _buildTimelineItem(exp['title'] ?? "", exp['company'] ?? "", isDark)),

              _buildSectionHeader(isAr ? 'التعليم' : 'Education', isDark),
              if (store.currentUserEducation.isEmpty)
                _buildEmptyState(isAr ? 'لم يضف تعليم' : 'No education added', isDark)
              else
                ...store.currentUserEducation.map((edu) => _buildTimelineItem(edu['degree'] ?? edu['institution'] ?? "", edu['institution'] ?? "", isDark)),

              _buildSectionHeader(isAr ? 'المهارات' : 'Skills', isDark),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: store.currentUserSkills.isEmpty 
                    ? [Text(isAr ? 'لم تضاف مهارات' : 'No skills added', style: const TextStyle(color: Colors.grey))]
                    : store.currentUserSkills.map((skill) => _buildSkillChip(skill, isDark)).toList(),
                ),
              ),

              _buildSectionHeader(isAr ? 'معرض الأعمال' : 'Portfolio Gallery', isDark),
              if (store.portfolioImages.isEmpty)
                _buildEmptyState(isAr ? 'لم يتم إضافة أعمال بعد.' : 'No works added yet.', isDark)
              else
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: store.portfolioImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, i) {
                      final provider = getAppImageProvider(store.portfolioImages[i]);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          image: provider != null
                              ? DecorationImage(
                                  image: provider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: provider == null
                            ? const Icon(Icons.broken_image_outlined,
                                color: Colors.grey)
                            : null,
                      );
                    },
                  ),
                ),

              _buildSectionHeader(isAr ? 'تقييمات الشركات والعملاء' : 'Company & Client Ratings', isDark),
              _UserRatingsSection(isDark: isDark, isAr: isAr),

              const SizedBox(height: 100),
            ],
          ),
        );
      }
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF213E75)),
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(bool isDark, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFF7A2A)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12, height: 12,
            decoration: const BoxDecoration(color: Color(0xFFFF7A2A), shape: BoxShape.circle),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF213E75).withOpacity(isDark ? 0.3 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(label, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF213E75), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
    );
  }
}

class _UserRatingsSection extends StatefulWidget {
  const _UserRatingsSection({required this.isDark, required this.isAr});

  final bool isDark;
  final bool isAr;

  @override
  State<_UserRatingsSection> createState() => _UserRatingsSectionState();
}

class _UserRatingsSectionState extends State<_UserRatingsSection> {
  List<Map<String, dynamic>> _ratings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    final userId =
        RecruitmentSyncStore.instance.currentUserId.isNotEmpty
            ? RecruitmentSyncStore.instance.currentUserId
            : await ApiClient.getUserId() ?? '';
    if (userId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final ratings = await RatingService.instance.getUserRatings(userId);
    if (!mounted) return;
    setState(() {
      _ratings = ratings;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isAr = widget.isAr;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _ratings.isEmpty
            ? Text(
                isAr ? 'لا توجد تقييمات بعد' : 'No ratings yet',
                style: const TextStyle(color: Colors.grey),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Text(
                        RatingUtils.average(_ratings).toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7A2A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                color: i <
                                        RatingUtils.average(_ratings).round()
                                    ? const Color(0xFFFF7A2A)
                                    : Colors.grey.shade300,
                                size: 16,
                              ),
                            ),
                          ),
                          Text(
                            isAr
                                ? 'بناءً على ${_ratings.length} تقييم'
                                : 'Based on ${_ratings.length} reviews',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._ratings.take(3).map((rating) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        child: Icon(Icons.business),
                      ),
                      title: Text(
                        RatingUtils.authorName(rating),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(RatingUtils.comment(rating)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFF7A2A),
                            size: 16,
                          ),
                          Text(RatingUtils.value(rating).toStringAsFixed(1)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
