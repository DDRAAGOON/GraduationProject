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

  List<Map<String, dynamic>> _getAllJobs(AppLocalizations t) => [
    {
      "title": "نقاش محترف (Painter)",
      "company": "مقاولات الحديثة",
      "location": "Cairo",
      "tags": ["Full-Time", "Painting", "Interior"],
      "applied": 5,
      "capacity": 10,
      "logo": Icons.brush,
    },
    // ... other jobs (kept as is for brevity in this replace call, 
    // but ensuring they don't break. 
    // Actually I should keep the whole list to be safe)
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
      "title": t.tr(en: "Insulation Technician", ar: "فني عزل أسطح"),
      "company": t.tr(en: "Protection Shield", ar: "درع الحماية"),
      "location": "Cairo",
      "tags": ["Full-Time", "Insulation", "Waterproof"],
      "applied": 6,
      "capacity": 12,
      "logo": Icons.shield,
    },
  ];

  late List<Map<String, dynamic>> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterJobs);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterJobs(); // Initial filter once we have context/t
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterJobs);
    _searchController.dispose();
    super.dispose();
  }

  void _filterJobs() {
    if (!mounted) return;
    final t = AppLocalizations.of(context);
    final query = _searchController.text.toLowerCase();
    final allJobs = _getAllJobs(t);
    setState(() {
      _filteredJobs = allJobs.where((job) {
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? const Color(0xFF0D2D4D) 
          : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(t.tr(en: "Select Governorate", ar: "اختر المحافظة"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _egyptGovernorates.length + 1,
                itemBuilder: (context, index) {
                  final loc = index == 0 ? (t.isAr ? "الكل" : "All") : _egyptGovernorates[index - 1];
                  return ListTile(
                    title: Text(loc, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withValues(alpha: 0.05) 
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: t.tr(en: "Search jobs", ar: "البحث عن وظائف"),
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                            border: InputBorder.none,
                          ),
                      ),
                    ),
                    Container(height: 20, width: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _showLocationPicker(t),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 18),
                          const SizedBox(width: 4),
                          Text(_selectedLocation, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12)),
                          Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${t.userTr('find_jobs.popular', fallbackEn: 'Popular', fallbackAr: 'شائع')} : Plumber, Painter, Carpenter, Electrician",
               style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11),
              ),
              const SizedBox(height: 35),

              // All Jobs Header
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: t.tr(en: "All ", ar: "جميع "), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    TextSpan(text: t.job, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Jobs List
              _filteredJobs.isEmpty 
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                  child: Text(t.tr(en: 'No jobs found', ar: 'لا توجد وظائف'), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54))),
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
          color: Theme.of(context).brightness == Brightness.dark 
              ? const Color(0xFF0D2D4D) 
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 20),
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
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(job['logo'], color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'],
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "${job['company']} • ${job['location']}",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12),
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
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(t.tr(en: 'Apply', ar: 'تقديم'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              Text(
                "${job['applied']} ${t.tr(en: 'applied', ar: 'متقدم')}",
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11),
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
        border: Border.all(color: isSpecial ? Colors.orange.withValues(alpha: 0.4) : Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSpecial ? Colors.orange : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 10,
        ),
      ),
    );
  }
}

