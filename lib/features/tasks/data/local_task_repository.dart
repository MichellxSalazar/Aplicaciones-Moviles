import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Modelar capa de datos con Room',
      description: 'Crear CategoryEntity, IngredientEntity y sus DAOs con Flow',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Implementar Repositorios y Mappers',
      description:
          'Mapear entidades a modelos de dominio limpios toDomainModel()',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Diseñar OrganizerScreen en Compose',
      description: 'Construir PrimaryTabRow, barra de búsqueda y LazyColumns',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Manejar estado en OrganizerViewModel',
      description: 'Exponer StateFlow con stateIn y WhileSubscribed(5000)',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Integrar navegación central',
      description:
          'Conectar OrganizerRoute en AppNavigation con ViewModelFactory',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  List<Task> getTasks() => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
