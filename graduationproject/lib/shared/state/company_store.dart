// [ChangeNotifier] holding company profile, jobs, and contacts.

import 'package:flutter/foundation.dart';

import '../../constants/app_images.dart';
import '../models/contact_entry.dart';
import '../models/job.dart';

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

  // Public getters to access state securely
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
  /// 
  /// [english] The introduction text in English.
  /// [arabic] The introduction text in Arabic.
  void setCompanyIntro({required String english, required String arabic}) {
    _aboutEn = english;
    _aboutAr = arabic;
    notifyListeners();
  }

  void setRegistrationData({
    String? companyName,
    String? customProfileImage,
    String? commercialRegister,
    String? nationalNumber,
  }) {
    if (companyName != null && companyName.isNotEmpty) _companyName = companyName;
    if (customProfileImage != null) _customProfileImage = customProfileImage;
    if (commercialRegister != null) _commercialRegister = commercialRegister;
    if (nationalNumber != null) _nationalNumber = nationalNumber;
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
    _locations = List.from(locations);
    _techStack = List.from(techStack);
    _foundedDay = foundedDay;
    _foundedMonth = foundedMonth;
    _foundedYear = foundedYear;
    _category = category;
    _benefits = List.from(benefits);
    _commercialRegister = commercialRegister;
    _nationalNumber = nationalNumber;
    notifyListeners();
  }

  // --- Associated Entities: Jobs & Contacts ---
  
  /// Holds the list of dynamically managed jobs for the company.
  final List<Job> _jobs = [...Job.mockList()];
  
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

  /// Deletes a job from the current list using its unique ID.
  /// Returns `true` if the deletion triggered an item removal and UI update.
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
