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
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _experience = TextEditingController();
  final _portfolio = TextEditingController();
  final _cvLink = TextEditingController();
  final _cover = TextEditingController();
  final _linkedIn = TextEditingController();
  bool _relocate = false;
  bool _authorizedToWork = true;
  bool _loading = false;
  String? _pickedPdfName;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;
    _name.text = store.currentUserName;
    _email.text = 'user@jobito.com';
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _experience.dispose();
    _portfolio.dispose();
    _cvLink.dispose();
    _cover.dispose();
    _linkedIn.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _phone.text.trim().isEmpty ||
        _cover.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete required fields.')),
      );
      return;
    }
    if (_pickedPdfName == null && _cvLink.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload CV PDF or provide CV link.')),
      );
      return;
    }
    setState(() => _loading = true);
    await RecruitmentSyncService.instance.applyToJob(
      jobId: widget.job.id,
      userName: _name.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted successfully.')),
    );
    Navigator.of(context).pop();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _pickedPdfName = result.files.single.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/company/logo/logo.png',
          height: 35,
          fit: BoxFit.contain,
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
          
          _buildInputField('Full name *', _name),
          _buildInputField('Email *', _email, keyboardType: TextInputType.emailAddress),
          _buildInputField('Phone *', _phone, keyboardType: TextInputType.phone),
          _buildInputField('Years of experience', _experience),
          _buildInputField('Portfolio URL', _portfolio),
          _buildInputField('LinkedIn URL', _linkedIn),
          _buildInputField('CV link', _cvLink),
          
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            onPressed: _pickPdf,
            icon: const Icon(Icons.upload_file),
            label: Text(
              _pickedPdfName == null
                  ? 'Upload CV as PDF'
                  : 'PDF: $_pickedPdfName',
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 16),
          _buildInputField('Cover letter *', _cover, maxLines: 5),
          
          CheckboxListTile(
            value: _relocate,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) => setState(() => _relocate = value ?? false),
            title: const Text('Open to relocation', style: TextStyle(fontSize: 14)),
          ),
          CheckboxListTile(
            value: _authorizedToWork,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) =>
                setState(() => _authorizedToWork = value ?? true),
            title: const Text('Authorized to work in job location', style: TextStyle(fontSize: 14)),
          ),
          
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
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
        ),
      ),
    );
  }
}
