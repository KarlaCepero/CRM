# Servidor MCP - Product Requirements Document

## Executive Summary
**Job To Be Done**: Cuando estoy desarrollando o manteniendo el CRM y necesito que sistemas externos accedan a los datos de forma programática, quiero exponer una interfaz estandarizada mediante Model Context Protocol, para integrar el CRM con el ecosistema de herramientas modernas de desarrollo y AI sin construir APIs personalizadas para cada caso de uso.

**Solución Propuesta**: Implementar un servidor MCP (Model Context Protocol) para el CRM que exponga recursos (Companies, Contacts, Deals, Activities, Notes), herramientas (CRUD operations, queries), y prompts (templates de interacción común) siguiendo el estándar MCP.

**Impacto Esperado**:
- Claude Code puede generar código preciso usando datos reales del CRM
- Reducción del 80% en tiempo de desarrollo vs. APIs REST personalizadas
- Latencia < 500ms para queries simples
- Soporte para 10+ conexiones concurrentes

## Problem Statement
### El Problema
Los desarrolladores, product managers y administradores del sistema enfrentan **fricción constante en el ciclo de desarrollo** cuando necesitan que herramientas externas (Claude Code, IDEs, scripts de automatización) accedan a datos del CRM. Actualmente deben:
- Construir APIs REST personalizadas (alto costo de desarrollo y mantenimiento)
- Exportar datos manualmente a CSV/Excel (propenso a errores, datos obsoletos)
- Ejecutar consultas SQL directas (riesgoso, sin control de acceso)
- Crear scripts fragmentados sin estandarización

Esto resulta en **pérdida de contexto** al cambiar constantemente entre escribir código → consultar datos → volver al código.

### Por Qué Ahora
- **Claude Code necesita acceso**: Para generar código más preciso y contextual basado en datos reales del CRM
- **Análisis AI sin exportación manual**: Los PMs quieren usar herramientas AI para analizar métricas directamente
- **Automatización de workflows**: Administradores necesitan automatizar tareas repetitivas desde herramientas externas
- **Dashboards personalizados**: Usuarios avanzados quieren crear visualizaciones con datos en tiempo real
- **MCP como estándar emergente**: El ecosistema de herramientas MCP está creciendo rápidamente

### Alternativas Actuales
1. **API REST personalizada**: Alto overhead de desarrollo, documentación, versionado
2. **Exportación manual**: CSV/Excel - no automatizable, datos obsoletos
3. **SQL directo**: Requiere conocimiento técnico, sin control de acceso granular
4. **Webhooks**: Unidireccional, solo eventos específicos, no queries on-demand
5. **Scripts personalizados**: Fragmentados, difíciles de mantener

## User Stories & Acceptance Criteria

### User Story 1: Consultar Datos del CRM desde Claude Code
**Como** desarrollador del CRM trabajando con Claude Code
**Quiero** consultar información de companies, contacts, deals, activities y notes mediante lenguaje natural
**Para** que Claude Code genere código preciso basado en datos reales sin exportar manualmente

**Acceptance Criteria:**
- [ ] Claude Code puede conectarse al servidor MCP ejecutando `bin/rails mcp:server`
- [ ] Claude Code puede listar todos los recursos disponibles (companies, contacts, deals, activities, notes)
- [ ] Puedo consultar "muéstrame los top 5 deals del mes pasado" y recibir resultados estructurados
- [ ] Las respuestas incluyen todos los campos relevantes del modelo Rails
- [ ] La latencia para queries simples es < 500ms
- [ ] Los errores se retornan con mensajes claros y códigos de estado apropiados

### User Story 2: Modificar Datos del CRM
**Como** usuario avanzado con permisos de escritura
**Quiero** crear, actualizar o eliminar registros del CRM mediante herramientas MCP
**Para** automatizar workflows sin necesidad de la interfaz web

**Acceptance Criteria:**
- [ ] Puedo crear una nueva company/contact/deal mediante tools MCP
- [ ] Puedo actualizar campos específicos de registros existentes
- [ ] Puedo eliminar registros (respetando `dependent: :destroy` del modelo)
- [ ] Las validaciones del modelo Rails se aplican y retornan errores claros
- [ ] Todas las operaciones de escritura se auditan en logs
- [ ] Las operaciones respetan permisos de seguridad (autenticación/autorización)

