import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/network/secure_storage.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../constants/app_images.dart';
import '../widgets/company_bottom_nav.dart';
import '../widgets/glowing_chatbot_fab.dart';
import '../../user/messages/chat_thread_screen.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/models/job.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  bool _isLoading = true;
  String? _error;

  Map<String, dynamic>? _companyProfile;
  Map<String, dynamic>? _dashboardStats;
  List<dynamic> _latestJobs = [];

  Dio? _dio;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initDashboard();
  }

  Future<void> _initDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _token = await SecureStorage.getToken();

      // 1. فحص مبكر للتوكن للتأكد من أن المستخدم مسجل الدخول
      if (_token == null || _token!.isEmpty) {
        if (mounted) {
          setState(() {
            _error = 'يجب عليك تسجيل الدخول أولاً للوصول إلى لوحة التحكم.';
            _isLoading = false;
          });
          // توجيه المستخدم لشاشة تسجيل الدخول تلقائياً
          Navigator.of(context).pushReplacementNamed(AppRoutes.companyLogin);
        }
        return;
      }

      _dio = Dio(
        BaseOptions(
          baseUrl: 'https://jobito-api-production.up.railway.app/api',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      // 2. Fetch company profile to get companyId
      final profileResponse = await _dio!.get('/companies/my/profile');
      final profileData = profileResponse.data;

      final profile = profileData['data'] ?? profileData;
      final companyId =
          profile['id'] ?? profile['companyId'] ?? profile['company_id'];

      if (companyId == null) {
        throw Exception('Could not find company ID in profile response');
      }

      // 3. Fetch dashboard summary
      final statsResponse = await _dio!.get('/companies/my/dashboard-summary');
      final statsData = statsResponse.data;
      final stats = statsData['data'] ?? statsData;

      // 4. Fetch latest jobs
      final jobsResponse = await _dio!.get(
        '/jobs',
        queryParameters: {'companyId': companyId, 'limit': 4},
      );
      final jobsData = jobsResponse.data;
      final jobs = jobsData['data'] ?? jobsData['jobs'] ?? [];

      if (mounted) {
        setState(() {
          _companyProfile = profile;
          _dashboardStats = stats;
          _latestJobs = List.from(jobs);
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          // التعامل المخصص مع خطأ 401 Unauthorized
          if (e.response?.statusCode == 401) {
            _error =
                'انتهت صلاحية الجلسة أو ليس لديك صلاحية. برجاء تسجيل الدخول مجدداً.';
            // توجيه المستخدم لتسجيل الدخول إذا انتهت الجلسة
            SecureStorage.deleteToken();
            Navigator.of(context).pushReplacementNamed(AppRoutes.companyLogin);
          } else {
            _error = 'Network error: ${e.response?.statusMessage ?? e.message}';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'An error occurred: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _initDashboard();
  }

  int _getStat(Map<String, dynamic>? stats, String camelKey, String snakeKey) {
    if (stats == null) return 0;
    return stats[camelKey] ?? stats[snakeKey] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final tLocal = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xE8131313),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _companyProfile != null
            ? Text(
                '${tLocal.tr(en: 'Hello', ar: 'مرحباً')}, ${_companyProfile!['name'] ?? _companyProfile!['companyName'] ?? _companyProfile!['company_name'] ?? 'Company'}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                tLocal.tr(en: 'Dashboard', ar: 'لوحة التحكم'),
                style: const TextStyle(color: Colors.white),
              ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: Colors.blueAccent,
        backgroundColor: const Color(0xFF222222),
        child: _buildBody(),
      ),
      bottomNavigationBar: const CompanyBottomNav(current: CompanyTab.home),
      floatingActionButton: GlowingChatbotFAB(
        onTap: () {
          final tLocal = AppLocalizations.of(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatThreadScreen(
                name: tLocal.isAr
                    ? 'مساعد جوبيتو الذكي'
                    : 'Jobito AI Assistant',
                image: AppImages.jobito,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    final tLocal = AppLocalizations.of(context);

    if (_isLoading && _companyProfile == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    if (_error != null && _companyProfile == null) {
      return _buildErrorState();
    }

    final newCandidates = _getStat(
      _dashboardStats,
      'newCandidates',
      'new_candidates',
    );
    final acceptedCandidates = _getStat(
      _dashboardStats,
      'acceptedCandidates',
      'accepted_candidates',
    );

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Statistics Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: tLocal.tr(en: 'New Candidates', ar: 'مرشحون جدد'),
                    value: newCandidates.toString(),
                    icon: Icons.person_add_alt_1,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard(
                    title: tLocal.tr(en: 'Accepted', ar: 'مقبولين'),
                    value: acceptedCandidates.toString(),
                    icon: Icons.check_circle_outline,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // Latest Jobs Section
            Text(
              tLocal.tr(en: 'Latest Jobs', ar: 'أحدث الوظائف'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            _latestJobs.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Text(
                        tLocal.tr(
                          en: 'No jobs posted yet.',
                          ar: 'لا توجد وظائف تم نشرها بعد.',
                        ),
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _latestJobs.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final job = _latestJobs[index];
                      return _buildJobCard(job);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    final tLocal = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 56.w,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    _error ??
                        tLocal.tr(
                          en: 'An unexpected error occurred.',
                          ar: 'حدث خطأ غير متوقع.',
                        ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: _initDashboard,
                    icon: const Icon(Icons.refresh),
                    label: Text(tLocal.tr(en: 'Retry', ar: 'إعادة المحاولة')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.w),
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(dynamic job) {
    final title = job['title']?.toString() ?? 'Unknown Job';
    final address =
        job['address']?.toString() ?? job['location']?.toString() ?? 'Remote';

    // Safely parse jobType since it could be an array in the backend
    String jobType = 'Full-time';
    final rawJobType = job['jobType'] ?? job['job_type'];
    if (rawJobType is List && rawJobType.isNotEmpty) {
      jobType = rawJobType.join(' • ');
    } else if (rawJobType != null) {
      jobType = rawJobType.toString();
    }

    final availableSlots =
        job['availableSlots'] ?? job['available_slots'] ?? job['capacity'] ?? 0;

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.companyJobDetails, arguments: Job.fromMap(job));
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    jobType,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white54,
                  size: 16.w,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.people_outline, color: Colors.white54, size: 16.w),
                SizedBox(width: 4.w),
                Text(
                  '$availableSlots slots',
                  style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
