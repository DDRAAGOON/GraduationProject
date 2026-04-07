/// The [Applicant] model contains details about a candidate moving through
/// the hiring pipeline stages (e.g. In Review, Interview, Hired).
final class Applicant {
  /// Constructs a new [Applicant] instance.
  Applicant({
    required this.id,
    required this.fullName,
    required this.role,
    required this.rating,
    required this.stage,
    required this.email,
    required this.phone,
    required this.location,
    required this.appliedDateLabel,
  });

  final String id;
  final String fullName;
  final String role;
  final double rating;
  final String stage;
  final String email;
  final String phone;
  final String location;
  final String appliedDateLabel;

  /// Generates a static mock [Applicant] to populate the UI templates.
  static Applicant mock() => Applicant(
        id: 'app_1',
        fullName: 'Jerome Bell',
        role: 'Product Designer',
        rating: 4.0,
        stage: 'Interview',
        email: 'jeromebell45@email.com',
        phone: '+44 1245 572 135',
        location: 'Manchester, UK',
        appliedDateLabel: '2 days ago',
      );

  static List<Applicant> mockList() => [
        mock(),
        Applicant(
          id: 'app_2',
          fullName: 'Jake Gyll',
          role: 'Product Designer',
          rating: 0.0,
          stage: 'In Review',
          email: 'jake@email.com',
          phone: '+44 1245 111 111',
          location: 'Paris, France',
          appliedDateLabel: '13 July, 2021',
        ),
        Applicant(
          id: 'app_3',
          fullName: 'Jenny Wilson',
          role: 'Brand Designer',
          rating: 4.8,
          stage: 'Hired',
          email: 'jenny@email.com',
          phone: '+44 1245 222 222',
          location: 'Berlin, Germany',
          appliedDateLabel: '9 July, 2021',
        ),
      ];
}

