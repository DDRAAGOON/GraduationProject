import 'dart:math';

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

class PendingTradesmanRating {
  PendingTradesmanRating({
    required this.personName,
    required this.applicationId,
    required this.showAt,
  });

  final String personName;
  final String applicationId;
  final DateTime showAt;
}

class TradesmanRatingEntry {
  const TradesmanRatingEntry({
    required this.personName,
    required this.rating,
    required this.comment,
    required this.date,
    this.subtitle,
  });

  final String personName;
  final double rating;
  final String comment;
  final DateTime date;
  final String? subtitle;
}

class TradesmanPostedWorkRow {
  const TradesmanPostedWorkRow({
    required this.id,
    required this.title,
    required this.rate,
    required this.status,
    required this.applicantsCount,
    required this.postedAt,
  });

  final String id;
  final String title;
  final String rate;
  final String status;
  final int applicantsCount;
  final DateTime postedAt;
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
    _seedTradesmanRatingsPreview();
  }

  void _seedTradesmanRatingsPreview() {
    if (_ratingsFromClients.isNotEmpty) return;
    _ratingsFromClients.addAll([
      TradesmanRatingEntry(
        personName: 'أحمد المصري',
        rating: 4.8,
        comment: 'شغل ممتاز وفي الميعاد.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        subtitle: 'عميل',
      ),
      TradesmanRatingEntry(
        personName: 'منى حسن',
        rating: 4.5,
        comment: 'محترف ومتعاون جداً.',
        date: DateTime.now().subtract(const Duration(days: 8)),
        subtitle: 'عميل',
      ),
    ]);
    _ratingsGivenByTradesman.addAll([
      TradesmanRatingEntry(
        personName: 'يوسف عبد الله',
        rating: 5,
        comment: 'تعامل محترم ووصف واضح للمشكلة.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        subtitle: 'طالب خدمة',
      ),
      TradesmanRatingEntry(
        personName: 'سارة علي',
        rating: 4,
        comment: 'التزام جيد بالمواعيد.',
        date: DateTime.now().subtract(const Duration(days: 6)),
        subtitle: 'طالب خدمة',
      ),
    ]);
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
  final List<PendingTradesmanRating> _pendingTradesmanRatings =
      <PendingTradesmanRating>[];
  final Map<String, String> _tradesmanJobStatusOverrides = <String, String>{};

  String? _backgroundImage;
  String _birthDate = '';
  String _gender = '';
  String _governorate = '';
  String _district = '';
  List<String> _languages = <String>[];
  List<String> _tradesmanServices = <String>[];
  final List<TradesmanRatingEntry> _ratingsFromClients =
      <TradesmanRatingEntry>[];
  final List<TradesmanRatingEntry> _ratingsGivenByTradesman =
      <TradesmanRatingEntry>[];
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
  List<PendingTradesmanRating> get pendingTradesmanRatings =>
      List.unmodifiable(_pendingTradesmanRatings);
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
  String? get backgroundImage => _backgroundImage;
  String get birthDate => _birthDate;
  String get gender => _gender;
  String get governorate => _governorate;
  String get district => _district;
  List<String> get languages => _languages;
  List<String> get tradesmanServices => _tradesmanServices;
  List<TradesmanRatingEntry> get ratingsFromClients =>
      List.unmodifiable(_ratingsFromClients);
  List<TradesmanRatingEntry> get ratingsGivenByTradesman =>
      List.unmodifiable(_ratingsGivenByTradesman);

  static const Map<String, List<String>> tradesmanGovernorateAreas = {
    'القاهرة': ['عين شمس', 'مدينة نصر', 'المعادي', 'مصر الجديدة', 'حلوان'],
    'الجيزة': ['الدقي', 'المهندسين', 'الهرم', '6 أكتوبر', 'فيصل'],
    'الإسكندرية': ['سيدي جابر', 'سموحة', 'المندرة', 'ميامي'],
    'القليوبية': ['شبرا الخيمة', 'الخانكة', 'بنها'],
  };

  static const List<String> tradesmanDefaultServices = [
    'نجار',
    'فني تكييف',
    'كهربائي',
    'سباك',
    'دهان',
  ];

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
      final jobCat = job.category.toLowerCase();
      final filterCat = _filterCategory.toLowerCase();
      final matchesCategory =
          _filterCategory == 'All' ||
          jobCat == filterCat ||
          (filterCat == 'service' &&
              (jobCat == 'service' || jobCat == 'tradesman'));
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

  void applyToJob(
    RecruitmentJob job, {
    String? about,
    String? location,
    String? email,
    String? phone,
    bool hasCv = false,
  }) {
    final alreadyApplied = _applications.any((a) => a.jobId == job.id);
    if (!alreadyApplied) {
      final newApp = RecruitmentApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        jobId: job.id,
        jobTitle: job.title,
        companyName: job.companyName,
        userName: _currentUserName,
        status: 'Applied',
        updatedAt: DateTime.now(),
        about: about,
        location: location,
        email: email ?? _currentUserEmail,
        phone: phone ?? _currentUserPhone,
        hasCv: hasCv,
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
      if (item is Map<String, dynamic>) {
        final newJob = RecruitmentJob.fromMap(item);
        _jobs.add(newJob);
      }
    }
    
    // Always ensure mock jobs are present for the demo
    _addInitialMockJobs();
    
    // Remove duplicates by ID (keeping the first one found, usually the remote one if it exists)
    final ids = <String>{};
    _jobs.retainWhere((j) => ids.add(j.id));

    _applications.clear();
    for (final item in applications) {
      if (item is Map<String, dynamic>) {
        _applications.add(RecruitmentApplication.fromMap(item));
      }
    }
    _messages.clear();
    for (final item in messages) {
      if (item is Map<String, dynamic>) {
        _messages.add(RecruitmentMessage.fromMap(item));
      }
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

  void upsertTradesmanChatThread({
    required String name,
    required String image,
    required String lastMessage,
    String? time,
  }) {
    final now = time ?? _formatChatTime(DateTime.now());
    final index = _tradesmanChatThreads.indexWhere((t) => t.name == name);
    if (index >= 0) {
      _tradesmanChatThreads[index].lastMessage = lastMessage;
      _tradesmanChatThreads[index].time = now;
      final thread = _tradesmanChatThreads.removeAt(index);
      _tradesmanChatThreads.insert(0, thread);
    } else {
      _tradesmanChatThreads.insert(
        0,
        ChatThread(
          name: name,
          image: image,
          lastMessage: lastMessage,
          time: now,
        ),
      );
    }
    notifyListeners();
  }

  String _formatChatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final h12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    return '$h12:$minute $period';
  }

  void scheduleTradesmanRatingPrompt({
    required String personName,
    required String applicationId,
  }) {
    _pendingTradesmanRatings.removeWhere(
      (r) => r.applicationId == applicationId,
    );
    final random = Random();
    final maxSeconds = 24 * 60 * 60;
    final randomSeconds = max(8, random.nextInt(maxSeconds));
    final showAt = DateTime.now().add(Duration(seconds: randomSeconds));
    _pendingTradesmanRatings.add(
      PendingTradesmanRating(
        personName: personName,
        applicationId: applicationId,
        showAt: showAt,
      ),
    );
    notifyListeners();
  }

  PendingTradesmanRating? consumeDueTradesmanRating() {
    final now = DateTime.now();
    final index = _pendingTradesmanRatings.indexWhere(
      (r) => !r.showAt.isAfter(now),
    );
    if (index == -1) return null;
    final rating = _pendingTradesmanRatings.removeAt(index);
    notifyListeners();
    return rating;
  }

  List<TradesmanPostedWorkRow> getTradesmanPostedWorksPreview({
    bool isAr = true,
  }) {
    return [
      TradesmanPostedWorkRow(
        id: 'mock-work-1',
        title: isAr ? 'إصلاح تسريب مياه' : 'Water leak repair',
        rate: '4.8',
        status: isAr ? 'نشط' : 'Active',
        applicantsCount: 5,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TradesmanPostedWorkRow(
        id: 'mock-work-2',
        title: isAr ? 'تركيب تكييف' : 'AC installation',
        rate: '4.5',
        status: isAr ? 'قيد المراجعة' : 'In review',
        applicantsCount: 3,
        postedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      TradesmanPostedWorkRow(
        id: 'mock-work-3',
        title: isAr ? 'صيانة كهرباء منزلية' : 'Home electrical maintenance',
        rate: '4.9',
        status: isAr ? 'مكتمل' : 'Completed',
        applicantsCount: 8,
        postedAt: DateTime.now().subtract(const Duration(days: 9)),
      ),
      TradesmanPostedWorkRow(
        id: 'mock-work-4',
        title: isAr ? 'دهان غرفة معيشة' : 'Living room painting',
        rate: '4.2',
        status: isAr ? 'نشط' : 'Active',
        applicantsCount: 2,
        postedAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      TradesmanPostedWorkRow(
        id: 'mock-work-5',
        title: isAr ? 'عزل حمامات ومطابخ' : 'Kitchen and bathroom insulation',
        rate: '4.7',
        status: isAr ? 'نشط' : 'Active',
        applicantsCount: 4,
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TradesmanPostedWorkRow(
        id: 'mock-work-6',
        title: isAr ? 'تركيب نجف وإضاءة حديثة' : 'Chandelier and modern lighting installation',
        rate: '4.9',
        status: isAr ? 'مكتمل' : 'Completed',
        applicantsCount: 12,
        postedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  void _addInitialMockJobs() {
    _jobs.addAll([
      // ========== وظائف الصنايعية (Tradesman) ==========
      RecruitmentJob(
        id: 'trade_plumber_1',
        title: 'سباك محترف لتأسيس فيلا',
        companyName: 'المارودي للمقاولات',
        location: 'Cairo',
        salaryRange: '5000 - 8000 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Plumbing', 'تأسيس'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        logoIcon: Icons.plumbing,
        description:
            'مطلوب سباك محترف لتأسيس سباكة فيلا جديدة بالكامل - مواسير تغذية وصرف صحي.',
        responsibilities: [
          'تأسيس مواسير المياه الساخنة والباردة',
          'تركيب سخانات وخلاطات',
          'تمديد مواسير الصرف الصحي',
        ],
        qualifications: ['خبرة 5 سنوات على الأقل', 'معرفة بجودة الخامات'],
        acceptedCount: 3,
        capacity: 8,
        specialTag: 'مطلوب urgently',
      ),
      RecruitmentJob(
        id: 'trade_electrician_1',
        title: 'كهربائي منازل لتمديد أسلاك فيلا',
        companyName: 'مؤسسة النور للكهرباء',
        location: 'Giza',
        salaryRange: '4000 - 6000 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Electrical', 'تمديدات'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        logoIcon: Icons.electrical_services,
        description:
            'مطلوب كهربائي ذو خبرة لتمديد الأسلاك الكهربائية وتركيب اللوحات والفيش في فيلا بالدقي.',
        responsibilities: [
          'تمديد الأسلاك داخل الجدران',
          'تركيب اللوحات الكهربائية والفيش واللمبات',
          'اختبار الدوائر والتأكد من السلامة',
        ],
        qualifications: ['خبرة 7 سنوات', 'شهادة مزاولة مهنة'],
        acceptedCount: 5,
        capacity: 10,
        specialTag: 'خبرة',
      ),
      RecruitmentJob(
        id: 'trade_carpenter_1',
        title: 'نجار كبس لتركيب غرف نوم ومطابخ',
        companyName: 'معرض الأثاث العصري',
        location: 'Alexandria',
        salaryRange: '6000 - 9000 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Carpentry', 'أثاث'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        logoIcon: Icons.handyman,
        description:
            'مطلوب نجار كبس محترف لتركيب غرف نوم ومطابخ وأثاث مكتبي لشقة جديدة.',
        responsibilities: [
          'تركيب غرف النوم والمطابخ',
          'فك وتركيب الأثاث في الموقع',
          'تعديل المقاسات حسب المساحات المتاحة',
        ],
        qualifications: ['خبرة 3 سنوات في الكبس', 'امتلاك أدوات العمل'],
        acceptedCount: 2,
        capacity: 5,
        specialTag: 'محترف',
      ),
      RecruitmentJob(
        id: 'trade_painter_1',
        title: 'دهان ديكورات وشقق سكنية',
        companyName: 'شركة الألوان الذهبية',
        location: 'Cairo',
        salaryRange: '3500 - 5500 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Painting', 'ديكور'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        logoIcon: Icons.format_paint,
        description:
            'نحتاج دهان ديكورات داخلي لشقة 200 متر مربع - دهانات عادية وإسباني وجرافياتو.',
        responsibilities: [
          'دهان الحوائط والأسقف',
          'تنفيذ ديكورات جرافياتو وإسباني',
          'تهيئة الجدران قبل الدهان',
        ],
        qualifications: ['خبرة 4 سنوات', 'معرفة بأنواع الدهانات'],
        acceptedCount: 6,
        capacity: 12,
        specialTag: 'ديكورات',
      ),
      RecruitmentJob(
        id: 'trade_ac_1',
        title: 'فني تكييف وتبريد للصيانة والتركيب',
        companyName: 'مجموعة تكييف مصر',
        location: 'Giza',
        salaryRange: '4500 - 7000 ج.م',
        type: 'دوام كامل',
        status: 'Open',
        category: 'Tradesman',
        tags: ['AC', 'تكييف'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        logoIcon: Icons.ac_unit,
        description:
            'مطلوب فني تكييف متخصص لتركيب وصيانة أجهزة التكييف السبلت والمركزي لشركة كبرى.',
        responsibilities: [
          'تركيب وحدات التكييف السبلت',
          'صيانة وإصلاح أعطال التبريد',
          'فحص ضغط الفريون وتنظيف الفلاتر',
        ],
        qualifications: ['خبرة 3 سنوات', 'رخصة قيادة'],
        acceptedCount: 4,
        capacity: 7,
        specialTag: 'دوام كامل',
      ),
      RecruitmentJob(
        id: 'trade_tiler_1',
        title: 'سيراميك وبلاط محترف لتركيب وتوريد',
        companyName: 'مكتب السعدني للمقاولات',
        location: 'Cairo',
        salaryRange: '5500 - 8000 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Tiling', 'سيراميك'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        logoIcon: Icons.grid_view,
        description:
            'مطلوب فني سيراميك وبلاط لتركيب سيراميك أرضيات وحوائط وجميع أنحاء فيلا كبيرة.',
        responsibilities: [
          'تركيب سيراميك الأرضيات والحوائط',
          'قص البورسلين والجرانيت',
          'تسوية الأرضيات وعزل الحمامات',
        ],
        qualifications: ['خبرة 6 سنوات', 'دقة في القياس'],
        acceptedCount: 1,
        capacity: 4,
        specialTag: 'دقة عالية',
      ),
      RecruitmentJob(
        id: 'trade_welder_1',
        title: 'حداد ولحام كريتال وأبواب حديد',
        companyName: 'ورشة ابو العز للحدادة',
        location: 'Alexandria',
        salaryRange: '5000 - 7500 ج.م',
        type: 'دوام كامل',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Welding', 'حدادة'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        logoIcon: Icons.fireplace,
        description:
            'نبحث عن حداد كريتال ولحام لعمل أبواب وشبابيك حديد في مشروع تجاري كبير.',
        responsibilities: [
          'لحام الحديد والاستانلس',
          'تصنيع أبواب وشبابيك كريتال',
          'دهان وتجهيز المنتجات النهائية',
        ],
        qualifications: ['خبرة 5 سنوات', 'معرفة باللحام الكهربائي'],
        acceptedCount: 8,
        capacity: 15,
        specialTag: 'مشروع كبير',
      ),
      RecruitmentJob(
        id: 'trade_plaster_1',
        title: 'مبيض محارة للتشطيب الداخلي',
        companyName: 'مقاولات التشطيب السريع',
        location: 'Cairo',
        salaryRange: '4000 - 6000 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Plaster', 'محارة'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        logoIcon: Icons.brush,
        description:
            'مطلوب مبيض محارة لإنهاء تشطيب شقتين في مدينة نصر - محارة حوائط وأسقف.',
        responsibilities: [
          'بياض محارة للحوائط والأسقف',
          'تسوية الزوايا والبروز',
          'تحضير السطح للدهان',
        ],
        qualifications: ['خبرة 4 سنوات', 'سرعة في الإنجاز'],
        acceptedCount: 3,
        capacity: 6,
        specialTag: 'مشروعين',
      ),
      RecruitmentJob(
        id: 'trade_marble_1',
        title: 'فني رخام وجرانيت للواجهات',
        companyName: 'شركة الجرانيت الملكي',
        location: 'Giza',
        salaryRange: '7000 - 10000 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Marble', 'Granite', 'رخام'],
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        logoIcon: Icons.diamond,
        description:
            'نحن بصدد تنفيذ واجهة فيلا بالرخام والجرانيت - نبحث عن فني تركيب متخصص.',
        responsibilities: [
          'تركيب ألواح الرخام والجرانيت',
          'تقطيع وتشطيب الأحجار',
          'تثبيت الواجهات بالطريقة الصحيحة',
        ],
        qualifications: ['خبرة 8 سنوات', 'فريق عمل متكامل'],
        acceptedCount: 2,
        capacity: 5,
        specialTag: 'فاخر',
      ),
      RecruitmentJob(
        id: 'trade_glass_1',
        title: 'فني زجاج وواجهات الوميتال',
        companyName: 'شركة الألمنيوم الحديث',
        location: 'Cairo',
        salaryRange: '4500 - 6500 ج.م',
        type: 'دوام كامل',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Glass', 'Aluminum', 'زجاج'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        logoIcon: Icons.window,
        description:
            'مطلوب فني زجاج وألوميتال لتركيب واجهات زجاجية وشبابيك ألوميتال لمشروع تجاري ضخم.',
        responsibilities: [
          'تركيب واجهات الألوميتال والزجاج',
          'تثبيت زجاج السيكوريت',
          'تشطيب الواجهات بدقة',
        ],
        qualifications: ['خبرة 5 سنوات', 'معرفة بمقاسات الألوميتال'],
        acceptedCount: 6,
        capacity: 10,
        specialTag: 'مشروع تجاري',
      ),

      // ========== وظائف الخدمة (Service/Tradesman for TechnicalScreen) ==========
      RecruitmentJob(
        id: 'service_plumber_2',
        title: 'سباك لإصلاح أعطال طارئة وتسريبات',
        companyName: 'الشركة المصرية للصيانة',
        location: 'Cairo',
        salaryRange: 'Negotiable',
        type: 'One-time',
        status: 'Open',
        category: 'Service',
        tags: ['Plumbing', 'صيانة'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        logoIcon: Icons.plumbing,
        description: 'مطلوب سباك فوراً لإصلاح مجموعة من التسريبات في عقار سكني.',
        responsibilities: ['إصلاح التسريبات', 'تغيير المحابس'],
        qualifications: ['خبرة سابقة في أعمال الصيانة السريعة'],
        capacity: 2,
      ),
      RecruitmentJob(
        id: 'service_electrician_2',
        title: 'فني كهرباء لتركيب لوحة مفاتيح رئيسية',
        companyName: 'نور المستقبل للكهرباء',
        location: 'Giza',
        salaryRange: 'Negotiable',
        type: 'One-time',
        status: 'Open',
        category: 'Service',
        tags: ['Electrical', 'تركيبات'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        logoIcon: Icons.electrical_services,
        description: 'نبحث عن كهربائي محترف لتركيب وتوصيل لوحة المفاتيح الرئيسية لمحل تجاري.',
        responsibilities: ['توصيل الكابلات', 'اختبار اللوحة'],
        qualifications: ['دقة عالية في العمل'],
        capacity: 1,
      ),
      RecruitmentJob(
        id: 'service_painter_2',
        title: 'نقاش لدهان شقة مساحة صغيرة (70 متر)',
        companyName: 'لمسات فنية للديكور',
        location: 'Alexandria',
        salaryRange: '3000 - 5000 ج.م',
        type: 'One-time',
        status: 'Open',
        category: 'Service',
        tags: ['Painting', 'نقاشة'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        logoIcon: Icons.format_paint,
        description: 'مطلوب نقاش لدهان شقة سكنية صغيرة - وشين نظافة ومعالجة شروخ بسيطة.',
        responsibilities: ['معالجة الحوائط', 'الدهان'],
        capacity: 1,
      ),

      // ========== وظائف Technical ==========
      RecruitmentJob(
        id: 'tech_flutter_1',
        title: 'مطور تطبيقات Flutter (Junior/Mid)',
        companyName: 'إبداع للبرمجيات',
        location: 'Cairo',
        salaryRange: '15k - 25k',
        type: 'Full-time',
        status: 'Open',
        category: 'Technical',
        tags: ['Flutter', 'Dart', 'Mobile'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        logoIcon: Icons.smartphone,
        description: 'مطلوب مطور فلاتر للعمل على تطبيقات التجارة الإلكترونية.',
        responsibilities: ['تطوير واجهات المستخدم', 'ربط الـ APIs'],
        qualifications: ['خبرة سنة على الأقل', 'معرفة بـ Bloc أو Riverpod'],
        capacity: 2,
      ),
      RecruitmentJob(
        id: 'tech_ui_ux_1',
        title: 'مصمم واجهات مستخدم (UI/UX Designer)',
        companyName: 'وكالة بيكسل الرقمية',
        location: 'Remote',
        salaryRange: 'Negotiable',
        type: 'Remote',
        status: 'Open',
        category: 'Technical',
        tags: ['UI', 'UX', 'Figma'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        logoIcon: Icons.design_services,
        description: 'تصميم تجربة مستخدم مميزة لمواقع الويب وتطبيقات الجوال.',
        responsibilities: ['رسم النماذج الأولية', 'إجراء بحوث المستخدم'],
        capacity: 1,
      ),
      RecruitmentJob(
        id: 'tech_devops_1',
        title: 'مهندس DevOps لإدارة السحابة',
        companyName: 'سحاب مصر للتكنولوجيا',
        location: 'Giza',
        salaryRange: '30k - 45k',
        type: 'Full-time',
        status: 'Open',
        category: 'Technical',
        tags: ['DevOps', 'AWS', 'Docker'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        logoIcon: Icons.cloud_done,
        description: 'إدارة البنية التحتية السحابية وتحسين عمليات النشر التلقائي.',
        capacity: 1,
      ),

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
        id: 'non_tech_hr_1',
        title: 'أخصائي موارد بشرية (HR Specialist)',
        companyName: 'مجموعة الفطيم',
        location: 'Cairo',
        salaryRange: '10k - 15k',
        type: 'Full-time',
        status: 'Open',
        category: 'Non-Technical',
        tags: ['HR', 'Recruitment'],
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        logoIcon: Icons.people,
        description: 'إدارة عمليات التوظيف وشؤون الموظفين.',
        capacity: 1,
      ),
      RecruitmentJob(
        id: 'non_tech_sales_1',
        title: 'مندوب مبيعات عقارية',
        companyName: 'إعمار العقارية',
        location: 'New Cairo',
        salaryRange: 'Negotiable',
        type: 'Full-time',
        status: 'Open',
        category: 'Non-Technical',
        tags: ['Sales', 'Real Estate'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
        logoIcon: Icons.sell,
        description: 'بيع الوحدات السكنية والتجارية في المشاريع الجديدة.',
        capacity: 5,
      ),
      RecruitmentJob(
        id: 'gen_driver_1',
        title: 'سائق خاص رخصة درجة أولى',
        companyName: 'شركة النقل السريع',
        location: 'Cairo',
        salaryRange: '6000 - 8000 ج.م',
        type: 'Full-time',
        status: 'Open',
        category: 'Service',
        tags: ['Driving', 'سواقة'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        logoIcon: Icons.drive_eta,
        description: 'مطلوب سائق خاص ذو خبرة بالقاهرة والجيزة والمناطق الحيوية.',
        capacity: 2,
      ),
      RecruitmentJob(
        id: 'gen_security_1',
        title: 'أفراد أمن لمول تجاري',
        companyName: 'فالكون للأمن',
        location: 'Giza',
        salaryRange: '4000 - 5000 ج.م',
        type: 'Full-time',
        status: 'Open',
        category: 'Service',
        tags: ['Security', 'أمن'],
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        logoIcon: Icons.security,
        description: 'مطلوب أفراد أمن للعمل بمول تجاري بمدينة 6 أكتوبر.',
        capacity: 10,
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
    String? backgroundImage,
    String? birthDate,
    String? gender,
    String? governorate,
    String? district,
    List<String>? languages,
    List<String>? tradesmanServices,
    String? profileImage,
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
    if (backgroundImage != null) _backgroundImage = backgroundImage;
    if (birthDate != null) _birthDate = birthDate;
    if (gender != null) _gender = gender;
    if (governorate != null) _governorate = governorate;
    if (district != null) _district = district;
    if (languages != null) _languages = languages;
    if (tradesmanServices != null) _tradesmanServices = tradesmanServices;
    if (profileImage != null) _profileImage = profileImage;
    notifyListeners();
  }

  String tradesmanJobStatus(String jobId, String fallback) {
    return _tradesmanJobStatusOverrides[jobId] ?? fallback;
  }

  void setTradesmanJobStatus(String jobId, String status) {
    _tradesmanJobStatusOverrides[jobId] = status;
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index != -1) {
      final old = _jobs[index];
      _jobs[index] = RecruitmentJob(
        id: old.id,
        title: old.title,
        companyName: old.companyName,
        location: old.location,
        salaryRange: old.salaryRange,
        type: old.type,
        status: status,
        category: old.category,
        tags: old.tags,
        publishedAt: old.publishedAt,
        description: old.description,
        responsibilities: old.responsibilities,
        qualifications: old.qualifications,
        niceToHaves: old.niceToHaves,
        benefits: old.benefits,
        acceptedCount: old.acceptedCount,
        capacity: old.capacity,
        logoIcon: old.logoIcon,
        companyLogoUrl: old.companyLogoUrl,
        deadline: old.deadline,
        specialTag: old.specialTag,
      );
    }
    notifyListeners();
  }

  String translateTradesmanWorkStatus(String status, bool isAr) {
    final low = status.toLowerCase();
    if (low.contains('close') || low.contains('مغلق')) {
      return isAr ? 'مغلق' : 'Closed';
    }
    if (low.contains('inactive') ||
        low.contains('غير') ||
        low.contains('pause')) {
      return isAr ? 'غير نشط' : 'Inactive';
    }
    return isAr ? 'نشط' : 'Active';
  }
}
