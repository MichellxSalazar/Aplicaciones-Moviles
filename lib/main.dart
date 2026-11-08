import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
}

const demoTasks = [
  Task(
    id: 1,
    title: 'Modelar capa de datos con Room',
    description: 'Crear CategoryEntity, IngredientEntity y sus DAOs con Flow',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 2,
    title: 'Implementar Repositorios y Mappers',
    description:
        'Mapear entidades a modelos de dominio limpios toDomainModel()',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 3,
    title: 'Diseñar OrganizerScreen en Compose',
    description: 'Construir PrimaryTabRow, barra de búsqueda y LazyColumns',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 4,
    title: 'Manejar estado en OrganizerViewModel',
    description: 'Exponer StateFlow con stateIn y WhileSubscribed(5000)',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 5,
    title: 'Integrar navegación central',
    description:
        'Conectar OrganizerRoute en AppNavigation con ViewModelFactory',
    priority: 'Alta',
    isCompleted: false,
  ),
];

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final taskId = int.parse(state.pathParameters['id']!);
        return TaskDetailScreen(taskId: taskId);
      },
    ),
  ],
);

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(task.title),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final task = demoTasks.firstWhere((item) => item.id == taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(task.description),
            const SizedBox(height: 16),
            Chip(label: Text('Prioridad: ${task.priority}')),
            const SizedBox(height: 12),
            Text(task.isCompleted ? 'Estado: completada' : 'Estado: pendiente'),
            const Spacer(),
            if (!task.isCompleted)
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.done),
                label: const Text('Marcar como completada'),
              ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al listado'),
            ),
          ],
        ),
      ),
    );
  }
}
