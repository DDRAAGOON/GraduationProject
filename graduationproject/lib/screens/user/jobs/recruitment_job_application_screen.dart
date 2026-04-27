import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentJobApplicationScreen extends StatefulWidget {
  const RecruitmentJobApplicationScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  State<RecruitmentJobApplicationScreen> createState() =>
      _RecruitmentJobApplicationScreenState();
}

class _RecruitmentJobApplicationScreenState
    extends State<RecruitmentJobApplicationScreen> {
  final _portfolio = TextEditingController();
  final _cover = TextEditingController();
  final _linkedIn = TextEditingController();
  bool _loading = false;
  String? _selectedCVName;

  @override
  void dispose() {
    _portfolio.dispose();
    _cover.dispose();
    _linkedIn.dispose();
    super.dispose();
  }

  Future<void> _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    
    if (result != null) {
      setState(() {
        _selectedCVName = result.files.single.name;
      });
    }
  }

  Future<void> _submit() async {
    if (_cover.text.trim().isEmpty || _selectedCVName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your CV and write a Cover Letter.')),
      );
      return;
    }
    
    setState(() => _loading = true);
    await RecruitmentSyncService.instance.applyToJob(
      jobId: widget.job.id,
      userName: RecruitmentSyncStore.instance.currentUserName,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted successfully.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Apply to Job',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.job.companyName} • ${widget.job.location}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          _buildInputField('Portfolio URL', _portfolio),
          _buildInputField('LinkedIn URL', _linkedIn),
          
          const SizedBox(height: 8),
          const Text('Curriculum Vitae (CV) *', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickCV,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedCVName ?? 'Upload your CV (PDF, DOC)',
                      style: TextStyle(color: _selectedCVName == null ? Colors.black38 : Colors.black87),
                    ),
                  ),
                  const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          _buildInputField('Cover letter *', _cover, maxLines: 5),
          
          const SizedBox(height: 24),
          AppButton(
            label: 'Submit Application',
            loading: _loading,
            onPressed: _loading ? null : _submit,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, 
      {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
