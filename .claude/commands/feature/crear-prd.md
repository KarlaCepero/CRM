---
argument-hint: [contexto-feature]
description: Crear Product Requirements Document para la feature actual
---

# Crear PRD

Genera Product Requirements Document para la feature actual usando Product Owner y Feature Flow Manager.

**Uso**: `/feature:crear-prd [contexto-feature]`

## Qué Hace Este Comando

Crea un Product Requirements Document (PRD) lean para la feature actual, basándose en el análisis JTBD para definir QUÉ construir (no cómo).

## Implementación

### 1. Determinar Feature Actual
- Leer `_features/current-feature`
- Si no existe current-feature, mostrar error: "No hay feature actual. Usa /feature:cambiar <nombre> primero."

### 2. Validar JTBD Existe
- Verificar que existe `_features/active/[feature-actual]/JTBD.md`
- Si no existe, recomendar: "Ejecuta /feature:crear-jtbd primero para crear el análisis JTBD."

### 3. Leer Contexto
- Leer `_features/active/[feature-actual]/JTBD.md` completo
- Leer `_features/active/[feature-actual]/feature.md`
- Incorporar contexto adicional de `$ARGUMENTS` si está presente

### 4. Crear Documento PRD
Crear archivo `_features/active/[feature-actual]/PRD.md` con estructura lean basada en JTBD:

```markdown
# [Nombre Feature] - Product Requirements Document

## Executive Summary
**Job To Be Done**: [Extraer del JTBD.md - Job Statement]

**Solución Propuesta**: [Descripción de 2-3 líneas de QUÉ vamos a construir]

**Impacto Esperado**: [Outcomes medibles basados en Success Criteria del JTBD]

## Problem Statement
### El Problema
[Descripción del problema del usuario basándose en User Context del JTBD]

### Por Qué Ahora
[Circunstancias que disparan el job - del JTBD]

### Alternativas Actuales
[Cómo lo están resolviendo ahora - del JTBD]

## User Stories & Acceptance Criteria
### User Story 1: [Nombre del flujo principal]
**Como** [usuario del JTBD]
**Quiero** [capability funcional]
**Para** [outcome del job]

**Acceptance Criteria:**
- [ ] [Criterio verificable 1]
- [ ] [Criterio verificable 2]
- [ ] [Criterio verificable 3]

### User Story 2: [Flujo secundario si aplica]
[Misma estructura]

## MVP Scope
### ¿Qué DEBE tener el MVP?
[Features mínimas necesarias para completar el job principal - basado en Functional Jobs del JTBD]

### ¿Qué NO tendrá v1?
[Features pospuestas - aplicar YAGNI]

### ¿Qué nunca haremos?
[Anti-features - basado en "Constraints & Obstacles" del JTBD]

## Success Metrics
### Métricas de Adopción (Leading Indicators)
- [Métrica de uso - del JTBD Success Criteria]
- [Métrica de engagement]

### Métricas de Outcome (Lagging Indicators)
- [Métrica de valor - del JTBD Success Criteria]
- [Métrica de satisfacción del job]

### Criterios para Pivot/Persevere/Kill (30 días post-launch)
- **Persevere**: [Umbral de éxito]
- **Pivot**: [Señal de ajuste necesario]
- **Kill**: [Señal de fallo total]

## Dependencies & Risks
### Dependencias Internas
[Features existentes o componentes necesarios]

### Dependencias Externas
[APIs, servicios terceros, datos externos]

### Riesgos Identificados
1. **Riesgo**: [Descripción]
   - **Mitigación**: [Estrategia]

## Open Questions
- [ ] [Pregunta pendiente 1]
- [ ] [Pregunta pendiente 2]

## Out of Scope
[Explícitamente lo que NO es parte de esta feature - prevenir scope creep]

---
*PRD creado: [timestamp ISO 8601 actual]*
*Basado en JTBD: [nombre-feature]/JTBD.md*
```

**Contenido**: Completar cada sección basándose en:
- El análisis JTBD (Job Statement, User Context, Success Criteria)
- La descripción de la feature
- Contexto adicional de `$ARGUMENTS`
- Aplicar principios lean: enfocarse en QUÉ construir, no CÓMO

### 5. Actualizar Estado de la Feature
Modificar `_features/state.json`:

- Marcar stage PRD como completado:
  ```json
  "stages": {
    "prd": {
      "completed": true,
      "started_at": "[usar completed_at del stage jtbd]",
      "completed_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar documentos:
  ```json
  "documents": {
    "PRD.md": {
      "exists": true,
      "created_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar workflow:
  ```json
  "workflow": {
    "current_stage": "planning",
    "next_recommended_command": "/feature:crear-plan"
  }
  ```
- Actualizar `updated_at` con timestamp actual

### 6. Informar Usuario
Mostrar:
```
✅ PRD completado para "[nombre-feature]"

📝 Documento: _features/active/[feature-actual]/PRD.md
🎯 MVP Scope: [extracto breve del MVP scope]

📊 Progreso:
[✓ JTBD] [✓ PRD] [○ Plan] [○ Code]

🚀 Próximo Paso: /feature:crear-plan
```

## Criterios de Éxito

- ✅ Feature actual identificada correctamente
- ✅ JTBD.md validado como existente
- ✅ `PRD.md` creado con todas las secciones completas
- ✅ PRD basado en análisis JTBD (Jobs → User Stories → Success Metrics)
- ✅ Scope MVP definido claramente (qué SÍ, qué NO, qué NUNCA)
- ✅ Stage "prd" marcado como completado en `.feature-state.json`
- ✅ Workflow actualizado a "planning" con próximo comando `/feature:crear-plan`
- ✅ Usuario recibe resumen y siguiente paso recomendado
