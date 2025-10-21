# MCP Server for CRM

This Rails application includes a Model Context Protocol (MCP) server that allows external tools like Claude Code to access and query CRM data programmatically.

## Prerequisites

- Ruby 3.4.6+
- Rails 8.0.3+
- MCP gem installed (already in Gemfile)

## Setup

### 1. Install Dependencies

```bash
bundle install
```

### 2. Run Migrations

```bash
bin/rails db:migrate
```

### 3. Configure Authentication (Optional but Recommended)

Set the `MCP_AUTH_TOKEN` environment variable:

```bash
# Linux/Mac
export MCP_AUTH_TOKEN="your_secret_token_here"

# Windows
set MCP_AUTH_TOKEN=your_secret_token_here
```

If not set, the server will run without authentication (development only).

## Starting the Server

```bash
bin/rails mcp:server
```

The server will start and listen on stdio for incoming MCP connections.

## Available Resources

The MCP server exposes the following CRM resources:

- **Companies**: List, search, and retrieve company data
- **Contacts**: List, search, and retrieve contact information
- **Deals**: List, search, filter by stage, and retrieve deal details
- **Activities**: List activities associated with companies/contacts/deals
- **Notes**: List notes associated with any CRM entity

## Tools Available

### Companies
- `list_companies`: List all companies with pagination (limit, offset)
- `get_company`: Get a specific company by ID
- `search_companies`: Search companies by name or email

### Contacts
- `list_contacts`: List all contacts with pagination
- `get_contact`: Get a specific contact by ID
- `search_contacts`: Search contacts by name or email

### Deals
- `list_deals`: List all deals with pagination
- `get_deal`: Get a specific deal by ID
- `search_deals`: Search deals by title
- `filter_deals_by_stage`: Filter deals by stage (lead, qualification, proposal, negotiation, closed_won, closed_lost)

### Activities
- `list_activities`: List all activities
- `get_activity`: Get a specific activity by ID
- `list_activities_for`: List activities for a specific company/contact/deal

### Notes
- `list_notes`: List all notes
- `get_note`: Get a specific note by ID
- `list_notes_for`: List notes for a specific company/contact/deal

## Example Queries with Claude Code

Once the server is running and Claude Code is connected, you can ask:

- "List all companies"
- "Search for companies named Acme"
- "Show me deals in the proposal stage"
- "Get contact with ID 5"
- "List activities for company 1"

## Performance

- All queries use eager loading (`.includes`) to prevent N+1 queries
- Database indexes are in place for search fields (name, email, stage)
- Query limits: max 500 results per request to prevent abuse
- Search results limited to 50 items

## Security

- **Authentication**: Set `MCP_AUTH_TOKEN` for production use
- **Rate Limiting**: 60 requests per minute per client
- **Logging**: All operations are logged for auditing
- **Read-only**: MVP version only supports read operations (no create/update/delete)

## Troubleshooting

### Server won't start
- Check that all dependencies are installed: `bundle install`
- Verify Rails environment loads: `bin/rails console`
- Check logs in `log/development.log`

### Authentication errors
- Verify `MCP_AUTH_TOKEN` is set correctly
- Check token matches between client and server

### Performance issues
- Verify database indexes: `bin/rails db:migrate:status`
- Check query performance with `.explain` in Rails console
- Monitor N+1 queries with Bullet gem (if installed)

## Architecture

```
lib/mcp/
├── server.rb              # MCP server core
├── authentication.rb      # Token-based auth
├── logger.rb             # Audit logging
├── rate_limiter.rb       # Rate limiting
├── query_builders/       # Optimized ActiveRecord queries
│   ├── company_query_builder.rb
│   ├── contact_query_builder.rb
│   ├── deal_query_builder.rb
│   ├── activity_query_builder.rb
│   └── note_query_builder.rb
└── serializers/          # JSON serialization
    ├── company_serializer.rb
    ├── contact_serializer.rb
    ├── deal_serializer.rb
    ├── activity_serializer.rb
    └── note_serializer.rb
```

## Support

For issues or questions:
1. Check logs: `tail -f log/development.log`
2. Verify server status: Server should show "Listening on stdio" message
3. Test connection with Claude Code

## Roadmap

Future versions may include:
- Write operations (create, update, delete)
- Complex aggregations and reporting
- WebSocket streaming for real-time updates
- Bulk operations
- Custom query DSL

---

*Generated for CRM MCP Server v0.1.0*
