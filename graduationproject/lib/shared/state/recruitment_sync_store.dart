import 'package:flutter/material.dart';
import '../../screens/user/profile/user_data.dart';
import '../models/job.dart';
import 'company_store.dart';

class RecruitmentJob {
  const RecruitmentJob({
    required this.id, required this.title, required this.companyName, required this.location,
    required this.salaryRange, required this.type, required this.status, required this.category,
    required this.tags, required this.publishedAt, this.description = '', this.responsibilities = const [],
    this.qualifications = const [], this.niceToHaves = const [], required this.benefits,
    this.logoIcon, this.companyLogoUrl, this.capacity = 1, this.acceptedCount = 0, this.deadline,
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
    required this.id, required this.jobId, required this.jobTitle, required this.companyName,
    required this.userName, required this.status, required this.updatedAt,
    this.gender, this.birthDate, this.languages = const [], this.about,
    this.experienceYears = 0, this.education, this.skills = const [], this.hasCv = false,
    this.email, this.phone, this.location,
  });

  final String id; final String jobId; final String jobTitle; final String companyName;
  final String userName; final String status; final DateTime updatedAt;
  final String? gender; final String? birthDate; final List<String> languages;
  final String? about; final int experienceYears; final String? education;
  final List<String> skills; final bool hasCv; final String? email; final String? phone; final String? location;

  RecruitmentApplication copyWith({String? status, DateTime? updatedAt}) {
    return RecruitmentApplication(
      id: id, jobId: jobId, jobTitle: jobTitle, companyName: companyName, userName: userName,
      status: status ?? this.status, updatedAt: updatedAt ?? this.updatedAt,
      gender: gender, birthDate: birthDate, languages: languages, about: about,
      experienceYears: experienceYears, education: education, skills: skills,
      hasCv: hasCv, email: email, phone: phone, location: location,
    );
  }
}

class RecruitmentMessage {
  const RecruitmentMessage({required this.id, required this.fromCompany, required this.text, required this.createdAt});
  final String id; final bool fromCompany; final String text; final DateTime createdAt;
}

class ChatThread {
  final String name; final String image; String lastMessage; String time;
  ChatThread({required this.name, required this.image, required this.lastMessage, required this.time});
}

class ServiceRequestPost {
  const ServiceRequestPost({
    required this.id, required this.title, required this.description, required this.budget,
    required this.requestedBy, required this.createdAt,
  });
  final String id; final String title; final String description; final String budget;
  final String requestedBy; final DateTime createdAt;
}

