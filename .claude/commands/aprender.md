---
description: Analizar conversación y actualizar CLAUDE.md con información relevante
argument-hint: [sección]
---

# Learn - Análisis de Conversación y Actualización de CLAUDE.md

Analiza la conversación actual para extraer patrones relevantes, decisiones, insights arquitectónicos y mejores prácticas, luego actualiza el archivo CLAUDE.md con esta información aprendida.

**Uso**: `/project:learn [sección]`

**Argumentos**:
- `sección` (opcional): Sección específica a actualizar (overview, architecture, principles, development, structure). Si no se proporciona, analiza y actualiza todas las secciones relevantes.

## Instrucciones de Implementación

### 1. Analizar Contexto de la Conversación

Revisar la conversación actual para identificar:

**Decisiones Técnicas**:
- Nuevos comandos creados o modificados
- Patrones arquitectónicos introducidos o cambiados
- Actualizaciones de configuración
- Patrones de uso de herramientas
- Enfoques de integración

**Patrones de Diseño**:
- Mejoras en experiencia de usuario
- Patrones de estructura de comandos
- Enfoques de manejo de errores
- Mecanismos de seguridad
- Convenciones de nomenclatura

**Evolución del Proyecto**:
- Nuevas características o capacidades añadidas
- Cambios en estructura de directorios
- Mejoras en flujos de trabajo
- Necesidades de documentación

**Mejores Prácticas Descubiertas**:
- Enfoques efectivos que funcionaron bien
- Anti-patrones a evitar
- Lecciones aprendidas de errores o iteraciones

### 2. Extraer Insights Clave

Del análisis, extraer:
- **Qué** se construyó o cambió
- **Por qué** se tomaron las decisiones
- **Cómo** encaja en la arquitectura existente
- **Impacto** en usuarios o desarrolladores

Enfocarse en información que ayudaría a:
- Futuras instancias de Claude trabajando en este código
- Desarrolladores entendiendo el proyecto
- Usuarios aprendiendo sobre características disponibles

### 3. Leer CLAUDE.md Actual

```bash
Leer CLAUDE.md para entender:
- Estructura y secciones actuales
- Nivel de documentación existente
- Gaps que podrían llenarse
- Información desactualizada a actualizar
```

### 4. Determinar Actualizaciones Necesarias

Basado en el argumento de sección (o todas las secciones si no se especifica):

**Actualizaciones de Project Overview**:
- Nuevas capacidades añadidas
- Cambios en alcance del proyecto
- Lista de características actualizada

**Actualizaciones de Architecture**:
- Nuevos tipos o categorías de comandos
- Cambios en estructura de directorios
- Patrones de integración
- Dependencias del sistema

**Actualizaciones de Key Design Principles**:
- Nuevos patrones UX descubiertos
- Características de seguridad añadidas
- Reglas de consistencia establecidas

**Actualizaciones de Development Notes**:
- Enfoques de testing
- Técnicas de debugging
- Limitaciones conocidas
- Flujos de trabajo de desarrollo

**Actualizaciones de File Structure**:
- Nuevos directorios creados
- Cambios en organización de archivos
- Adiciones de archivos de configuración

### 5. Actualizar CLAUDE.md

Aplicar actualizaciones usando la herramienta Edit:

**Guías**:
- Mantener estructura y formato existentes
- Añadir nueva información en secciones apropiadas
- Actualizar información desactualizada
- Mantener lenguaje conciso y claro
- Usar formato markdown consistentemente
- Preservar ejemplos de comandos y bloques de código
- Actualizar conteos de comandos y listados de archivos

**Qué Incluir**:
- Ejemplos concretos de nuevas características
- Rutas de archivos específicas y nombres de comandos
- Explicaciones claras del "por qué" detrás de decisiones
- Enlaces entre componentes relacionados

**Qué Evitar**:
- Descripciones excesivamente verbosas
- Detalles temporales o específicos de la sesión
- Opiniones personales sin mérito técnico
- Información redundante ya cubierta

### 6. Reportar Cambios

Proporcionar un resumen de actualizaciones realizadas:

```markdown
## CLAUDE.md Actualizado

### Secciones Modificadas:
- [Nombre de Sección]: [Breve descripción de cambios]

### Adiciones Clave:
- [Nueva información añadida]

### Información Actualizada:
- [Contenido desactualizado que fue revisado]

### Insights Capturados:
- [Patrones o decisiones importantes documentadas]
```

## Ejemplos de Uso

### Analizar conversación completa
```bash
/project:learn
```
*Revisa conversación completa, identifica todos los insights relevantes, actualiza todas las secciones aplicables*

### Actualizar sección específica
```bash
/project:learn architecture
```
*Se enfoca en aprendizajes relacionados con arquitectura, actualiza solo sección de Architecture*

### Después de crear nuevos comandos
```bash
# Después de conversación sobre crear nuevos comandos de gestión de proyectos
/project:learn
```
*Captura nueva categoría de comandos, actualiza sección de Comandos Disponibles, documenta patrones*

## Criterios de Éxito

- CLAUDE.md refleja con precisión el estado actual del proyecto
- Nuevos patrones y decisiones están documentados
- Estructura de archivos coincide con la realidad
- Listas de comandos están completas y precisas
- Principios de diseño capturan prácticas actuales
- Información es accionable para trabajo futuro

## Manejo de Errores

- **CLAUDE.md no encontrado**: Crear estructura básica desde plantilla
- **Sin insights significativos**: Reportar "No se necesitan actualizaciones"
- **Sección no encontrada**: Listar secciones disponibles
- **Cambios ambiguos**: Pedir aclaración antes de actualizar

## Notas

Este comando debería ejecutarse:
- Después de implementar nuevas características
- Después de cambios arquitectónicos
- Cuando emergen nuevos patrones
- Periódicamente para mantener documentación fresca
- Antes de terminar sesiones de trabajo

El objetivo es crear un sistema de documentación que aprende continuamente donde cada interacción mejora el contexto para trabajo futuro.
