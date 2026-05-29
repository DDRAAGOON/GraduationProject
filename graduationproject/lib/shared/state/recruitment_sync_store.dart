import 'package:flutter/material.dart';

class RecruitmentJob {
  const RecruitmentJob({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
    required this.type,
    required this.status,
    required this.category,
    this.tags = const [],
    required this.publishedAt,
    this.description = '',
    this.responsibilities = const [],
    this.qualifications = const [],
    this.niceToHaves = const [],
    this.benefits = const [],
    this.acceptedCount = 0,
    this.capacity = 1,
    this.logoIcon,
    this.companyLogoUrl,
    this.deadline,
    this.specialTag,
  });

  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;
  final String type;
  final String status;
  final String category;
  final List<String> tags;
  final DateTime publishedAt;
  final String description;
  final List<String> responsibilities;
  final List<String> qualifications;
  final List<String> niceToHaves;
  final List<String> benefits;
  final int acceptedCount;
  final int capacity;
  final IconData? logoIcon;
  final String? companyLogoUrl;
  final TimeOfDay? deadline;
  final String? specialTag;

  factory RecruitmentJob.fromMap(Map<String, dynamic> map) {
    return RecruitmentJob(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      companyName: map['companyName']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      salaryRange: map['salaryRange']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Open',
      category: map['category']?.toString() ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      publishedAt: map['publishedAt'] != null
          ? DateTime.tryParse(map['publishedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      description: map['description']?.toString() ?? '',
      responsibilities: List<String>.from(map['responsibilities'] ?? []),
      qualifications: List<String>.from(map['qualifications'] ?? []),
      niceToHaves: List<String>.from(map['niceToHaves'] ?? []),
      benefits: List<String>.from(map['benefits'] ?? []),
      acceptedCount: int.tryParse(map['acceptedCount']?.toString() ?? '0') ?? 0,
      capacity: int.tryParse(map['requiredCount']?.toString() ?? '1') ?? 1,
      companyLogoUrl: map['companyLogoUrl']?.toString(),
    );
  }
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
    this.gender,
    this.birthDate,
    this.languages = const [],
    this.about,
    this.experienceYears = 0,
    this.education,
    this.skills = const [],
    this.hasCv = false,
    this.email,
    this.phone,
    this.location,
  });

  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String userName;
  final String status;
  final DateTime updatedAt;
  final String? gender;
  final String? birthDate;
  final List<String> languages;
  final String? about;
  final int experienceYears;
  final String? education;
  final List<String> skills;
  final bool hasCv;
  final String? email;
  final String? phone;
  final String? location;

  RecruitmentApplication copyWith({String? status, DateTime? updatedAt}) {
    return RecruitmentApplication(
      id: id,
      jobId: jobId,
      jobTitle: jobTitle,
      companyName: companyName,
      userName: userName,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      gender: gender,
      birthDate: birthDate,
      languages: languages,
      about: about,
      experienceYears: experienceYears,
      education: education,
      skills: skills,
      hasCv: hasCv,
      email: email,
      phone: phone,
      location: location,
    );
  }

