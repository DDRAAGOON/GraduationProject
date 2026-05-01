import 'package:flutter/material.dart';
import '../../screens/user/profile/user_data.dart';
import '../models/job.dart';
import 'company_store.dart';

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
    required this.tags,
    required this.publishedAt,
    this.description = '',
    this.responsibilities = const [],
    this.qualifications = const [],
    this.niceToHaves = const [],
    required this.benefits,
    this.logoIcon,
    this.companyLogoUrl,
    this.capacity = 1,
    this.acceptedCount = 0,
    this.deadline,
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
  final IconData? logoIcon;
  final String? companyLogoUrl;
  final int capacity;
  final int acceptedCount;
  final DateTime? deadline;
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

  // Detailed fields
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

// New class for Chat Threads
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
    // Empty initial state
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

  final List<RecruitmentJob> _jobs = <RecruitmentJob>[];
  final List<RecruitmentApplication> _applications = <RecruitmentApplication>[];
  final List<RecruitmentMessage> _messages = <RecruitmentMessage>[];
  final List<ChatThread> _tradesmanChatThreads = <ChatThread>[];
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
  final List<ServiceRequestPost> _serviceRequests = <ServiceRequestPost>[];

  List<RecruitmentJob> get jobs => List<RecruitmentJob>.unmodifiable(_jobs);
  List<RecruitmentApplication> get applications =>
      List<RecruitmentApplication>.unmodifiable(_applications);
  List<RecruitmentMessage> get messages =>
      List<RecruitmentMessage>.unmodifiable(_messages);
  List<ChatThread> get tradesmanChatThreads =>
      List<ChatThread>.unmodifiable(_tradesmanChatThreads);
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
  List<ServiceRequestPost> get serviceRequests =>
      List<ServiceRequestPost>.unmodifiable(_serviceRequests);

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
    if (photoUrl != null) {
      _profileImage = photoUrl;
      UserProfileData.profileImage = photoUrl;
    }
    notifyListeners();
  }

  List<RecruitmentJob> get savedJobs =>
      _jobs.where((item) => _savedJobIds.contains(item.id)).toList();

  List<RecruitmentJob> get filteredJobs {
    final now = DateTime.now();
    return _jobs.where((job) {
      // Auto-close logic: Hide jobs where capacity is met or deadline has passed
      if (job.acceptedCount >= job.capacity) return false;
      if (job.deadline != null && job.deadline!.isBefore(now)) return false;

      final query = _searchQuery.toLowerCase();
      final searchParts = query
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty);

      final matchesQuery =
          _searchQuery.isEmpty ||
          searchParts.every((part) {
            final titleMatch = job.title.toLowerCase().contains(part);
            final companyMatch = job.companyName.toLowerCase().contains(part);
            final locationEn = job.location;
            final locationAr = locationTranslations[locationEn] ?? '';
            final locationMatch =
                locationEn.toLowerCase().contains(part) ||
                locationAr.toLowerCase().contains(part);

            return titleMatch || companyMatch || locationMatch;
          });

      final matchesType =
          _filterType == 'All' ||
          job.type.toLowerCase() == _filterType.toLowerCase();
      bool matchesLocation =
          _filterLocation == 'All' || _filterLocation == 'الكل';
      if (!matchesLocation) {
        final currentFilterAr =
            locationTranslations[_filterLocation] ?? _filterLocation;
        final jobLocationAr =
            locationTranslations[job.location] ?? job.location;
        matchesLocation =
            job.location == _filterLocation ||
            jobLocationAr == _filterLocation ||
            job.location == currentFilterAr;
      }

      final matchesCategory =
          _filterCategory == 'All' ||
          job.category.toLowerCase() == _filterCategory.toLowerCase();
      final matchesSalary =
          _filterSalaryRange == 'All' ||
          job.salaryRange.toLowerCase().contains(
            _filterSalaryRange.toLowerCase(),
          );

      return matchesQuery &&
          matchesType &&
          matchesLocation &&
          matchesCategory &&
          matchesSalary;
    }).toList();
  }

  void updateTradesmanChat(String name, String image, String text) {
    final existingIndex = _tradesmanChatThreads.indexWhere(
      (t) => t.name == name,
    );
    final now = DateTime.now();
    final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    if (existingIndex != -1) {
      _tradesmanChatThreads[existingIndex].lastMessage = text;
      _tradesmanChatThreads[existingIndex].time = timeStr;
      // Move to top
      final thread = _tradesmanChatThreads.removeAt(existingIndex);
      _tradesmanChatThreads.insert(0, thread);
    } else {
      _tradesmanChatThreads.insert(
        0,
        ChatThread(name: name, image: image, lastMessage: text, time: timeStr),
      );
    }
    notifyListeners();
  }

  void companyPostJob(RecruitmentJob job) {
    _jobs.insert(0, job);
    notifyListeners();
  }

  void removeJob(String jobId) {
    _jobs.removeWhere((j) => j.id == jobId);
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
    if (searchQuery != null) _searchQuery = searchQuery;
    if (type != null) _filterType = type;
    if (location != null) _filterLocation = location;
    if (category != null) _filterCategory = category;
    if (salaryRange != null) _filterSalaryRange = salaryRange;
    notifyListeners();
  }

  void userApplyToJob({required String jobId, required String userName}) {
    final int index = _jobs.indexWhere(
      (RecruitmentJob item) => item.id == jobId,
    );
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
    final int index = _applications.indexWhere(
      (app) => app.id == applicationId,
    );
    if (index < 0) return;

    final RecruitmentApplication previousApplication = _applications[index];
    final String previousStatus = previousApplication.status;
    _applications[index] = previousApplication.copyWith(
      status: nextStatus,
      updatedAt: DateTime.now(),
    );

    final int jobIndex = CompanyStore.instance.jobs.indexWhere(
      (job) => job.id == previousApplication.jobId,
    );
    if (jobIndex >= 0) {
      final job = CompanyStore.instance.jobs[jobIndex];
      final bool wasHired = previousStatus.toLowerCase().contains('hire');
      final bool isHired = nextStatus.toLowerCase().contains('hire');
      if (wasHired != isHired) {
        final int updatedAcceptedCount =
            (job.acceptedCount + (isHired ? 1 : -1)).clamp(
              0,
              job.requiredCount,
            );
        CompanyStore.instance.saveJob(
          job.copyWith(acceptedCount: updatedAcceptedCount),
        );
      }
    }

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
    // 1. Update Jobs
    _jobs.clear();
    final List<Job> companyJobs = [];
    final currentCompanyName = CompanyStore.instance.companyName
        .trim()
        .toLowerCase();
    final currentCompanyId = CompanyStore.instance.companyId;

    // Convert and sort jobs by date descending
    final List<Map<String, dynamic>> sortedJobs = List.from(jobs);
    sortedJobs.sort((a, b) {
      final da =
          DateTime.tryParse(a['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final db =
          DateTime.tryParse(b['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });

    for (final item in sortedJobs) {
      final rJob = RecruitmentJob(
        id: item['id']?.toString() ?? '',
        title: item['title']?.toString() ?? 'Untitled',
        companyName: item['companyName']?.toString() ?? 'Company',
        location: item['location']?.toString() ?? 'Remote',
        salaryRange: item['salaryRange']?.toString() ?? 'Negotiable',
        type: item['type']?.toString() ?? 'Full-time',
        status: item['status']?.toString() ?? 'Open',
        category: item['category']?.toString() ?? 'Technical',
        tags: item['tags'] is List
            ? (item['tags'] as List).map((e) => e.toString()).toList()
            : const [],
        publishedAt:
            DateTime.tryParse(item['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        description: item['description']?.toString() ?? '',
        responsibilities: item['responsibilities'] is List
            ? (item['responsibilities'] as List)
                  .map((e) => e.toString())
                  .toList()
            : const [],
        qualifications: item['qualifications'] is List
            ? (item['qualifications'] as List).map((e) => e.toString()).toList()
            : const [],
        niceToHaves: item['niceToHaves'] is List
            ? (item['niceToHaves'] as List).map((e) => e.toString()).toList()
            : const [],
        benefits: item['benefits'] is List
            ? (item['benefits'] as List).map((e) => e.toString()).toList()
            : const [],
        companyLogoUrl: item['companyLogoUrl']?.toString(),
        capacity: int.tryParse(item['requiredCount']?.toString() ?? '1') ?? 1,
        acceptedCount:
            int.tryParse(item['acceptedCount']?.toString() ?? '0') ?? 0,
        deadline: item['deadline'] != null
            ? DateTime.tryParse(item['deadline'].toString())
            : null,
      );
      _jobs.add(rJob);

      // Check if job belongs to current company
      final itemCompanyId = item['companyId']?.toString() ?? '';
      final itemCompanyName = rJob.companyName.trim().toLowerCase();

      bool belongsToCompany = false;
      if (currentCompanyId.isNotEmpty && itemCompanyId.isNotEmpty) {
        belongsToCompany = itemCompanyId == currentCompanyId;
      } else if (currentCompanyName.isNotEmpty) {
        belongsToCompany = itemCompanyName == currentCompanyName;
      }

      if (belongsToCompany) {
        companyJobs.add(Job.fromMap(item));
      }
    }

    // Sync with CompanyStore
    CompanyStore.instance.clearJobs();
    for (final job in companyJobs) {
      CompanyStore.instance.saveJob(job);
    }

    // 2. Update Applications
    _applications.clear();
    for (final item in applications) {
      _applications.add(
        RecruitmentApplication(
          id: item['id']?.toString() ?? '',
          jobId: item['jobId']?.toString() ?? '',
          jobTitle: item['jobTitle']?.toString() ?? '',
          companyName: item['companyName']?.toString() ?? '',
          userName: item['userName']?.toString() ?? '',
          status: item['status']?.toString() ?? 'Pending',
          updatedAt:
              DateTime.tryParse(item['updatedAt']?.toString() ?? '') ??
              DateTime.now(),
          email: item['email']?.toString(),
          phone: item['phone']?.toString(),
          location: item['location']?.toString(),
          about: item['about']?.toString(),
          skills: item['skills'] is List
              ? (item['skills'] as List).map((e) => e.toString()).toList()
              : const [],
        ),
      );
    }

    // 3. Update Messages
    _messages.clear();
    for (final item in messages) {
      _messages.add(
        RecruitmentMessage(
          id: item['id']?.toString() ?? '',
          fromCompany: item['fromCompany'] == true,
          text: item['text']?.toString() ?? '',
          createdAt:
              DateTime.tryParse(item['createdAt']?.toString() ?? '') ??
              DateTime.now(),
        ),
      );
    }

    notifyListeners();
  }
}
