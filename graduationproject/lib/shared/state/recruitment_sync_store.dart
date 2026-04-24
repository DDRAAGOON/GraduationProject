import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecruitmentJob {
  const RecruitmentJob({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
    required this.type,
    required this.category,
    required this.tags,
    required this.publishedAt,
    this.logoIcon,
  });

  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;
  final String type;
  final String category;
  final List<String> tags;
  final DateTime publishedAt;
  final IconData? logoIcon;
}

class RecruitmentApplication {
  const RecruitmentApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.userName,
    required this.status,
    required this.updatedAt,
  });

  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String userName;
  final String status;
  final DateTime updatedAt;

  RecruitmentApplication copyWith({
    String? status,
    DateTime? updatedAt,
  }) {
    return RecruitmentApplication(
      id: id,
      jobId: jobId,
      jobTitle: jobTitle,
      companyName: companyName,
      userName: userName,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RecruitmentMessage {
  const RecruitmentMessage({
    required this.id,
    required this.fromCompany,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final bool fromCompany;
  final String text;
  final DateTime createdAt;
}

class ServiceRequestPost {
  const ServiceRequestPost({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.requestedBy,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String budget;
  final String requestedBy;
  final DateTime createdAt;
}

class RecruitmentSyncStore extends ChangeNotifier {
  RecruitmentSyncStore._();

  static final RecruitmentSyncStore instance = RecruitmentSyncStore._();

  static const Map<String, String> locationTranslations = {
    'All': 'الكل',
    'Cairo': 'القاهرة',
    'Giza': 'الجيزة',
    'Alexandria': 'الإسكندرية',
    'Dakahlia': 'الدقهلية',
    'Red Sea': 'البحر الأحمر',
    'Beheira': 'البحيرة',
    'Fayoum': 'الفيوم',
    'Gharbia': 'الغربية',
    'Ismailia': 'الإسماعيلية',
    'Monufia': 'المنوفية',
    'Minya': 'المنيا',
    'Qalyubia': 'القليوبية',
    'New Valley': 'الوادي الجديد',
    'Sharqia': 'الشرقية',
    'Suez': 'السويس',
    'Aswan': 'أسوان',
    'Assiut': 'أسيوط',
    'Beni Suef': 'بني سويف',
    'Port Said': 'بورسعيد',
    'Damietta': 'دمياط',
    'South Sinai': 'جنوب سيناء',
    'Kafr El Sheikh': 'كفر الشيخ',
    'Matrouh': 'مطروح',
    'Luxor': 'الأقصر',
    'Qena': 'قنا',
    'Sohag': 'سوهاج',
    'North Sinai': 'شمال سيناء',
    'Remote': 'عن بعد',
  };

  static const List<String> egyptGovernorates = [
    'All',
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Beheira',
    'Fayoum',
    'Gharbia',
    'Ismailia',
    'Monufia',
    'Minya',
    'Qalyubia',
    'New Valley',
    'Sharqia',
    'Suez',
    'Aswan',
    'Assiut',
    'Beni Suef',
    'Port Said',
    'Damietta',
    'South Sinai',
    'Kafr El Sheikh',
    'Matrouh',
    'Luxor',
    'Qena',
    'Sohag',
    'North Sinai',
    'Remote',
  ];

  static const List<String> categories = [
    'All',
    'Technical',
    'Non-technical',
    'Service',
    'Tradesman',
  ];

  static const List<String> salaryRanges = [
    'All',
    '10k - 20k',
    '20k - 30k',
    '30k - 45k',
    'Negotiable',
  ];

  final List<RecruitmentJob> _jobs = <RecruitmentJob>[
    // Technical
    RecruitmentJob(
      id: 'job_1',
      title: 'Flutter Mobile Developer',
      companyName: 'Valeo Egypt',
      location: 'Cairo',
      salaryRange: '10k - 25k EGP',
      type: 'Full-time',
      category: 'Technical',
      tags: const ['Flutter', 'Dart', 'REST'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    RecruitmentJob(
      id: 'job_2',
      title: 'Frontend React Developer',
      companyName: 'Orange Digital Center',
      location: 'Cairo',
      salaryRange: '5k - 15k EGP',
      type: 'Part-time',
      category: 'Technical',
      tags: const ['Html', 'Css', 'Java'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    RecruitmentJob(
      id: 'job_3',
      title: 'Data Analyst',
      companyName: 'Orange Digital Center',
      location: 'Suez',
      salaryRange: '8k - 15k EGP',
      type: 'Full-time',
      category: 'Technical',
      tags: const ['Flutter', 'Dart', 'REST'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    RecruitmentJob(
      id: 'job_4',
      title: 'AI / Machine Learning Engineer',
      companyName: 'IBM Egypt',
      location: 'Cairo',
      salaryRange: '20k - 30k EGP',
      type: 'Part-time',
      category: 'Technical',
      tags: const ['Flutter', 'Dart', 'REST'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),

    RecruitmentJob(
      id: 'job_5',
      title: 'Backend Node.js Engineer',
      companyName: 'IBM Egypt',
      location: 'Luxor',
      salaryRange: '30k - 45k EGP',
      type: 'Full-time',
      category: 'Technical',
      tags: const ['Node.js', 'Express', 'PostgreSQL'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    RecruitmentJob(
      id: 'job_6',
      title: 'Cyber Security Analyst',
      companyName: 'Vodafone Egypt (Technology sector)',
      location: 'Cairo',
      salaryRange: '30k - 45k EGP',
      type: 'Part-time',
      category: 'Technical',
      tags: const ['Node.js', 'Express', 'PostgreSQL'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    RecruitmentJob(
      id: 'job_7',
      title: 'Cyber Security Analyst',
      companyName: 'Valeo Egypt',
      location: 'Cairo',
      salaryRange: '30k - 45k EGP',
      type: 'Full-time',
      category: 'Technical',
      tags: const ['Node.js', 'Express', 'PostgreSQL'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    RecruitmentJob(
      id: 'job_8',
      title: 'Cyber Security Analyst',
      companyName: 'Nexa Systems' ,
      location: 'Alexandria',
      salaryRange: '30k - 45k EGP',
      type: 'Full-time',
      category: 'Technical',
      tags: const ['Node.js', 'Express', 'PostgreSQL'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    RecruitmentJob(
      id: 'job_9',
      title: 'Cyber Security Analyst',
      companyName: 'Nexa Systems',
      location: 'Cairo',
      salaryRange: '30k - 45k EGP',
      type: 'Full-time',
      category: 'Technical',
      tags: const ['Node.js', 'Express', 'PostgreSQL'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    RecruitmentJob(
      id: 'job_10',
      title: 'Cyber Security Analyst',
      companyName: 'Nexa Systems',
      location: 'Alexandria',
      salaryRange: '20k - 35k EGP',
      type: 'Part-time',
      category: 'Technical',
      tags: const ['Node.js', 'Express', 'PostgreSQL'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),

    // Tradesman
    RecruitmentJob(
      id: 'tr_1',
      title: 'نقاش محترف',
      companyName: 'مقاولات الحديثة',
      location: 'Cairo',
      salaryRange: 'Negotiable',
      type: 'Full-time',
      category: 'Tradesman',
      tags: const ['Painting', 'Interior'],
      logoIcon: Icons.brush,
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RecruitmentJob(
      id: 'tr_2',
      title: 'سباك صحي',
      companyName: 'الجزيرة للخدمات',
      location: 'Giza',
      salaryRange: 'Negotiable',
      type: 'Part-time',
      category: 'Tradesman',
      tags: const ['Plumbing', 'Maintenance'],
      logoIcon: Icons.plumbing,
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RecruitmentJob(
      id: 'tr_3',
      title: 'نجار أثاث',
      companyName: 'ورشة الإبداع',
      location: 'Damietta',
      salaryRange: 'Negotiable',
      type: 'Full-time',
      category: 'Tradesman',
      tags: const ['Carpentry', 'Furniture'],
      logoIcon: Icons.carpenter,
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    RecruitmentJob(
      id: 'tr_4',
      title: 'كهربائي منازل',
      companyName: 'النور للكهرباء',
      location: 'Alexandria',
      salaryRange: 'Negotiable',
      type: 'Part-time',
      category: 'Tradesman',
      tags: const ['Electrical', 'Repair'],
      logoIcon: Icons.electrical_services,
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    RecruitmentJob(
      id: 'tr_5',
      title: 'فني تكييف وتبريد',
      companyName: 'كول اير للخدمات',
      location: 'Cairo',
      salaryRange: 'Negotiable',
      type: 'Full-time',
      category: 'Tradesman',
      tags: const ['AC Repair', 'Maintenance'],
      logoIcon: Icons.ac_unit,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final List<RecruitmentApplication> _applications = <RecruitmentApplication>[];
  final List<RecruitmentMessage> _messages = <RecruitmentMessage>[];
  final Set<String> _savedJobIds = <String>{};
  
  String _currentUserName = 'Ahmed User';
  String _currentUserEmail = 'user@jobito.com';
  String _currentUserPhone = '';
  String _currentUserLocation = 'Cairo, Egypt';
  String _currentUserAbout = '';
  String _currentUserTitle = 'Mobile Developer';
  String _currentUserPortfolio = '';
  String _userRole = 'Job Seeker';
  String? _currentUserCvName;
  String? _profileImage;
  String _searchQuery = '';
  String _filterType = 'All';
  String _filterLocation = 'All';
  String _filterCategory = 'All';
  String _filterSalaryRange = 'All';
  List<Map<String, String>> _socialLinks = [];
  List<String> _currentUserSkills = [];
  List<Map<String, String>> _currentUserEducation = [];
  List<Map<String, String>> _currentUserExperience = [];
  final List<ServiceRequestPost> _serviceRequests = <ServiceRequestPost>[
    ServiceRequestPost(
      id: 'sr_1',
      title: 'Need Electrician Worker',
      description: 'Home maintenance for wiring and switches.',
      budget: '3k EGP',
      requestedBy: 'Mona Ali',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  List<RecruitmentJob> get jobs => List<RecruitmentJob>.unmodifiable(_jobs);
  List<RecruitmentApplication> get applications => List<RecruitmentApplication>.unmodifiable(_applications);
  List<RecruitmentMessage> get messages => List<RecruitmentMessage>.unmodifiable(_messages);
  Set<String> get savedJobIds => Set<String>.unmodifiable(_savedJobIds);
  
  String get currentUserName => _currentUserName;
  String get currentUserEmail => _currentUserEmail;
  String get currentUserPhone => _currentUserPhone;
  String get currentUserLocation => _currentUserLocation;
  String get currentUserAbout => _currentUserAbout;
  String get currentUserTitle => _currentUserTitle;
  String get currentUserPortfolio => _currentUserPortfolio;
  String get userRole => _userRole;
  String? get currentUserCvName => _currentUserCvName;
  String? get profileImage => _profileImage;
  String get searchQuery => _searchQuery;
  String get filterType => _filterType;
  String get filterLocation => _filterLocation;
  String get filterCategory => _filterCategory;
  String get filterSalaryRange => _filterSalaryRange;
  List<Map<String, String>> get socialLinks => _socialLinks;
  List<String> get currentUserSkills => _currentUserSkills;
  List<Map<String, String>> get currentUserEducation => _currentUserEducation;
  List<Map<String, String>> get currentUserExperience => _currentUserExperience;
  List<ServiceRequestPost> get serviceRequests => List<ServiceRequestPost>.unmodifiable(_serviceRequests);

  List<RecruitmentJob> get savedJobs =>
      _jobs.where((item) => _savedJobIds.contains(item.id)).toList();

  List<RecruitmentJob> get filteredJobs {
    return _jobs.where((job) {
      final query = _searchQuery.toLowerCase();
      final searchParts = query.split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
      
      final matchesQuery = _searchQuery.isEmpty || searchParts.every((part) {
          final titleMatch = job.title.toLowerCase().contains(part);
          final companyMatch = job.companyName.toLowerCase().contains(part);
          final locationEn = job.location;
          final locationAr = locationTranslations[locationEn] ?? '';
          final locationMatch = locationEn.toLowerCase().contains(part) || 
                                locationAr.toLowerCase().contains(part);
          
          return titleMatch || companyMatch || locationMatch;
      });

      final matchesType = _filterType == 'All' || job.type == _filterType;
      
      // Smart location match supporting both EN and AR
      bool matchesLocation = _filterLocation == 'All' || _filterLocation == 'الكل';
      if (!matchesLocation) {
        final currentFilterAr = locationTranslations[_filterLocation] ?? _filterLocation;
        final jobLocationAr = locationTranslations[job.location] ?? job.location;
        matchesLocation = job.location == _filterLocation || jobLocationAr == _filterLocation || job.location == currentFilterAr;
      }

      final matchesCategory = _filterCategory == 'All' || job.category == _filterCategory;
      final matchesSalary = _filterSalaryRange == 'All' || job.salaryRange.contains(_filterSalaryRange);

      return matchesQuery && matchesType && matchesLocation && matchesCategory && matchesSalary;
    }).toList();
  }

  void companyPostJob(RecruitmentJob job) {
    _jobs.insert(0, job);
    notifyListeners();
  }

  void toggleSaveJob(String jobId) {
    if (_savedJobIds.contains(jobId)) {
      _savedJobIds.remove(jobId);
    } else {
      _savedJobIds.add(jobId);
    }
    notifyListeners();
  }

  void updateUserProfile({
    required String fullName,
    required String title,
    String? email,
    String? phone,
    String? location,
    String? about,
    String? portfolio,
    List<String>? skills,
    List<Map<String, String>>? education,
    List<Map<String, String>>? experience,
    String? role,
    List<Map<String, String>>? socialLinks,
    String? cvName,
    String? profileImage,
  }) {
    _currentUserName = fullName.trim().isEmpty ? _currentUserName : fullName;
    _currentUserTitle = title.trim().isEmpty ? _currentUserTitle : title;
    if (email != null) _currentUserEmail = email;
    if (phone != null) _currentUserPhone = phone;
    if (location != null) _currentUserLocation = location;
    if (about != null) _currentUserAbout = about;
    if (portfolio != null) _currentUserPortfolio = portfolio;
    if (skills != null) _currentUserSkills = List.from(skills);
    if (education != null) _currentUserEducation = List.from(education);
    if (experience != null) _currentUserExperience = List.from(experience);
    if (cvName != null) _currentUserCvName = cvName;
    if (profileImage != null) _profileImage = profileImage;

    if (role != null && role.isNotEmpty) {
      _userRole = role;
    }
    if (socialLinks != null) {
      _socialLinks = List.from(socialLinks);
    }
    notifyListeners();
  }

  void postServiceRequest({
    required String title,
    required String description,
    required String budget,
  }) {
    _serviceRequests.insert(
      0,
      ServiceRequestPost(
        id: 'sr_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        budget: budget,
        requestedBy: _currentUserName,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateFilters({
    String? searchQuery,
    String? type,
    String? location,
    String? category,
    String? salaryRange,
  }) {
    if (searchQuery != null) {
      _searchQuery = searchQuery;
    }
    if (type != null) {
      _filterType = type;
    }
    if (location != null) {
      _filterLocation = location;
    }
    if (category != null) {
      _filterCategory = category;
    }
    if (salaryRange != null) {
      _filterSalaryRange = salaryRange;
    }
    notifyListeners();
  }

  void userApplyToJob({
    required String jobId,
    required String userName,
  }) {
    final int index = _jobs.indexWhere((RecruitmentJob item) => item.id == jobId);
    if (index < 0) return;
    final RecruitmentJob job = _jobs[index];
    _applications.insert(
      0,
      RecruitmentApplication(
        id: 'app_${DateTime.now().millisecondsSinceEpoch}',
        jobId: job.id,
        jobTitle: job.title,
        companyName: job.companyName,
        userName: userName,
        status: 'Applied',
        updatedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void companyUpdateApplicationStatus({
    required String applicationId,
    required String nextStatus,
  }) {
    final int index = _applications.indexWhere((app) => app.id == applicationId);
    if (index < 0) return;
    _applications[index] = _applications[index].copyWith(
      status: nextStatus,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void companySendMessage(String text) {
    _messages.insert(
      0,
      RecruitmentMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        fromCompany: true,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void replaceFromRemote({
    required List<Map<String, dynamic>> jobs,
    required List<Map<String, dynamic>> applications,
    required List<Map<String, dynamic>> messages,
  }) {
    _jobs.clear();
    _jobs.addAll(jobs.map((item) => RecruitmentJob(
      id: item['id']?.toString() ?? '',
      title: item['title']?.toString() ?? 'Untitled',
      companyName: item['companyName']?.toString() ?? 'Company',
      location: item['location']?.toString() ?? 'Remote',
      salaryRange: item['salaryRange']?.toString() ?? 'Negotiable',
      type: item['type']?.toString() ?? 'Full-time',
      category: item['category']?.toString() ?? 'Technical',
      tags: item['tags'] is List ? (item['tags'] as List).map((e) => e.toString()).toList() : const [],
      publishedAt: DateTime.tryParse(item['createdAt']?.toString() ?? '') ?? DateTime.now(),
    )));
    notifyListeners();
  }
}
