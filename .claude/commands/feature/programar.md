---
argument-hint: [siguiente|todo] [contexto-adicional]
description: Programar tareas del plan organizado (siguiente tarea o todas)
---

# Programar

Programa tareas del plan organizado orquestando agentes especializados según necesidades.

**Uso**: `/feature:programar [siguiente|todo] [contexto-adicional]`

## Qué Hace Este Comando

Programa las tareas del plan organizado, creando el código necesario (modelos, servicios, controllers, views, tests) según el tipo de tarea y actualizando el progreso.

**Modos de operación**:
- `siguiente` (por defecto): Implementa la siguiente tarea pendiente (verificando dependencias)
- `todo`: Implementa TODAS las tareas pendientes del plan (sin verificar dependencias)

## Implementación

### 0. Determinar Modo de Operación
- Leer primer argumento `$1`:
  - Si es "siguiente" o está vacío: modo = `siguiente`
  - Si es "todo": modo = `todo`
  - Si es otro valor: modo = `siguiente` y tratar como contexto adicional
- Resto de argumentos ($2, $3, etc.) se tratan como contexto adicional

### 1. Determinar Feature Actual
- Leer `_features/current-feature`
- Si no existe current-feature, mostrar error: "No hay feature actual. Usa /feature:cambiar <nombre> primero."

### 2. Validar Plan Organizado Existe
- Verificar que existe `_features/active/[feature-actual]/plan-organized.md`
- Si no existe, mostrar error: "Necesitas ejecutar /feature:organizar-plan primero"

### 3. Identificar Tareas a Implementar

**Si modo = `siguiente`**:
Leer `plan-organized.md` y:
- Buscar la primera tarea con checkbox `[ ]` (no completada)
- Verificar que sus dependencias previas en la misma capacidad estén completas `[x]`
- Si todas las dependencias no están completas, buscar la siguiente tarea disponible
- Identificar a qué capacidad de usuario pertenece la tarea
- Leer contexto de esa capacidad (valor usuario, dependencias, riesgos)
- Guardar tarea en lista para procesar

**Si modo = `todo`**:
Leer `plan-organized.md` y:
- Identificar TODAS las tareas con checkbox `[ ]` (no completadas)
- Agregar todas las tareas a la lista para procesar
- NO verificar dependencias - programar todas las tareas pendientes

**Si todas las tareas `[ ]` están completadas `[x]`** (aplica a ambos modos):
- Informar: "¡Todas las tareas están completas! Ejecuta /feature:archivar [nombre-feature] para archivar la feature."
- Terminar ejecución

### 4. Leer Contexto para Implementación
- Leer `_features/active/[feature-actual]/plan-organized.md` completo
- Leer `_features/active/[feature-actual]/PRD.md` para requisitos
- Leer capacidad específica donde está la tarea
- Incorporar contexto adicional de `$ARGUMENTS` si está presente

### 5. Analizar Tipo de Tarea
Basándose en la descripción de la tarea, determinar categoría:

**Tarea Backend** (contiene: "migración", "modelo", "service object", "controller", "ruta", "job"):
- Implementar código Rails backend
- Seguir patrones SOLID y arquitectura limpia
- Considerar multi-tenancy

**Tarea Frontend** (contiene: "view", "partial", "componente UI", "form"):
- Implementar templates ERB
- Aplicar Tailwind CSS del sistema de diseño
- Considerar responsive y accesibilidad

**Tarea Interactividad** (contiene: "Turbo", "Stimulus", "tiempo real", "modal", "actualización"):
- Implementar Turbo Frames/Streams
- Crear Stimulus controllers si necesario
- Configurar broadcasts ActionCable si aplica

**Tarea Testing** (contiene: "test", "spec", "system test"):
- Implementar specs RSpec
- Seguir convenciones de testing del proyecto

### 6. Implementar Código de las Tareas

**Para cada tarea** en la lista de tareas a implementar (1 en modo `siguiente`, N en modo `todo`):

Según el tipo de tarea identificado en paso 5, implementar código siguiendo patrones del proyecto:

**Para Tarea Backend**:
- Crear migración Rails con timestamp y nombre descriptivo
- Crear modelo con validaciones, relaciones y scopes necesarios
- Crear Service Object si la lógica es compleja (más de validaciones simples)
- Crear controller con acciones REST apropiadas
- Definir rutas en `config/routes.rb`
- Crear job Solid Queue si hay procesamiento asíncrono
- Aplicar multi-tenancy con `account_id` donde corresponda
- Seguir principios SOLID (especialmente SRP)

**Para Tarea Frontend**:
- Crear view ERB en directorio apropiado del controller
- Crear partials reutilizables si hay componentes repetidos
- Aplicar clases Tailwind CSS del sistema de diseño existente
- Implementar diseño responsive (mobile-first)
- Agregar ARIA labels para accesibilidad
- Manejar estados visuales (hover, focus, disabled, loading)

