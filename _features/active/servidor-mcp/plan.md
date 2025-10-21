# Servidor MCP - Plan Técnico de Implementación

## Resumen
**Job To Be Done**: Cuando estoy desarrollando o manteniendo el CRM y necesito que sistemas externos accedan a los datos de forma programática, quiero exponer una interfaz estandarizada mediante Model Context Protocol, para integrar el CRM con el ecosistema de herramientas modernas de desarrollo y AI sin construir APIs personalizadas para cada caso de uso.

**Solución**: Implementar un servidor MCP standalone que exponga los modelos existentes del CRM (Companies, Contacts, Deals, Activities, Notes) mediante el protocolo MCP, con operaciones read-only en MVP, autenticación mediante token, y logging completo de operaciones.

**Enfoque Técnico**:
- Servidor MCP independiente usando Ruby que se ejecuta con `bin/rails mcp:server`
- Implementación del protocolo MCP utilizando la gema `ruby-lsp` o desarrollo custom si no existe gema oficial
- Acceso a modelos Rails existentes vía ActiveRecord (no SQL directo)
- Servidor basado en stdio/TCP para comunicación con clientes MCP
- Autenticación mediante token en variable de entorno
- Logging exhaustivo con Rails.logger

## Arquitectura del Servidor MCP

### Componentes Principales

#### 1. MCP Server Core (`lib/mcp/server.rb`)
**Responsabilidad**: Implementar el protocolo MCP base, manejar conexiones, routing de mensajes

**Estructura**:
```ruby
module Mcp
  class Server
    # Inicializar servidor MCP
    # Manejar lifecycle (initialize, list_resources, list_tools, call_tool)
    # Routing de mensajes JSON-RPC
    # Error handling siguiendo spec MCP
  end
end
```

**Métodos clave**:
- `start`: Iniciar servidor (stdio o TCP)
- `handle_request(request)`: Router de mensajes MCP
- `list_capabilities`: Retornar capabilities del servidor
- `authenticate(token)`: Validar token de autenticación

#### 2. Resource Registry (`lib/mcp/resources/registry.rb`)
**Responsabilidad**: Registrar y exponer recursos (Companies, Contacts, Deals, Activities, Notes)

**Recursos a exponer**:
```ruby
module Mcp
  module Resources
    class Registry
      RESOURCES = {
        'companies' => CompanyResource,
        'contacts' => ContactResource,
        'deals' => DealResource,
        'activities' => ActivityResource,
        'notes' => NoteResource
      }
    end
  end
end
```

Cada Resource class implementa:
- `schema`: Definir estructura de datos (campos, tipos)
- `uri_template`: Template para acceder a recursos individuales
- `description`: Descripción legible del recurso

#### 3. Tool Registry (`lib/mcp/tools/registry.rb`)
**Responsabilidad**: Registrar y ejecutar herramientas (list, get, search por cada recurso)

**Tools MVP (Read-only)**:
```ruby
module Mcp
  module Tools
    class Registry
      TOOLS = {
        # Companies
        'list_companies' => ListCompaniesTool,
        'get_company' => GetCompanyTool,
        'search_companies' => SearchCompaniesTool,

        # Contacts
        'list_contacts' => ListContactsTool,
        'get_contact' => GetContactTool,
        'search_contacts' => SearchContactsTool,

        # Deals
        'list_deals' => ListDealsTool,
        'get_deal' => GetDealTool,
        'search_deals' => SearchDealsTool,
        'filter_deals_by_stage' => FilterDealsByStageTool,

        # Activities
        'list_activities' => ListActivitiesTool,
        'get_activity' => GetActivityTool,

        # Notes
        'list_notes' => NotesTool,
        'get_note' => GetNoteTool
      }
    end
  end
end
```

Cada Tool implementa:
- `name`: Nombre del tool
- `description`: Descripción de qué hace
- `input_schema`: JSON Schema de parámetros (requeridos/opcionales)
- `execute(params)`: Lógica de ejecución, retorna resultado estructurado

#### 4. Query Builders (`lib/mcp/query_builders/`)
**Responsabilidad**: Construir queries ActiveRecord eficientes, evitar N+1, aplicar eager loading

**Ejemplo**:
```ruby
module Mcp
  module QueryBuilders
    class CompanyQueryBuilder
      def self.list(limit: 100, offset: 0)
        Company.includes(:contacts, :deals)
               .limit(limit)
               .offset(offset)
               .order(created_at: :desc)
      end

      def self.search(query:)
        Company.includes(:contacts, :deals)
               .where("name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%")
               .limit(50)
      end
    end
  end
end
```

