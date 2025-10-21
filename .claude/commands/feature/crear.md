---
argument-hint: <nombre-y-descripción>
description: Crear nueva feature con estructura y tracking
---

# Crear Feature

Crea una nueva feature con estructura de directorios y tracking inicial usando Feature Flow Manager.

**Uso**: `/feature:crear <nombre-y-descripción>`

**Ejemplo**: `/feature:crear user-authentication Sistema de autenticación con JWT`

## Qué Hace Este Comando

Crea una nueva feature en el pipeline con estructura de directorios, documentación inicial y tracking en el estado global.

## Implementación

### 1. Parsear Argumentos
Extraer de `$ARGUMENTS`:
- **Primer token**: Nombre de la feature (slug format: lowercase-with-dashes)
- **Resto**: Descripción de la feature

Ejemplo: `user-authentication Sistema de autenticación con JWT`
- Nombre: `user-authentication`
- Descripción: `Sistema de autenticación con JWT`

### 2. Validar Nombre Único
- Leer `_features/state.json`
- Verificar que `features_by_name[nombre-feature]` NO existe
- Si ya existe, mostrar error: "Feature '[nombre]' ya existe. Usa /feature:listar para ver todas las features."

### 3. Crear Estructura de Directorios
Crear directorio: `_features/active/[nombre-feature]/`

### 4. Crear feature.md
Crear archivo `_features/active/[nombre-feature]/feature.md` con:

```markdown
# [Nombre Feature]

## Descripción
[descripción extraída de argumentos]

## Estado Actual
- **Workflow Stage**: Discovery
- **Próximo Paso**: Ejecutar `/feature:cambiar [nombre]` y luego `/feature:crear-jtbd`

## Documentos
- [ ] JTBD.md - Análisis Jobs-to-be-Done
- [ ] PRD.md - Product Requirements Document
- [ ] plan.md - Plan técnico de implementación
- [ ] plan-organized.md - Plan organizado por capacidades

## Tracking
- **Creado**: [timestamp ISO 8601 actual]
- **Última Actualización**: [timestamp ISO 8601 actual]
```

### 5. Actualizar .feature-state.json
Modificar `_features/state.json`:

Agregar entrada en `features_by_name`:
```json
"[nombre-feature]": {
  "name": "[nombre-feature]",
  "description": "[descripción]",
  "state": "active",
  "created_at": "[timestamp ISO 8601 actual]",
  "updated_at": "[timestamp ISO 8601 actual]",
  "workflow": {
    "current_stage": "discovery",
    "next_recommended_command": "/feature:crear-jtbd"
  },
  "stages": {
    "jtbd": {
      "completed": false,
      "started_at": null,
      "completed_at": null
    },
    "prd": {
      "completed": false,
      "started_at": null,
      "completed_at": null
    },
    "plan": {
      "completed": false,
      "started_at": null,
      "completed_at": null
    },
    "plan_organized": {
      "completed": false,
      "started_at": null,
      "completed_at": null
    }
  },
  "documents": {
    "feature.md": {
      "exists": true,
      "created_at": "[timestamp ISO 8601 actual]"
    }
  },
  "implementation": {
    "started_at": null,
    "last_implementation": null,
    "total_tasks": 0,
    "completed_tasks": 0
  }
}
```

Actualizar también `updated_at` del objeto raíz del JSON.

### 6. Generar Confirmación
Mostrar al usuario:
```
✅ Feature "[nombre-feature]" creada exitosamente

📁 Ubicación: _features/active/[nombre-feature]/
📝 Documentos: feature.md creado

🚀 Próximos Pasos:
1. Ejecuta: /feature:cambiar [nombre-feature]
2. Luego: /feature:crear-jtbd para comenzar el análisis

💡 Usa /feature:estado [nombre-feature] para ver el estado en cualquier momento
```

## Criterios de Éxito

- ✅ Nombre y descripción parseados correctamente de argumentos
- ✅ Validación de unicidad exitosa (no existe duplicado)
- ✅ Directorio creado en `_features/active/[nombre-feature]/`
- ✅ `feature.md` generado con estructura y metadata inicial
- ✅ `.feature-state.json` actualizado con entrada completa de nueva feature
- ✅ Estado inicial configurado como `"discovery"` con comando recomendado
- ✅ Usuario recibe confirmación con próximos pasos claros
