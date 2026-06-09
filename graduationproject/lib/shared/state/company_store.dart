// [ChangeNotifier] holding company profile, jobs, and contacts.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';

import '../../core/network/secure_storage.dart';
import '../models/contact_entry.dart';
import '../models/job.dart';
import '../services/session_manager.dart';

/// The [CompanyStore] acts as the central state management layer for the application.
/// It uses the [ChangeNotifier] mixin to broadcast updates to the UI whenever
/// the company's profile, job listings, or contact details change.
class CompanyStore extends ChangeNotifier {
  CompanyStore._();

  /// The static singleton instance of [CompanyStore].
  /// This prevents multiple and conflicting instances from being created.
  static final CompanyStore instance = CompanyStore._();

  // --- Company Basic Details ---
  String _companyName = '';
  String _website = '';
  String _employee = '';
  String _industry = '';

  // --- Company Extended Details ---
  List<String> _locations = [];
  List<String> _techStack = [];

  // --- Date Founded ---
  int _foundedDay = 0;
  int _foundedMonth = 0;
  int _foundedYear = 0;

  // --- Category and Benefits ---
  String _category = '';
  List<String> _benefits = [];

  // --- Registration Data ---
  String _commercialRegister = '';
  String _nationalNumber = '';
  String? _customProfileImage;
  String _companyId = '';

  // Public getters to access state securely
  String get companyId => _companyId;
  String get companyName => _companyName;
  String get website => _website;
  String get employee => _employee;
  String get industry => _industry;

  /// Returns an unmodifiable list of locations to prevent accidental mutations.
  List<String> get locations => List.unmodifiable(_locations);

  /// Returns an unmodifiable list of the underlying technology stack.
  List<String> get techStack => List.unmodifiable(_techStack);

  int get foundedDay => _foundedDay;
  int get foundedMonth => _foundedMonth;
  int get foundedYear => _foundedYear;

  String get category => _category;
  List<String> get benefits => List.unmodifiable(_benefits);

  String get commercialRegister => _commercialRegister;
  String get nationalNumber => _nationalNumber;

  String? get companyProfileImage => _customProfileImage;

  String _aboutEn = '';
  String _aboutAr = '';

  String get companyAboutEn => _aboutEn;
  String get companyAboutAr => _aboutAr;

  /// Updates the localized company introduction and notifies UI listeners.
  void setCompanyIntro({required String english, required String arabic}) {
    _aboutEn = english;
    _aboutAr = arabic;
    notifyListeners();
  }

  void setRegistrationData({
    String? companyId,
    String? companyName,
    String? customProfileImage,
    String? commercialRegister,
    String? nationalNumber,
    String? email,
  }) {
    if (companyId != null && companyId.isNotEmpty) _companyId = companyId;
    if (companyName != null && companyName.isNotEmpty) _companyName = companyName;
    if (customProfileImage != null) _customProfileImage = customProfileImage;
    if (commercialRegister != null) _commercialRegister = commercialRegister;
    if (nationalNumber != null) _nationalNumber = nationalNumber;

    if (email != null && email.isNotEmpty) {
      final existingEmailIndex = _contacts.indexWhere((c) => c.name.toLowerCase() == 'email' || c.name == 'البريد الإلكتروني');
      if (existingEmailIndex >= 0) {
        _contacts[existingEmailIndex] = _contacts[existingEmailIndex].copyWith(value: email);
      } else {
        _contacts.add(ContactEntry(name: 'Email', value: email));
      }
    }

    if (kDebugMode) {
      debugPrint('✅ CompanyStore.setRegistrationData:');
      debugPrint('   - companyId: $_companyId');
      debugPrint('   - companyName: $_companyName');
    }

    notifyListeners();
  }

  /// Updates the master profile variables and alerts the app to redraw.
  void updateProfile({
    required String name,
    required String website,
    required String employee,
    required String industry,
    required String aboutEn,
    required String aboutAr,
    required List<String> locations,
    required List<String> techStack,
    required int foundedDay,
    required int foundedMonth,
    required int foundedYear,
    required String category,
    required List<String> benefits,
    required String commercialRegister,
    required String nationalNumber,
  }) {
    _companyName = name;
    _website = website;
    _employee = employee;
    _industry = industry;
    _aboutEn = aboutEn;
    _aboutAr = aboutAr;
    _locations = List.from(locations.toSet());
    _techStack = List.from(techStack.toSet());
    _foundedDay = foundedDay;
    _foundedMonth = foundedMonth;
    _foundedYear = foundedYear;
    _category = category;
    _benefits = List.from(benefits.toSet());
    _commercialRegister = commercialRegister;
    _nationalNumber = nationalNumber;
    notifyListeners();
  }

