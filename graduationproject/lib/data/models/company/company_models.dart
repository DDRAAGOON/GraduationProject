class Company {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? description;
  final String? website;
  final String? location;
  final String status;

  Company({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.description,
    this.website,
    this.location,
    required this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      description: json['description'],
      website: json['website'],
      location: json['location'],
      status: json['status'] ?? 'Active',
    );
  }
}

class CompanyProfile {
  final String companyId;
  final String name;
  final String? description;
  final String? address;
  final String? contactEmail;
  final String? phone;
  final String? logoUrl;
  final String? bannerUrl;
  final String? website;
  final String? industry;
  final String? employees;
  final int? foundedYear;
  final int? foundedMonth;
  final int? foundedDay;
  final String? classification;
  final String? verificationStatus;
  final SocialLinks socialLinks;
  final List<String> benefits;
  final List<String> techStack;

  CompanyProfile({
    required this.companyId,
    required this.name,
    this.description,
    this.address,
    this.contactEmail,
    this.phone,
    this.logoUrl,
    this.bannerUrl,
    this.website,
    this.industry,
    this.employees,
    this.foundedYear,
    this.foundedMonth,
    this.foundedDay,
    this.classification,
    this.verificationStatus,
    required this.socialLinks,
    required this.benefits,
    required this.techStack,
  });

  factory CompanyProfile.fromMap(Map<String, dynamic> map) {
    return CompanyProfile(
      companyId: map['companyId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
      address: map['address']?.toString(),
      contactEmail: map['contactEmail']?.toString(),
      phone: map['phone']?.toString(),
      logoUrl: map['logoUrl']?.toString(),
      bannerUrl: map['bannerUrl']?.toString(),
      website: map['website']?.toString(),
      industry: map['industry']?.toString(),
      employees: map['employees']?.toString(),
      foundedYear: map['foundedYear'] != null
          ? int.tryParse(map['foundedYear'].toString())
          : null,
      foundedMonth: map['foundedMonth'] != null
          ? int.tryParse(map['foundedMonth'].toString())
          : null,
      foundedDay: map['foundedDay'] != null
          ? int.tryParse(map['foundedDay'].toString())
          : null,
      classification: map['classification']?.toString(),
      verificationStatus: map['verificationStatus']?.toString(),
      socialLinks: SocialLinks.fromMap(map['socialLinks'] ?? {}),
      benefits: map['benefits'] is List
          ? (map['benefits'] as List).where((b) => b != null).map((b) {
              if (b is String) return b;
              if (b is Map)
                return b['desc']?.toString() ??
                    b['description']?.toString() ??
                    '';
              return '';
            }).toList()
          : [],
      techStack: map['techStack'] is List
          ? List<String>.from(map['techStack'])
          : [],
    );
  }
}

class SocialLinks {
  final String? facebook;
  final String? twitter;
  final String? linkedin;
  final String? instagram;
  final String? youtube;

  SocialLinks({
    this.facebook,
    this.twitter,
    this.linkedin,
    this.instagram,
    this.youtube,
  });

  factory SocialLinks.fromMap(Map<String, dynamic> map) {
    return SocialLinks(
      facebook: map['facebook']?.toString(),
      twitter: map['twitter']?.toString(),
      linkedin: map['linkedin']?.toString(),
      instagram: map['instagram']?.toString(),
      youtube: map['youtube']?.toString(),
    );
  }
}

class CompanyStatistics {
  final int totalJobs;
  final int totalApplications;
  final int totalHired;
  final int totalViews;
  final double averageRating;

  CompanyStatistics({
    required this.totalJobs,
    required this.totalApplications,
    required this.totalHired,
    required this.totalViews,
    required this.averageRating,
  });

  factory CompanyStatistics.fromMap(Map<String, dynamic> map) {
    return CompanyStatistics(
      totalJobs: map['totalJobs'] as int? ?? 0,
      totalApplications: map['totalApplications'] as int? ?? 0,
      totalHired: map['totalHired'] as int? ?? 0,
      totalViews: map['totalViews'] as int? ?? 0,
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
