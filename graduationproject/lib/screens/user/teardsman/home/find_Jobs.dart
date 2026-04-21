import 'package:flutter/material.dart';
import '../../../../../shared/l10n/app_localizations.dart';
import '../notifications/teardsman_notifications.dart';
import '../setting/settings.dart';

class FindJobs extends StatefulWidget {
  const FindJobs({super.key});

  @override
  State<FindJobs> createState() => _FindJobsState();
}

class _FindJobsState extends State<FindJobs> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = "Cairo";

  final List<String> _egyptGovernorates = [
    "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", 
    "Gharbia", "Ismailia", "Monufia", "Minya", "Qalyubia", "New Valley", 
    "Sharqia", "Suez", "Aswan", "Assiut", "Beni Suef", "Port Said", 
    "Damietta", "South Sinai", "Kafr El Sheikh", "Matrouh", "Luxor", "Qena", "Sohag", "North Sinai"
  ];

  final List<Map<String, dynamic>> _allJobs = [
    {
      "title": "نقاش محترف (Painter)",
      "company": "مقاولات الحديثة",
      "location": "Cairo",
      "tags": ["Full-Time", "Painting", "Interior"],
      "applied": 5,
      "capacity": 10,
      "logo": Icons.brush,
    },
    {
      "title": "سباك صحي (Plumber)",
      "company": "الجزيرة للخدمات",
      "location": "Giza",
      "tags": ["Full-Time", "Plumbing", "Maintenance"],
      "applied": 3,
      "capacity": 8,
      "logo": Icons.plumbing,
    },
    {
      "title": "نجار أثاث (Carpenter)",
      "company": "ورشة الإبداع",
      "location": "Damietta",
      "tags": ["Full-Time", "Carpentry", "Furniture"],
      "applied": 12,
      "capacity": 15,
      "logo": Icons.carpenter,
    },
    {
      "title": "كهربائي منازل (Electrician)",
      "company": "النور للكهرباء",
      "location": "Alexandria",
      "tags": ["Part-Time", "Electrical", "Repair"],
      "applied": 2,
      "capacity": 5,
      "logo": Icons.electrical_services,
    },
    {
      "title": "فني تكييف (HVAC Tech)",
      "company": "كول اير",
      "location": "Cairo",
      "tags": ["Contract", "AC Repair", "Maintenance"],
      "applied": 7,
      "capacity": 10,
      "logo": Icons.ac_unit,
    },
    {
      "title": "مبلط سيراميك (Tiler)",
      "company": "تشطيبات لوكس",
      "location": "Monufia",
      "tags": ["Full-Time", "Flooring", "Tiling"],
      "applied": 4,
      "capacity": 10,
      "logo": Icons.layers,
    },
    {
      "title": "فني ألوميتال",
      "company": "المستقبل للألمنيوم",
      "location": "Gharbia",
      "tags": ["Full-Time", "Windows", "Alumital"],
      "applied": 6,
      "capacity": 12,
      "logo": Icons.window,
    },
    {
      "title": "فني صيانة غسالات",
      "company": "خدمة صيانة",
      "location": "Cairo",
      "tags": ["Full-Time", "Washing Machine", "Repair"],
      "applied": 3,
      "capacity": 10,
      "logo": Icons.dry_cleaning,
    },
    {
      "title": "فني دش ورسيفر",
      "company": "سمارت للستالايت",
      "location": "Giza",
      "tags": ["Full-Time", "Satellite", "Installation"],
      "applied": 8,
      "capacity": 15,
      "logo": Icons.settings_input_antenna,
    },
    {
      "title": "مركب ستائر",
      "company": "بيت الهنا",
      "location": "Alexandria",
      "tags": ["Full-Time", "Curtain", "Home Decor"],
      "applied": 2,
      "capacity": 6,
      "logo": Icons.window_outlined,
    },
    {
      "title": "حداد كريتال",
      "company": "الحديد والصلب",
      "location": "Qalyubia",
      "tags": ["Full-Time", "Blacksmith", "Metal Work"],
      "applied": 5,
      "capacity": 10,
      "logo": Icons.hardware,
    },
    {
      "title": "منجد أثاث",
      "company": "لمسة فن",
      "location": "Damietta",
      "tags": ["Full-Time", "Upholstery", "Furniture"],
      "applied": 1,
      "capacity": 5,
      "logo": Icons.chair,
    },
    {
      "title": "فني رخام وجرانيت",
      "company": "الماسة للرخام",
      "location": "Cairo",
      "tags": ["Full-Time", "Marble", "Stone"],
      "applied": 4,
      "capacity": 8,
      "logo": Icons.foundation,
    },
    {
      "title": "فني باركيه",
      "company": "أرضيات الخشب",
      "location": "Giza",
      "tags": ["Contract", "Parquet", "Flooring"],
      "applied": 2,
      "capacity": 10,
      "logo": Icons.grid_on,
    },
    {
      "title": "ÙÙ†ÙŠ Ø¹Ø²Ù„ Ø£Ø³Ø·Ø­",
      "company": "Ø¯Ø±Ø¹ Ø§Ù„Ø­Ù…Ø§ÙŠØ©",
      "location": "Cairo",
      "tags": ["Full-Time", "Insulation", "Waterproof"],
      "applied": 6,
      "capacity": 12,
      "logo": Icons.shield,
    },
  ];

  late List<Map<String, dynamic>> _filteredJobs;

  @override
  void initState() {
    super.initState();
    _filteredJobs = _allJobs;
    _searchController.addListener(_filterJobs);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterJobs);
    _searchController.dispose();
    super.dispose();
  }

  void _filterJobs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredJobs = _allJobs.where((job) {
        final matchesTitle = job['title'].toLowerCase().contains(query) ||
            job['company'].toLowerCase().contains(query);
        final matchesLocation = _selectedLocation == "All" || job['location'] == _selectedLocation;
        return matchesTitle && matchesLocation;
      }).toList();
    });
  }

  void _showLocationPicker(AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D2D4D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(t.tr(en: "Select Governorate", ar: "اختر المحافظة"), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _egyptGovernorates.length + 1,
                itemBuilder: (context, index) {
                  final loc = index == 0 ? "All" : _egyptGovernorates[index - 1];
                  return ListTile(
                    title: Text(loc, style: const TextStyle(color: Colors.white70)),
                    onTap: () {
                      setState(() {
                        _selectedLocation = loc;
                      });
                      _filterJobs();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF011931),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildIconButton(Icons.notifications_none, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TradesmanNotifications()));
                  }),
                  const SizedBox(width: 12),
                  _buildIconButton(Icons.settings_outlined, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
                  }),
                ],
              ),
              const SizedBox(height: 25),

              // Search Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: t.userTr('find_jobs.searchHint', fallbackEn: 'Job title or keyword', fallbackAr: 'عنوان الوظيفة أو كلمة مفتاحية'),
                            hintStyle: const TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                      ),
                    ),
                    Container(height: 20, width: 1, color: Colors.white10),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _showLocationPicker(t),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.white38, size: 18),
                          const SizedBox(width: 4),
                          Text(_selectedLocation, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white38, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${t.userTr('find_jobs.popular', fallbackEn: 'Popular', fallbackAr: 'شائع')} : Plumber, Painter, Carpenter, Electrician",
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(height: 35),

              // All Jobs Header
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: t.tr(en: "All ", ar: "جميع "), style: const TextStyle(color: Colors.white)),
                    TextSpan(text: t.tr(en: "jobs", ar: "الوظائف"), style: const TextStyle(color: Color(0xFF49769F))),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Jobs List
              _filteredJobs.isEmpty 
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                  child: Text(t.tr(en: 'No jobs found', ar: 'لا توجد وظائف'), style: const TextStyle(color: Colors.white54)),
                  ),
                )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredJobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(_filteredJobs[index], t);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0D2D4D),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, AppLocalizations t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(job['logo'], color: Colors.white70, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "${job['company']} • ${job['location']}",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (job['tags'] as List<String>).map((tag) => _buildTag(tag)).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF49769F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(t.tr(en: 'Apply', ar: 'تقديم'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              Text(
                "${job['applied']} ${t.tr(en: 'applied', ar: 'متقدم')}",
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    bool isSpecial = ["Painting", "Plumbing", "Carpentry", "Furniture", "Maintenance"].any((s) => text.toLowerCase().contains(s.toLowerCase()));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSpecial ? Colors.orange.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSpecial ? Colors.orange.withValues(alpha: 0.4) : Colors.white12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSpecial ? Colors.orange : Colors.white70,
          fontSize: 10,
        ),
      ),
    );
  }
}

