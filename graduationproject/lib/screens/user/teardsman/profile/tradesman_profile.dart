import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graduationproject/screens/user/teardsman/profile/tradesman_edit_profile_screen.dart';
import 'package:graduationproject/screens/user/teardsman/profile/tradesman_ratings_hub_screen.dart';
import 'package:graduationproject/shared/utils/image_helper.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';

class TradesmanProfile extends StatefulWidget {
  const TradesmanProfile({super.key});

  @override
  State<TradesmanProfile> createState() => _TradesmanProfileState();
}

class _TradesmanProfileState extends State<TradesmanProfile> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final colorScheme = Theme.of(context).colorScheme;

    // Determine role label (صنايعي أو باحث عن عمل)
    final String statusLabel = store.userRole == 'Tradesman' 
        ? t.tr(en: "Tradesman", ar: "صنايعي")
        : t.tr(en: "Job Seeker", ar: "باحث عن عمل");
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Edge-to-edge Top Cover Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: getAppImageProvider(store.backgroundImage) == null
                        ? const LinearGradient(
                            colors: [Color(0xFF011931), Color(0xFF49769F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    image: getAppImageProvider(store.backgroundImage) != null
                        ? DecorationImage(
                            image: getAppImageProvider(store.backgroundImage)!,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: store.backgroundImage != null && getAppImageProvider(store.backgroundImage) == null
                      ? const Center(child: Icon(Icons.broken_image, color: Colors.white30))
                      : null,
                ),
                Positioned(
                  top: 12,
                  left: isAr ? null : 16,
                  right: isAr ? 16 : null,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TradesmanEditProfileScreen(),
                        ),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.35),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
                // Profile Avatar Positioned on the Right
                Positioned(
                  bottom: -60,
                  right: 24, 
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 5))],
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
            ),
            
            const SizedBox(height: 75),

            // User Primary Info (Name and Status under the image on the right)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 128, // Matches circle diameter (60*2 + 4*2 border)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        store.currentUserName.isEmpty ? "No Name" : store.currentUserName,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w900),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusLabel, // Shows "صنايعي" or "باحث عن عمل"
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.primary, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store.currentUserLocation.isEmpty ? (isAr ? "العنوان غير محدد" : "Address not set") : store.currentUserLocation,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 35),

            // Main Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // About Me Card
                  _buildFullWidthCard(
                    child: Column(
                      crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(t.aboutMe, Icons.info_outline, isAr),
                        const SizedBox(height: 12),
                        Text(
                          store.currentUserAbout.isEmpty ? "No info provided yet." : store.currentUserAbout,
                          textAlign: isAr ? TextAlign.right : TextAlign.left,
                          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Contact Details Card
                  _buildFullWidthCard(
                    child: Column(
                      children: [
                        _buildInfoRow(t.emailAddress, store.currentUserEmail, Icons.email_outlined, isAr),
                        Divider(height: 32, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                        _buildInfoRow(t.phoneNumber, store.currentUserPhone, Icons.phone_android_outlined, isAr),
                        Divider(height: 32, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                        _buildInfoRow(t.address, store.currentUserLocation, Icons.location_on_outlined, isAr),
                        Divider(height: 32, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                        _buildInfoRow(t.tr(en: "Skills", ar: "المهارات"), store.currentUserSkills.join(', '), Icons.psychology_outlined, isAr),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (store.currentUserExperience.isNotEmpty)
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment:
                            isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            t.tr(en: 'Experience', ar: 'الخبرات'),
                            Icons.work_outline,
                            isAr,
                          ),
                          const SizedBox(height: 12),
                          ...store.currentUserExperience.map(
                            (exp) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                '${exp['title'] ?? ''} • ${exp['company'] ?? ''} • ${exp['duration'] ?? ''}',
                                textAlign: isAr ? TextAlign.right : TextAlign.left,
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.65),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (store.currentUserExperience.isNotEmpty)
                    const SizedBox(height: 16),

                  if (store.tradesmanServices.isNotEmpty)
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment:
                            isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            t.tr(en: 'Services', ar: 'الخدمات'),
                            Icons.handyman_outlined,
                            isAr,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: store.tradesmanServices
                                .map(
                                  (s) => Chip(
                                    label: Text(s),
                                    backgroundColor:
                                        colorScheme.primary.withValues(alpha: 0.1),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  if (store.tradesmanServices.isNotEmpty)
                    const SizedBox(height: 16),

                  if (store.languages.isNotEmpty)
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment:
                            isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            t.tr(en: 'Languages', ar: 'اللغات'),
                            Icons.language,
                            isAr,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            store.languages.join(', '),
                            textAlign: isAr ? TextAlign.right : TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  if (store.languages.isNotEmpty) const SizedBox(height: 16),

                  // Gallery Section
                  if (store.portfolioImages.isNotEmpty) ...[
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(t.tr(en: "Portfolio Gallery", ar: "معرض الأعمال"), Icons.image_outlined, isAr),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: store.portfolioImages.length,
                              itemBuilder: (context, index) {
                                final path = store.portfolioImages[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                      image: getAppImageProvider(path) ?? const AssetImage('assets/placeholder.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Social Links
                  if (store.socialLinks.isNotEmpty) ...[
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(t.socialLinks, Icons.link, isAr),
                          const SizedBox(height: 16),
                          ...store.socialLinks.map((link) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () async {
                                String url = link['url'] ?? '';
                                if (url.isNotEmpty) {
                                  if (!url.startsWith('http')) url = 'https://$url';
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Row(
                                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                                    child: Icon(Icons.link_rounded, color: colorScheme.primary, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Text("${link['platform']}: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colorScheme.onSurface)),
                                  Expanded(child: Text(link['url'] ?? "", style: TextStyle(color: colorScheme.primary, decoration: TextDecoration.underline), overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Education Section
                  if (store.currentUserEducation.isNotEmpty) ...[
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(t.education, Icons.school_outlined, isAr),
                          const SizedBox(height: 16),
                          ...store.currentUserEducation.map((edu) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                  child: Icon(Icons.school, color: colorScheme.primary, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Text(edu['institution'] ?? "", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                                      Text("${edu['degree']} • ${edu['duration']}", style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Ratings Card (Moved to the end)
                  _buildFullWidthCard(
                    child: Column(
                      crossAxisAlignment:
                          isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          t.tr(en: 'Ratings', ar: 'التقييمات'),
                          Icons.star_outline,
                          isAr,
                        ),
                        const SizedBox(height: 12),
                        _buildRatingSummaryRow(
                          context,
                          isAr
                              ? 'تقييمات العملاء'
                              : 'Client ratings',
                          store.ratingsFromClients.length,
                          isAr,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TradesmanRatingsHubScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildRatingSummaryRow(
                          context,
                          isAr ? 'تقييماتي للآخرين' : 'My ratings',
                          store.ratingsGivenByTradesman.length,
                          isAr,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TradesmanRatingsHubScreen(),
                              ),
                            );
                          },
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

  // Remove the old Ratings Card placement from around line 230 in your mental map.
  // I will use multi_replace if needed, but since I can see the structure I will do it precisely.


  Widget _buildFullWidthCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isAr) {
    return Row(
      mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isAr) Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
        if (!isAr) const SizedBox(width: 10),
        Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
        if (isAr) const SizedBox(width: 10),
        if (isAr) Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      ],
    );
  }

  Widget _buildRatingSummaryRow(
    BuildContext context,
    String label,
    int count,
    bool isAr,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, bool isAr) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? "Not provided" : value,
                textAlign: isAr ? TextAlign.right : TextAlign.left,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