**Optimizaciones**:
- Usar `.includes()` para eager loading
- Limitar resultados (default 100, max 500)
- Índices en campos de búsqueda (name, email)

#### 5. Serializers (`lib/mcp/serializers/`)
**Responsabilidad**: Convertir modelos Rails a formato JSON compatible con MCP

**Ejemplo**:
```ruby
module Mcp
  module Serializers
    class CompanySerializer
      def self.serialize(company)
        {
          id: company.id,
          name: company.name,
          email: company.email,
          phone: company.phone,
          address: company.address,
          website: company.website,
          industry: company.industry,
          created_at: company.created_at.iso8601,
          updated_at: company.updated_at.iso8601,
          contacts_count: company.contacts.size,
          deals_count: company.deals.size
        }
      end
    end
  end
end
```

**Consideraciones**:
- No exponer campos sensibles (contraseñas, tokens internos)
- Formato ISO 8601 para fechas
- Incluir counts de asociaciones (evitar queries adicionales)

#### 6. Authentication (`lib/mcp/authentication.rb`)
**Responsabilidad**: Validar token de autenticación

**Implementación**:
```ruby
module Mcp
  class Authentication
    def self.authenticate(token)
      expected_token = ENV['MCP_AUTH_TOKEN']
      raise AuthenticationError, "Invalid token" unless token == expected_token
      true
    end
  end
end
```

**Configuración**:
- Token en variable de entorno: `MCP_AUTH_TOKEN=secret_token_here`
- Validación en cada request
- Logging de intentos fallidos

#### 7. Logger (`lib/mcp/logger.rb`)
**Responsabilidad**: Logging exhaustivo de operaciones para auditoría

**Eventos a loggear**:
- Conexión de cliente (timestamp, IP si disponible)
- Cada tool execution (tool name, params, user)
- Resultados (success/error, latency)
- Intentos de autenticación fallidos
- Errores y excepciones

**Formato**:
```ruby
Rails.logger.info "[MCP] Tool executed: #{tool_name} | Params: #{params} | Latency: #{latency}ms"
```

### Arquitectura de Comando

#### Rake Task: `bin/rails mcp:server`
**Ubicación**: `lib/tasks/mcp.rake`

```ruby
namespace :mcp do
  desc "Start MCP server"
  task server: :environment do
    require 'mcp/server'



    server = Mcp::Server.new
    server.start
  end
end
```

**Comportamiento**:
- Cargar environment de Rails (acceso a modelos)
- Inicializar servidor MCP
- Escuchar en stdio (standard input/output) para comunicación con Claude Code
- Logging a `log/mcp.log`

### Modelos Existentes (Sin Modificación)

**No modificar modelos core del CRM**. El servidor MCP es una capa externa que consume los modelos via ActiveRecord.

**Modelos a exponer**:
- `Company` (app/models/company.rb)
- `Contact` (app/models/contact.rb)
- `Deal` (app/models/deal.rb)
- `Activity` (app/models/activity.rb)
- `Note` (app/models/note.rb)

**Relaciones existentes a aprovechar**:
- `Company.has_many :contacts`
- `Company.has_many :deals`
- `Contact.belongs_to :company`
- `Deal.belongs_to :contact`
- `Deal.belongs_to :company`
- Polymorphic: `Activity.belongs_to :activitable`
- Polymorphic: `Note.belongs_to :notable`

### Índices de Base de Datos

**Revisar índices existentes** para performance de búsqueda:

```ruby
# db/migrate/TIMESTAMP_add_indexes_for_mcp.rb
class AddIndexesForMcp < ActiveRecord::Migration[8.0]
  def change
    # Búsqueda por nombre/email en companies
    add_index :companies, :name unless index_exists?(:companies, :name)
    add_index :companies, :email unless index_exists?(:companies, :email)

    # Búsqueda en contacts
    add_index :contacts, :first_name unless index_exists?(:contacts, :first_name)
    add_index :contacts, :last_name unless index_exists?(:contacts, :last_name)
    add_index :contacts, :email unless index_exists?(:contacts, :email)

    # Filtrado de deals por stage
    add_index :deals, :stage unless index_exists?(:deals, :stage)
    add_index :deals, :created_at unless index_exists?(:deals, :created_at)
  end
end
```

