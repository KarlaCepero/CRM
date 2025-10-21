---
argument-hint: [contexto-adicional]
description: Crear plan técnico de implementación para la feature actual
---

# Crear Plan Técnico

Genera plan técnico de implementación orquestando agentes especializados y usando Feature Flow Manager.

**Uso**: `/feature:crear-plan [contexto-adicional]`

## Qué Hace Este Comando

Genera un plan técnico de implementación completo para la feature actual, analizando arquitectura Rails, diseño UI y patrones de interactividad basándose en el PRD.

## Implementación

### 1. Determinar Feature Actual
- Leer `_features/current-feature`
- Si no existe current-feature, mostrar error: "No hay feature actual. Usa /feature:cambiar <nombre> primero."

### 2. Validar PRD Existe
- Verificar que existe `_features/active/[feature-actual]/PRD.md`
- Si no existe, recomendar: "Ejecuta /feature:crear-prd primero para crear el PRD."

### 3. Analizar PRD y Determinar Alcance Técnico
- Leer `_features/active/[feature-actual]/PRD.md` completo
- Leer `_features/active/[feature-actual]/JTBD.md` para contexto
- Incorporar contexto adicional de `$ARGUMENTS` si está presente

Determinar alcance de implementación:
- **Backend necesario**: Siempre (modelos, controladores, servicios, API)
- **UI/Frontend nuevo**: Basándose en User Stories del PRD
- **Interactividad**: Si hay formularios, modales, actualizaciones en tiempo real en PRD

### 4. Analizar Arquitectura Rails (Backend)
Basándose en PRD y JTBD, definir:

**Modelos y Base de Datos**:
- Identificar entidades del dominio desde User Stories
- Diseñar esquema de base de datos con relaciones
- Definir migraciones Rails necesarias
- Considerar índices para performance
- Aplicar multi-tenancy (account_id donde corresponda)

**Service Objects y Lógica de Negocio**:
- Identificar operaciones complejas que requieren Service Objects
- Diseñar interfaz de servicios (inputs/outputs)
- Considerar validaciones y manejo de errores
- Evaluar necesidad de transacciones

**Controladores y API**:
- Definir rutas REST para recursos
- Planear acciones de controlador necesarias
- Diseñar respuestas JSON para API si aplica
- Considerar autenticación y autorización

**Jobs en Background**:
- Identificar operaciones asíncronas (emails, procesamiento pesado)
- Planear jobs Solid Queue necesarios

**Testing**:
- Planear specs RSpec para modelos, servicios, controladores
- Considerar system tests para flujos completos

### 5. Analizar UI/Frontend (si hay User Stories con interfaz)
Basándose en PRD y sistema de diseño existente, definir:

**Componentes UI necesarios**:
- Identificar componentes desde User Stories (formularios, listas, cards, modales)
- Especificar clases Tailwind CSS para cada componente
- Definir layout responsive (mobile-first)
- Planear estados visuales (hover, focus, disabled, loading)

**Views Rails**:
- Identificar templates ERB necesarios
- Planear partials reutilizables
- Considerar accesibilidad (ARIA labels, contraste)

### 6. Analizar Interactividad (si hay formularios/tiempo real)
Si el PRD incluye interactividad, definir:

**Turbo Frames**:
- Identificar secciones que requieren actualizaciones parciales
- Planear frame IDs y estructura

**Turbo Streams**:
- Identificar operaciones de tiempo real (crear, actualizar, eliminar)
- Planear broadcasts ActionCable si necesario

**Stimulus Controllers**:
- Identificar comportamiento JavaScript necesario
- Diseñar controllers con targets y actions

### 7. Crear Plan Técnico Completo

Crear archivo `_features/active/[feature-actual]/plan.md` con análisis técnico completo:

