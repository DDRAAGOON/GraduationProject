class PortfolioItem {
  final String title;
  final String imageUrl;
  final String linkUrl;

  PortfolioItem({
    required this.title,
    required this.imageUrl,
    required this.linkUrl,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      title: json['title'] ?? 'Untitled',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      linkUrl: json['linkUrl'] ?? '',
    );
  }
}
