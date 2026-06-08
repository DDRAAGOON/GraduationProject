import 'dart:convert';

void main() {
  String jsonString = '{"companies":[{"id":"1","companyName":"Test","jobs":[]}], "total":4, "page":1, "limit":100, "totalPages":1}';
  Map<String, dynamic> data = jsonDecode(jsonString);
  List<dynamic> list = data['data'] ?? data['companies'] ?? data ?? [];
  print('List length: ${list.length}');
  
  List<Map<String, dynamic>> _companies = [];
  for (final item in list) {
    if (item is Map<String, dynamic>) {
      _companies.add(item);
    } else {
      print('item is NOT Map<String, dynamic>. It is ${item.runtimeType}');
    }
  }
  print('Companies: ${_companies.length}');
}