```markdown
# [Nombre Feature] - Plan Técnico de Implementación

## Resumen
**Job To Be Done**: [Del JTBD]
**Solución**: [Del PRD]
**Enfoque Técnico**: [Descripción general de cómo se implementará]

## Arquitectura Rails

### Modelos y Base de Datos
[Esquema de tablas, relaciones, migraciones necesarias]
[Consideraciones multi-tenancy]

### Service Objects
[Servicios necesarios con sus responsabilidades]

### Controladores y Rutas
[Endpoints REST, acciones de controlador]

### Jobs en Background
[Solid Queue jobs necesarios]

## Frontend y UI

### Componentes UI
[Lista de componentes con clases Tailwind]
[Consideraciones responsive y accesibilidad]

### Views Rails
[Templates ERB necesarios]

## Interactividad

### Turbo Frames
[Frames necesarios para actualizaciones parciales]

### Turbo Streams
[Streams para tiempo real]

### Stimulus Controllers
[Controllers JavaScript necesarios]

## Checklist de Implementación

### Backend
- [ ] Crear migración: [descripción]
- [ ] Crear modelo: [nombre con ruta]
- [ ] Crear service object: [nombre con ruta]
- [ ] Crear controlador: [nombre con ruta]
- [ ] Definir rutas REST
- [ ] Crear job background (si necesario)

### Frontend
- [ ] Crear view: [ruta]
- [ ] Crear partial: [ruta]
- [ ] Implementar componente UI: [descripción]
- [ ] Añadir Turbo Frame: [descripción]
- [ ] Crear Stimulus controller (si necesario)

### Testing
- [ ] Test modelo: [ruta spec]
- [ ] Test service: [ruta spec]
- [ ] Test controller: [ruta spec]
- [ ] System test: [descripción flujo]

### Documentación
- [ ] Actualizar CLAUDE.md
- [ ] Documentar API endpoints (si aplica)

## Dependencias
- **Internas**: [Features/componentes del proyecto necesarios]
- **Externas**: [APIs, servicios terceros]

## Riesgos Técnicos
- [Riesgo 1]: Mitigación: [estrategia]
- [Riesgo 2]: Mitigación: [estrategia]

---
*Plan técnico creado: [timestamp ISO 8601]*
*Basado en: PRD.md y JTBD.md*
```

**Contenido**: Completar cada sección con análisis detallado basándose en los pasos 4-6.

### 8. Actualizar Estado de la Feature
Modificar `_features/state.json`:

- Marcar stage plan como completado:
  ```json
  "stages": {
    "plan": {
      "completed": true,
      "started_at": "[usar completed_at del stage prd]",
      "completed_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar documentos:
  ```json
  "documents": {
    "plan.md": {
      "exists": true,
      "created_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar workflow:
  ```json
  "workflow": {
    "current_stage": "planning",
    "next_recommended_command": "/feature:organizar-plan"
  }
  ```
- Actualizar `updated_at` con timestamp actual

### 9. Informar Usuario
Mostrar:
```
✅ Plan técnico completado para "[nombre-feature]"

📝 Documento: _features/active/[feature-actual]/plan.md
🏗️  Arquitectura: [extracto de decisiones clave]

📊 Progreso:
[✓ JTBD] [✓ PRD] [✓ Plan] [○ Code]

🚀 Próximo Paso: /feature:organizar-plan
```

## Criterios de Éxito

- ✅ Feature actual identificada correctamente
- ✅ PRD.md validado como existente
- ✅ Alcance técnico determinado (backend, frontend, interactividad)
- ✅ Arquitectura Rails analizada y planificada completamente
- ✅ UI/Frontend diseñado con componentes Tailwind (si necesario)
- ✅ Interactividad planificada con Hotwire (si necesario)
- ✅ `plan.md` creado con checklist completo de implementación
- ✅ Stage "plan" marcado como completado en `.feature-state.json`
- ✅ Workflow actualizado a "planning" con próximo comando `/feature:organizar-plan`
- ✅ Usuario recibe resumen y siguiente paso recomendado
