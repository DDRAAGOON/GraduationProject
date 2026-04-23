import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';

class PostJob extends StatefulWidget {
  const PostJob({super.key});

  @override
  State<PostJob> createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final List<String> _days = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  final Set<String> _selectedDays = {};
  
  bool _isWorkTimeExpanded = false;
  String _selectedLocation = "";

  // Egypt Locations Data
  final Map<String, List<String>> _egyptLocations = {
    "Cairo": ["Ain Shams", "Heliopolis (Misr El-Gedida)", "Maadi", "Nasr City", "Shobra", "Zamalek", "Garden City", "New Cairo"],
    "Giza": ["6th of October", "Dokki", "Haram", "Mohandessin", "Sheikh Zayed", "Faisal"],
    "Alexandria": ["Agami", "Amreya", "Mansheya", "Montaza", "Sidi Gaber", "Stanly"],
    "Dakahlia": ["Mansoura", "Talkha", "Mit Ghamr"],
    "Sharqia": ["Zagazig", "10th of Ramadan", "Bilbeis"],
    "Qalyubia": ["Banha", "Shubra El Kheima", "Obour"],
    "Gharbia": ["Tanta", "Mahalla El Kubra"],
    "Menofia": ["Shibin El Kom", "Menouf"],
    "Beheira": ["Damanhour", "Kafr El Dawwar"],
    "Ismailia": ["Ismailia City", "Fayed"],
    "Suez": ["Suez City", "Arbaeen"],
    "Port Said": ["Port Said City", "Port Fouad"],
    "Luxor": ["Luxor City", "Karnak"],
    "Aswan": ["Aswan City", "Kom Ombo"],
    "Sohag": ["Sohag City", "Girga"],
    "Assiut": ["Assiut City", "Manfalut"],
    "Minya": ["Minya City", "Mallawi"],
    "Beni Suef": ["Beni Suef City", "Nasser"],
    "Fayoum": ["Fayoum City", "Itsa"],
    "Kafr El Sheikh": ["Kafr El Sheikh City", "Desouk"],
    "Damietta": ["Damietta City", "New Damietta"],
    "Matrouh": ["Marsa Matrouh", "Siwa"],
    "North Sinai": ["Arish"],
    "South Sinai": ["Sharm El Sheikh", "Dahab", "Nuweiba"],
    "Qena": ["Qena City", "Nag Hammadi"],
    "New Valley": ["Kharga", "Dakhla"],
    "Red Sea": ["Hurghada", "Safaga", "Marsa Alam"],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showLocationPicker(AppLocalizations t) {
    String? currentGov;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final List<String> items = currentGov == null 
                ? _egyptLocations.keys.toList() 
                : _egyptLocations[currentGov]!;

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        if (currentGov != null) 
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black87),
                            onPressed: () => setModalState(() => currentGov = null),
                          ),
                        Text(
                          currentGov ?? t.tr(en: "Select Governorate", ar: "اختر المحافظة"), 
                          style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(items[index], style: const TextStyle(color: Colors.black87)),
                          onTap: () {
                            if (currentGov == null) {
                              setModalState(() => currentGov = items[index]);
                            } else {
                              setState(() {
                                _selectedLocation = "$currentGov, ${items[index]}";
                              });
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _validateAndPost(AppLocalizations t) {
    if (_nameController.text.trim().isEmpty ||
        _titleController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _selectedLocation.isEmpty ||
        _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.tr(en: "Please fill all required fields", ar: "يرجى ملء جميع الحقول المطلوبة")),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.tr(en: "Service posted successfully!", ar: "تم نشر الخدمة بنجاح!"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false, 
        title: Row(
          children: [
          //  Image.asset(
            //  'assets/company/logo/logo.png',
             // height: 100,
              //fit: BoxFit.contain,
            //),
            const SizedBox(width: 12),
            Text(
              t.tr(en: "Post job", ar: "نشر وظيفة"),
              style: const TextStyle(
                color: Color(0xFF011931),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Basic Information Header
            _buildSectionHeader(
              t.tr(en: "Basic Information", ar: "معلومات أساسية"), 
              t.tr(en: "This information will be displayed publicly", ar: "سيتم عرض هذه المعلومات بشكل علني")
            ),
            const Divider(color: Colors.black12, height: 40),

            // Name
            _buildSideTitleSection(
              title: "${t.tr(en: "Full Name", ar: "الاسم بالكامل")} *",
              subtitle: t.tr(en: "Enter your full name", ar: "أدخل اسمك بالكامل"),
              child: _buildTextField(controller: _nameController, hint: "e.g. Ahmed Ali"),
            ),
            const Divider(color: Colors.black12, height: 40),

            // Service Title (Job Title)
            _buildSideTitleSection(
              title: "${t.tr(en: "Service Title", ar: "عنوان الخدمة")} *",
              subtitle: t.tr(en: "Describe your profession", ar: "صف مهنتك"),
              child: _buildTextField(controller: _titleController, hint: "e.g. Professional Plumber"),
            ),
            const Divider(color: Colors.black12, height: 40),

            // Starting Price
            _buildSideTitleSection(
              title: "${t.tr(en: "Starting Price", ar: "السعر المبدئي")} *",
              subtitle: t.tr(en: "Price starts from...", ar: "يبدأ السعر من..."),
              child: _buildTextField(
                controller: _priceController, 
                hint: "e.g. 150 EGP",
                keyboardType: TextInputType.number,
              ),
            ),
            const Divider(color: Colors.black12, height: 40),

            // Location
            _buildSideTitleSection(
              title: "${t.tr(en: "Location", ar: "الموقع")} *",
              subtitle: t.tr(en: "Select governorate and area in Egypt", ar: "اختر المحافظة والمنطقة في مصر"),
              child: GestureDetector(
                onTap: () => _showLocationPicker(t),
                child: _buildDropdownField(_selectedLocation.isEmpty ? t.tr(en: "Select Location", ar: "اختر الموقع") : _selectedLocation),
              ),
            ),
            const Divider(color: Colors.black12, height: 40),

            // Work Time
            _buildSideTitleSection(
              title: "${t.tr(en: "Work time", ar: "وقت العمل")} *",
              subtitle: t.tr(en: "Available days", ar: "الأيام المتاحة"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isWorkTimeExpanded = !_isWorkTimeExpanded),
                    child: _buildSmallDropdown(_selectedDays.length == 7 ? t.tr(en: "All days", ar: "كل الأيام") : t.tr(en: "Select", ar: "اختر")),
                  ),
                  if (_isWorkTimeExpanded) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildDayItem(t.tr(en: "All Days", ar: "كل الأيام"), isSpecial: true),
                          const Divider(color: Colors.black12, height: 1),
                          ..._days.map((day) => _buildDayItem(day)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Bottom Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _validateAndPost(t),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF49769F),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  t.tr(en: "Post job", ar: "نشر وظيفة"),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.black38, fontSize: 12)),
      ],
    );
  }

  Widget _buildSideTitleSection({required String title, required String subtitle, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold)),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black38, fontSize: 11)),
              ],
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 5,
          child: child,
        ),
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
          contentPadding: const EdgeInsets.all(12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black54, fontSize: 14), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black38),
        ],
      ),
    );
  }

  Widget _buildSmallDropdown(String hint) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          Icon(
            _isWorkTimeExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
            color: Colors.black38, 
            size: 16
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, {bool isSpecial = false}) {
    bool isSelected = isSpecial 
        ? _selectedDays.length == 7 
        : _selectedDays.contains(day);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSpecial) {
            if (_selectedDays.length == 7) {
              _selectedDays.clear();
            } else {
              _selectedDays.addAll(_days);
            }
          } else {
            if (isSelected) {
              _selectedDays.remove(day);
            } else {
              _selectedDays.add(day);
            }
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF49769F).withOpacity(0.1) : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.05))),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? const Color(0xFF49769F) : Colors.black26,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.black54,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
