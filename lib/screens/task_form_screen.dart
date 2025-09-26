import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_aplikasi/providers/task_providers.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _completed = widget.task?.completed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    final isEdit = widget.task != null;

    // Warna tema
    const Color primaryBlue = Color(0xFF264E9E);
    const Color lightBlue   = Color(0xFFBFD7ED);

    return Scaffold(
      backgroundColor: lightBlue, // Biru muda lembut untuk background layar
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: Text(
          isEdit ? 'Edit Tugas' : 'Tambah Tugas',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Judul
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: primaryBlue),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryBlue.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryBlue, width: 2),
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // Checkbox Selesai
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  value: _completed,
                  title: const Text(
                    'Tugas Selesai?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  activeColor: primaryBlue,
                  onChanged: (v) => setState(() => _completed = v ?? false),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan/Tambah
              ElevatedButton.icon(
                icon: Icon(
                  isEdit ? Icons.save_rounded : Icons.add_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  isEdit ? 'Simpan' : 'Tambah',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  minimumSize: const Size.fromHeight(55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black45,
                  elevation: 6,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isEdit) {
                      provider.updateTask(
                        widget.task!.copyWith(
                          title: _titleCtrl.text,
                          completed: _completed,
                        ),
                      );
                    } else {
                      provider.addTask(
                        Task(
                          userId: 1,
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: _titleCtrl.text,
                          completed: _completed,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
