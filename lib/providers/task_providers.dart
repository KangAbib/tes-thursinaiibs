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
      // Kita bisa batasi jumlah data jika mau
      _tasks = fetchedTasks.take(20).toList();
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
      final created = await _apiService.addTask(newTask);
      // Karena API dummy, kita tetap tambahkan ke list lokal
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
    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      debugPrint('Warning deleteTask (simulasi lokal): $e');
    }
  }
}
