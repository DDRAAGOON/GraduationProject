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
  RecruitmentSyncStore._();

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
  final Set<String> _deletedJobIds = <String>{};
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

  // Notification Settings
  bool _emailNotifications = true;
  bool _jobAlerts = true;
  bool _applicationUpdates = false;

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
  String get searchQuery => _searchQuery;
  String get filterType => _filterType;
  String get filterLocation => _filterLocation;
  String get filterCategory => _filterCategory;
  String get filterSalaryRange => _filterSalaryRange;

  bool get emailNotifications => _emailNotifications;
  bool get jobAlerts => _jobAlerts;
  bool get applicationUpdates => _applicationUpdates;

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
      // Hide full jobs
      if (job.acceptedCount >= job.capacity) return false;

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

  void updateNotificationSettings({
    bool? email,
    bool? jobs,
    bool? updates,
  }) {
    if (email != null) _emailNotifications = email;
    if (jobs != null) _jobAlerts = jobs;
    if (updates != null) _applicationUpdates = updates;
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
    
    // Remove duplicates by ID (keeping the first one found, usually the remote one if it exists)
    final ids = <String>{};
    _jobs.retainWhere((j) => ids.add(j.id));

    _applications.clear();
    for (final item in applications) {
      if (item is Map<String, dynamic>) {
        _applications.add(RecruitmentApplication.fromMap(item));
      }
    }
    
    // Remove duplicates by ID
    final appIds = <String>{};
    _applications.retainWhere((a) => appIds.add(a.id));

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
    _deletedJobIds.add(jobId);
    notifyListeners();
  }

  bool isJobDeleted(String jobId) => _deletedJobIds.contains(jobId);

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
    return [];
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
