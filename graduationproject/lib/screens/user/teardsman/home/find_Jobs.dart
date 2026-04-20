import 'package:flutter/material.dart';
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
      "title": "Ù†Ù‚Ø§Ø´ Ù…Ø­ØªØ±Ù (Painter)",
      "company": "Ù…Ù‚Ø§ÙˆÙ„Ø§Øª Ø§Ù„Ø­Ø¯ÙŠØ«Ø©",
      "location": "Cairo",
      "tags": ["Full-Time", "Painting", "Interior"],
      "applied": 5,
      "capacity": 10,
      "logo": Icons.brush,
    },
    {
      "title": "Ø³Ø¨Ø§Ùƒ ØµØ­ÙŠ (Plumber)",
      "company": "Ø§Ù„Ø¬Ø²ÙŠØ±Ø© Ù„Ù„Ø®Ø¯Ù…Ø§Øª",
      "location": "Giza",
      "tags": ["Full-Time", "Plumbing", "Maintenance"],
      "applied": 3,
      "capacity": 8,
      "logo": Icons.plumbing,
    },
    {
      "title": "Ù†Ø¬Ø§Ø± Ø£Ø«Ø§Ø« (Carpenter)",
      "company": "ÙˆØ±Ø´Ø© Ø§Ù„Ø¥Ø¨Ø¯Ø§Ø¹",
      "location": "Damietta",
      "tags": ["Full-Time", "Carpentry", "Furniture"],
      "applied": 12,
      "capacity": 15,
      "logo": Icons.carpenter,
    },
    {
      "title": "ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠ Ù…Ù†Ø§Ø²Ù„ (Electrician)",
      "company": "Ø§Ù„Ù†ÙˆØ± Ù„Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¡",
      "location": "Alexandria",
      "tags": ["Part-Time", "Electrical", "Repair"],
      "applied": 2,
      "capacity": 5,
      "logo": Icons.electrical_services,
    },
    {
      "title": "ÙÙ†ÙŠ ØªÙƒÙŠÙŠÙ (HVAC Tech)",
      "company": "ÙƒÙˆÙ„ Ø§ÙŠØ±",
      "location": "Cairo",
      "tags": ["Contract", "AC Repair", "Maintenance"],
      "applied": 7,
      "capacity": 10,
      "logo": Icons.ac_unit,
    },
    {
      "title": "Ù…Ø¨Ù„Ø· Ø³ÙŠØ±Ø§Ù…ÙŠÙƒ (Tiler)",
      "company": "ØªØ´Ø·ÙŠØ¨Ø§Øª Ù„ÙˆÙƒØ³",
      "location": "Monufia",
      "tags": ["Full-Time", "Flooring", "Tiling"],
      "applied": 4,
      "capacity": 10,
      "logo": Icons.layers,
    },
    {
      "title": "ÙÙ†ÙŠ Ø£Ù„ÙˆÙ…ÙŠØªØ§Ù„",
      "company": "Ø§Ù„Ù…Ø³ØªÙ‚Ø¨Ù„ Ù„Ù„Ø£Ù„Ù…Ù†ÙŠÙˆÙ…",
      "location": "Gharbia",
      "tags": ["Full-Time", "Windows", "Alumital"],
      "applied": 6,
      "capacity": 12,
      "logo": Icons.window,
    },
    {
      "title": "ÙÙ†ÙŠ ØµÙŠØ§Ù†Ø© ØºØ³Ø§Ù„Ø§Øª",
      "company": "Ø®Ø¯Ù…Ø© ØµÙŠØ§Ù†Ø©",
      "location": "Cairo",
      "tags": ["Full-Time", "Washing Machine", "Repair"],
      "applied": 3,
      "capacity": 10,
      "logo": Icons.dry_cleaning,
    },
    {
      "title": "ÙÙ†ÙŠ Ø¯Ø´ ÙˆØ±Ø³ÙŠÙØ±",
      "company": "Ø³Ù…Ø§Ø±Øª Ù„Ù„Ø³Ø§ØªÙ„Ø§ÙŠØª",
      "location": "Giza",
      "tags": ["Full-Time", "Satellite", "Installation"],
      "applied": 8,
      "capacity": 15,
      "logo": Icons.settings_input_antenna,
    },
    {
      "title": "Ù…Ø±ÙƒØ¨ Ø³ØªØ§Ø¦Ø±",
      "company": "Ø¨ÙŠØª Ø§Ù„Ù‡Ù†Ø§",
      "location": "Alexandria",
      "tags": ["Full-Time", "Curtain", "Home Decor"],
      "applied": 2,
      "capacity": 6,
      "logo": Icons.window_outlined,
    },
    {
      "title": "Ø­Ø¯Ø§Ø¯ ÙƒØ±ÙŠØªØ§Ù„",
      "company": "Ø§Ù„Ø­Ø¯ÙŠØ¯ ÙˆØ§Ù„ØµÙ„Ø¨",
      "location": "Qalyubia",
      "tags": ["Full-Time", "Blacksmith", "Metal Work"],
      "applied": 5,
      "capacity": 10,
      "logo": Icons.hardware,
    },
    {
      "title": "Ù…Ù†Ø¬Ø¯ Ø£Ø«Ø§Ø«",
      "company": "Ù„Ù…Ø³Ø© ÙÙ†",
      "location": "Damietta",
      "tags": ["Full-Time", "Upholstery", "Furniture"],
      "applied": 1,
      "capacity": 5,
      "logo": Icons.chair,
    },
    {
      "title": "ÙÙ†ÙŠ Ø±Ø®Ø§Ù… ÙˆØ¬Ø±Ø§Ù†ÙŠØª",
      "company": "Ø§Ù„Ù…Ø§Ø³Ø© Ù„Ù„Ø±Ø®Ø§Ù…",
      "location": "Cairo",
      "tags": ["Full-Time", "Marble", "Stone"],
      "applied": 4,
      "capacity": 8,
      "logo": Icons.foundation,
    },
    {
      "title": "ÙÙ†ÙŠ Ø¨Ø§Ø±ÙƒÙŠÙ‡",
      "company": "Ø£Ø±Ø¶ÙŠØ§Øª Ø§Ù„Ø®Ø´Ø¨",
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

  void _showLocationPicker() {
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
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Select Governorate", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
                        decoration: const InputDecoration(
                          hintText: "Job title or keyword",
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(height: 20, width: 1, color: Colors.white10),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _showLocationPicker,
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
              const Text(
                "Popular : Plumber, Painter, Carpenter, Electrician",
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(height: 35),

              // All Jobs Header
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: "All ", style: TextStyle(color: Colors.white)),
                    TextSpan(text: "jobs", style: TextStyle(color: Color(0xFF49769F))),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Jobs List
              _filteredJobs.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text("No jobs found", style: TextStyle(color: Colors.white54)),
                  ),
                )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredJobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(_filteredJobs[index]);
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

  Widget _buildJobCard(Map<String, dynamic> job) {
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
                  "${job['company']} â€¢ ${job['location']}",
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
                child: const Text("Apply", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: job['applied'] / job['capacity'],
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${job['applied']} applied of ${job['capacity']}",
                      style: const TextStyle(color: Colors.white38, fontSize: 9),
                    ),
                  ],
                ),
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