### User Story 3: Descubrir Capabilities del Sistema
**Como** nueva herramienta MCP conectándose al CRM
**Quiero** explorar qué recursos, tools y prompts están disponibles
**Para** no requerir documentación externa y descubrir funcionalidades dinámicamente

**Acceptance Criteria:**
- [ ] La herramienta puede llamar al endpoint de capabilities y recibir lista completa
- [ ] Cada recurso incluye descripción, schema de datos y operaciones soportadas
- [ ] Cada tool incluye nombre, descripción, parámetros requeridos/opcionales
- [ ] Los prompts incluyen templates de interacción común con ejemplos
- [ ] La respuesta sigue el formato estándar MCP para capabilities

## MVP Scope

### ¿Qué DEBE tener el MVP?

**Servidor Base**
- Comando `bin/rails mcp:server` para iniciar el servidor MCP
- Implementación del protocolo MCP siguiendo el estándar oficial
- Manejo de conexiones concurrentes (mínimo 10)

**Recursos (Read-only en MVP)**
- Companies: listar, buscar, obtener por ID
- Contacts: listar, buscar, obtener por ID
- Deals: listar, buscar, obtener por ID, filtrar por stage
- Activities: listar por recurso asociado (company/contact/deal)
- Notes: listar por recurso asociado

**Tools (CRUD básico)**
- `list_companies`, `get_company`, `search_companies`
- `list_contacts`, `get_contact`, `search_contacts`
- `list_deals`, `get_deal`, `search_deals`, `filter_deals_by_stage`
- `list_activities`, `get_activity`
- `list_notes`, `get_note`

**Seguridad Básica**
- Autenticación mediante token en configuración
- Logging de todas las operaciones (audit trail)
- Rate limiting básico (prevenir abuso)

**Documentación Mínima**
- README con setup instructions
- Ejemplos de uso con Claude Code
- Lista de tools disponibles

### ¿Qué NO tendrá v1?

**Pospuesto para v2**
- Operaciones de escritura (create/update/delete) - Solo lectura en MVP
- Queries complejas con joins múltiples
- Agregaciones avanzadas (sumas, promedios, reportes)
- Caché de queries para optimización
- WebSocket streaming para actualizaciones en tiempo real
- Soporte para attachments/archivos
- Integración con Active Storage
- Export masivo de datos
- Bulk operations

**No priorizamos porque**
- Lectura cubre 80% de casos de uso iniciales (generar código, análisis)
- Escritura requiere más robustez en seguridad y auditoría
- Queries complejas pueden agregarse basado en demanda real

### ¿Qué nunca haremos?

- **Reemplazar la interfaz web del CRM**: MCP es complementario, no sustituto de la UI
- **Inventar nuestro propio protocolo**: Seguimos estrictamente el estándar MCP
- **Exponer datos sin autenticación**: Security by design desde día 1
- **Modificar código core del CRM**: El servidor MCP es una capa externa/opcional
- **Soportar protocolos legacy**: Solo MCP, no GraphQL, REST, SOAP, etc.

## Success Metrics

### Métricas de Adopción (Leading Indicators)
- **Sesiones semanales de Claude Code**: Target: 10+ sesiones/semana en primer mes
- **Comandos ejecutados diariamente**: Target: 50+ queries/día al mes 2
- **Tiempo promedio de setup**: Target: < 5 minutos desde instalación hasta primera query exitosa
- **Tasa de error en queries**: Target: < 5% de queries fallan

### Métricas de Outcome (Lagging Indicators)
- **Tiempo ahorrado vs API REST**: Target: 80% reducción (medido en horas de desarrollo)
- **Velocidad de desarrollo**: Target: 2x más rápido en features que usan MCP vs. manual
- **Satisfacción de desarrolladores**: Target: NPS > 40 en survey post-uso
- **Adopción de herramientas**: Target: 2+ herramientas diferentes conectadas (Claude Code + otra)

### Criterios para Pivot/Persevere/Kill (30 días post-launch)
- **Persevere**:
  - ≥ 8 sesiones semanales de Claude Code
  - ≥ 30 queries/día
  - NPS ≥ 30
  - 0 incidentes de seguridad

