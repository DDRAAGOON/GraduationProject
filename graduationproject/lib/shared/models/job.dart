final class JobBenefit {
  JobBenefit({required this.title, required this.description});
  final String title;
  final String description;

  Map<String, String> toMap() => {'title': title, 'description': description};
  factory JobBenefit.fromMap(Map<String, dynamic> map) => JobBenefit(
    title: map['title'] ?? '',
    description: map['description'] ?? '',
  );
}

/// The [Job] model represents a job posting created by a company.
/// It holds critical details used across the jobs hub and analytics screens.
final class Job {
  /// Constructs a new [Job] instance.
  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.employmentType,
    required this.category,
    required this.salaryRange,
    this.description = '',
    this.responsibilities = const [],
    this.niceToHaves = const [],
    this.qualifications = const [],
    this.benefits = const [],
    this.department = '',
    this.appliedCount,
    this.capacity,
  });

  final String id;
  final String title;
  final String companyName;
  final String location;
  final String employmentType;
  final String category;
  final String department;
  final String salaryRange;
  final String description;
  final List<String> responsibilities;
  final List<String> niceToHaves;
  final List<String> qualifications;
  final List<JobBenefit> benefits;
  final int? appliedCount;
  final int? capacity;

  /// Creates a copy of the current [Job] while allowing specific fields to be updated.
  Job copyWith({
    String? id,
    String? title,
    String? companyName,
    String? location,
    String? employmentType,
    String? category,
    String? department,
    String? salaryRange,
    String? description,
    List<String>? responsibilities,
    List<String>? niceToHaves,
    List<String>? qualifications,
    List<JobBenefit>? benefits,
    int? appliedCount,
    int? capacity,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      employmentType: employmentType ?? this.employmentType,
      category: category ?? this.category,
      department: department ?? this.department,
      salaryRange: salaryRange ?? this.salaryRange,
      description: description ?? this.description,
      responsibilities: responsibilities ?? this.responsibilities,
      niceToHaves: niceToHaves ?? this.niceToHaves,
      qualifications: qualifications ?? this.qualifications,
      benefits: benefits ?? this.benefits,
      appliedCount: appliedCount ?? this.appliedCount,
      capacity: capacity ?? this.capacity,
    );
  }

  /// Generates a mock [Job] instance primarily for UI testing purposes.
  static Job mock() => Job(
    id: 'job_1',
    title: 'Social Media Assistant',
    companyName: 'Nomad',
    location: 'Paris, France',
    employmentType: 'Full-Time',
    category: 'Marketing',
    salaryRange: r'$15k-$85k USD',
    description:
        'Stripe is looking for Social Media Marketing expert to help manage our online networks.',
    responsibilities: [
      'Community engagement to ensure that we support and actively represented online',
      'Focus on social media content development and publication',
      'Marketing and strategy support',
    ],
    niceToHaves: [
      'Project management skills',
      'Copy editing skills',
      'Experience with online communities',
    ],
    appliedCount: 5,
    capacity: 10,
  );

  static List<Job> mockList() => [];
}
