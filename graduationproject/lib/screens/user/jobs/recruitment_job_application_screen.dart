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
      appBar: AppBar(title: const Text('Apply To Job')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.job.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text('${widget.job.companyName} • ${widget.job.location}'),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Full name *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _experience,
            decoration: const InputDecoration(labelText: 'Years of experience'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _portfolio,
            decoration: const InputDecoration(labelText: 'Portfolio URL'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _linkedIn,
            decoration: const InputDecoration(labelText: 'LinkedIn URL'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cvLink,
            decoration: const InputDecoration(labelText: 'CV link'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickPdf,
            icon: const Icon(Icons.upload_file),
            label: Text(
              _pickedPdfName == null
                  ? 'Upload CV as PDF'
                  : 'PDF: $_pickedPdfName',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cover,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Cover letter *',
              alignLabelWithHint: true,
            ),
          ),
          CheckboxListTile(
            value: _relocate,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) => setState(() => _relocate = value ?? false),
            title: const Text('Open to relocation'),
          ),
          CheckboxListTile(
            value: _authorizedToWork,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) =>
                setState(() => _authorizedToWork = value ?? true),
            title: const Text('Authorized to work in job location'),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Submit Application',
            loading: _loading,
            onPressed: _loading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
