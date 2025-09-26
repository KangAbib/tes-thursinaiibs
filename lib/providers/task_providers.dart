// lib/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  /// Memuat daftar tugas dari API
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetchedTasks = await _apiService.fetchTasks();
     _tasks = []; 

    } catch (e) {
      // bisa tampilkan log atau lempar error
      debugPrint('Error loadTasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tambah tugas baru (simulasi lokal)
  Future<void> addTask(Task newTask) async {
  try {
    var created = await _apiService.addTask(newTask);

    // Buat ID unik lokal kalau API tidak memberi atau ID duplicate
    final existingIds = _tasks.map((t) => t.id).toSet();
    int newId = created.id;

    // Jika ID null atau sudah ada, buat ID baru
    while (existingIds.contains(newId)) {
      newId = DateTime.now().millisecondsSinceEpoch + existingIds.length;
    }

    created = created.copyWith(id: newId);

    _tasks.insert(0, created);
    notifyListeners();
  } catch (e) {
    debugPrint('Error addTask: $e');
    rethrow;
  }
}


  /// Update tugas (simulasi lokal)
  Future<void> updateTask(Task updatedTask) async {
    try {
      await _apiService.updateTask(updatedTask); // tidak perlu response
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      // tetap update lokal jika API gagal
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
      debugPrint('Warning updateTask (simulasi lokal): $e');
    }
  }

  /// Hapus tugas (simulasi lokal)
  Future<void> deleteTask(int id) async {
  debugPrint('Deleting task id=$id');
  try {
    await _apiService.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  } catch (e) {
    debugPrint('Warning deleteTask (simulasi lokal): $e');
  }
}


}
