---
argument-hint: [contexto-adicional]
description: Organizar plan técnico por capacidades de usuario
---

# Organizar Plan Técnico

Reorganiza el plan técnico desde estructura de infraestructura a capacidades de usuario usando Feature Flow Manager.

**Uso**: `/feature:organizar-plan [contexto-adicional]`

## Qué Hace Este Comando

Reorganiza el plan técnico desde estructura de infraestructura (backend/frontend/testing) a capacidades de usuario, analizando dependencias y priorizando por valor entregado.

## Implementación

### 1. Determinar Feature Actual
- Leer `_features/current-feature`
- Si no existe current-feature, mostrar error: "No hay feature actual. Usa /feature:cambiar <nombre> primero."

### 2. Validar Plan Técnico Existe
- Verificar que existe `_features/active/[feature-actual]/plan.md`
- Si no existe, mostrar error: "Necesitas ejecutar /feature:crear-plan primero"

### 3. Leer Documentos de Contexto
- Leer `_features/active/[feature-actual]/plan.md` completo
- Leer `_features/active/[feature-actual]/PRD.md` (User Stories)
- Leer `_features/active/[feature-actual]/JTBD.md` (Jobs funcionales)
- Incorporar contexto adicional de `$ARGUMENTS` si está presente

### 4. Identificar Capacidades de Usuario
Desde JTBD.md y PRD.md, extraer capacidades de usuario:
- Cada User Story del PRD representa una capacidad potencial
- Cada Functional Job del JTBD puede agruparse en capacidades
- Agrupar User Stories relacionadas en una sola capacidad cuando tienen sentido funcional común

Ejemplo:
- **Capacidad**: "Gestionar leads de ventas"
  - User Story 1: Crear nuevo lead
  - User Story 2: Editar lead existente
  - User Story 3: Ver detalles de lead

### 5. Mapear Tareas Técnicas a Capacidades
Para cada capacidad identificada, mapear tareas del plan.md:
- Extraer tareas del checklist en plan.md
- Agrupar tareas por la capacidad de usuario que entregan
- Ordenar tareas dentro de cada capacidad por dependencias técnicas:
  1. **Fundación**: Modelos y migraciones (deben ir primero)
  2. **Funcionalidad Core**: Service Objects, controllers, rutas
  3. **Interfaz de Usuario**: Views, componentes UI, Turbo/Stimulus
  4. **Testing y Validación**: Tests para validar la capacidad

### 6. Analizar Dependencias Entre Tareas
Para cada tarea, determinar:
- **Dependencias técnicas**: Qué debe existir antes (ej: modelo antes de controller)
- **Dependencias de negocio**: Qué capacidad debe completarse primero
- **Oportunidades de paralelismo**: Qué tareas pueden hacerse simultáneamente

Patrón Rails típico de dependencias:
```
Migración → Modelo → Service Object → Controller → Routes → View → Tests
```

### 7. Crear Plan Organizado

Crea el archivo `_features/active/[feature-actual]/plan-organized.md` con la siguiente estructura:

