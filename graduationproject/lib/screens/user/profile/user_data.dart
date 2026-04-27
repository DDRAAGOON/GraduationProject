class UserProfileData {
  static String fullName = "Ahmed Mohamed";
  static String aboutMe = "Experienced mobile developer with a passion for creating high-quality applications.";
  static String phone = "0123456789";
  static String email = "ahmed@example.com";
  static String dob = "1995-01-01";
  static String gender = "Male";
  static String portfolioUrl = "";
  static String location = "Cairo, Egypt";
  static String jobTitle = "Flutter Developer";
  static String? cvName;
  static String? profileImage;
  static String? coverImage;
  
  static List<String> skills = ["Flutter", "Dart", "Firebase", "Git", "UI/UX"];
  static List<Map<String, String>> socialLinks = [
    {"platform": "LinkedIn", "url": "linkedin.com/in/ahmed"},
    {"platform": "GitHub", "url": "github.com/ahmed"}
  ];
  static List<Map<String, String>> experiences = [
    {
      "title": "Senior Flutter Developer",
      "company": "Tech Solutions",
      "duration": "2021 - Present"
    },
    {
      "title": "Junior Developer",
      "company": "App Works",
      "duration": "2019 - 2021"
    }
  ];
  static List<Map<String, String>> education = [
    {
      "institution": "Cairo University",
      "degree": "Bachelor of Computer Science",
      "duration": "2014 - 2018"
    }
  ];
  static List<String> portfolioImages = [
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150"
  ];
  
  static double minSalary = 10000;
  static double maxSalary = 20000;
  static String salaryFrequency = "Monthly";
}
