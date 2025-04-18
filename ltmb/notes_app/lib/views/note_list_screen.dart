import 'package:flutter/material.dart';
import 'package:notes_app/db/note_api_helper.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/views/note_form.dart';
import 'package:notes_app/views/note_item.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _localNotes = []; // Danh sách cục bộ để quản lý ghi chú
  bool _isGridView = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Tải dữ liệu khi khởi động
  }

  // Tải danh sách ghi chú từ API
  Future<void> _loadNotes() async {
    try {
      final notes = await NoteApiHelper.instance.getAllNotes();
      setState(() {
        _localNotes = notes; // Cập nhật danh sách cục bộ
      });
      print('Đã tải ${_localNotes.length} ghi chú từ API');
    } catch (e) {
      print('Lỗi khi tải ghi chú: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải ghi chú: $e')),
      );
    }
  }

  // Thêm ghi chú mới
  Future<void> _addNote(Note newNote) async {
    try {
      final newId = await NoteApiHelper.instance.insertNote(newNote);
      setState(() {
        _localNotes.add(newNote.copyWith(id: newId)); // Thêm vào danh sách cục bộ
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm ghi chú thành công')),
      );
    } catch (e) {
      print('Lỗi khi thêm ghi chú: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm ghi chú: $e')),
      );
    }
  }

  // Cập nhật ghi chú
  Future<void> _updateNote(Note updatedNote) async {
    try {
      await NoteApiHelper.instance.updateNote(updatedNote);
      setState(() {
        final index = _localNotes.indexWhere((n) => n.id == updatedNote.id);
        if (index != -1) {
          _localNotes[index] = updatedNote; // Cập nhật danh sách cục bộ
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật ghi chú thành công')),
      );
    } catch (e) {
      print('Lỗi khi cập nhật ghi chú: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật ghi chú: $e')),
      );
    }
  }

  // Xóa ghi chú
  Future<void> _deleteNote(int id) async {
    try {
      await NoteApiHelper.instance.deleteNote(id);
      setState(() {
        _localNotes.removeWhere((n) => n.id == id); // Xóa khỏi danh sách cục bộ
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa ghi chú thành công')),
      );
    } catch (e) {
      print('Lỗi khi xóa ghi chú: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa ghi chú: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách ghi chú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotes, // Làm mới dữ liệu từ API
          ),
        ],
      ),
      body: _localNotes.isEmpty
          ? const Center(child: Text('Không có ghi chú nào'))
          : ListView.builder(
        itemCount: _localNotes.length,
        itemBuilder: (context, index) {
          final note = _localNotes[index];
          return NoteItem(
            note: note,
            isGridView: _isGridView,
            onDelete: () => _deleteNote(note.id!),
            onEdit: (updatedNote) async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteForm(note: updatedNote),
                ),
              );
              if (result != null) {
                _updateNote(result); // Cập nhật ghi chú khi có kết quả
              }
            },
            onToggleComplete: (note) async {
              final updatedNote = note.copyWith(isCompleted: !note.isCompleted);
              _updateNote(updatedNote); // Cập nhật trạng thái hoàn thành
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteForm()),
          );
          if (newNote != null) {
            _addNote(newNote); // Thêm ghi chú mới
          }
        },
      ),
    );
  }
}