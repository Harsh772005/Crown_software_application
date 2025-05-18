import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<TodoModel> _todos = [];
  List<TodoModel> _filteredTodos = [];
  bool _isLoading = true;
  bool _showCompletedOnly = false;
  bool _isSorted = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();

    _searchController.addListener(() {
      _applyFilters();
    });
  }

  Future<void> _loadTodos() async {
    try {
      final todos = await apiService.fetchTodos();
      setState(() {
        _todos = todos;
        _filteredTodos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching todos: $e");
    }
  }

  void _applyFilters() {
    String query = _searchController.text.toLowerCase();
    List<TodoModel> result = _todos.where((todo) {
      return todo.title.toLowerCase().contains(query);
    }).toList();

    if (_showCompletedOnly) {
      result = result.where((todo) => todo.completed).toList();
    }

    if (_isSorted) {
      result.sort((a, b) => a.id.compareTo(b.id));
    }

    setState(() {
      _filteredTodos = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search todos...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _isSorted = !_isSorted;
                _applyFilters();
              });
            },
          ),
          IconButton(
            icon: Icon(
              _showCompletedOnly ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () {
              setState(() {
                _showCompletedOnly = !_showCompletedOnly;
                _applyFilters();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredTodos.isEmpty
          ? const Center(child: Text("No todos found"))
          : ListView.separated(
        itemCount: _filteredTodos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final todo = _filteredTodos[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: todo.completed ? Colors.green : Colors.red,
              child: Icon(todo.completed ? Icons.check : Icons.close, color: Colors.white),
            ),
            title: Text(todo.title),
            subtitle: Text("ID: ${todo.id} | UserID: ${todo.userId}"),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
