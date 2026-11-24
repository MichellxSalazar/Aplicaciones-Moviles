# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### API de tareas (sesión 7)

- **API usada:** JSONPlaceholder, una API pública de datos de prueba.
- **URL exacta:** `https://jsonplaceholder.typicode.com/todos?userId=[TU_USERID]`
- **Método:** GET (solo consulta).
- **Parámetro `userId`:** limita los resultados a las tareas de un usuario. Está definido en la constante `userId` de `TaskApiService`. Valor elegido: **[TU_USERID]**.
- **Campos que llegan de la API:** `userId`, `id`, `title` y `completed` (que TaskFlow guarda como `isCompleted`).
- **Valores que TaskFlow completa por defecto:** `description` ("Sin descripción (API)") y `priority` ("Sin prioridad (API)"). No vienen del servidor.
- **Marcar una tarea como completada es local:** solo cambia la copia en memoria. JSONPlaceholder no guarda cambios, así que al actualizar o reiniciar la app la marca desaparece.

## Estados de la lista (sesión 8)

La pantalla "Mis tareas" distingue cuatro situaciones. `TasksViewModel` guarda el estado (`isLoading`, `errorMessage` y `isEmpty`) y la vista lo dibuja con `context.watch`.

| Estado | Qué se muestra | Cómo lo provoqué |
|---|---|---|
| Carga | Indicador circular de progreso | Al abrir la app o pulsar Actualizar. Para verlo con más calma, limité la velocidad de red en [emulador / DevTools de Chrome → Network → Slow 3G]. No agregué esperas artificiales al código. |
| Éxito | Una tarjeta por cada tarea | Con internet y un `userId` válido ([1]). |
| Vacío | "Todavía no hay tareas para mostrar." y botón **Actualizar** | Cambié temporalmente `userId` a 9999 en `TaskApiService`, reinicié la app y la API respondió con una lista vacía. Luego restauré el valor válido. |
| Error | "No se pudieron cargar las tareas." y botón **Reintentar** | Desactivé internet en el navegador, con la pestaña Network en "Offline" y pulsé Actualizar. |

**Reintentar:** después del error, reactivé internet y pulsé **Reintentar**. La lista volvió sin reiniciar la app, porque el botón vuelve a llamar a `loadTasks()`.

**Diferencia entre vacío y error:** una lista vacía es una respuesta válida del servidor. Un error significa que no se sabe qué tareas hay. Por eso el vacío ofrece **Actualizar** y el error ofrece **Reintentar**.

**Actualizar:** el botón de la barra superior y el gesto de deslizar hacia abajo (RefreshIndicator) vuelven a consultar el servidor. Una tarea marcada como completada puede volver a su valor original, porque el cambio es solo local.