import 'package:flutter/material.dart';

import '../../screens/company/auth/forgot_password_screen.dart';
import '../../screens/company/auth/otp_email_verification_screen.dart';
import '../../screens/company/auth/password_changed_dialog_screen.dart';
import '../../screens/company/auth/reset_password_screen.dart';
import '../../screens/company/auth/sign_in_screen.dart';
import '../../screens/company/auth/sign_up_screen.dart';
import '../../screens/company/candidates/applicant_details_profile_screen.dart';
import '../../screens/company/candidates/applicant_details_resume_screen.dart';
import '../../screens/company/candidates/applicant_hiring_progress_hired_declined_screen.dart';
import '../../screens/company/candidates/applicant_hiring_progress_interview_screen.dart';
import '../../screens/company/candidates/applicant_interview_schedule_screen.dart';
import '../../screens/company/help/help_center_screen.dart';
import '../../screens/company/home/dashboard_screen.dart';
import '../../screens/company/jobs/job_analytics_screen.dart';
import '../../screens/company/jobs/job_applicants_pipeline_view_screen.dart';
import '../../screens/company/jobs/job_applicants_table_view_screen.dart';
import '../../screens/company/jobs/job_details_screen.dart';
import '../../screens/company/jobs/jobs_hub_screen.dart';
import '../../screens/company/jobs/post_job/post_job_step1_information_screen.dart';
import '../../screens/company/jobs/post_job/post_job_step1_information_v2_screen.dart';
import '../../screens/company/jobs/post_job/post_job_step2_description_screen.dart';
import '../../screens/company/jobs/post_job/post_job_step2_description_v2_screen.dart';
import '../../screens/company/messages/chat_thread_candidate_v2_screen.dart';
import '../../screens/company/messages/chat_thread_screen.dart';
import '../../screens/company/messages/messages_list_screen.dart';
import '../../screens/company/onboarding/onboarding_future_starts_screen.dart';
import '../../screens/company/onboarding/onboarding_next_job_closer_screen.dart';
import '../../screens/company/onboarding/onboarding_smart_search_screen.dart';
import '../../screens/company/profile/company_edit_intro_screen.dart';
import '../../screens/company/profile/company_profile_screen.dart';
import '../../screens/company/profile/profile_settings_overview_screen.dart';
import '../../screens/company/profile/profile_settings_social_links_screen.dart';
import '../../screens/company/settings/appearance_settings_dark_screen.dart';
import '../../screens/company/settings/appearance_settings_light_screen.dart';
import '../../screens/company/settings/notification_setting_screen.dart';
import '../../screens/company/settings/notifications_screen.dart';
import '../../shared/models/applicant.dart';
import '../../shared/models/job.dart';
import '../../shared/models/message_thread.dart';

final class AppRoutes {
  static const companyOnboardingSmartSearch = '/company/onboarding/smart_search';
  static const companyOnboardingNextJobCloser =
      '/company/onboarding/next_job_closer';
  static const companyOnboardingFutureStarts =
      '/company/onboarding/future_starts';

  static const companySignIn = '/company/auth/sign_in';
  static const companySignUp = '/company/auth/sign_up';
  static const companyForgotPassword = '/company/auth/forgot_password';
  static const companyOtp = '/company/auth/otp';
  static const companyResetPassword = '/company/auth/reset_password';
  static const companyPasswordChanged = '/company/auth/password_changed';

  // Company shell areas
  static const companyDashboard = '/company/home/dashboard';
  static const companyMessagesList = '/company/messages/list';
  static const companyChatThread = '/company/messages/thread';
  static const companyChatThreadCandidateV2 = '/company/messages/thread_v2';

  static const companyJobsHub = '/company/jobs';
  static const companyApplicantsTable = '/company/jobs/applicants_table';
  static const companyApplicantsPipeline = '/company/jobs/applicants_pipeline';
  static const companyJobDetails = '/company/jobs/details';
  static const companyJobAnalytics = '/company/jobs/analytics';
  static const companyPostJobStep1 = '/company/jobs/post/step1';
  static const companyPostJobStep2 = '/company/jobs/post/step2';
  static const companyPostJobStep1v2 = '/company/jobs/post/step1_v2';
  static const companyPostJobStep2v2 = '/company/jobs/post/step2_v2';

  static const companyApplicantDetailsProfile = '/company/candidates/profile';
  static const companyApplicantDetailsResume = '/company/candidates/resume';
  static const companyApplicantHiringInterview =
      '/company/candidates/hiring_interview';
  static const companyApplicantHiringHiredDeclined =
      '/company/candidates/hiring_hired_declined';
  static const companyApplicantInterviewSchedule =
      '/company/candidates/interview_schedule';

  static const companyProfileOverview = '/company/profile/overview';
  static const companyProfileSocialLinks = '/company/profile/social_links';
  static const companyCompanyProfile = '/company/profile/company_profile';
  static const companyEditIntro = '/company/profile/edit_intro';

  static const companyAppearanceDark = '/company/settings/appearance_dark';
  static const companyAppearanceLight = '/company/settings/appearance_light';
  static const companyNotificationSetting = '/company/settings/notification';
  static const companyNotifications = '/company/notifications';
  static const companyHelpCenter = '/company/help/center';
}

