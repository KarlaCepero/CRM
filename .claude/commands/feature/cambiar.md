---
argument-hint: <nombre-feature>
description: Cambiar la feature actual del pipeline
---

# Cambiar Feature Actual

Cambia la feature actual sobre la que operarán los comandos de desarrollo.

**Uso**: `/feature:cambiar <nombre-feature>`

**Ejemplo**: `/feature:cambiar user-authentication`

## Qué Hace Este Comando

Cambia la feature actual del contexto de trabajo, actualizando el estado global del sistema para que los siguientes comandos operen sobre la nueva feature seleccionada.

## Implementación

### 1. Parsear Argumentos
Extraer el nombre de la feature de `$ARGUMENTS`.

### 2. Validar Feature Existe
- Leer `_features/state.json`
- Buscar feature con nombre coincidente en `features_by_name`
- Validar que existe y su estado es `"active"` (no `"archived"` ni `"trashed"`)
- Si no existe o no está activa, mostrar error con lista de features activas disponibles

### 3. Actualizar Estado Global
- Actualizar campo `current_feature` en `.feature-state.json` con el nombre de la feature
- Actualizar timestamp `updated_at` con fecha actual ISO 8601

### 4. Actualizar Archivo Current Feature
- Escribir nombre de la feature en `_features/current-feature` (una sola línea)

### 5. Cargar y Mostrar Estado
- Leer directorio `_features/active/[nombre-feature]/`
- Mostrar información de la feature:
  - Nombre y descripción (desde `feature.md`)
  - Etapa actual del workflow (`workflow.current_stage`)
  - Progreso de implementación si existe (`implementation.completed_tasks / implementation.total_tasks`)
  - Documentos existentes (JTBD.md, PRD.md, plan.md, plan-organized.md)

### 6. Recomendar Siguiente Acción
Basándose en `workflow.next_recommended_command` del estado de la feature, recomendar el siguiente comando a ejecutar.

## Criterios de Éxito

- ✅ Validación exitosa de existencia y estado activo de la feature
- ✅ `.feature-state.json` actualizado con `current_feature` correcto
- ✅ Archivo `current-feature` actualizado
- ✅ Estado de la feature mostrado al usuario (descripción, progreso, etapa)
- ✅ Siguiente comando recomendado proporcionado