## Protocolo MCP: Mensajes Clave

### Initialize
**Request**:
```json
{
  "jsonrpc": "2.0",
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {},
    "clientInfo": {
      "name": "claude-code",
      "version": "1.0.0"
    }
  },
  "id": 1
}
```

**Response**:
```json
{
  "jsonrpc": "2.0",
  "result": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "resources": {},
      "tools": {}
    },
    "serverInfo": {
      "name": "crm-mcp-server",
      "version": "0.1.0"
    }
  },
  "id": 1
}
```

### List Resources
**Response** (ejemplo parcial):
```json
{
  "jsonrpc": "2.0",
  "result": {
    "resources": [
      {
        "uri": "crm://companies",
        "name": "Companies",
        "description": "List of all companies in the CRM",
        "mimeType": "application/json"
      },
      {
        "uri": "crm://companies/{id}",
        "name": "Company by ID",
        "description": "Get a specific company by ID",
        "mimeType": "application/json"
      }
    ]
  }
}
```

### List Tools
**Response** (ejemplo parcial):
```json
{
  "jsonrpc": "2.0",
  "result": {
    "tools": [
      {
        "name": "list_companies",
        "description": "List companies with pagination",
        "inputSchema": {
          "type": "object",
          "properties": {
            "limit": { "type": "integer", "default": 100 },
            "offset": { "type": "integer", "default": 0 }
          }
        }
      },
      {
        "name": "search_companies",
        "description": "Search companies by name or email",
        "inputSchema": {
          "type": "object",
          "properties": {
            "query": { "type": "string", "description": "Search term" }
          },
          "required": ["query"]
        }
      }
    ]
  }
}
```

### Call Tool
**Request**:
```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "search_companies",
    "arguments": {
      "query": "acme"
    }
  },
  "id": 5
}
```

**Response**:
```json
{
  "jsonrpc": "2.0",
  "result": {
    "content": [
      {
        "type": "text",
        "text": "Found 2 companies matching 'acme':\n\n1. Acme Corp (acme@example.com)\n2. Acme Industries (contact@acme.com)"
      }
    ],
    "isError": false
  },
  "id": 5
}
```

## Seguridad y Rate Limiting

### Autenticación
- Token en ENV: `MCP_AUTH_TOKEN=your_secret_token_here`
- Validación en cada request (middleware)
- Error 401 si falta o es inválido

### Rate Limiting (MVP simple)
```ruby
module Mcp
  class RateLimiter
    MAX_REQUESTS_PER_MINUTE = 60

    def self.check(client_id)
      # Implementación simple con Redis o memoria
      # Retornar error 429 si se excede límite
    end
  end
end
```

### Logging de Auditoría
- Cada operación loggea: timestamp, tool, params, result, latency
- Almacenar en `log/mcp_audit.log`
- Incluir client info si está disponible

## Checklist de Implementación

### Fase 1: Servidor Base y Protocolo
- [ ] Investigar gema MCP para Ruby o preparar implementación custom
- [ ] Crear `lib/mcp/server.rb` - Core del servidor MCP
- [ ] Implementar JSON-RPC message handling
- [ ] Implementar lifecycle: initialize, list_resources, list_tools
- [ ] Crear rake task: `lib/tasks/mcp.rake` (`bin/rails mcp:server`)
- [ ] Setup stdio communication (entrada/salida estándar)
- [ ] Test manual: iniciar servidor y recibir initialize request

### Fase 2: Resources Registry
- [ ] Crear `lib/mcp/resources/registry.rb`
- [ ] Implementar `CompanyResource` con schema
- [ ] Implementar `ContactResource` con schema
- [ ] Implementar `DealResource` con schema
- [ ] Implementar `ActivityResource` con schema
- [ ] Implementar `NoteResource` con schema
- [ ] Test: list_resources retorna todos los recursos con schema correcto

### Fase 3: Tools - Companies
- [ ] Crear `lib/mcp/tools/registry.rb`
- [ ] Implementar `ListCompaniesTool` (limit, offset)
- [ ] Implementar `GetCompanyTool` (by ID)
- [ ] Implementar `SearchCompaniesTool` (query por name/email)
- [ ] Crear `lib/mcp/query_builders/company_query_builder.rb`
- [ ] Aplicar eager loading (`.includes(:contacts, :deals)`)
- [ ] Test: ejecutar cada tool y verificar resultados

