import 'package:flutter/material.dart';
import 'package:testa/models/employe.dart';

/// Pass [initial] to pre-fill fields when editing.
/// [onSubmit] receives the built Employe and must return success bool.
class EmployeFormWidget extends StatefulWidget {
  final Employe? initial;
  final Future<bool> Function(Employe) onSubmit;
  final String submitLabel;

  const EmployeFormWidget({
    super.key,
    this.initial,
    required this.onSubmit,
    this.submitLabel = 'Guardar',
  });

  @override
  State<EmployeFormWidget> createState() => _EmployeFormWidgetState();
}

class _EmployeFormWidgetState extends State<EmployeFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _jobTitle;
  late final TextEditingController _phone;
  late final TextEditingController _imageUrl;
  late final TextEditingController _employeeCode;
  late final TextEditingController _dateContract;
  late bool _active;

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    _name         = TextEditingController(text: e?.name         ?? '');
    _email        = TextEditingController(text: e?.email        ?? '');
    _jobTitle     = TextEditingController(text: e?.jobTitle     ?? '');
    _phone        = TextEditingController(text: e?.phone        ?? '');
    _imageUrl     = TextEditingController(text: e?.imageUrl     ?? '');
    _employeeCode = TextEditingController(text: e?.employeeCode ?? '');
    _dateContract = TextEditingController(
        text: e?.dateContract?.toString() ?? '');
    _active = e?.active ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _jobTitle.dispose();
    _phone.dispose();
    _imageUrl.dispose();
    _employeeCode.dispose();
    _dateContract.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A1A1A)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dateContract.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final emp = Employe(
      id:           widget.initial?.id ?? 0,
      name:         _name.text.trim(),
      email:        _email.text.trim(),
      jobTitle:     _jobTitle.text.trim(),
      phone:        _phone.text.trim(),
      imageUrl:     _imageUrl.text.trim(),
      employeeCode: _employeeCode.text.trim(),
      active:       _active,
      dateContract: _dateContract.text.trim().isEmpty
          ? null
          : _dateContract.text.trim(),
    );

    final ok = await widget.onSubmit(emp);
    if (mounted) setState(() => _loading = false);
    if (ok && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        children: [
          _field('Nombre*',         _name,         validator: _req),
          _field('Email*',          _email,        type: TextInputType.emailAddress,
              validator: (v) => !v!.contains('@') ? 'Email inválido' : null),
          _field('Cargo*',          _jobTitle,     validator: _req),
          _field('Teléfono',        _phone,        type: TextInputType.phone),
          _field('Código empleado', _employeeCode),
          _field('URL imagen',      _imageUrl,     type: TextInputType.url),

          // Date picker field
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              controller: _dateContract,
              readOnly: true,
              onTap: _pickDate,
              decoration: _dec('Fecha de contrato').copyWith(
                suffixIcon: const Icon(Icons.calendar_today_outlined,
                    size: 18, color: Color(0xFF9E9E9E)),
              ),
            ),
          ),

          // Active toggle
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Activo',
                    style: TextStyle(fontSize: 14, color: Color(0xFF616161))),
                Switch.adaptive(
                  value: _active,
                  activeColor: const Color.fromARGB(255, 15, 120, 225),
                  onChanged: (v) => setState(() => _active = v),
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(widget.submitLabel,
                      style: const TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  String? _req(String? v) => v == null || v.isEmpty ? 'Requerido' : null;

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF1A1A1A), width: 1.2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFC62828), width: 1)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFC62828), width: 1.2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType? type,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator: validator,
          decoration: _dec(label),
        ),
      );
}