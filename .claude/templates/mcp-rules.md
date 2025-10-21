# Reglas Específicas para Implementación MCP

## CRÍTICO - Configuración del Servidor (lib/mcp/server.rb)
```ruby
# CORRECTO
def initialize
  @server = MCP::Server.new(
    name: "servidor-mcp",
    version: "0.1.0",
    tools: [
      Mcp::Tools::Companies::ListCompaniesTool,
      Mcp::Tools::Companies::GetCompanyTool,
      # Todas las clases de herramientas aquí
    ]
  )
end

# NUNCA HACER
def setup_tools
  @server.define_tool(...) do |args, context|  # ❌ NO FUNCIONA
    ...
  end
end
```

## CRÍTICO - Formato de Respuesta (Todas las Tools)
```ruby
# CORRECTO - Siempre devolver MCP::Tool::Response
def self.call(limit: 100, offset: 0, server_context:)
  result = { data: data, total: total }
  
  MCP::Tool::Response.new([
    { type: "text", text: JSON.pretty_generate(result) }
  ])
end

# NUNCA devolver:
result                                      
[{ type: "text", text: ... }]              
{ content: [{ type: "text", text: ... }] } 
JSON.pretty_generate(result)               
```

## CRÍTICO - NO Logs en stdout
```ruby
def start
  transport = MCP::Server::Transports::StdioTransport.new(@server)
  transport.open
end

puts "Starting..."        
Rails.logger.info "..."   
```

## Estructura de Herramientas

Cada herramienta DEBE:
1. Heredar de `MCP::Tool`
2. Incluir `description`
3. Incluir `input_schema` con todas las propiedades
4. Devolver `MCP::Tool::Response.new([...])`

## Scripts de Inicio

Crear `start_mcp.bat` (Windows):
```batch
@echo off
cd /d "%~dp0"
bundle exec rails mcp:server
```

Crear `start_mcp.sh` (Unix):
```bash
#!/bin/bash
cd "$(dirname "$0")"
bundle exec rails mcp:server
```