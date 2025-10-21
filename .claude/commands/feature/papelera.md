---
argument-hint: <nombre-feature>
description: Mover feature a papelera
---

# Eliminar Feature

Mueve una feature a la papelera (eliminación soft, recuperable).

**Uso**: `/feature:papelera <nombre-feature>`

**Ejemplo**: `/feature:papelera user-authentication`

## Qué Hace Este Comando

Mueve una feature a la papelera (eliminación recuperable), manteniendo todos los archivos para posible restauración futura.

## Implementación

### 1. Parsear Argumentos
Extraer el nombre de la feature de `$ARGUMENTS`.

### 2. Validar Feature Existe
- Leer `_features/state.json`
- Buscar feature en `features_by_name[nombre-feature]`
- Validar que existe (puede ser `"active"` o `"archived"`)
- Si no existe, mostrar error con lista de features disponibles

### 3. Confirmar Eliminación (si hay trabajo significativo)
Verificar si la feature tiene trabajo significativo:
- Revisar si existen documentos: JTBD.md, PRD.md, plan.md
- Revisar si hay tareas completadas: `implementation.completed_tasks > 0`

Si hay trabajo significativo:
- Advertir al usuario: "⚠️  Esta feature tiene [X documentos] y [Y tareas completadas]. ¿Seguro que deseas moverla a papelera? (Puede restaurarse con /feature:restaurar)"
- Esperar confirmación del usuario antes de continuar

### 4. Mover Directorio a Trashed
- Determinar ubicación actual:
  - Si `state === "active"`: `_features/active/[nombre-feature]/`
  - Si `state === "archived"`: `_features/archived/[nombre-feature]/`
- Usar comando de sistema para mover directorio:
  - Destino: `_features/trashed/[nombre-feature]/`
- Validar que el movimiento fue exitoso

### 5. Actualizar Estado en JSON
Modificar `_features/state.json`:
- Cambiar `features_by_name[nombre-feature].state` a `"trashed"`
- Agregar campo `trashed_at` con timestamp actual ISO 8601
- Actualizar `updated_at` con timestamp actual
- Preservar todos los demás campos (para permitir restauración completa)

### 6. Actualizar Current Feature (si aplica)
- Si `current_feature === nombre-feature`:
  - Buscar otra feature activa en `features_by_name`
  - Si existe otra activa, actualizar `current_feature` a esa feature
  - Si no hay otras activas, establecer `current_feature` a `null`
  - Actualizar archivo `_features/current-feature` en consecuencia

### 7. Generar Confirmación
Mostrar al usuario:
```
🗑️  Feature "[nombre-feature]" movida a papelera

📁 Ubicación: _features/trashed/[nombre-feature]/
♻️  Para restaurar: /feature:restaurar [nombre-feature]

[Si current_feature cambió]
⚡ Nueva feature actual: [nueva-feature]
```

## Criterios de Éxito

- ✅ Feature validada como existente
- ✅ Confirmación obtenida si había trabajo significativo
- ✅ Directorio movido a `trashed/` desde su ubicación original
- ✅ Estado actualizado a `"trashed"` en `.feature-state.json`
- ✅ Timestamp `trashed_at` registrado
- ✅ Current feature actualizada si era necesario
- ✅ Usuario recibe confirmación con instrucciones para restaurar
