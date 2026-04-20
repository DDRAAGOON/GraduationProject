import 'package:flutter/material.dart';

class PostJob extends StatefulWidget {
  const PostJob({super.key});

  @override
  State<PostJob> createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _descriptionControllers = [TextEditingController()];
  final TextEditingController _skillInputController = TextEditingController();

  final List<String> _selectedSkills = [];
  final List<String> _days = ["Saterday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  final Set<String> _selectedDays = {"Sunday", "Tuesday"};
  
  bool _isWorkTimeExpanded = false;
  String _selectedLocation = "Select Location";

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
    _titleController.dispose();
    for (var controller in _descriptionControllers) {
      controller.dispose();
    }
    _skillInputController.dispose();
    super.dispose();
  }

  void _addDescriptionPoint() {
    setState(() {
      _descriptionControllers.add(TextEditingController());
    });
  }

  void _addSkill() {
    final skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _skillInputController.clear();
      });
    }
  }

  void _showLocationPicker() {
    String? currentGov;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D2D4D),
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
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        if (currentGov != null) 
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => setModalState(() => currentGov = null),
                          ),
                        Text(
                          currentGov ?? "Select Governorate", 
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(items[index], style: const TextStyle(color: Colors.white70)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011931),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back arrow
        title: const Text("Post a Job", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Header
            _buildSectionHeader("Basic Information", "This information will be displayed publicly"),
            const Divider(color: Colors.white24, height: 40),

            // Job Title
            _buildSideTitleSection(
              title: "Job Title",
              subtitle: "Job titles must be describe one position",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(controller: _titleController, hint: "e.g. Software Engineer"),
                  const SizedBox(height: 8),
                  const Text("At least 80 characters", style: TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 40),

            // Job Descriptions
            _buildSideTitleSection(
              title: "Job Descriptions",
              subtitle: "Job titles must be describe one position",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._descriptionControllers.map((controller) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildTextField(controller: controller, hint: "Enter job description", maxLines: 2),
                  )),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _addDescriptionPoint,
                    icon: const Icon(Icons.add, size: 18, color: Color(0xFF49769F)),
                    label: const Text("Add another point", style: TextStyle(color: Color(0xFF49769F))),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 40),

            // Required Skills
            _buildSideTitleSection(
              title: "Required Skills",
              subtitle: "Add required skills for the job",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(controller: _skillInputController, hint: "Type skill here..."),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: _addSkill,
                        icon: const Icon(Icons.add_circle, color: Color(0xFF49769F), size: 35),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedSkills.map((skill) => _buildSkillChip(skill)).toList(),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 40),

            // Location
            _buildSideTitleSection(
              title: "Location",
              subtitle: "Select governorate and area in Egypt",
              child: GestureDetector(
                onTap: _showLocationPicker,
                child: _buildDropdownField(_selectedLocation),
              ),
            ),
            const Divider(color: Colors.white24, height: 40),

            // Work Time
            _buildSideTitleSection(
              title: "Work time",
              subtitle: "",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isWorkTimeExpanded = !_isWorkTimeExpanded),
                    child: _buildSmallDropdown(_selectedDays.length == 7 ? "All days" : "Select"),
                  ),
                  if (_isWorkTimeExpanded) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.02),
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildDayItem("All Days", isSpecial: true),
                          const Divider(color: Colors.white12, height: 1),
                          ..._days.map((day) => _buildDayItem(day)).toList(),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 40),

            // Work Image
            _buildSideTitleSection(
              title: "Work Image",
              subtitle: "Can Put Image For Our Your Work",
              child: _buildUploadBox("Click to replace or drag and drop\nSVG, PNG, JPG or GIF (max. 400 x 400px)"),
            ),
            const SizedBox(height: 40),

            // Bottom Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF49769F),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
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
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
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

  Widget _buildTextField({required TextEditingController controller, required String hint, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          contentPadding: const EdgeInsets.all(12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF49769F), fontSize: 12)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedSkills.remove(label);
              });
            },
            child: const Icon(Icons.close, size: 14, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white70, fontSize: 14), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
        ],
      ),
    );
  }

  Widget _buildSmallDropdown(String hint) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Icon(
            _isWorkTimeExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
            color: Colors.white38, 
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
          color: isSelected ? const Color(0xFF49769F).withValues(alpha: 0.3) : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? const Color(0xFF49769F) : Colors.white24,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox(String text) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF49769F), style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.image_outlined, color: Colors.white38, size: 32),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(text: "Click to replace ", style: TextStyle(color: Color(0xFF49769F), fontSize: 12)),
                  TextSpan(text: "or drag and drop\n$text".replaceAll("Click to replace or drag and drop\n", ""), style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