  Future<void> initFromSession() async {
    final data = await SessionManager.getCompanyData();

    // ✅ محاولة جلب companyId من JWT token
    if (data['companyId'] == null || data['companyId'].toString().isEmpty) {
      try {
        final token = await SecureStorage.getToken();
        if (token != null && token.isNotEmpty) {
          final parts = token.split('.');
          if (parts.length == 3) {
            final payload = parts[1];
            final normalized = base64Url.normalize(payload);
            final decoded = utf8.decode(base64Url.decode(normalized));
            final json = jsonDecode(decoded) as Map<String, dynamic>;

            // ✅ استخدام userId كـ companyId
            _companyId = json['sub']?.toString() ?? '';

            if (kDebugMode) {
              debugPrint('✅ Extracted companyId from JWT: $_companyId');
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ Could not extract companyId from JWT: $e');
        }
      }
    } else {
      _companyId = data['companyId'].toString();
    }

    if (data['name'] != null) _companyName = data['name']!;
    if (data['photo'] != null) _customProfileImage = data['photo']!;

    final full = await SessionManager.getCompanyFullProfile();
    await loadFromSession(full);

    if (kDebugMode) {
      debugPrint('📦 CompanyStore.initFromSession:');
      debugPrint('   - companyId: $_companyId');
      debugPrint('   - companyName: $_companyName');
    }
  }

  Future<void> loadFromSession(Map<String, dynamic> data) async {
    // ✅ تحميل companyId من data
    if (data['companyId'] != null) {
      _companyId = data['companyId'].toString();
      if (kDebugMode) debugPrint('✅ Loaded companyId from session: $_companyId');
    }

    // ✅ لو companyId فاضي، نجيبه من الـ jobs
    if (_companyId.isEmpty) {
      final jobs = RecruitmentSyncStore.instance.jobs;
      if (jobs.isNotEmpty) {
        _companyId = jobs.first.companyId;
        if (kDebugMode) debugPrint('✅ Extracted companyId from jobs: $_companyId');
      }
    }

    _employee = data['employee'] as String? ?? '';
    _industry = data['industry'] as String? ?? '';
    _aboutEn = data['aboutEn'] as String? ?? '';
    _aboutAr = data['aboutAr'] as String? ?? '';
    _locations = List<String>.from(data['locations'] as List? ?? []);
    _techStack = List<String>.from(data['techStack'] as List? ?? []);
    _foundedDay = data['foundedDay'] as int? ?? 0;
    _foundedMonth = data['foundedMonth'] as int? ?? 0;
    _foundedYear = data['foundedYear'] as int? ?? 0;
    _category = data['category'] as String? ?? '';
    _benefits = List<String>.from(data['benefits'] as List? ?? []);
    _commercialRegister = data['commercialRegister'] as String? ?? '';
    _nationalNumber = data['nationalNumber'] as String? ?? '';
    notifyListeners();
  }

  // --- Associated Entities: Jobs & Contacts ---

  /// Holds the list of dynamically managed jobs for the company.
  final List<Job> _jobs = [];

  /// Holds contact details like social links and emails.
  final List<ContactEntry> _contacts = [];

  List<Job> get jobs => List<Job>.unmodifiable(_jobs);
  List<ContactEntry> get contacts => List<ContactEntry>.unmodifiable(_contacts);

  /// Retrieves a specific job by its ID, returning a mock fallback if not found.
  Job jobById(String id) {
    return _jobs.firstWhere((job) => job.id == id, orElse: Job.mock);
  }

  /// Inserts a new job at the top of the list or updates an existing one if ID matches.
  void saveJob(Job job) {
    final index = _jobs.indexWhere((j) => j.id == job.id);
    if (index >= 0) {
      _jobs[index] = job;
    } else {
      _jobs.insert(0, job);
    }
    notifyListeners();
  }

  /// Clears all jobs from the store.
  void clearJobs() {
    _jobs.clear();
    notifyListeners();
  }

  /// Deletes a job from the current list using its unique ID.
  bool deleteJob(String id) {
    final before = _jobs.length;
    _jobs.removeWhere((job) => job.id == id);
    final changed = _jobs.length != before;
    if (changed) {
      notifyListeners();
    }
    return changed;
  }

  void addContact(ContactEntry contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void updateContact(int index, ContactEntry updated) {
    if (index < 0 || index >= _contacts.length) return;
    _contacts[index] = updated;
    notifyListeners();
  }

  void removeContact(int index) {
    if (index < 0 || index >= _contacts.length) return;
    _contacts.removeAt(index);
    notifyListeners();
  }
}