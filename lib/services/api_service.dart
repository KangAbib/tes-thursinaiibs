// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

/// Kelas ini menangani semua request ke REST API
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// GET: Ambil daftar tugas
  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Convert list JSON ke list Task
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat tugas (status: ${response.statusCode})');
    }
  }

  /// POST: Tambah tugas baru
  Future<Task> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      // JSONPlaceholder mengembalikan object baru dengan ID palsu
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambah tugas');
    }
  }

  /// PUT: Edit tugas berdasarkan ID
  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengupdate tugas');
    }
  }

  /// DELETE: Hapus tugas berdasarkan ID
  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus tugas');
    }
    // Tidak perlu mengembalikan apa-apa, cukup sukses/hanya throw error jika gagal
  }
}
