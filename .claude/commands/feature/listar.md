---
argument-hint: [filtro]
description: Listar todas las features con su estado
---

# Listar Features

Muestra lista de todas las features del pipeline con sus estados.

**Uso**: `/feature:listar [filtro]`

**Ejemplos**:
- `/feature:listar` - Todas las features
- `/feature:listar active` - Solo activas
- `/feature:listar archived` - Solo archivadas

## Qué Hace Este Comando

Lista todas las features del pipeline con su estado, progreso y organización por categoría (activas, archivadas, eliminadas).

## Implementación

### 1. Determinar Filtro
- Si `$ARGUMENTS` contiene "active", mostrar solo activas
- Si `$ARGUMENTS` contiene "archived", mostrar solo archivadas
- Si `$ARGUMENTS` contiene "trashed", mostrar solo eliminadas
- Si no hay argumentos, mostrar todas las features organizadas por estado

### 2. Cargar Estado Global
- Leer `_features/state.json`
- Leer `features_by_name` (objeto con todas las features)
- Leer `current_feature` para marcar la feature activa actual

### 3. Organizar Features por Estado
Clasificar cada feature según su campo `state`:
- **Active**: `state === "active"`
- **Archived**: `state === "archived"`
- **Trashed**: `state === "trashed"`

### 4. Preparar Información de Cada Feature
Para cada feature, extraer:
- Nombre
- Descripción (primera línea del `feature.md` o del campo description en JSON)
- Estado del workflow: `workflow.current_stage`
- Progreso de implementación: `implementation.completed_tasks / implementation.total_tasks` (si existe)
- Es current feature: comparar con `current_feature`

### 5. Generar Output Organizado

**Si hay filtro**: Mostrar solo la sección filtrada

**Si no hay filtro**: Mostrar todas las secciones

Formato por sección:
```
## FEATURES ACTIVAS (3)

⚡ lead-management (Development) [8/12 tareas - 67%]
   CRM para gestión de leads de ventas

   user-notifications (Planning) [Plan creado]
   Sistema de notificaciones en tiempo real

   reports-dashboard (Discovery) [PRD completado]
   Dashboard de reportes y analytics

## FEATURES ARCHIVADAS (1)

   user-authentication (Completado) [Archivado 2025-01-15]
   Sistema de autenticación JWT

## FEATURES ELIMINADAS (0)
```

Indicadores:
- `⚡` = Feature actual (según `current_feature`)
- Nombre en **negrita** si es la actual
- Estado entre paréntesis
- Progreso entre corchetes

### 6. Calcular Totales
Al final mostrar:
```
Total: 4 features (3 activas, 1 archivada, 0 eliminadas)
```

## Criterios de Éxito

- ✅ `.feature-state.json` cargado exitosamente
- ✅ Features organizadas por estado (active/archived/trashed)
- ✅ Filtro aplicado correctamente si especificado
- ✅ Feature actual marcada con indicador ⚡
- ✅ Progreso mostrado para cada feature (stages o tareas)
- ✅ Totales calculados y mostrados por categoría
