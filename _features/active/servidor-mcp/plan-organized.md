# Servidor MCP - Plan Organizado por Capacidades

## Resumen de Reorganización

Este plan reorganiza las 74 tareas técnicas desde estructura de infraestructura (backend/frontend/testing) hacia **capacidades de usuario** que entregan valor incremental.

**Reorganización realizada:**
- **Antes**: Fase 1-14 por componentes técnicos (Server Core, Resources, Tools, Serializers...)
- **Ahora**: 3 capacidades de usuario priorizadas por valor entregado

**Beneficios:**
- Cada capacidad se puede implementar y probar de forma independiente
- Entrega valor incremental al usuario (no "todo o nada")
- Facilita desarrollo paralelo (diferentes capacidades por diferentes desarrolladores)
- Permite validar cada capacidad antes de continuar con la siguiente

---

## Capacidad 1: Conectar y Descubrir el Sistema MCP

### Valor para el Usuario
**Job To Be Done**: "Descubrir capacidades del sistema - Explorar qué recursos, herramientas y prompts están disponibles sin consultar documentación" (JTBD.md - Functional Job #6)

**User Story**: "Como nueva herramienta MCP conectándose al CRM, quiero explorar qué recursos, tools y prompts están disponibles, para no requerir documentación externa" (PRD.md - User Story 3)

**Impacto**: El usuario puede iniciar el servidor MCP, conectar Claude Code, y descubrir dinámicamente qué está disponible. **Sin esto, ninguna otra capacidad funciona**.

### Tareas de Implementación

#### Fundación (Completar Primero)
- [x] Investigar gema MCP oficial para Ruby (`gem 'mcp'` del SDK oficial)
- [x] Agregar gema MCP al Gemfile: `gem 'mcp'`
- [x] Ejecutar `bundle install`
- [x] Crear estructura de directorios: `lib/mcp/`

#### Funcionalidad Core
- [ ] Crear `lib/mcp/server.rb` - Core del servidor MCP
- [ ] Implementar MCP::Server initialization (name, version)
- [ ] Implementar JSON-RPC 2.0 message handling (request/response)
- [ ] Implementar lifecycle: `initialize` handshake
- [ ] Implementar `list_resources` endpoint (retorna recursos vacíos inicialmente)
- [ ] Implementar `list_tools` endpoint (retorna tools vacíos inicialmente)
- [ ] Setup stdio transport (StdioTransport para Claude Code)
- [ ] Crear rake task: `lib/tasks/mcp.rake`
- [ ] Implementar comando `bin/rails mcp:server` que inicia el servidor

#### Testing y Validación
- [ ] Test manual: ejecutar `bin/rails mcp:server` y verificar inicio
- [ ] Test manual: Claude Code puede conectarse al servidor
- [ ] Test manual: Claude Code recibe response a `initialize`
- [ ] Test: `list_resources` retorna array vacío (por ahora)
- [ ] Test: `list_tools` retorna array vacío (por ahora)
- [ ] Crear spec: `spec/lib/mcp/server_spec.rb` - Test initialize handshake

### Dependencias
- **Internas**: Ninguna (es la fundación)
- **Externas**: Gema `mcp` (SDK oficial de Ruby para MCP)

### Factores de Riesgo
- **Gema inmadura**: El SDK oficial de Ruby para MCP es reciente (2024), puede tener bugs
- **Protocolo cambiante**: MCP es estándar emergente, la spec puede actualizarse
- **Mitigación**: Aislar implementación en módulo `lib/mcp/`, fácil de reemplazar si es necesario

### Criterios de Aceptación
- [x] `bin/rails mcp:server` inicia sin errores
- [x] Claude Code se conecta y recibe response a initialize
- [x] `list_resources` y `list_tools` responden (aunque vacíos)

---

## Capacidad 2: Consultar Datos de Companies

### Valor para el Usuario
**Job To Be Done**: "Consultar datos del CRM - Obtener información de companies, contacts, deals, activities y notes de forma estructurada" (JTBD.md - Functional Job #1)

**User Story**: "Como desarrollador trabajando con Claude Code, quiero consultar información de companies mediante lenguaje natural, para que Claude Code genere código preciso basado en datos reales" (PRD.md - User Story 1)

**Impacto**: El usuario puede consultar companies desde Claude Code ("muéstrame todas las companies", "busca companies llamadas Acme"). **Primera capacidad con valor real**.

### Tareas de Implementación

#### Fundación (Completar Primero)
- [ ] Crear migración: `db/migrate/TIMESTAMP_add_indexes_for_mcp.rb`
- [ ] Agregar índice en `companies.name`
- [ ] Agregar índice en `companies.email`
- [ ] Ejecutar migración: `bin/rails db:migrate`

#### Funcionalidad Core - Resources
- [ ] Crear `lib/mcp/resources/registry.rb`
- [ ] Crear `lib/mcp/resources/company_resource.rb`
- [ ] Definir schema de CompanyResource (id, name, email, phone, address, website, industry)
- [ ] Definir URI template: `crm://companies/{id}`
- [ ] Registrar CompanyResource en Registry
- [ ] Actualizar `list_resources` para incluir companies

#### Funcionalidad Core - Tools
- [ ] Crear `lib/mcp/tools/registry.rb`
- [ ] Crear `lib/mcp/tools/companies/list_companies_tool.rb`
  - Input schema: limit (default 100), offset (default 0)
  - Implementar `execute(params)` método
- [ ] Crear `lib/mcp/tools/companies/get_company_tool.rb`
  - Input schema: id (required)
  - Implementar `execute(params)` método
- [ ] Crear `lib/mcp/tools/companies/search_companies_tool.rb`
  - Input schema: query (required, string)
  - Implementar `execute(params)` método
- [ ] Registrar tools en ToolRegistry
- [ ] Actualizar `list_tools` para incluir company tools

#### Funcionalidad Core - Query Builders
- [ ] Crear `lib/mcp/query_builders/company_query_builder.rb`
- [ ] Implementar `list(limit:, offset:)` con `.includes(:contacts, :deals)`
- [ ] Implementar `find(id)` con `.includes(:contacts, :deals)`
- [ ] Implementar `search(query:)` con LIKE en name/email
- [ ] Limitar resultados search a 50 (prevenir queries masivas)

#### Funcionalidad Core - Serializers
- [ ] Crear `lib/mcp/serializers/company_serializer.rb`
- [ ] Implementar `serialize(company)` retornando hash JSON
- [ ] Incluir campos: id, name, email, phone, address, website, industry, created_at, updated_at
- [ ] Incluir counts: contacts_count, deals_count (sin N+1)
- [ ] Formato ISO 8601 para fechas

#### Testing y Validación
- [ ] Test: `list_resources` incluye resource "companies"
- [ ] Test: `list_tools` incluye list_companies, get_company, search_companies
- [ ] Test manual Claude Code: "list all companies"
- [ ] Test manual Claude Code: "get company with id 1"
- [ ] Test manual Claude Code: "search companies named acme"
- [ ] Benchmark: medir latencia de list_companies (target < 500ms)
- [ ] Test: verificar uso de índices con `.explain`
- [ ] Crear spec: `spec/lib/mcp/tools/companies/list_companies_tool_spec.rb`
- [ ] Crear spec: `spec/lib/mcp/query_builders/company_query_builder_spec.rb`

### Dependencias
- **Internas**: Capacidad 1 completada (servidor MCP funcionando)
- **Externas**: Modelo Company existente (app/models/company.rb)

### Factores de Riesgo
- **N+1 queries**: Si no se usa `.includes()`, performance degradada
- **Queries lentas**: Sin índices, búsquedas por name/email serán lentas
- **Mitigación**: Query builders con eager loading, índices de BD, benchmarks

### Criterios de Aceptación
- [x] Claude Code puede ejecutar "list companies" y recibir resultados
- [x] Latencia < 500ms para queries simples (list, get)
- [x] Search by name/email funciona correctamente
- [x] No hay N+1 queries (verificado con logs)
- [x] Índices se usan en búsquedas (verificado con .explain)

---

## Capacidad 3: Consultar Datos de Contacts

### Valor para el Usuario
**Job To Be Done**: "Consultar datos del CRM - Obtener información de contacts de forma estructurada" (JTBD.md - Functional Job #1)

**Impacto**: El usuario puede consultar contacts asociados a companies, buscar por nombre/email, explorar relaciones del CRM.

### Tareas de Implementación

#### Fundación
- [ ] Agregar índice en `contacts.first_name` (migración ya creada en Capacidad 2)
- [ ] Agregar índice en `contacts.last_name`
- [ ] Agregar índice en `contacts.email`

#### Funcionalidad Core - Resources
- [ ] Crear `lib/mcp/resources/contact_resource.rb`
- [ ] Definir schema (id, first_name, last_name, email, phone, position, company_id)
- [ ] Definir URI template: `crm://contacts/{id}`
- [ ] Registrar ContactResource en Registry

#### Funcionalidad Core - Tools
- [ ] Crear `lib/mcp/tools/contacts/list_contacts_tool.rb`
- [ ] Crear `lib/mcp/tools/contacts/get_contact_tool.rb`
- [ ] Crear `lib/mcp/tools/contacts/search_contacts_tool.rb`
- [ ] Registrar contact tools en ToolRegistry

#### Funcionalidad Core - Query Builders & Serializers
- [ ] Crear `lib/mcp/query_builders/contact_query_builder.rb`
- [ ] Implementar eager loading: `.includes(:company, :deals)`
- [ ] Crear `lib/mcp/serializers/contact_serializer.rb`
- [ ] Incluir full_name, company info, deals_count

#### Testing y Validación
- [ ] Test manual Claude Code: "list contacts"
- [ ] Test manual Claude Code: "search contacts by email"
- [ ] Benchmark latencia (target < 500ms)
- [ ] Crear specs para contact tools

### Dependencias
- **Internas**: Capacidad 2 completada (company tools funcionando, índices de BD)
- **Externas**: Modelo Contact existente

### Criterios de Aceptación
- [x] Claude Code puede listar/buscar contacts
- [x] Latencia < 500ms
- [x] Eager loading funciona (no N+1)

---

## Capacidad 4: Consultar Datos de Deals

### Valor para el Usuario
**Job To Be Done**: "Ejecutar análisis complejos - Realizar filtros sobre deals por stage sin SQL directo" (JTBD.md - Functional Job #3)

**Impacto**: El usuario puede consultar deals, filtrar por stage (lead, qualification, proposal...), analizar pipeline de ventas.

### Tareas de Implementación

#### Fundación
- [ ] Agregar índice en `deals.stage` (migración ya creada)
- [ ] Agregar índice en `deals.created_at`

#### Funcionalidad Core - Resources
- [ ] Crear `lib/mcp/resources/deal_resource.rb`
- [ ] Definir schema (id, title, amount, stage, expected_close_date, contact_id, company_id)
- [ ] Registrar DealResource en Registry

#### Funcionalidad Core - Tools
- [ ] Crear `lib/mcp/tools/deals/list_deals_tool.rb`
- [ ] Crear `lib/mcp/tools/deals/get_deal_tool.rb`
- [ ] Crear `lib/mcp/tools/deals/search_deals_tool.rb`
- [ ] Crear `lib/mcp/tools/deals/filter_deals_by_stage_tool.rb` (usar Deal::STAGES)
- [ ] Registrar deal tools en ToolRegistry

#### Funcionalidad Core - Query Builders & Serializers
- [ ] Crear `lib/mcp/query_builders/deal_query_builder.rb`
- [ ] Implementar eager loading: `.includes(:contact, :company)`
- [ ] Implementar filter by stage con validación de stages válidos
- [ ] Crear `lib/mcp/serializers/deal_serializer.rb`
- [ ] Incluir stage label (Deal::STAGES), contact info, company info

#### Testing y Validación
- [ ] Test manual Claude Code: "show deals in proposal stage"
- [ ] Test manual Claude Code: "list deals closed this month"
- [ ] Test: filtrar por cada stage válido (lead, qualification, proposal...)
- [ ] Benchmark latencia
- [ ] Crear specs para deal tools

### Dependencias
- **Internas**: Capacidades 2-3 completadas
- **Externas**: Modelo Deal existente, Deal::STAGES constant

### Criterios de Aceptación
- [x] Claude Code puede filtrar deals por stage
- [x] Validación de stages inválidos (error claro)
- [x] Latencia < 500ms

---

## Capacidad 5: Consultar Activities y Notes (Polimórficas)

### Valor para el Usuario
**Job To Be Done**: "Proveer contexto a herramientas AI - Alimentar modelos con información completa del CRM incluyendo activities y notes" (JTBD.md - Functional Job #4)

**Impacto**: El usuario puede consultar activities y notes asociadas a companies/contacts/deals, obteniendo contexto completo.

### Tareas de Implementación

#### Funcionalidad Core - Resources
- [ ] Crear `lib/mcp/resources/activity_resource.rb`
- [ ] Crear `lib/mcp/resources/note_resource.rb`
- [ ] Definir schemas con asociaciones polimórficas (activitable_type, activitable_id)
- [ ] Registrar en Registry

#### Funcionalidad Core - Tools
- [ ] Crear `lib/mcp/tools/activities/list_activities_tool.rb`
  - Filtrar por activitable (company/contact/deal)
  - Input schema: activitable_type, activitable_id
- [ ] Crear `lib/mcp/tools/activities/get_activity_tool.rb`
- [ ] Crear `lib/mcp/tools/notes/list_notes_tool.rb`
- [ ] Crear `lib/mcp/tools/notes/get_note_tool.rb`
- [ ] Registrar tools en ToolRegistry

#### Funcionalidad Core - Query Builders & Serializers
- [ ] Crear `lib/mcp/query_builders/activity_query_builder.rb`
- [ ] Implementar `list_for_activitable(type:, id:)` con eager loading
- [ ] Crear `lib/mcp/query_builders/note_query_builder.rb`
- [ ] Crear serializers para Activity y Note
- [ ] Incluir info del parent (company/contact/deal)

#### Testing y Validación
- [ ] Test: listar activities de una company específica
- [ ] Test: listar notes de un deal específico
- [ ] Test: asociaciones polimórficas funcionan correctamente
- [ ] Crear specs para activity/note tools

### Dependencias
- **Internas**: Capacidades 2-4 completadas (companies, contacts, deals)
- **Externas**: Modelos Activity, Note existentes (polymorphic)

### Criterios de Aceptación
- [x] Claude Code puede consultar "activities for company 1"
- [x] Asociaciones polimórficas funcionan
- [x] Eager loading correcto

---

## Infraestructura de Soporte

### Autenticación y Seguridad

#### Tareas
- [ ] Crear `lib/mcp/authentication.rb`
- [ ] Implementar validación de token desde ENV['MCP_AUTH_TOKEN']
- [ ] Agregar middleware de autenticación al servidor
- [ ] Retornar error 401 si token inválido o ausente
- [ ] Documentar setup de MCP_AUTH_TOKEN en README
- [ ] Test: intentar conectar sin token (debe fallar con 401)

### Logging y Auditoría

#### Tareas
- [ ] Crear `lib/mcp/logger.rb`
- [ ] Loggear cada tool execution (tool name, params, latency, result)
- [ ] Loggear conexiones de clientes (timestamp, client info)
- [ ] Loggear errores y excepciones con stack trace
- [ ] Setup log rotation para `log/mcp_audit.log`
- [ ] Test: ejecutar operaciones y verificar logs completos

### Rate Limiting

#### Tareas
- [ ] Crear `lib/mcp/rate_limiter.rb`
- [ ] Implementar límite simple: 60 requests/minuto por client
- [ ] Integrar con servidor (check antes de ejecutar tool)
- [ ] Retornar error 429 si se excede límite
- [ ] Loggear rate limit violations
- [ ] Test: ejecutar 61 requests en 1 minuto (debe bloquear el 61)

### Documentación

#### Tareas
- [ ] Crear `README_MCP.md` con setup instructions
- [ ] Documentar prerequisitos (Ruby, Rails, gema MCP)
- [ ] Documentar comando de inicio: `bin/rails mcp:server`
- [ ] Listar todos los tools disponibles con ejemplos
- [ ] Documentar configuración de autenticación (MCP_AUTH_TOKEN)
- [ ] Ejemplos de queries comunes con Claude Code
- [ ] Troubleshooting: errores comunes y soluciones
- [ ] Actualizar `CLAUDE.md` con información del servidor MCP

---

## Secuencia de Implementación Recomendada

### Fase 1: Fundación (Capacidad 1)
**Duración estimada**: 1-2 días
**Por qué primero**: Sin servidor MCP funcionando, nada más funciona. Es la base.

**Entregables**:
- Servidor MCP inicia con `bin/rails mcp:server`
- Claude Code se conecta exitosamente
- `list_resources` y `list_tools` responden (aunque vacíos)

### Fase 2: Primera Capacidad de Valor (Capacidad 2 - Companies)
**Duración estimada**: 2-3 días
**Por qué segundo**: Companies es el recurso más simple, sin dependencias complejas. Valida que el patrón completo funciona (resource → tools → query builder → serializer).

**Entregables**:
- Claude Code puede consultar companies
- Performance < 500ms validada
- No hay N+1 queries

### Fase 3: Expandir Recursos (Capacidades 3-4: Contacts, Deals)
**Duración estimada**: 2-3 días
**Por qué tercero**: Reutiliza el patrón validado en Capacidad 2. Contacts y Deals pueden desarrollarse en paralelo si hay 2 desarrolladores.

**Entregables**:
- Claude Code puede consultar contacts, deals
- Filtrado por stage funciona
- Performance validada

### Fase 4: Asociaciones Polimórficas (Capacidad 5)
**Duración estimada**: 1-2 días
**Por qué cuarto**: Requiere que companies/contacts/deals estén disponibles. Es más complejo por las asociaciones polimórficas.

**Entregables**:
- Claude Code puede consultar activities/notes
- Asociaciones polimórficas funcionan

### Fase 5: Seguridad y Producción (Infraestructura de Soporte)
**Duración estimada**: 2 días
**Por qué último**: Autenticación, logging y rate limiting son críticos para producción, pero no bloquean desarrollo/testing.

**Entregables**:
- Autenticación funciona
- Logging exhaustivo
- Rate limiting previene abuso
- Documentación completa

---

## Oportunidades de Desarrollo Paralelo

### Equipo de 2 Desarrolladores

**Developer A**:
1. Capacidad 1 (fundación)
2. Capacidad 2 (companies)
3. Capacidad 4 (deals)
4. Infraestructura: Autenticación + Logging

**Developer B**:
1. Esperar Capacidad 1 completada
2. Capacidad 3 (contacts) - **Paralelo con Dev A trabajando en deals**
3. Capacidad 5 (activities/notes)
4. Infraestructura: Rate Limiting + Documentación

**Punto de sincronización**: Después de Capacidad 2, ambos desarrolladores pueden trabajar en paralelo (Capacidad 3 y 4 son independientes).

### Equipo de 1 Desarrollador

Seguir la secuencia lineal:
1. Capacidad 1 → 2 → 3 → 4 → 5 → Infraestructura

**Estimación total**: 10-14 días de desarrollo

---

*Plan organizado por capacidades de usuario*
*Total de tareas: 74 checkboxes*
