import 'package:flutter/foundation.dart';

import '../../constants/app_images.dart';
import '../models/contact_entry.dart';
import '../models/job.dart';

class CompanyStore extends ChangeNotifier {
  CompanyStore._();

  static final CompanyStore instance = CompanyStore._();

  String get companyName => 'Nomad';
  String get companyProfileImage => AppImages.companyProfileImage;

  String _aboutEn =
      'Nomad is a software platform for starting and running internet businesses. '
      'Millions of businesses rely on Stripe’s software tools to accept payments, '
      'expand globally, and manage their businesses online.\n\n'
      'Stripe has been at the forefront of expanding internet commerce. '
      'Our mission is to increase the GDP of the internet...';

  String _aboutAr =
      'تُعد Nomad منصّة برمجية لإطلاق وإدارة الأعمال عبر الإنترنت. يعتمد ملايين '
      'الشركات على أدوات Stripe لقبول المدفوعات والتوسّع عالميًا وإدارة أعمالها '
      'رقميًا بكفاءة.\n\n'
      'ظلّ Stripe في مقدمة توسيع التجارة الإلكترونية، ورسالتنا هي دعم ازدهار '
      'اقتصاد الإنترنت عبر حلول موثوقة وقابلة للتوسّع.';

  String get companyAboutEn => _aboutEn;
  String get companyAboutAr => _aboutAr;

  void setCompanyIntro({required String english, required String arabic}) {
    _aboutEn = english;
    _aboutAr = arabic;
    notifyListeners();
  }

  final List<Job> _jobs = [...Job.mockList()];
  final List<ContactEntry> _contacts = [
    const ContactEntry(name: 'Twitter', value: 'twitter.com/Nomad'),
    const ContactEntry(name: 'Facebook', value: 'facebook.com/NomadHQ'),
    const ContactEntry(name: 'LinkedIn', value: 'linkedin.com/company/nomad'),
    const ContactEntry(name: 'Email', value: 'nomad@gmail.com'),
  ];

  List<Job> get jobs => List<Job>.unmodifiable(_jobs);
  List<ContactEntry> get contacts => List<ContactEntry>.unmodifiable(_contacts);

  Job jobById(String id) {
    return _jobs.firstWhere((job) => job.id == id, orElse: Job.mock);
  }

  void saveJob(Job job) {
    final index = _jobs.indexWhere((j) => j.id == job.id);
    if (index >= 0) {
      _jobs[index] = job;
    } else {
      _jobs.insert(0, job);
    }
    notifyListeners();
  }

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