final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments;

    Widget page;
    switch (name) {
      case AppRoutes.companyOnboardingSmartSearch:
        page = const CompanyOnboardingSmartSearchScreen();
      case AppRoutes.companyOnboardingNextJobCloser:
        page = const CompanyOnboardingNextJobCloserScreen();
      case AppRoutes.companyOnboardingFutureStarts:
        page = const CompanyOnboardingFutureStartsScreen();
      case AppRoutes.companySignIn:
        page = const CompanySignInScreen();
      case AppRoutes.companySignUp:
        page = const CompanySignUpScreen();
      case AppRoutes.companyForgotPassword:
        page = const CompanyForgotPasswordScreen();
      case AppRoutes.companyOtp:
        page = CompanyOtpEmailVerificationScreen(
          email: (args is String && args.isNotEmpty) ? args : 'example@mail.com',
        );
      case AppRoutes.companyResetPassword:
        page = const CompanyResetPasswordScreen();
      case AppRoutes.companyPasswordChanged:
        page = const CompanyPasswordChangedDialogScreen();
      case AppRoutes.companyDashboard:
        page = const CompanyDashboardScreen();
      case AppRoutes.companyMessagesList:
        page = const CompanyMessagesListScreen();
      case AppRoutes.companyChatThread:
        page = CompanyChatThreadScreen(
          thread: args is MessageThread ? args : MessageThread.mock(),
        );
      case AppRoutes.companyChatThreadCandidateV2:
        page = CompanyChatThreadCandidateV2Screen(
          thread: args is MessageThread ? args : MessageThread.mock(),
        );
      case AppRoutes.companyJobsHub:
        page = const CompanyJobsHubScreen();
      case AppRoutes.companyApplicantsTable:
        page = CompanyJobApplicantsTableViewScreen(
          job: args is Job ? args : Job.mock(),
        );
      case AppRoutes.companyApplicantsPipeline:
        page = CompanyJobApplicantsPipelineViewScreen(
          job: args is Job ? args : Job.mock(),
        );
      case AppRoutes.companyJobDetails:
        page = CompanyJobDetailsScreen(job: args is Job ? args : Job.mock());
      case AppRoutes.companyJobAnalytics:
        page = CompanyJobAnalyticsScreen(job: args is Job ? args : Job.mock());
      case AppRoutes.companyPostJobStep1:
        page = const CompanyPostJobStep1InformationScreen();
      case AppRoutes.companyPostJobStep2:
        page = const CompanyPostJobStep2DescriptionScreen();
      case AppRoutes.companyPostJobStep1v2:
        page = const CompanyPostJobStep1InformationV2Screen();
      case AppRoutes.companyPostJobStep2v2:
        page = const CompanyPostJobStep2DescriptionV2Screen();
      case AppRoutes.companyApplicantDetailsProfile:
        page = CompanyApplicantDetailsProfileScreen(
          applicant: args is Applicant ? args : Applicant.mock(),
        );
      case AppRoutes.companyApplicantDetailsResume:
        page = CompanyApplicantDetailsResumeScreen(
          applicant: args is Applicant ? args : Applicant.mock(),
        );
      case AppRoutes.companyApplicantHiringInterview:
        page = CompanyApplicantHiringProgressInterviewScreen(
          applicant: args is Applicant ? args : Applicant.mock(),
        );
      case AppRoutes.companyApplicantHiringHiredDeclined:
        page = CompanyApplicantHiringProgressHiredDeclinedScreen(
          applicant: args is Applicant ? args : Applicant.mock(),
        );
      case AppRoutes.companyApplicantInterviewSchedule:
        page = CompanyApplicantInterviewScheduleScreen(
          applicant: args is Applicant ? args : Applicant.mock(),
        );
      case AppRoutes.companyProfileOverview:
        page = const CompanyProfileSettingsOverviewScreen();
      case AppRoutes.companyProfileSocialLinks:
        page = const CompanyProfileSettingsSocialLinksScreen();
      case AppRoutes.companyCompanyProfile:
        page = const CompanyCompanyProfileScreen();
      case AppRoutes.companyEditIntro:
        final intro = args is CompanyEditIntroArgs ? args : null;
        page = CompanyEditIntroScreen(
          initialEnglish: intro?.english ?? '',
          initialArabic: intro?.arabic ?? '',
        );
      case AppRoutes.companyAppearanceDark:
        page = const CompanyAppearanceSettingsDarkScreen();
      case AppRoutes.companyAppearanceLight:
        page = const CompanyAppearanceSettingsLightScreen();
      case AppRoutes.companyNotificationSetting:
        page = const CompanyNotificationSettingScreen();
      case AppRoutes.companyNotifications:
        page = const CompanyNotificationsScreen();
      case AppRoutes.companyHelpCenter:
        page = const CompanyHelpCenterScreen();
      default:
        page = const _UnknownRouteScreen();
    }

    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unknown route')),
      body: Center(child: Text('Route not found: ${ModalRoute.of(context)?.settings.name}')),
    );
  }
}

