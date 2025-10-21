---
argument-hint: <nombre-feature>
description: Restaurar feature archivada o eliminada
---

# Restaurar Feature

Restaura una feature archivada o eliminada volviéndola al estado activo.

**Uso**: `/feature:restaurar <nombre-feature>`

**Ejemplo**: `/feature:restaurar user-authentication`

## Qué Hace Este Comando

Restaura una feature archivada o eliminada, devolviéndola al estado activo del pipeline de desarrollo.

## Implementación

### 1. Parsear Argumentos
Extraer el nombre de la feature de `$ARGUMENTS`.

### 2. Buscar Feature en Archived o Trashed
- Leer `_features/state.json`
- Buscar feature en `features_by_name[nombre-feature]`
- Validar que existe y su estado es `"archived"` o `"trashed"`
- Si no existe o ya está `"active"`, mostrar error apropiado

### 3. Determinar Ubicación Actual
Basándose en el campo `state`:
- Si `state === "archived"`: `_features/archived/[nombre-feature]/`
- Si `state === "trashed"`: `_features/trashed/[nombre-feature]/`

### 4. Mover Directorio a Active
- Usar comando de sistema para mover directorio:
  - Destino: `_features/active/[nombre-feature]/`
- Validar que el movimiento fue exitoso

### 5. Actualizar Estado en JSON
Modificar `_features/state.json`:
- Cambiar `features_by_name[nombre-feature].state` a `"active"`
- Agregar campo `restored_at` con timestamp actual ISO 8601
- Actualizar `updated_at` con timestamp actual
- Preservar todos los campos existentes (stages, implementation, workflow, etc.)

### 6. Mostrar Estado de la Feature Restaurada
Leer y mostrar:
- Nombre y descripción (desde `feature.md`)
- Etapa del workflow donde se quedó: `workflow.current_stage`
- Progreso de implementación: `implementation.completed_tasks / implementation.total_tasks` (si existe)
- Documentos existentes: listar JTBD.md, PRD.md, plan.md, plan-organized.md
- Último comando recomendado: `workflow.next_recommended_command`

### 7. Recomendar Siguiente Acción
Basándose en el estado previo:
- Si `workflow.next_recommended_command` existe, recomendarlo
- Si no, analizar el progreso y recomendar:
  - Si no hay JTBD.md → `/feature:crear-jtbd`
  - Si hay JTBD pero no PRD → `/feature:crear-prd`
  - Si hay PRD pero no plan → `/feature:crear-plan`
  - Si hay plan pero no plan-organized → `/feature:organizar-plan`
  - Si hay plan-organized y tareas pendientes → `/feature:programar siguiente`

### 8. Ofrecer Cambiar Current Feature
Preguntar al usuario si desea hacer esta feature la actual:
```
¿Deseas cambiar a esta feature como la actual? (Ejecuta /feature:cambiar [nombre-feature] para hacerlo)
```

## Criterios de Éxito

- ✅ Feature encontrada en archived/ o trashed/
- ✅ Directorio movido exitosamente a `active/`
- ✅ Estado actualizado a `"active"` en `.feature-state.json`
- ✅ Timestamp `restored_at` registrado
- ✅ Estado de la feature mostrado (progreso, documentos, workflow)
- ✅ Siguiente acción recomendada basada en progreso previo
- ✅ Usuario informado sobre cómo hacer switch si lo desea
