import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_aplikasi/providers/task_providers.dart';
import 'package:tes_aplikasi/screens/task_form_screen.dart';
import '../models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<TaskProvider>(context, listen: false).loadTasks());
  }

  void _openForm({Task? task}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(task: task),
      ),
    );
  }

  void _deleteTask(BuildContext context, int id) async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Tugas'),
        content: const Text('Yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await provider.deleteTask(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil dihapus')),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus tugas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final theme = Theme.of(context);

    return Scaffold(
  backgroundColor: const Color(0xFFBFD7ED), // biru muda lembut
  body: provider.isLoading
      ? const Center(child: CircularProgressIndicator(color: Colors.blue))
      : RefreshIndicator(
          onRefresh: provider.loadTasks,
          color: Colors.white,
          backgroundColor: const Color(0xFF264E9E),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                centerTitle: true,
                backgroundColor: const Color(0xFF264E9E), // biru tua
                elevation: 0,
                title: const Text(
                  'Daftar Tugas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = provider.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _TaskCard(
                          task: task,
                          cardColor: const Color(0xFF264E9E), // <-- biru tua
                          textColor: Colors.white,            // teks putih
                          onEdit: () => _openForm(task: task),
                          onDelete: () => _deleteTask(context, task.id),
                        ),
                      );
                    },
                    childCount: provider.tasks.length,
                  ),
                ),
              ),
            ],
          ),
        ),
  floatingActionButton: FloatingActionButton.extended(
    onPressed: () => _openForm(),
    icon: const Icon(Icons.add, color: Colors.white),
    label: const Text('Tambah', style: TextStyle(color: Colors.white)),
    backgroundColor: const Color(0xFF264E9E), // tombol biru tua
  ),
);

  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color cardColor;
  final Color textColor;

  const _TaskCard({
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(task.title, style: TextStyle(color: textColor)),
        subtitle: Text(
          task.completed ? 'Selesai' : 'Belum selesai',
          style: TextStyle(
            color: task.completed ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.white), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
