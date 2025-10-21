---
argument-hint: [contexto-feature]
description: Crear análisis Job-to-be-Done para la feature actual
---

# Crear Análisis JTBD

Genera análisis Jobs To Be Done para la feature actual usando Product Owner y Feature Flow Manager.

**Uso**: `/feature:crear-jtbd [contexto-feature]`

## Qué Hace Este Comando

Crea un análisis Jobs-to-be-Done (JTBD) completo para la feature actual, aplicando el framework JTBD para descubrir el verdadero problema del usuario antes de definir la solución.

## Implementación

### 1. Determinar Feature Actual
- Leer `_features/current-feature`
- Si no existe current-feature, mostrar error: "No hay feature actual. Usa /feature:cambiar <nombre> primero."

### 2. Leer Contexto de la Feature
- Leer `_features/active/[feature-actual]/feature.md`
- Leer descripción de la feature desde `feature.md`
- Incorporar contexto adicional de `$ARGUMENTS` si está presente

### 3. Crear Documento JTBD
Crear archivo `_features/active/[feature-actual]/JTBD.md` con estructura completa de análisis Jobs-to-be-Done:

```markdown
# [Nombre Feature] - Jobs To Be Done Analysis

## Job Statement
**When** [situación/contexto del usuario]
**I want to** [motivación/objetivo del usuario]
**So I can** [outcome deseado/beneficio]

## User Context
### Quién está contratando este "job"
[Descripción del perfil de usuario específico que necesita esta funcionalidad]

### Circunstancias que disparan el job
[Eventos o situaciones que hacen que el usuario necesite esta funcionalidad]

### Alternativas actuales (competencia)
[Qué están usando actualmente para resolver este problema]

## Functional Jobs (qué quieren lograr)
1. [Job funcional principal]
2. [Jobs funcionales secundarios]

## Emotional Jobs (cómo quieren sentirse)
1. [Job emocional - ej: sentirse en control]
2. [Job emocional - ej: sentirse profesional]

## Social Jobs (cómo quieren ser percibidos)
1. [Job social - ej: verse organizado ante clientes]

## Success Criteria
### Cómo el usuario sabrá que el job está "bien hecho"
- [ ] [Criterio medible de éxito 1]
- [ ] [Criterio medible de éxito 2]
- [ ] [Criterio medible de éxito 3]

### Métricas de adopción
- [Métrica clave de uso esperado]
- [Indicador de satisfacción del job]

## Constraints & Obstacles
### Qué podría impedir que el usuario "contrate" esta solución
- [Obstáculo técnico o de usabilidad]
- [Preocupación o fricción del usuario]

### Qué debe NO hacer la solución
- [Anti-pattern a evitar]
- [Complejidad innecesaria a evitar]

## Job Map (pasos del proceso del usuario)
1. **[Fase 1 del proceso]**: [Descripción de qué hace el usuario]
2. **[Fase 2 del proceso]**: [Descripción]
3. **[Fase 3 del proceso]**: [Descripción]

## Insights & Discoveries
[Hallazgos importantes del análisis JTBD]
[Revelaciones sobre el verdadero problema vs. la solución solicitada]

---
*Análisis JTBD creado: [timestamp ISO 8601 actual]*
```

**Contenido**: Completar cada sección con análisis detallado basado en:
- La descripción de la feature
- El contexto adicional de `$ARGUMENTS`
- Aplicación rigurosa del framework JTBD (descubrir el "por qué" antes del "qué")

### 4. Actualizar Estado de la Feature
Modificar `_features/state.json`:

- Marcar stage JTBD como completado:
  ```json
  "stages": {
    "jtbd": {
      "completed": true,
      "started_at": "[usar created_at de la feature]",
      "completed_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar documentos:
  ```json
  "documents": {
    "JTBD.md": {
      "exists": true,
      "created_at": "[timestamp ISO 8601 actual]"
    }
  }
  ```
- Actualizar workflow:
  ```json
  "workflow": {
    "current_stage": "definition",
    "next_recommended_command": "/feature:crear-prd"
  }
  ```
- Actualizar `updated_at` con timestamp actual

### 5. Informar Usuario
Mostrar:
```
✅ Análisis JTBD completado para "[nombre-feature]"

📝 Documento: _features/active/[feature-actual]/JTBD.md
🎯 Job Principal: [extracto del job statement]

📊 Progreso:
[✓ JTBD] [○ PRD] [○ Plan] [○ Code]

🚀 Próximo Paso: /feature:crear-prd
```

## Criterios de Éxito

- ✅ Feature actual identificada correctamente
- ✅ `JTBD.md` creado con todas las secciones completas
- ✅ Análisis riguroso aplicando framework JTBD (Jobs, Contexts, Success Criteria)
- ✅ Stage "jtbd" marcado como completado en `.feature-state.json`
- ✅ Workflow actualizado a "definition" con próximo comando `/feature:crear-prd`
- ✅ Usuario recibe resumen y siguiente paso recomendado
