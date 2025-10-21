---
argument-hint: <nombre-feature>
description: Archivar feature completada del pipeline
---

# Archivar Feature

Archiva una feature completada, moviéndola fuera del desarrollo activo.

**Uso**: `/feature:archivar <nombre-feature>`

**Ejemplo**: `/feature:archivar user-authentication`

## Qué Hace Este Comando

Archiva una feature completada, moviéndola del estado activo al archivo histórico con documentación de outcomes y learnings.

## Implementación

### 1. Parsear Argumentos
Extraer el nombre de la feature de `$ARGUMENTS`.

### 2. Validar Feature Existe y Es Archivable
- Leer `_features/state.json`
- Buscar feature en `features_by_name[nombre-feature]`
- Validar que existe y su estado es `"active"`
- **Verificar criterios de completitud**:
  - `implementation.completed_tasks === implementation.total_tasks` (todas las tareas completadas)
  - O confirmar con usuario si realmente desea archivar feature incompleta

### 3. Crear ARCHIVE_SUMMARY.md
Crear archivo `_features/active/[nombre-feature]/ARCHIVE_SUMMARY.md` con:

```markdown
# [Nombre Feature] - Resumen de Archivo

## Información General
- **Archivado**: [fecha actual ISO 8601]
- **Duración Total**: [calcular desde created_at hasta ahora]
- **Estado Final**: [workflow.current_stage]

## Outcomes y Resultados
- Tareas completadas: [implementation.completed_tasks]/[implementation.total_tasks]
- Documentos generados: [listar JTBD.md, PRD.md, plan.md, etc.]
- Implementación: [describir qué se implementó basándose en plan-organized.md]

## Métricas del Ciclo
- **Cycle Time**: [tiempo total desde created_at hasta archived_at]
- **Lead Time por Stage**:
  - Discovery (JTBD): [calcular desde created_at hasta stages.jtbd.completed_at]
  - Definition (PRD): [calcular tiempo en este stage]
  - Planning: [calcular tiempo en este stage]
  - Development: [calcular desde implementation.started_at hasta última tarea]

## Learnings y Notas
[Espacio para que el usuario agregue learnings - dejar vacío o con placeholder]

## Archivos Incluidos
- [listar todos los archivos en el directorio de la feature]
```

### 4. Mover Directorio a Archived
- Usar comando de sistema para mover directorio:
  - Origen: `_features/active/[nombre-feature]/`
  - Destino: `_features/archived/[nombre-feature]/`
- Validar que el movimiento fue exitoso

### 5. Actualizar Estado en JSON
Modificar `_features/state.json`:
- Cambiar `features_by_name[nombre-feature].state` de `"active"` a `"archived"`
- Agregar campo `archived_at` con timestamp actual ISO 8601
- Actualizar `updated_at` con timestamp actual
- Calcular y agregar métricas:
  ```json
  "metrics": {
    "cycle_time_days": [cálculo de días totales],
    "development_time_days": [cálculo de días en desarrollo]
  }
  ```

### 6. Actualizar Current Feature (si aplica)
- Si `current_feature === nombre-feature`:
  - Buscar otra feature activa en `features_by_name`
  - Si existe otra activa, actualizar `current_feature` a esa feature
  - Si no hay otras activas, establecer `current_feature` a `null`
  - Actualizar archivo `_features/current-feature` en consecuencia

### 7. Generar Reporte de Archivo
Mostrar al usuario:
```
✅ Feature "[nombre-feature]" archivada exitosamente

📊 Métricas Finales:
- Duración total: X días
- Tareas completadas: X/X (100%)
- Documentos generados: JTBD, PRD, Plan, Plan Organizado

📁 Ubicación: _features/archived/[nombre-feature]/
📝 Summary: ARCHIVE_SUMMARY.md creado

[Si current_feature cambió]
⚡ Nueva feature actual: [nueva-feature] (usa /feature:estado para ver detalles)
```

## Criterios de Éxito

- ✅ Feature validada como existente y completable
- ✅ ARCHIVE_SUMMARY.md creado con métricas y outcomes
- ✅ Directorio movido de `active/` a `archived/`
- ✅ Estado actualizado a `"archived"` en `.feature-state.json`
- ✅ Métricas de cycle time calculadas y documentadas
- ✅ Current feature actualizada si era necesario
- ✅ Usuario recibe confirmación con summary de métricas