### Fase 4: Tools - Contacts
- [ ] Implementar `ListContactsTool`
- [ ] Implementar `GetContactTool`
- [ ] Implementar `SearchContactsTool`
- [ ] Crear `lib/mcp/query_builders/contact_query_builder.rb`
- [ ] Aplicar eager loading (`.includes(:company, :deals)`)
- [ ] Test: ejecutar tools y verificar performance

### Fase 5: Tools - Deals
- [ ] Implementar `ListDealsTool`
- [ ] Implementar `GetDealTool`
- [ ] Implementar `SearchDealsTool`
- [ ] Implementar `FilterDealsByStageTool` (usar Deal::STAGES)
- [ ] Crear `lib/mcp/query_builders/deal_query_builder.rb`
- [ ] Aplicar eager loading (`.includes(:contact, :company)`)
- [ ] Test: filtrar por cada stage y verificar resultados

### Fase 6: Tools - Activities & Notes
- [ ] Implementar `ListActivitiesTool` (filtrar por activitable)
- [ ] Implementar `GetActivityTool`
- [ ] Implementar `ListNotesTool` (filtrar por notable)
- [ ] Implementar `GetNoteTool`
- [ ] Crear query builders para Activities y Notes
- [ ] Manejar asociaciones polimórficas correctamente
- [ ] Test: listar activities/notes de una company específica

### Fase 7: Serializers
- [ ] Crear `lib/mcp/serializers/company_serializer.rb`
- [ ] Crear `lib/mcp/serializers/contact_serializer.rb`
- [ ] Crear `lib/mcp/serializers/deal_serializer.rb`
- [ ] Crear `lib/mcp/serializers/activity_serializer.rb`
- [ ] Crear `lib/mcp/serializers/note_serializer.rb`
- [ ] Incluir counts de asociaciones sin N+1 queries
- [ ] Test: verificar formato JSON y performance

### Fase 8: Autenticación y Seguridad
- [ ] Crear `lib/mcp/authentication.rb`
- [ ] Implementar validación de token desde ENV
- [ ] Agregar middleware de autenticación a servidor
- [ ] Retornar error 401 si token inválido
- [ ] Documentar setup de `MCP_AUTH_TOKEN` en README
- [ ] Test: intentar conectar sin token (debe fallar)

### Fase 9: Logging y Auditoría
- [ ] Crear `lib/mcp/logger.rb`
- [ ] Loggear cada tool execution (params, latency, result)
- [ ] Loggear conexiones de clientes
- [ ] Loggear errores y excepciones
- [ ] Setup log rotation para `log/mcp_audit.log`
- [ ] Test: ejecutar operaciones y verificar logs completos

### Fase 10: Performance y Optimización
- [ ] Crear migración: `db/migrate/TIMESTAMP_add_indexes_for_mcp.rb`
- [ ] Agregar índices en companies (name, email)
- [ ] Agregar índices en contacts (first_name, last_name, email)
- [ ] Agregar índices en deals (stage, created_at)
- [ ] Ejecutar migración: `bin/rails db:migrate`
- [ ] Benchmark queries con `.explain` para verificar uso de índices
- [ ] Test: medir latencia de queries (target < 500ms)

### Fase 11: Rate Limiting
- [ ] Crear `lib/mcp/rate_limiter.rb`
- [ ] Implementar límite simple (60 requests/minuto)
- [ ] Integrar con servidor (check antes de ejecutar tool)
- [ ] Retornar error 429 si se excede límite
- [ ] Loggear rate limit violations
- [ ] Test: ejecutar 61 requests en 1 minuto (debe bloquear)

### Fase 12: Testing Completo
- [ ] Crear spec: `spec/lib/mcp/server_spec.rb`
- [ ] Test: initialize handshake
- [ ] Test: list_resources retorna todos los recursos
- [ ] Test: list_tools retorna todos los tools
- [ ] Test: call_tool con cada tool disponible
- [ ] Test: autenticación (válida e inválida)
- [ ] Test: rate limiting
- [ ] Test: error handling (tool no existe, params inválidos)
- [ ] Ejecutar test suite completo: `bin/rails test`

