import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:notes_app/models/note.dart';

class NoteApiHelper {
  static final NoteApiHelper instance = NoteApiHelper._init();
  static const String baseUrl = 'https://my-json-server.typicode.com/leexiaolong15/testflutter';

  NoteApiHelper._init();

  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));
    print('getAllNotes: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách ghi chú: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Note?> getNoteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$id'));
    print('getNoteById: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      return Note.fromMap(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Không thể tải ghi chú: ${response.statusCode} - ${response.body}');
    }
  }

  Future<int> insertNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(note.toMap()..remove('id')),
    );
    print('insertNote: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['id'] ?? (DateTime.now().millisecondsSinceEpoch % 10000); // Fallback ID nếu API không trả về
    } else {
      throw Exception('Không thể tạo ghi chú: ${response.statusCode} - ${response.body}');
    }
  }

  Future<int> updateNote(Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(note.toMap()),
    );
    print('updateNote: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw Exception('Không thể cập nhật ghi chú: ${response.statusCode} - ${response.body}');
    }
  }

  Future<int> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
    print('deleteNote: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw Exception('Không thể xóa ghi chú: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Note>> getNotesByPriority(int priority) async {
    final response = await http.get(Uri.parse('$baseUrl/notes?priority=$priority'));
    print('getNotesByPriority: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Không thể tải ghi chú theo ưu tiên: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/notes?q=$query'));
    print('searchNotes: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Không thể tìm kiếm ghi chú: ${response.statusCode} - ${response.body}');
    }
  }
}