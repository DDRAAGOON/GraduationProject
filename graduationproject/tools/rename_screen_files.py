import os


def rename_many(base_dir: str, mapping: list[tuple[str, str]]) -> None:
    os.makedirs(base_dir, exist_ok=True)
    for old_name, new_name in mapping:
        old_path = os.path.join(base_dir, old_name)
        new_path = os.path.join(base_dir, new_name)

        if not os.path.exists(old_path):
            raise FileNotFoundError(old_path)

        os.makedirs(os.path.dirname(new_path), exist_ok=True)
        os.replace(old_path, new_path)


def main() -> None:
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    user_dir = os.path.join(project_root, "lib", "screens", "user")
    company_dir = os.path.join(project_root, "lib", "screens", "company")

    user = [
        ("user_screen_01.dart", "splash_screen.dart"),
        ("user_screen_02.dart", "onboarding_smart_search_screen.dart"),
        ("user_screen_03.dart", "onboarding_next_job_closer_screen.dart"),
        ("user_screen_04.dart", "onboarding_future_starts_screen.dart"),
        ("user_screen_05.dart", "sign_in_screen.dart"),
        ("user_screen_06.dart", "sign_up_screen.dart"),
        ("user_screen_07.dart", "forgot_password_screen.dart"),
        ("user_screen_08.dart", "otp_email_verification_screen.dart"),
        ("user_screen_09.dart", "password_changed_dialog_screen.dart"),
        ("user_screen_10.dart", "applications_dashboard_screen.dart"),
        ("user_screen_11.dart", "messages_list_screen.dart"),
        ("user_screen_12.dart", "chat_thread_screen.dart"),
        ("user_screen_13.dart", "jobs_list_screen.dart"),
        ("user_screen_14.dart", "jobs_filters_screen.dart"),
        ("user_screen_15.dart", "job_details_screen.dart"),
        ("user_screen_16.dart", "submit_application_screen.dart"),
        ("user_screen_17.dart", "profile_overview_screen.dart"),
        ("user_screen_18.dart", "profile_edit_basic_info_screen.dart"),
        ("user_screen_19.dart", "profile_login_details_screen.dart"),
        ("user_screen_20.dart", "profile_notification_preferences_screen.dart"),
        ("user_screen_21.dart", "help_center_screen.dart"),
        ("user_screen_22.dart", "notification_setting_screen.dart"),
        ("user_screen_23.dart", "appearance_settings_dark_screen.dart"),
        ("user_screen_24.dart", "appearance_settings_light_screen.dart"),
        ("user_screen_25.dart", "reset_password_screen.dart"),
    ]

    company = [
        ("company_screen_01.dart", "splash_screen.dart"),
        ("company_screen_02.dart", "onboarding_next_job_closer_screen.dart"),
        ("company_screen_03.dart", "onboarding_smart_search_screen.dart"),
        ("company_screen_04.dart", "onboarding_future_starts_screen.dart"),
        ("company_screen_05.dart", "sign_in_screen.dart"),
        ("company_screen_06.dart", "sign_up_screen.dart"),
        ("company_screen_07.dart", "forgot_password_screen.dart"),
        ("company_screen_08.dart", "otp_email_verification_screen.dart"),
        ("company_screen_09.dart", "password_changed_dialog_screen.dart"),
        ("company_screen_10.dart", "dashboard_screen.dart"),
        ("company_screen_11.dart", "messages_list_screen.dart"),
        ("company_screen_12.dart", "chat_thread_screen.dart"),
        ("company_screen_13.dart", "job_applicants_table_view_screen.dart"),
        ("company_screen_14.dart", "job_applicants_pipeline_view_screen.dart"),
        ("company_screen_15.dart", "job_details_screen.dart"),
        ("company_screen_16.dart", "job_analytics_screen.dart"),
        ("company_screen_17.dart", "applicant_details_profile_screen.dart"),
        ("company_screen_18.dart", "applicant_details_resume_screen.dart"),
        ("company_screen_19.dart", "applicant_hiring_progress_interview_screen.dart"),
        ("company_screen_20.dart", "applicant_hiring_progress_hired_declined_screen.dart"),
        ("company_screen_21.dart", "applicant_interview_schedule_screen.dart"),
        ("company_screen_22.dart", "appearance_settings_dark_screen.dart"),
        ("company_screen_23.dart", "post_job_step2_description_screen.dart"),
        ("company_screen_24.dart", "post_job_step1_information_screen.dart"),
        ("company_screen_25.dart", "profile_settings_overview_screen.dart"),
        ("company_screen_26.dart", "chat_thread_candidate_v2_screen.dart"),
        ("company_screen_27.dart", "post_job_step1_information_v2_screen.dart"),
        ("company_screen_28.dart", "post_job_step2_description_v2_screen.dart"),
        ("company_screen_29.dart", "company_profile_screen.dart"),
        ("company_screen_30.dart", "profile_settings_social_links_screen.dart"),
        ("company_screen_31.dart", "help_center_screen.dart"),
        ("company_screen_32.dart", "appearance_settings_light_screen.dart"),
        ("company_screen_33.dart", "notification_setting_screen.dart"),
    ]

    rename_many(user_dir, user)
    rename_many(company_dir, company)

    print("OK: renamed user + company screen files.")


if __name__ == "__main__":
    main()

