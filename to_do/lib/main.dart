import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Lista',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
      home: const TodoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoTask {
  String text;
  bool isDone;
  TodoTask({required this.text, this.isDone = false});
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<TodoTask> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _tasks.add(TodoTask(text: text));
        _controller.clear();
      });
    }
  }

  void _toggleDone(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Widget _buildTaskTile(TodoTask task, int index) {
    return Dismissible(
      key: Key('${task.text}-$index'),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _removeTask(index),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Checkbox(
            value: task.isDone,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            activeColor: Colors.indigo,
            onChanged: (value) => _toggleDone(index),
          ),
          title: Text(
            task.text,
            style: TextStyle(
              fontSize: 18,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? Colors.grey : Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            onPressed: () => _removeTask(index),
            tooltip: 'Usuń',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moja lista zadań'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo[400],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Dodaj nowe zadanie...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: _addTask,
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.indigo[100]),
                        const SizedBox(height: 16),
                        Text(
                          'Brak zadań!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 18),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) =>
                        _buildTaskTile(_tasks[index], index),
                  ),
          ),
        ],
      ),
    );
  }
}