### Fase 13: Integración con Claude Code
- [ ] Iniciar servidor: `bin/rails mcp:server`
- [ ] Configurar Claude Code para conectarse al servidor
- [ ] Test: Claude Code puede listar recursos
- [ ] Test: Claude Code puede ejecutar "list companies"
- [ ] Test: Claude Code puede buscar "deals en stage proposal"
- [ ] Test: Consulta compleja: "muéstrame los top 5 deals del mes pasado"
- [ ] Medir latencia de queries reales (target < 500ms)
- [ ] Verificar logs de auditoría

### Fase 14: Documentación
- [ ] Crear `README_MCP.md` con setup instructions
- [ ] Documentar prerequisitos (Ruby, Rails, ENV variables)
- [ ] Documentar comando de inicio: `bin/rails mcp:server`
- [ ] Listar todos los tools disponibles con ejemplos
- [ ] Documentar configuración de autenticación
- [ ] Ejemplos de queries comunes con Claude Code
- [ ] Troubleshooting common issues
- [ ] Actualizar `CLAUDE.md` con información del servidor MCP

## Dependencies & Risks

### Dependencias Internas
- **Modelos Rails**: Company, Contact, Deal, Activity, Note (estables, no modificar)
- **ActiveRecord**: Para queries y serialización
- **Rails.logger**: Para logging de auditoría

### Dependencias Externas
- **Gema MCP para Ruby**: Investigar si existe (`ruby-lsp`, `mcp-ruby`)
  - Si no existe: Implementar protocolo MCP manualmente siguiendo spec oficial
- **Protocolo MCP spec**: https://spec.modelcontextprotocol.io/
  - Riesgo: Spec puede cambiar (mitigación: aislar implementación, versionar)

### Riesgos Técnicos

1. **Riesgo: No existe gema MCP madura para Ruby**
   - **Probabilidad**: Alta
   - **Impacto**: Medio (más trabajo de desarrollo)
   - **Mitigación**: Implementar protocolo MCP manualmente siguiendo JSON-RPC spec, aislar en módulo separado para facilitar reemplazo futuro

2. **Riesgo: Performance degradada con N+1 queries**
   - **Probabilidad**: Alta si no se usa eager loading
   - **Impacto**: Alto (latencia > 500ms)
   - **Mitigación**: Usar `.includes()` en todos los query builders, agregar índices, benchmark cada query

3. **Riesgo: Exposición accidental de datos sensibles**
   - **Probabilidad**: Media
   - **Impacto**: Crítico (seguridad)
   - **Mitigación**: Whitelist de campos en serializers, revisar cada campo antes de exponer, logging exhaustivo

4. **Riesgo: Servidor MCP bloquea Rails server**
   - **Probabilidad**: Baja (son procesos separados)
   - **Impacto**: Alto si ocurre
   - **Mitigación**: Ejecutar en proceso separado, usar Puma o threading para concurrencia

5. **Riesgo: Protocolo MCP cambia frecuentemente**
   - **Probabilidad**: Media (estándar emergente)
   - **Impacto**: Medio (requiere actualización)
   - **Mitigación**: Aislar implementación en módulo `lib/mcp/`, versionar servidor, monitorear spec oficial

## Open Questions (Technical)

- [ ] **¿Gema MCP disponible?**: Investigar `ruby-lsp`, `mcp-ruby` o implementar custom
- [ ] **¿Stdio vs TCP?**: MVP con stdio (más simple para Claude Code), considerar TCP para otros clientes
- [ ] **¿Paginación?**: Default limit=100, max=500, ¿cursor-based o offset-based?
- [ ] **¿Versionado?**: ¿Versionar servidor desde día 1? (ej: `crm://v1/companies`)
- [ ] **¿Deployment?**: ¿Servidor MCP corre en mismo proceso que Rails o separado?
- [ ] **¿Monitoreo?**: ¿Métricas con Prometheus/StatsD o solo logs?

## Success Criteria Técnicos

- [ ] Servidor inicia con `bin/rails mcp:server` en < 5 segundos
- [ ] Claude Code se conecta exitosamente al servidor
- [ ] Latencia de queries simples < 500ms (p95)
- [ ] Soporte para 10+ conexiones concurrentes sin degradación
- [ ] 0 N+1 queries (verificado con `bullet` gem)
- [ ] 100% de operaciones loggeadas para auditoría
- [ ] Tasa de error < 5% en operaciones válidas
- [ ] Autenticación funciona correctamente (rechazo sin token)
- [ ] Rate limiting previene abuso (> 60 req/min)

---
*Plan técnico creado: 2025-10-16T19:00:00Z*
*Basado en: PRD.md y JTBD.md*