- **Pivot**:
  - 3-7 sesiones semanales (hay interés pero algo falla)
  - Tasa de error > 10% (problemas de implementación)
  - Feedback negativo sobre performance o usabilidad

- **Kill**:
  - < 3 sesiones semanales (no hay adopción)
  - No se usa después de setup inicial (falta value)
  - Incidentes de seguridad críticos no mitigables

## Dependencies & Risks

### Dependencias Internas
- **Modelos Rails existentes**: Company, Contact, Deal, Activity, Note deben ser estables
- **Schema de base de datos**: Cambios en schema requieren actualizar MCP resources
- **Autenticación**: Sistema de tokens o API keys para autenticación

### Dependencias Externas
- **Gema MCP para Ruby**: Puede requerir desarrollo custom si no existe gema oficial
- **Protocolo MCP**: Cambios en el estándar MCP pueden requerir actualizaciones
- **Claude Code**: Actualizaciones de Claude Code pueden cambiar el cliente MCP

### Riesgos Identificados

1. **Riesgo: Protocolo MCP inmaduro**
   - **Descripción**: MCP es estándar emergente, puede cambiar frecuentemente
   - **Mitigación**: Aislar implementación del protocolo en módulo separado para facilitar actualizaciones; monitorear spec oficial; versionar el servidor

2. **Riesgo: Performance degradada con múltiples conexiones**
   - **Descripción**: N+1 queries, falta de índices, conexiones bloqueantes
   - **Mitigación**: Implementar eager loading (`.includes`), revisar índices de BD, usar threading/async si necesario

3. **Riesgo: Exposición de datos sensibles**
   - **Descripción**: Datos confidenciales del CRM accesibles sin control adecuado
   - **Mitigación**: Autenticación obligatoria desde día 1, logging exhaustivo, rate limiting, revisar qué campos exponer (ej: no exponer IPs, datos de pago)

4. **Riesgo: Adopción baja por complejidad de setup**
   - **Descripción**: Si es difícil configurar, los usuarios no lo adoptarán
   - **Mitigación**: Setup con un solo comando (`bin/rails mcp:server`), documentación clara con ejemplos, video tutorial de 2 minutos

5. **Riesgo: Scope creep hacia "API completa"**
   - **Descripción**: Presión para agregar features complejos antes de validar MVP
   - **Mitigación**: Aplicar YAGNI rigurosamente, requerir justificación basada en uso real antes de agregar features, mantener backlog priorizado

## Open Questions
- [ ] ¿Necesitamos soporte para campos personalizados (custom attributes) en el MVP?
- [ ] ¿Qué biblioteca Ruby usaremos para implementar MCP? (evaluar opciones disponibles)
- [ ] ¿El servidor debe correr en proceso separado o integrado con Rails server?
- [ ] ¿Usamos SQLite directamente o pasamos por ActiveRecord para queries? (trade-off performance vs. validaciones)
- [ ] ¿Cómo manejamos paginación en listas grandes? (límite de resultados, cursor-based, offset-based)
- [ ] ¿Necesitamos versionado del servidor MCP desde el día 1? (ej: mcp/v1)

## Out of Scope
- **Sincronización bidireccional con CRMs externos** (Salesforce, HubSpot): Esto es una integración compleja, no parte del servidor MCP
- **UI web para administrar el servidor MCP**: Configuración mediante YAML/ENV es suficiente
- **Webhooks para notificaciones**: Diferente patrón de integración, no parte de MCP
- **Soporte para queries SQL arbitrarios**: Riesgo de seguridad, no exponer SQL raw
- **Sistema de permisos granular por campo**: Permisos a nivel de recurso es suficiente para MVP
- **Multi-tenancy**: El CRM actual es single-tenant, MCP hereda esa arquitectura
- **Internacionalización del servidor**: Mensajes en inglés son estándar para APIs
- **GraphQL o REST endpoints**: Solo MCP, no duplicar protocolos

---
*PRD creado: 2025-10-16T18:55:00Z*
*Basado en JTBD: servidor-mcp/JTBD.md*
