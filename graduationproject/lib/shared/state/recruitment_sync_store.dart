import 'package:flutter/foundation.dart';

class RecruitmentJob {
  const RecruitmentJob({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
    required this.type,
    required this.tags,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;
  final String type;
  final List<String> tags;
  final DateTime publishedAt;
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

  final List<RecruitmentJob> _jobs = <RecruitmentJob>[
    RecruitmentJob(
      id: 'job_1',
      title: 'Flutter Mobile Developer',
      companyName: 'Jobito Labs',
      location: 'Cairo, Egypt',
      salaryRange: '20k - 30k EGP',
      type: 'Full-time',
      tags: const ['Flutter', 'Dart', 'REST'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    RecruitmentJob(
      id: 'job_2',
      title: 'Backend Node.js Engineer',
      companyName: 'Nexa Systems',
      location: 'Remote',
      salaryRange: '30k - 45k EGP',
      type: 'Full-time',
      tags: const ['Node.js', 'Express', 'PostgreSQL'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 7)),
    ),
    RecruitmentJob(
      id: 'job_3',
      title: 'UI/UX Product Designer',
      companyName: 'BlueOrbit',
      location: 'Cairo, Egypt',
      salaryRange: '18k - 28k EGP',
      type: 'Part-time',
      tags: const ['Figma', 'Design Systems', 'UX Research'],
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RecruitmentJob(
      id: 'job_4',
      title: 'QA Automation Engineer',
      companyName: 'HireFlow Tech',
      location: 'Alex, Egypt',
      salaryRange: '20k - 35k EGP',
      type: 'Contract',
      tags: const ['Selenium', 'Cypress', 'CI/CD'],
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<RecruitmentApplication> _applications = <RecruitmentApplication>[
    RecruitmentApplication(
      id: 'app_1',
      jobId: 'job_1',
      jobTitle: 'Flutter Mobile Developer',
      companyName: 'Jobito Labs',
      userName: 'Ahmed User',
      status: 'In Review',
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  final List<RecruitmentMessage> _messages = <RecruitmentMessage>[
    RecruitmentMessage(
      id: 'msg_1',
      fromCompany: true,
      text: 'Thanks for applying. We will review your profile today.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];
  final Set<String> _savedJobIds = <String>{'job_1'};
  String _currentUserName = 'Ahmed User';
  String _currentUserTitle = 'Mobile Developer';
  String _userRole = 'Job Seeker';
  String _searchQuery = '';
  String _filterType = 'All';
  String _filterLocation = 'All';
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

  List<RecruitmentApplication> get applications =>
      List<RecruitmentApplication>.unmodifiable(_applications);

  List<RecruitmentMessage> get messages =>
      List<RecruitmentMessage>.unmodifiable(_messages);
  Set<String> get savedJobIds => Set<String>.unmodifiable(_savedJobIds);
  String get currentUserName => _currentUserName;
  String get currentUserTitle => _currentUserTitle;
  String get userRole => _userRole;
  String get searchQuery => _searchQuery;
  String get filterType => _filterType;
  String get filterLocation => _filterLocation;
  List<ServiceRequestPost> get serviceRequests =>
      List<ServiceRequestPost>.unmodifiable(_serviceRequests);
  List<RecruitmentJob> get savedJobs =>
      _jobs.where((item) => _savedJobIds.contains(item.id)).toList();
  List<RecruitmentJob> get filteredJobs {
    return _jobs.where((job) {
      final matchesQuery = _searchQuery.isEmpty ||
          job.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job.companyName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _filterType == 'All' || job.type == _filterType;
      final matchesLocation =
          _filterLocation == 'All' || job.location == _filterLocation;
      return matchesQuery && matchesType && matchesLocation;
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
    String? role,
  }) {
    _currentUserName = fullName.trim().isEmpty ? _currentUserName : fullName;
    _currentUserTitle = title.trim().isEmpty ? _currentUserTitle : title;
    if (role != null && role.isNotEmpty) {
      _userRole = role;
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
    _messages.insert(
      0,
      RecruitmentMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        fromCompany: false,
        text: 'New worker request posted: $title',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateFilters({
    String? searchQuery,
    String? type,
    String? location,
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
    notifyListeners();
  }

  void userApplyToJob({
    required String jobId,
    required String userName,
  }) {
    final int index = _jobs.indexWhere((RecruitmentJob item) => item.id == jobId);
    if (index < 0) {
      return;
    }
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
      (RecruitmentApplication app) => app.id == applicationId,
    );
    if (index < 0) {
      return;
    }
    _applications[index] = _applications[index].copyWith(
      status: nextStatus,
      updatedAt: DateTime.now(),
    );
    _messages.insert(
      0,
      RecruitmentMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        fromCompany: true,
        text:
            'Application for ${_applications[index].jobTitle} moved to $nextStatus.',
        createdAt: DateTime.now(),
      ),
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
    _jobs
      ..clear()
      ..addAll(
        jobs.map(
          (Map<String, dynamic> item) => RecruitmentJob(
            id: item['id']?.toString() ?? '',
            title: item['title']?.toString() ?? 'Untitled',
            companyName: item['companyName']?.toString() ?? 'Company',
            location: item['location']?.toString() ?? 'Remote',
            salaryRange: item['salaryRange']?.toString() ?? 'Negotiable',
            type: item['type']?.toString() ?? 'Full-time',
            tags: item['tags'] is List
                ? (item['tags'] as List).map((dynamic e) => e.toString()).toList()
                : const <String>[],
            publishedAt: DateTime.tryParse(item['createdAt']?.toString() ?? '') ??
                DateTime.now(),
          ),
        ),
      );
    _applications
      ..clear()
      ..addAll(
        applications.map(
          (Map<String, dynamic> item) => RecruitmentApplication(
            id: item['id']?.toString() ?? '',
            jobId: item['jobId']?.toString() ?? '',
            jobTitle: _jobTitleById(item['jobId']?.toString() ?? ''),
            companyName: 'Jobito Labs',
            userName: item['userName']?.toString() ?? 'Candidate',
            status: item['status']?.toString() ?? 'Applied',
            updatedAt: DateTime.tryParse(item['updatedAt']?.toString() ?? '') ??
                DateTime.now(),
          ),
        ),
      );
    _messages
      ..clear()
      ..addAll(
        messages.map(
          (Map<String, dynamic> item) => RecruitmentMessage(
            id: item['id']?.toString() ?? '',
            fromCompany: item['fromCompany'] == true,
            text: item['text']?.toString() ?? '',
            createdAt: DateTime.tryParse(item['createdAt']?.toString() ?? '') ??
                DateTime.now(),
          ),
        ),
      );
    _savedJobIds.removeWhere((id) => _jobs.every((j) => j.id != id));
    notifyListeners();
  }

  String _jobTitleById(String jobId) {
    final index = _jobs.indexWhere((item) => item.id == jobId);
    if (index < 0) {
      return 'Job';
    }
    return _jobs[index].title;
  }
}
