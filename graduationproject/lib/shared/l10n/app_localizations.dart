import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(l != null, 'AppLocalizations not found in context');
    return l!;
  }

  bool get isAr => locale.languageCode.toLowerCase().startsWith('ar');

  String tr({required String en, required String ar}) => isAr ? ar : en;

  // ── Bottom Nav ─────────────────────────────────────────────────────────────
  String get home => isAr ? 'الرئيسية' : 'Home';
  String get chat => isAr ? 'المحادثة' : 'Chat';
  String get job => isAr ? 'الوظائف' : 'Job';
  String get profile => isAr ? 'الملف الشخصي' : 'Profile';
  String get stats => isAr ? 'الإحصائيات' : 'Stats';

  // ── Language / Settings ────────────────────────────────────────────────────
  String get language => isAr ? 'اللغة' : 'Language';
  String get arabic => 'العربية';
  String get english => 'English';
  String get appearance => isAr ? 'المظهر' : 'Appearance';
  String get theme => isAr ? 'المظهر العام' : 'Theme';
  String get dark => isAr ? 'داكن' : 'Dark';
  String get light => isAr ? 'فاتح' : 'Light';
  String get settings => isAr ? 'الإعدادات' : 'Settings';
  String get notifications => isAr ? 'الإشعارات' : 'Notifications';

  // ── Common actions ─────────────────────────────────────────────────────────
  String get continueBtn => isAr ? 'متابعة' : 'Continue';
  String get next => isAr ? 'التالي' : 'Next';
  String get nextStep => isAr ? 'الخطوة التالية' : 'Next Step';
  String get getStarted => isAr ? 'ابدأ الآن' : 'Get Started';
  String get save => isAr ? 'حفظ' : 'Save';
  String get saveChange => isAr ? 'حفظ التغييرات' : 'Save Change';
  String get saved => isAr ? 'تم الحفظ' : 'Saved';
  String get cancel => isAr ? 'إلغاء' : 'Cancel';
  String get delete => isAr ? 'حذف' : 'Delete';
  String get edit => isAr ? 'تعديل' : 'Edit';
  String get addMore => isAr ? 'إضافة المزيد' : 'Add more';
  String get reply => isAr ? 'رد' : 'Reply';
  String get yes => isAr ? 'نعم' : 'Yes';
  String get no => isAr ? 'لا' : 'No';
  String get upload => isAr ? 'رفع' : 'Upload';
  String get required => isAr ? 'مطلوب' : 'Required';

  // ── Validation ─────────────────────────────────────────────────────────────
  String get enterValidEmail => isAr ? 'أدخل بريدًا إلكترونيًا صحيحًا' : 'Enter a valid email';
  String get min8Chars => isAr ? 'الحد الأدنى 8 أحرف' : 'Minimum 8 characters';
  String get passwordsNoMatch => isAr ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match';
  String get enterCompanyNumber => isAr ? 'أدخل رقم الشركة' : 'Enter company number';
  String get at3Chars => isAr ? 'على الأقل 3 أحرف' : 'At least 3 characters';
  String get mustBe8Chars => isAr ? 'يجب أن تكون 8 أحرف على الأقل' : 'Must be at least 8 characters';
  String get mustMatch => isAr ? 'يجب أن تتطابق كلمتا المرور' : 'Both passwords must match';
  String get acceptTermsMsg => isAr ? 'يرجى قبول الشروط للمتابعة' : 'Please accept terms to continue';
  String get enterCode4 => isAr ? 'أدخل الرمز المكون من 4 أرقام' : 'Enter the 4-digit code';
  String get enterMobileNumber => isAr ? 'أدخل رقم الهاتف' : 'Enter mobile number';

  // ── Auth ───────────────────────────────────────────────────────────────────
  String get signInToAccount => isAr ? 'تسجيل الدخول إلى\nحسابك' : 'Sign in to your\naccount';
  String get createAccount => isAr ? 'إنشاء حسابك\nالجديد' : 'Create your new\naccount';
  String get companyEmailAddress => isAr ? 'البريد الإلكتروني للشركة' : 'Company Email Address';
  String get emailAddress => isAr ? 'البريد الإلكتروني' : 'Email Address';
  String get companyEmail => isAr ? 'البريد الإلكتروني' : 'Company Email';
  String get enterYourEmail => isAr ? 'أدخل بريدك الإلكتروني' : 'Enter your email';
  String get password => isAr ? 'كلمة المرور' : 'Password';
  String get enterYourPassword => isAr ? 'أدخل كلمة المرور' : 'Enter your password';
  String get confirmPassword => isAr ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get confirmYourPassword => isAr ? 'تأكيد كلمة المرور' : 'Confirm your password';
  String get forgotPassword => isAr ? 'نسيت كلمة المرور؟' : 'Forgot password?';
  String get orSignInWith => isAr ? 'أو سجل دخولك بـ' : 'Or sign in with';
  String get dontHaveAccount => isAr ? 'ليس لديك حساب؟ ' : "Don't have an account? ";
  String get signUpBtn => isAr ? 'إنشاء حساب' : 'Sign up';
  String get alreadyRegistered => isAr ? 'لديك حساب بالفعل؟ ' : 'Already Registered? ';
  String get signInBtn => isAr ? 'تسجيل الدخول' : 'Sign In';
  String get companyName => isAr ? 'اسم الشركة' : 'Company Name';
  String get enterCompanyName => isAr ? 'أدخل اسم الشركة' : 'Enter company name';
  String get companyNumber => isAr ? 'رقم الشركة' : 'Company Number';
  String get enterCompanyNumberHint => isAr ? 'أدخل رقم الشركة' : 'Enter company number';
  String get address => isAr ? 'العنوان' : 'Address';
  String get enterAddress => isAr ? 'أدخل العنوان' : 'Enter address';
  String get taxNumber => isAr ? 'الرقم الضريبي' : 'Tax number';
  String get enterTaxNumber => isAr ? 'أدخل الرقم الضريبي' : 'Enter tax number';
  String get agreeTerms => isAr ? 'أوافق على شروط الخدمة وسياسة الخصوصية' : 'I Agree with Terms of Service and Privacy Policy';

  // ── OTP ────────────────────────────────────────────────────────────────────
  String get otpTitle => isAr ? 'التحقق من البريد الإلكتروني' : 'Email verification';
  String get otpSubtitle => isAr ? 'أدخل رمز التحقق الذي أرسلناه إليك على:' : 'Enter the verification code we send you on:';
  String get didntReceiveCode => isAr ? 'لم تستقبل الرمز؟ ' : "Didn't receive code? ";
  String get resend => isAr ? 'إعادة الإرسال' : 'Resend';

  // ── Reset / Password Changed ────────────────────────────────────────────────
  String get resetPassword => isAr ? 'إعادة تعيين كلمة المرور' : 'Reset Password';
  String get resetPasswordSub => isAr
      ? 'يجب أن تكون كلمة المرور الجديدة مختلفة عن\nكلمة المرور المستخدمة سابقًا'
      : 'Your new password must be different from the\npreviously used password';
  String get newPassword => isAr ? 'كلمة المرور الجديدة' : 'New Password';
  String get enterNewPassword => isAr ? 'أدخل كلمة المرور الجديدة' : 'Enter new password';
  String get confirmPasswordHint => isAr ? 'تأكيد كلمة المرور' : 'Confirm password';
  String get verifyAccount => isAr ? 'التحقق من الحساب' : 'Verify Account';
  String get passwordChanged => isAr ? 'تم تغيير كلمة المرور' : 'Password Changed';
  String get passwordChangedMsg => isAr
      ? 'تم تغيير كلمة المرور بنجاح، يمكنك تسجيل الدخول\nمجددًا بكلمة المرور الجديدة'
      : 'Password changed successfully, you can login again\nwith a new password';
  String get backToSignIn => isAr ? 'العودة إلى تسجيل الدخول' : 'Back to Sign in';

  // ── Onboarding ─────────────────────────────────────────────────────────────
  String get smartSearchTitle => isAr ? 'بحث ذكي وفرص\nأفضل' : 'Smart Search & Better\nOpportunities';
  String get smartSearchSub => isAr ? 'وفر وقتك وركز على ما يهم' : 'Save time and focus on what \nmatters';
  String get futureStartsHere => isAr ? 'مستقبلك يبدأ من هنا' : 'Your Future Starts Here';
  String get futureStartsSub => isAr ? 'اتخذ الخطوة التالية نحو وظيفة أحلامك\nكل شيء في تطبيق واحد' : 'Take the next step toward your\ndream job All in one app';

  // ── Dashboard ──────────────────────────────────────────────────────────────
  String get newCandidates => isAr ? 'مرشحون جدد\nللمراجعة' : 'New candidates\nto review';
  String get scheduleToday => isAr ? 'جدول\nاليوم' : 'Schedule\nfor today';
  String get messagesReceived => isAr ? 'الرسائل\nالمستلمة' : 'Messages\nreceived';
  String get jobUpdates => isAr ? 'تحديثات الوظائف' : 'Job Updates';
  String get deleteJobTitle => isAr ? 'حذف الإعلان الوظيفي؟' : 'Delete job post?';
  String deleteJobContent(String title) => isAr
      ? 'سيتم حذف "$title" نهائيًا.'
      : 'This will permanently delete "$title".';
  String get jobDeleted => isAr ? 'تم حذف الوظيفة' : 'Job deleted';
  String get appliedOf => isAr ? 'تقدّم من أصل' : 'applied of';
  String get noJobsYet => isAr ? 'لا توجد وظائف بعد' : 'No jobs yet';

  // ── Jobs ───────────────────────────────────────────────────────────────────
  String get postJob => isAr ? 'نشر وظيفة' : 'Post a Job';
  String get step1Label => isAr ? 'الخطوة 1/3 • معلومات الوظيفة' : 'Step 1/3 • Job Information';
  String get step2Label => isAr ? 'الخطوة 2/3 • وصف الوظيفة' : 'Step 2/3 • Job Description';
  String get step1Short => isAr ? 'الخطوة 1/3' : 'Step 1/3';
  String get step2Short => isAr ? 'الخطوة 2/3' : 'Step 2/3';
  String get jobTitle => isAr ? 'مسمى الوظيفة' : 'Job title';
  String get jobTitleHint => isAr ? 'مثال: مهندس برمجيات' : 'e.g. Software Engineer';
  String get typeOfEmployment => isAr ? 'نوع التوظيف' : 'Type of Employment';
  String get salary => isAr ? 'الراتب' : 'Salary';
  String get requiredSkills => isAr ? 'المهارات المطلوبة' : 'Required skills';
  String get jobDescriptions => isAr ? 'وصف الوظيفة' : 'Job Descriptions';
  String get addDescription => isAr ? 'أضف وصف الوظيفة...' : 'Add the description of the job...';
  String get whatWeProvide => isAr ? 'ما نقدمه (اختياري)' : 'What we provide (optional)';
  String get addPreferredQual => isAr ? 'أضف مؤهلات المرشح المفضلة' : 'Add preferred candidate qualifications';
  String get niceToHaves => isAr ? 'مميزات إضافية' : 'Nice-To-Haves';
  String get niceToHavesHint => isAr ? 'أضف مهارات ومؤهلات إضافية' : 'Add nice-to-have skills and qualifications';
  String get basicInfo => isAr ? 'معلومات أساسية' : 'Basic Information';
  String get basicInfoHint => isAr ? 'معلومات أساسية عن الدور والشركة' : 'Basic info about role and company';
  String get perksAndBenefits => isAr ? 'المزايا والفوائد' : 'Perks and Benefits';
  String get openV2Step1 => isAr ? 'فتح النسخة 2 من الخطوة 1' : 'Open v2 of Step 1';
  String get openV2Step2 => isAr ? 'فتح النسخة 2 من الخطوة 2' : 'Open v2 of Step 2';
  String get details => isAr ? 'التفاصيل' : 'Details';
  String get listPerks => isAr ? 'اذكر المزايا (مفصولة بفاصلة)' : 'List perks and benefits (comma separated)';

  // ── Job Details ────────────────────────────────────────────────────────────
  String get descriptionSection => isAr ? 'الوصف' : 'Description';
  String get responsibilities => isAr ? 'المسؤوليات' : 'Responsibilities';
  String get niceToHavesSection => isAr ? 'مميزات إضافية' : 'Nice-To-Haves';
  String get aboutThisRole => isAr ? 'عن هذه الوظيفة' : 'About this role';
  String get salaryLabel => isAr ? 'الراتب' : 'Salary';
  String get jobTypeLabel => isAr ? 'نوع الوظيفة' : 'Job Type';
  String get categoryLabel => isAr ? 'الفئة' : 'Category';
  String get noDescriptionYet => isAr ? 'لا يوجد وصف بعد.' : 'No description yet.';
  String get noItemsYet => isAr ? 'لا توجد عناصر بعد' : 'No items yet';
  String get tableView => isAr ? 'جدول' : 'Table';
  String get pipelineView => isAr ? 'خط سير' : 'Pipeline';
  String get openFullTable => isAr ? 'فتح عرض الجدول الكامل' : 'Open Full Table View';
  String get openFullPipeline => isAr ? 'فتح عرض خط السير الكامل' : 'Open Full Pipeline View';
  String get editJobTooltip => isAr ? 'تعديل الوظيفة' : 'Edit job';
  String get deleteJobTooltip => isAr ? 'حذف الوظيفة' : 'Delete job';
  String get editJobTitle => isAr ? 'تعديل الوظيفة' : 'Edit Job';
  String get locationLabel => isAr ? 'الموقع' : 'Location';
  String get employmentTypeLabel => isAr ? 'نوع التوظيف' : 'Employment type';
  String get salaryRangeLabel => isAr ? 'نطاق الراتب' : 'Salary range';
  String get titleLabel => isAr ? 'العنوان' : 'Title';
  String get inReview => isAr ? 'قيد المراجعة' : 'In Review';
  String get shortlisted => isAr ? 'في القائمة المختصرة' : 'Shortlisted';

  // ── Candidates ─────────────────────────────────────────────────────────────
  String get applicantDetails => isAr ? 'تفاصيل المتقدم' : 'Applicant Details';
  String get contactSection => isAr ? 'بيانات التواصل' : 'Contact';
  String get quickActions => isAr ? 'إجراءات سريعة' : 'Quick actions';
  String get resumeLabel => isAr ? 'السيرة الذاتية' : 'Resume';
  String get hiringProgress => isAr ? 'تقدم التوظيف' : 'Hiring Progress';
  String get scheduleInterview => isAr ? 'جدولة المقابلة' : 'Schedule Interview';
  String get email => isAr ? 'البريد الإلكتروني' : 'Email';
  String get phone => isAr ? 'الهاتف' : 'Phone';
  String get locationInfo => isAr ? 'الموقع' : 'Location';
  String get currentStage => isAr ? 'المرحلة الحالية' : 'Current Stage';
  String get moveToNextStep => isAr ? 'الانتقال إلى الخطوة التالية' : 'Move To Next Step';
  String get notes => isAr ? 'الملاحظات' : 'Notes';
  String get interview => isAr ? 'مقابلة' : 'Interview';
  String get hired => isAr ? 'تم التوظيف' : 'Hired';
  String get declined => isAr ? 'مرفوض' : 'Declined';
  String get candidateHiredMsg => isAr ? 'تم توظيف المرشح بنجاح.' : 'Candidate has been marked as hired.';
  String get candidateDeclinedMsg => isAr ? 'تم رفض المرشح.' : 'Candidate has been declined.';
  String get candidateInterviewMsg => isAr ? 'المرشح في مرحلة المقابلة حاليًا.' : 'Candidate is currently in interview stage.';
  String get interviewSchedule => isAr ? 'جدول المقابلات' : 'Interview Schedule';
  String get interviewList => isAr ? 'قائمة المقابلات' : 'Interview List';
  String get addFeedback => isAr ? 'إضافة تغذية راجعة' : 'Add Feedback';
  String get addScheduleInterview => isAr ? 'إضافة مقابلة' : 'Add schedule interview';
  String get lastUsed => isAr ? 'آخر استخدام' : 'Last used';

  // ── Profile Settings ───────────────────────────────────────────────────────
  String get profileSettings => isAr ? 'إعدادات الملف الشخصي' : 'Profile Settings';
  String get overviewSection => isAr ? 'نظرة عامة' : 'Overview';
  String get socialLinks => isAr ? 'روابط التواصل' : 'Social Links';
  String get companyLogo => isAr ? 'شعار الشركة' : 'Company Logo';
  String get logoHint => isAr ? 'انقر للاستبدال أو اسحب وأفلت\nSVG أو PNG أو JPG أو GIF (الحد الأقصى 400x400 بكسل)' : 'Click to replace or drag and drop\nSVG, PNG, JPG or GIF (max. 400 x 400px)';
  String get website => isAr ? 'الموقع الإلكتروني' : 'Website';
  String get employee => isAr ? 'الموظفون' : 'Employee';
  String get industry => isAr ? 'القطاع' : 'Industry';
  String get dateFounded => isAr ? 'تاريخ التأسيس' : 'Date Founded';
  String get aboutCompany => isAr ? 'عن الشركة' : 'About Company';
  String get previewProfile => isAr ? 'معاينة ملف الشركة' : 'Preview Company Profile';
  String get socialLinksHint => isAr
      ? 'أضف روابط خارجية إلى ملف شركتك. يمكنك إضافة اسم المستخدم فقط دون الرابط الكامل.'
      : 'Add elsewhere links to your company profile. You can add only username without full https links.';
  String get addContactTitle => isAr ? 'إضافة جهة تواصل' : 'Add contact';
  String get editContactTitle => isAr ? 'تعديل جهة التواصل' : 'Edit contact';
  String get addSocialLink => isAr ? 'إضافة رابط تواصل اجتماعي' : 'Add social/contact link';
  String get editSocialLink => isAr ? 'تعديل رابط التواصل' : 'Edit social/contact link';
  String get nameLabel => isAr ? 'الاسم' : 'Name';
  String get urlOrHandle => isAr ? 'رابط أو معرف' : 'URL or handle';
  String get urlHandle => isAr ? 'رابط / معرف' : 'URL / handle';
  String get helpCenterBtn => isAr ? 'مركز المساعدة' : 'Help Center';

  // ── Company Profile ────────────────────────────────────────────────────────
  String get about => isAr ? 'نبذة عني' : 'About';
  String get editIntroTooltip => isAr ? 'تعديل التعريف' : 'Edit intro';
  String get contactSectionLabel => isAr ? 'بيانات التواصل' : 'Contact';
  String get addMoreContact => isAr ? 'إضافة المزيد' : 'Add more';

  // ── Help Center ────────────────────────────────────────────────────────────
  String get helpCenter => isAr ? 'مركز المساعدة' : 'Help Center';
  String get searchHelp => isAr ? 'البحث في المساعدة' : 'Search help';
  String get mostRelevant => isAr ? 'الأكثر صلة' : 'Most relevant';
  String get popularArticles => isAr ? 'المقالات الشائعة' : 'Popular articles';
  String get didntFindWhat => isAr ? 'لم تجد ما تبحث عنه؟' : "Didn't find what you were looking for?";
  String get contactCustomerService => isAr ? 'تواصل مع خدمة العملاء لدينا' : 'Contact our customer service';
  String get contactUs => isAr ? 'اتصل بنا' : 'Contact Us';
  String get wasArticleHelpful => isAr ? 'هل كان هذا المقال مفيدًا؟' : 'Was this article helpful?';

  // ── Messages / Chat ────────────────────────────────────────────────────────
  String get messages => isAr ? 'الرسائل' : 'Messages';
  String get replyMessage => isAr ? 'اكتب ردك' : 'Reply message';

  // ── Unknown route ──────────────────────────────────────────────────────────
  String get unknownRoute => isAr ? 'مسار غير معروف' : 'Unknown route';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