class RecruitmentSyncStore extends ChangeNotifier {
  RecruitmentSyncStore._() {
    _addMockTradesmanJobs();
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
    'All', 'Cairo', 'Giza', 'Alexandria', 'Dakahlia', 'Red Sea', 'Beheira', 'Fayoum', 'Gharbia', 'Ismailia', 'Monufia', 'Minya', 'Qalyubia', 'New Valley', 'Sharqia', 'Suez', 'Aswan', 'Assiut', 'Beni Suef', 'Port Said', 'Damietta', 'South Sinai', 'Kafr El Sheikh', 'Matrouh', 'Luxor', 'Qena', 'Sohag', 'North Sinai', 'Remote',
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
  List<RecruitmentApplication> get applications => List.unmodifiable(_applications);
  List<RecruitmentMessage> get messages => List.unmodifiable(_messages);
  List<ChatThread> get tradesmanChatThreads => List.unmodifiable(_tradesmanChatThreads);
  Set<String> get savedJobIds => Set.unmodifiable(_savedJobIds);
  List<ServiceRequestPost> get serviceRequests => List.unmodifiable(_serviceRequests);

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

  List<RecruitmentJob> get savedJobs => _jobs.where((item) => _savedJobIds.contains(item.id)).toList();

  List<RecruitmentJob> get filteredJobs {
    if (_searchQuery.isEmpty && _filterType == 'All' && _filterLocation == 'All' && _filterCategory == 'All') return _jobs;
    return _jobs.where((job) {
      final matchesQuery = _searchQuery.isEmpty || job.title.toLowerCase().contains(_searchQuery.toLowerCase()) || job.companyName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLocation = _filterLocation == 'All' || job.location == _filterLocation;
      final matchesCategory = _filterCategory == 'All' || job.category == _filterCategory;
      return matchesQuery && matchesLocation && matchesCategory;
    }).toList();
  }

  void _addMockTradesmanJobs() {
    _jobs.addAll([
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
        benefits: [],
        acceptedCount: 0,
        capacity: 1,
        logoIcon: Icons.plumbing,
      ),
      RecruitmentJob(
        id: 'mock_t2',
        title: 'كهربائي منازل خبير',
        companyName: 'تشطيبات النيل',
        location: 'Giza',
        salaryRange: 'Negotiable',
        type: 'One-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Electrical'],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        benefits: [],
        acceptedCount: 0,
        capacity: 1,
        logoIcon: Icons.electric_bolt,
      ),
      RecruitmentJob(
        id: 'mock_t3',
        title: 'نجار موبيليا وتصنيع',
        companyName: 'أثاث المودرن',
        location: 'Alexandria',
        salaryRange: '10k - 15k',
        type: 'Full-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['Carpentry'],
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        benefits: ['Insurance'],
        acceptedCount: 0,
        capacity: 5,
        logoIcon: Icons.carpenter,
      ),
      RecruitmentJob(
        id: 'mock_t4',
        title: 'فني تكييف وصيانة',
        companyName: 'كول سيرفيس',
        location: 'Cairo',
        salaryRange: '8k - 12k',
        type: 'Full-time',
        status: 'Open',
        category: 'Tradesman',
        tags: ['HVAC'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        benefits: ['Bonus'],
        acceptedCount: 0,
        capacity: 3,
        logoIcon: Icons.ac_unit,
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

  void updateCurrentUser({String? name, String? email, String? phone, String? location, String? photoUrl}) {
    if (name != null) _currentUserName = name;
    if (email != null) _currentUserEmail = email;
    if (phone != null) _currentUserPhone = phone;
    if (location != null) _currentUserLocation = location;
    if (photoUrl != null) _profileImage = photoUrl;
    notifyListeners();
  }

  void updateUserProfile({
    required String fullName, required String title, String? email, String? phone, String? location,
    String? about, List<String>? skills, List<Map<String, String>>? education,
    List<Map<String, String>>? experience, List<Map<String, String>>? socialLinks,
    String? role, List<String>? portfolioImages,
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

  void updateFilters({String? searchQuery, String? type, String? location, String? category, String? salaryRange}) {
    if (searchQuery != null) _searchQuery = searchQuery;
    if (type != null) _filterType = type;
    if (location != null) _filterLocation = location;
    if (category != null) _filterCategory = category;
    if (salaryRange != null) _filterSalaryRange = salaryRange;
    notifyListeners();
  }

  void updateTradesmanChat(String name, String image, String text) {
    final existingIndex = _tradesmanChatThreads.indexWhere((t) => t.name == name);
    final now = DateTime.now();
    final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    if (existingIndex != -1) {
      _tradesmanChatThreads[existingIndex].lastMessage = text;
      _tradesmanChatThreads[existingIndex].time = timeStr;
      final thread = _tradesmanChatThreads.removeAt(existingIndex);
      _tradesmanChatThreads.insert(0, thread);
    } else {
      _tradesmanChatThreads.insert(0, ChatThread(name: name, image: image, lastMessage: text, time: timeStr));
    }
    notifyListeners();
  }

  void replaceFromRemote({required List<Map<String, dynamic>> jobs, required List<Map<String, dynamic>> applications, required List<Map<String, dynamic>> messages}) {
    _jobs.clear();
    _addMockTradesmanJobs(); // Keep mock jobs
    for (var item in jobs) {
      _jobs.add(RecruitmentJob(
        id: item['id']?.toString() ?? '',
        title: item['title']?.toString() ?? '',
        companyName: item['companyName']?.toString() ?? '',
        location: item['location']?.toString() ?? '',
        salaryRange: item['salaryRange']?.toString() ?? '',
        type: item['type']?.toString() ?? '',
        status: item['status']?.toString() ?? '',
        category: item['category']?.toString() ?? '',
        tags: item['tags'] is List ? List<String>.from(item['tags']) : [],
        publishedAt: DateTime.tryParse(item['createdAt']?.toString() ?? '') ?? DateTime.now(),
        benefits: item['benefits'] is List ? List<String>.from(item['benefits']) : [],
        companyLogoUrl: item['companyLogoUrl'],
        capacity: int.tryParse(item['requiredCount']?.toString() ?? '1') ?? 1,
        acceptedCount: int.tryParse(item['acceptedCount']?.toString() ?? '0') ?? 0,
      ));
    }
    _applications.clear();
    for (var item in applications) {
      _applications.add(RecruitmentApplication(
        id: item['id']?.toString() ?? '', jobId: item['jobId']?.toString() ?? '', jobTitle: item['jobTitle']?.toString() ?? '', companyName: item['companyName']?.toString() ?? '', userName: item['userName']?.toString() ?? '', status: item['status']?.toString() ?? '', updatedAt: DateTime.tryParse(item['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      ));
    }
    _messages.clear();
    for (var item in messages) {
      _messages.add(RecruitmentMessage(
        id: item['id']?.toString() ?? '', fromCompany: item['fromCompany'] == true, text: item['text']?.toString() ?? '', createdAt: DateTime.tryParse(item['createdAt']?.toString() ?? '') ?? DateTime.now(),
      ));
    }
    notifyListeners();
  }

  void companyPostJob(RecruitmentJob job) { _jobs.insert(0, job); notifyListeners(); }
  void removeJob(String jobId) { _jobs.removeWhere((j) => j.id == jobId); notifyListeners(); }
  void companyUpdateApplicationStatus({required String applicationId, required String nextStatus}) {
    final idx = _applications.indexWhere((a) => a.id == applicationId);
    if (idx != -1) {
      _applications[idx] = _applications[idx].copyWith(status: nextStatus, updatedAt: DateTime.now());
      notifyListeners();
    }
  }
  void companySendMessage(String text) {
    _messages.insert(0, RecruitmentMessage(id: 'local_${DateTime.now().millisecondsSinceEpoch}', fromCompany: true, text: text, createdAt: DateTime.now()));
    notifyListeners();
  }
  void postServiceRequest({required String title, required String description, required String budget}) {
    _serviceRequests.insert(0, ServiceRequestPost(id: 'sr_${DateTime.now().millisecondsSinceEpoch}', title: title, description: description, budget: budget, requestedBy: _currentUserName, createdAt: DateTime.now()));
    notifyListeners();
  }
  void userApplyToJob({required String jobId, required String userName}) {
    _applications.insert(0, RecruitmentApplication(id: 'app_${DateTime.now().millisecondsSinceEpoch}', jobId: jobId, jobTitle: 'Job', companyName: 'Company', userName: userName, status: 'Applied', updatedAt: DateTime.now()));
    notifyListeners();
  }
}