  factory RecruitmentApplication.fromMap(Map<String, dynamic> map) {
    return RecruitmentApplication(
      id: map['id']?.toString() ?? '',
      jobId: map['jobId']?.toString() ?? '',
      jobTitle: map['jobTitle']?.toString() ?? '',
      companyName: map['companyName']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Pending',
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      email: map['email']?.toString(),
      phone: map['phone']?.toString(),
      location: map['location']?.toString(),
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

  factory RecruitmentMessage.fromMap(Map<String, dynamic> map) {
    return RecruitmentMessage(
      id: map['id']?.toString() ?? '',
      fromCompany: map['fromCompany'] == true,
      text: map['text']?.toString() ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class ChatThread {
  final String name;
  final String image;
  String lastMessage;
  String time;
  ChatThread({
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.time,
  });
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
  RecruitmentSyncStore._() {
    _addInitialMockJobs();
  }
  static final RecruitmentSyncStore instance = RecruitmentSyncStore._();

  static const List<String> categories = [
    'All',
    'Technical',
    'Non-Technical',
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

  final List<RecruitmentJob> _jobs = <RecruitmentJob>[];
  final List<RecruitmentApplication> _applications = <RecruitmentApplication>[];
  final List<RecruitmentMessage> _messages = <RecruitmentMessage>[];
  final List<ChatThread> _tradesmanChatThreads = <ChatThread>[];
  final Set<String> _savedJobIds = <String>{};
  final List<ServiceRequestPost> _serviceRequests = <ServiceRequestPost>[];

  String _currentUserName = 'User';
  String _currentUserEmail = '';
  String _currentUserPhone = '';
  String _currentUserLocation = '';
  String _currentUserAbout = '';
  String _currentUserTitle = '';
  String _userRole = 'Job Seeker';
  String? _profileImage;
  String _searchQuery = '';
  String _filterType = 'All';
  String _filterLocation = 'All';
  String _filterCategory = 'All';
  String _filterSalaryRange = 'All';

  List<String> _currentUserSkills = [];
  List<Map<String, String>> _currentUserEducation = [];
  List<Map<String, String>> _currentUserExperience = [];
  List<Map<String, String>> _socialLinks = [];
  List<String> _portfolioImages = [];

  List<RecruitmentJob> get jobs => List.unmodifiable(_jobs);
  List<RecruitmentApplication> get applications =>
      List.unmodifiable(_applications);
  List<RecruitmentMessage> get messages => List.unmodifiable(_messages);
  List<ChatThread> get tradesmanChatThreads =>
      List.unmodifiable(_tradesmanChatThreads);
  Set<String> get savedJobIds => Set.unmodifiable(_savedJobIds);
  List<ServiceRequestPost> get serviceRequests =>
      List.unmodifiable(_serviceRequests);

  String get currentUserName => _currentUserName;
  String get currentUserEmail => _currentUserEmail;
  String get currentUserPhone => _currentUserPhone;
  String get currentUserLocation => _currentUserLocation;
  String get currentUserAbout => _currentUserAbout;
  String get currentUserTitle => _currentUserTitle;
  String get userRole => _userRole;
  String? get profileImage => _profileImage;
  String get filterType => _filterType;
  String get filterLocation => _filterLocation;
  String get filterCategory => _filterCategory;
  String get filterSalaryRange => _filterSalaryRange;

  List<String> get currentUserSkills => _currentUserSkills;
  List<Map<String, String>> get currentUserEducation => _currentUserEducation;
  List<Map<String, String>> get currentUserExperience => _currentUserExperience;
  List<Map<String, String>> get socialLinks => _socialLinks;
  List<String> get portfolioImages => _portfolioImages;

  List<RecruitmentJob> get savedJobs =>
      _jobs.where((item) => _savedJobIds.contains(item.id)).toList();

  List<RecruitmentJob> get filteredJobs {
    final query = _searchQuery.toLowerCase();
    return _jobs.where((job) {
      final matchesQuery =
          query.isEmpty ||
          job.title.toLowerCase().contains(query) ||
          job.companyName.toLowerCase().contains(query);
      final matchesLocation =
          _filterLocation == 'All' ||
          job.location.toLowerCase() == _filterLocation.toLowerCase();
      final matchesCategory =
          _filterCategory == 'All' ||
          job.category.toLowerCase() == _filterCategory.toLowerCase();
      final matchesType =
          _filterType == 'All' ||
          job.type.toLowerCase() == _filterType.toLowerCase();
      final matchesSalary =
          _filterSalaryRange == 'All' ||
          job.salaryRange.toLowerCase() == _filterSalaryRange.toLowerCase();
      return matchesQuery &&
          matchesLocation &&
          matchesCategory &&
          matchesType &&
          matchesSalary;
    }).toList();
  }

  void updateFilters({
    String? type,
    String? category,
    String? salaryRange,
    String? location,
    String? searchQuery,
  }) {
    if (type != null) _filterType = type;
    if (category != null) _filterCategory = category;
    if (salaryRange != null) _filterSalaryRange = salaryRange;
    if (location != null) _filterLocation = location;
    if (searchQuery != null) _searchQuery = searchQuery;
    notifyListeners();
  }

  void applyToJob(RecruitmentJob job) {
    final alreadyApplied = _applications.any((a) => a.jobId == job.id);
    if (!alreadyApplied) {
      final newApp = RecruitmentApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        jobId: job.id,
        jobTitle: job.title,
        companyName: job.companyName,
        userName: _currentUserName,
        status: 'Pending',
        updatedAt: DateTime.now(),
      );
      _applications.add(newApp);
      notifyListeners();
    }
  }

  void acceptJobOffer(String applicationId) {
    final idx = _applications.indexWhere((a) => a.id == applicationId);
    if (idx != -1) {
      _applications[idx] = _applications[idx].copyWith(
        status: 'Accepted',
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void replaceFromRemote({
    required List<dynamic> jobs,
    required List<dynamic> applications,
    required List<dynamic> messages,
  }) {
    _jobs.clear();
    for (final item in jobs) {
      if (item is Map<String, dynamic>) _jobs.add(RecruitmentJob.fromMap(item));
    }
    _applications.clear();
    for (final item in applications) {
      if (item is Map<String, dynamic>)
        _applications.add(RecruitmentApplication.fromMap(item));
    }
    _messages.clear();
    for (final item in messages) {
      if (item is Map<String, dynamic>)
        _messages.add(RecruitmentMessage.fromMap(item));
    }
    notifyListeners();
  }

  void companyUpdateApplicationStatus({
    required String applicationId,
    required String nextStatus,
  }) {
    final idx = _applications.indexWhere((a) => a.id == applicationId);
    if (idx != -1) {
      _applications[idx] = _applications[idx].copyWith(
        status: nextStatus,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void removeApplication(String applicationId) {
    _applications.removeWhere((app) => app.id == applicationId);
    notifyListeners();
  }

  void removeJob(String jobId) {
    _jobs.removeWhere((j) => j.id == jobId);
    _savedJobIds.remove(jobId);
    notifyListeners();
  }

  void companySendMessage(String text) {
    final newMessage = RecruitmentMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromCompany: true,
      text: text,
      createdAt: DateTime.now(),
    );
    _messages.add(newMessage);
    notifyListeners();
  }

  void _addInitialMockJobs() {
    _jobs.addAll([
      RecruitmentJob(
        id: 'nexora_be',
        title: 'مطور Back-End مسؤول عن بناء وإدارة قواعد البيانات',
        companyName: 'Nexora Solutions',
        location: 'Remote',
        salaryRange: 'Negotiable',
        type: 'Remote',
        status: 'Open',
        category: 'Technical',
        specialTag: 'هندسة',
        publishedAt: DateTime.now(),
        logoIcon: Icons.account_tree_rounded,
        description: 'بناء وصيانة قواعد البيانات والعمليات البرمجية الخلفية.',
        responsibilities: ['بناء الـ API', 'إدارة قواعد البيانات'],
        qualifications: ['خبرة في Node.js', 'خبرة في SQL'],
        niceToHaves: ['خبرة في AWS'],
      ),
      RecruitmentJob(
        id: 'nexora_fe',
        title: 'مطور واجهات أمامية (Front-End Developer) لتطوير مواقع ويب',
        companyName: 'Nexora Solutions',
        location: 'Remote',
        salaryRange: 'Negotiable',
        type: 'Full-time / Remote',
        status: 'Open',
        category: 'Technical',
        specialTag: 'برمجة',
        publishedAt: DateTime.now(),
        logoIcon: Icons.account_tree_rounded,
        description: 'تطوير واجهات المستخدم باستخدام أحدث التقنيات.',
        responsibilities: ['تحويل التصاميم إلى كود', 'تحسين الأداء'],
        qualifications: ['خبرة في React أو Flutter Web'],
      ),
      RecruitmentJob(
        id: 'nexora_cs',
        title: 'موظف خدمة عملاء للرد على استفسارات العملاء',
        companyName: 'Nexora Solutions',
        location: 'Remote',
        salaryRange: 'Negotiable',
        type: 'Remote',
        status: 'Open',
        category: 'Non-Technical',
        specialTag: 'عام',
        publishedAt: DateTime.now(),
        logoIcon: Icons.account_tree_rounded,
        description: 'الرد على استفسارات العملاء وتقديم الدعم الفني.',
        responsibilities: ['الرد على المكالمات', 'متابعة الشكاوى'],
      ),
      RecruitmentJob(
        id: 'nexora_clean',
        title: 'عامل نظافة وخدمات مساعدة للمباني',
        companyName: 'Nexora Solutions',
        location: 'Remote',
        salaryRange: 'Negotiable',
        type: 'دوام جزئي',
        status: 'Open',
        category: 'Service',
        specialTag: 'عام',
        publishedAt: DateTime.now(),
        logoIcon: Icons.account_tree_rounded,
        description: 'المحافظة على نظافة المباني وتقديم الخدمات المساعدة.',
      ),
      RecruitmentJob(
        id: 'mock_t1',
        title: 'سباك محترف لتأسيس فيلا',
        companyName: 'المارودي للمقاولات',
        location: 'Cairo',
        salaryRange: 'Negotiable',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Plumbing'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        logoIcon: Icons.plumbing,
      ),
      RecruitmentJob(
        id: 'mock_tech1',
        title: 'Senior Flutter Developer',
        companyName: 'Tech Solutions',
        location: 'Cairo',
        salaryRange: '30k - 45k',
        type: 'Full-time',
        status: 'Open',
        category: 'Technical',
        tags: ['Flutter', 'Dart'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  void toggleSaveJob(String jobId) {
    if (_savedJobIds.contains(jobId)) {
      _savedJobIds.remove(jobId);
    } else {
      _savedJobIds.add(jobId);
    }
    notifyListeners();
  }

  void updateCurrentUser({
    String? name,
    String? email,
    String? phone,
    String? location,
    String? photoUrl,
  }) {
    if (name != null) _currentUserName = name;
    if (email != null) _currentUserEmail = email;
    if (phone != null) _currentUserPhone = phone;
    if (location != null) _currentUserLocation = location;
    if (photoUrl != null) _profileImage = photoUrl;
    notifyListeners();
  }

  void updateUserProfile({
    required String fullName,
    required String title,
    String? email,
    String? phone,
    String? location,
    String? about,
    List<String>? skills,
    List<Map<String, String>>? education,
    List<Map<String, String>>? experience,
    List<Map<String, String>>? socialLinks,
    String? role,
    List<String>? portfolioImages,
  }) {
    _currentUserName = fullName;
    _currentUserTitle = title;
    if (email != null) _currentUserEmail = email;
    if (phone != null) _currentUserPhone = phone;
    if (location != null) _currentUserLocation = location;
    if (about != null) _currentUserAbout = about;
    if (skills != null) _currentUserSkills = skills;
    if (education != null) _currentUserEducation = education;
    if (experience != null) _currentUserExperience = experience;
    if (socialLinks != null) _socialLinks = socialLinks;
    if (role != null) _userRole = role;
    if (portfolioImages != null) _portfolioImages = portfolioImages;
    notifyListeners();
  }
}
