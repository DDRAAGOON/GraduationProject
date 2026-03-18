import os


def mv(base_dir: str, src: str, dst: str) -> None:
    src_path = os.path.join(base_dir, src)
    dst_path = os.path.join(base_dir, dst)
    if not os.path.exists(src_path):
        raise FileNotFoundError(src_path)
    os.makedirs(os.path.dirname(dst_path), exist_ok=True)
    os.replace(src_path, dst_path)


def main() -> None:
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    user_dir = os.path.join(project_root, "lib", "screens", "user")
    company_dir = os.path.join(project_root, "lib", "screens", "company")

    # USER
    user_moves = [
        ("splash_screen.dart", "onboarding/splash_screen.dart"),
        ("onboarding_smart_search_screen.dart", "onboarding/onboarding_smart_search_screen.dart"),
        ("onboarding_next_job_closer_screen.dart", "onboarding/onboarding_next_job_closer_screen.dart"),
        ("onboarding_future_starts_screen.dart", "onboarding/onboarding_future_starts_screen.dart"),
        ("sign_in_screen.dart", "auth/sign_in_screen.dart"),
        ("sign_up_screen.dart", "auth/sign_up_screen.dart"),
        ("forgot_password_screen.dart", "auth/forgot_password_screen.dart"),
        ("otp_email_verification_screen.dart", "auth/otp_email_verification_screen.dart"),
        ("reset_password_screen.dart", "auth/reset_password_screen.dart"),
        ("password_changed_dialog_screen.dart", "auth/password_changed_dialog_screen.dart"),
        ("applications_dashboard_screen.dart", "home/applications_dashboard_screen.dart"),
        ("jobs_list_screen.dart", "jobs/jobs_list_screen.dart"),
        ("jobs_filters_screen.dart", "jobs/jobs_filters_screen.dart"),
        ("job_details_screen.dart", "jobs/job_details_screen.dart"),
        ("submit_application_screen.dart", "jobs/submit_application_screen.dart"),
        ("messages_list_screen.dart", "messages/messages_list_screen.dart"),
        ("chat_thread_screen.dart", "messages/chat_thread_screen.dart"),
        ("profile_overview_screen.dart", "profile/profile_overview_screen.dart"),
        ("profile_edit_basic_info_screen.dart", "profile/profile_edit_basic_info_screen.dart"),
        ("profile_login_details_screen.dart", "profile/profile_login_details_screen.dart"),
        ("profile_notification_preferences_screen.dart", "profile/profile_notification_preferences_screen.dart"),
        ("help_center_screen.dart", "help/help_center_screen.dart"),
        ("notification_setting_screen.dart", "settings/notification_setting_screen.dart"),
        ("appearance_settings_dark_screen.dart", "settings/appearance_settings_dark_screen.dart"),
        ("appearance_settings_light_screen.dart", "settings/appearance_settings_light_screen.dart"),
    ]

    for src, dst in user_moves:
        mv(user_dir, src, dst)

    # COMPANY
    company_moves = [
        ("splash_screen.dart", "onboarding/splash_screen.dart"),
        ("onboarding_smart_search_screen.dart", "onboarding/onboarding_smart_search_screen.dart"),
        ("onboarding_next_job_closer_screen.dart", "onboarding/onboarding_next_job_closer_screen.dart"),
        ("onboarding_future_starts_screen.dart", "onboarding/onboarding_future_starts_screen.dart"),
        ("sign_in_screen.dart", "auth/sign_in_screen.dart"),
        ("sign_up_screen.dart", "auth/sign_up_screen.dart"),
        ("forgot_password_screen.dart", "auth/forgot_password_screen.dart"),
        ("otp_email_verification_screen.dart", "auth/otp_email_verification_screen.dart"),
        ("password_changed_dialog_screen.dart", "auth/password_changed_dialog_screen.dart"),
        ("dashboard_screen.dart", "home/dashboard_screen.dart"),
        ("messages_list_screen.dart", "messages/messages_list_screen.dart"),
        ("chat_thread_screen.dart", "messages/chat_thread_screen.dart"),
        ("chat_thread_candidate_v2_screen.dart", "messages/chat_thread_candidate_v2_screen.dart"),
        ("job_applicants_table_view_screen.dart", "jobs/job_applicants_table_view_screen.dart"),
        ("job_applicants_pipeline_view_screen.dart", "jobs/job_applicants_pipeline_view_screen.dart"),
        ("job_details_screen.dart", "jobs/job_details_screen.dart"),
        ("job_analytics_screen.dart", "jobs/job_analytics_screen.dart"),
        ("post_job_step1_information_screen.dart", "jobs/post_job/post_job_step1_information_screen.dart"),
        ("post_job_step2_description_screen.dart", "jobs/post_job/post_job_step2_description_screen.dart"),
        ("post_job_step1_information_v2_screen.dart", "jobs/post_job/post_job_step1_information_v2_screen.dart"),
        ("post_job_step2_description_v2_screen.dart", "jobs/post_job/post_job_step2_description_v2_screen.dart"),
        ("applicant_details_profile_screen.dart", "candidates/applicant_details_profile_screen.dart"),
        ("applicant_details_resume_screen.dart", "candidates/applicant_details_resume_screen.dart"),
        ("applicant_hiring_progress_interview_screen.dart", "candidates/applicant_hiring_progress_interview_screen.dart"),
        ("applicant_hiring_progress_hired_declined_screen.dart", "candidates/applicant_hiring_progress_hired_declined_screen.dart"),
        ("applicant_interview_schedule_screen.dart", "candidates/applicant_interview_schedule_screen.dart"),
        ("company_profile_screen.dart", "profile/company_profile_screen.dart"),
        ("profile_settings_overview_screen.dart", "profile/profile_settings_overview_screen.dart"),
        ("profile_settings_social_links_screen.dart", "profile/profile_settings_social_links_screen.dart"),
        ("help_center_screen.dart", "help/help_center_screen.dart"),
        ("notification_setting_screen.dart", "settings/notification_setting_screen.dart"),
        ("appearance_settings_dark_screen.dart", "settings/appearance_settings_dark_screen.dart"),
        ("appearance_settings_light_screen.dart", "settings/appearance_settings_light_screen.dart"),
    ]

    for src, dst in company_moves:
        mv(company_dir, src, dst)

    print("OK: organized user + company screens into folders.")


if __name__ == "__main__":
    main()