```markdown
# [Nombre Feature] - Plan Organizado por Capacidades

## Resumen de Reorganización
[Cómo se reorganizaron las tareas desde infraestructura a capacidades de usuario]

## Capacidad 1: [Nombre Capacidad de Usuario]

### Valor para el Usuario
[Qué Job To Be Done satisface, referenciando JTBD.md]

### Tareas de Implementación

#### Fundación (Completar Primero)
- [ ] [Tarea base de datos/modelo con ruta archivo]
- [ ] [Tarea setup servicio core]

#### Funcionalidad Core
- [ ] [Implementación lógica de negocio]
- [ ] [Creación endpoint API]
- [ ] [Setup job background si necesario]

#### Interfaz de Usuario
- [ ] [Creación controller y view frontend]
- [ ] [Features interactivas Hotwire/Stimulus]
- [ ] [Estilado CSS y diseño responsive]

#### Testing y Validación
- [ ] [Tests unitarios modelos y servicios]
- [ ] [Tests integración workflow completo]
- [ ] [Cobertura test multi-tenant]

### Dependencias
- **Internas**: [Otras capacidades de las que depende]
- **Externas**: [Servicios terceros o setup requerido]

### Factores de Riesgo
- [Bloqueos potenciales o desafíos para esta capacidad]

## Capacidad 2: [Nombre Capacidad de Usuario]
[Continuar misma estructura]

## Infraestructura de Soporte

### Requisitos Cross-Capacidad
- [ ] [Tareas que soportan múltiples capacidades]
- [ ] [Setup infraestructura necesaria entre features]
- [ ] [Framework seguridad y permisos]

### Framework Integración
- [ ] [Setup OAuth y autenticación]
- [ ] [Infraestructura webhooks]
- [ ] [Configuración servicio externo]

### Documentación y Deployment
- [ ] [Actualizaciones CLAUDE.md para nuevos patrones]
- [ ] [Actualizaciones documentación API]
- [ ] [Configuración entorno]
- [ ] [Planes deployment migración]

## Secuencia de Implementación Recomendada

### Fase 1: Fundación
[Qué capacidades implementar primero y por qué]

### Fase 2: Features Core
[Workflows usuarios primarios y sus dependencias]

### Fase 3: Capacidades Mejoradas
[Features secundarias y optimizaciones]

### Oportunidades de Desarrollo Paralelo
[Tareas que pueden trabajarse simultáneamente por diferentes desarrolladores]

---

*Plan organizado por capacidades de usuario*
*Total de tareas: [contar todos los checkboxes]*
```

**Contenido**: Completar cada sección basándose en análisis de pasos 4-6:
- Agrupar tareas por capacidades (no por capas técnicas)
- Ordenar tareas por dependencias dentro de cada capacidad
- Identificar secuencia de implementación recomendada

### 8. Contar Tareas Totales
- Leer `plan-organized.md` recién creado
- Contar todos los checkboxes `[ ]` en el documento
- Este será el `total_tasks` para tracking de progreso

### 9. Actualizar Estado de la Feature
Modificar `_features/state.json`:

- Marcar stage plan_organized como completado:
  ```json
  "stages": {
    "plan_organized": {
      "completed": true,
      "started_at": "[usar completed_at del stage plan]",
      "completed_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar documentos:
  ```json
  "documents": {
    "plan-organized.md": {
      "exists": true,
      "created_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar implementation:
  ```json
  "implementation": {
    "started_at": null,
    "last_implementation": null,
    "total_tasks": [número contado en paso 8],
    "completed_tasks": 0
  }
  ```
- Actualizar workflow:
  ```json
  "workflow": {
    "current_stage": "ready_for_development",
    "next_recommended_command": "/feature:programar siguiente"
  }
  ```
- Actualizar `updated_at` con timestamp actual

### 10. Informar Usuario
Mostrar:
```
✅ Plan organizado por capacidades para "[nombre-feature]"

📝 Documento: _features/active/[feature-actual]/plan-organized.md
🎯 Capacidades identificadas: [número de capacidades]
📋 Total de tareas: [total_tasks]

📊 Progreso:
[✓ JTBD] [✓ PRD] [✓ Plan] [✓ Organized] [○ Code]

🚀 Próximo Paso: /feature:programar siguiente
   (Programará la primera tarea pendiente del plan organizado)

   Para programar todas las tareas: /feature:programar todo
```

## Criterios de Éxito

- ✅ Feature actual identificada y plan.md validado como existente
- ✅ Capacidades de usuario identificadas desde JTBD y PRD
- ✅ Tareas técnicas del plan.md mapeadas a capacidades de usuario
- ✅ Dependencias entre tareas analizadas (técnicas y de negocio)
- ✅ Tareas agrupadas por valor de usuario (no por capa técnica)
- ✅ `plan-organized.md` creado con estructura por capacidades
- ✅ Secuencia de implementación recomendada documentada
- ✅ Total de tareas contado correctamente
- ✅ Stage "plan_organized" marcado como completado en `.feature-state.json`
- ✅ `implementation.total_tasks` inicializado con conteo correcto
- ✅ Workflow actualizado a "ready_for_development"
- ✅ Usuario recibe resumen con total de tareas y próximo paso