**Para Tarea Interactividad**:
- Crear Turbo Frame con ID único y descriptivo
- Configurar Turbo Stream para actualizaciones en tiempo real si necesario
- Crear Stimulus controller en `app/javascript/controllers/`
- Definir targets, values y actions en el controller
- Implementar métodos con lógica clara y simple
- Configurar broadcast ActionCable en modelo si es tiempo real
- Manejar errores y mostrar feedback al usuario

**Para Tarea Testing**:
- Crear spec RSpec en directorio apropiado (`spec/models/`, `spec/services/`, etc.)
- Escribir tests unitarios para modelos y servicios
- Escribir tests de integración para controllers
- Crear system tests para flujos completos de usuario
- Verificar multi-tenancy en tests
- Seguir convenciones RSpec del proyecto (factories, helpers, etc.)

### 7. Actualizar Plan Organizado

Modificar `_features/active/[feature-actual]/plan-organized.md`:
- **Modo `siguiente`**: Cambiar `[ ]` a `[x]` para la tarea recién implementada
- **Modo `todo`**: Cambiar `[ ]` a `[x]` para TODAS las tareas recién implementadas
- Opcionalmente añadir nota si hay decisiones importantes: `[x] Tarea completada (nota: decisión X tomada)`

### 8. Contar Tareas Completadas
- Leer `plan-organized.md` actualizado
- Contar todos los checkboxes completados `[x]`
- Comparar con `implementation.total_tasks` del estado

### 9. Actualizar Estado de la Feature
Modificar `_features/state.json`:

- Actualizar implementation:
  ```json
  "implementation": {
    "started_at": "[timestamp de primera implementación si es null]",
    "last_implementation": "[timestamp ISO 8601 actual]",
    "total_tasks": [mantener el número existente],
    "completed_tasks": [número contado en paso 8]
  }
  ```

- Actualizar documento plan-organized.md:
  ```json
  "documents": {
    "plan-organized.md": {
      "exists": true,
      "created_at": "[mantener existente]",
      "last_modified": "[timestamp ISO 8601 actual]"
    }
  }
  ```

- Actualizar workflow según progreso:
  - **Si `completed_tasks == total_tasks`** (todas completadas):
    ```json
    "workflow": {
      "current_stage": "complete",
      "next_recommended_command": "/feature:archivar [nombre-feature]"
    }
    ```
  - **Si `completed_tasks < total_tasks`** (aún hay pendientes):
    ```json
    "workflow": {
      "current_stage": "development",
      "next_recommended_command": "/feature:programar siguiente"
    }
    ```

- Actualizar `updated_at` con timestamp actual

### 10. Generar Visualización de Progreso
Calcular porcentaje: `(completed_tasks / total_tasks) * 100`

Crear barra de progreso visual:
```
[████████░░] 80% (8/10 tareas)
```

### 11. Informar Usuario

**Modo `siguiente`**:
```
✅ Tarea implementada: [descripción de la tarea]

📝 Archivos modificados:
- [listar archivos creados/modificados]

📊 Progreso de "[nombre-feature]":
[████████░░] 80% (8/10 tareas completadas)

[Si hay más tareas pendientes]
🚀 Próxima Tarea: [descripción de siguiente tarea `[ ]`]
   Ejecuta: /feature:programar siguiente

   Para programar todas las tareas pendientes:
   /feature:programar todo

[Si todas las tareas están completas]
🎉 ¡Todas las tareas completadas!
   Ejecuta: /feature:archivar [nombre-feature] para archivar
```

**Modo `todo`**:
```
✅ Tareas implementadas: [N tareas]

📝 Tareas completadas:
- [Tarea 1]
- [Tarea 2]
- [Tarea N]

📝 Archivos modificados:
- [listar todos los archivos creados/modificados]

📊 Progreso de "[nombre-feature]":
[██████████] 100% (10/10 tareas completadas)

🎉 ¡Todas las tareas completadas!
   Ejecuta: /feature:archivar [nombre-feature] para archivar
```

## Criterios de Éxito

- ✅ Feature actual identificada y plan-organized.md validado
- ✅ Modo de operación determinado correctamente (`siguiente` o `todo`)
- ✅ Tareas pendientes identificadas según modo:
  - **Modo `siguiente`**: Una tarea con dependencias verificadas
  - **Modo `todo`**: Todas las tareas pendientes (sin verificar dependencias)
- ✅ Tipo de tarea analizado (backend/frontend/interactividad/testing)
- ✅ Código implementado siguiendo patrones del proyecto:
  - Backend: Modelos, Service Objects, Controllers, Jobs (si aplica)
  - Frontend: Views ERB, Tailwind CSS, responsive, accesibilidad
  - Interactividad: Turbo Frames/Streams, Stimulus controllers
  - Testing: Specs RSpec con cobertura apropiada
- ✅ Tarea marcada como completada `[x]` en plan-organized.md
- ✅ Contador de tareas actualizado en `.feature-state.json`
- ✅ `implementation.completed_tasks` incrementado correctamente
- ✅ `implementation.last_implementation` actualizado con timestamp
- ✅ Workflow actualizado según progreso (development o complete)
- ✅ Usuario recibe visualización de progreso con barra y porcentaje
- ✅ Siguiente tarea o acción claramente indicada al usuario
