class UserProfileData {
  static String fullName = "";
  static String aboutMe = "";
  static String phone = "";
  static String email = "";
  static String dob = "";
  static String gender = "";
  static String portfolioUrl = "";
  static String location = "";
  static String jobTitle = "";
  static String? cvName;
  static String? profileImage =
      "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg";
  static String? coverImage;

  static List<String> skills = [];
  static List<Map<String, String>> socialLinks = [];
  static List<Map<String, String>> experiences = [];
  static List<Map<String, String>> education = [];
  static List<String> portfolioImages = [];

  static double minSalary = 0;
  static double maxSalary = 0;
  static String salaryFrequency = "Monthly";
}
