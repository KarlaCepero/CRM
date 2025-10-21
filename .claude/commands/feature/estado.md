---
argument-hint: [nombre-feature]
description: Mostrar estado detallado de una feature
---

# Estado de Feature

Muestra estado detallado y progreso de una feature en el pipeline.

**Uso**: `/feature:estado [nombre-feature]`

**Ejemplos**:
- `/feature:estado` - Estado de la feature actual
- `/feature:estado user-auth` - Estado de feature específica

## Qué Hace Este Comando

Genera un reporte detallado del estado, progreso, documentos y métricas de una feature específica o de la feature actual.

## Implementación

### 1. Determinar Feature Target
- Si `$ARGUMENTS` está presente, usar como nombre de feature
- Si no hay argumentos, leer `_features/current-feature` para obtener feature actual
- Si no hay current-feature definida, mostrar error

### 2. Cargar Estado de la Feature
- Leer `_features/state.json`
- Buscar feature en `features_by_name[nombre-feature]`
- Si no existe, mostrar error con lista de features disponibles

### 3. Analizar Documentos de la Feature
- Leer directorio `_features/[estado]/[nombre-feature]/`
  - `estado` puede ser: `active`, `archived`, o `trashed` según el campo `state` en JSON
- Listar documentos existentes: `feature.md`, `JTBD.md`, `PRD.md`, `plan.md`, `plan-organized.md`
- Para cada documento, obtener timestamp de última modificación

### 4. Calcular Progreso
- **Stage Progress**: Analizar objeto `stages` en el estado de la feature
  - Contar stages completados (donde `completed: true`)
  - Total de stages: jtbd, prd, plan, plan_organized
- **Implementation Progress**:
  - Leer `implementation.completed_tasks` y `implementation.total_tasks`
  - Calcular porcentaje: `(completed/total) * 100`
- **Timeline**:
  - Calcular tiempo en cada etapa usando timestamps de stages
  - Calcular tiempo total desde `created_at` hasta ahora

### 5. Generar Visualización de Progreso
Crear barra de progreso visual:
```
Implementation: [████████░░] 80% (8/10 tareas)
Stages: [✓ JTBD] [✓ PRD] [✓ Plan] [○ Code]
```

### 6. Identificar Blockers (si existen)
- Buscar campo `blockers` en el estado
- Si existe y tiene elementos, listarlos con descripción y timestamp

### 7. Generar Reporte Completo
Mostrar:
- **Header**: Nombre, descripción, estado (active/archived/trashed)
- **Timeline**: Fechas de creación, última actualización, tiempo en desarrollo
- **Workflow**: Etapa actual (`workflow.current_stage`)
- **Stages Progress**: Visual de stages completados
- **Implementation Progress**: Barra de progreso y contador de tareas
- **Documentos**: Lista con timestamps
- **Blockers**: Si existen
- **Siguiente Acción**: Leer `workflow.next_recommended_command`

## Criterios de Éxito

- ✅ Feature target identificada correctamente (argumento o current)
- ✅ Estado cargado exitosamente desde `.feature-state.json`
- ✅ Todos los documentos analizados con timestamps
- ✅ Progreso calculado y visualizado con barras/porcentajes
- ✅ Reporte completo mostrado con toda la información relevante
- ✅ Siguiente comando recomendado proporcionado
