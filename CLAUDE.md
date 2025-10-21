# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.0.3 CRM (Customer Relationship Management) application built with Ruby 3.4.6. The application uses Hotwire (Turbo + Stimulus) for interactivity and Tailwind CSS (via CDN) for styling. It follows Rails conventions and uses SQLite3 as the database.

## Core Architecture

### Data Model Hierarchy

The application follows a hierarchical relationship structure:
- **Companies** are the top-level entities
- **Contacts** belong to companies (optional)
- **Deals** belong to both contacts and companies (both optional)
- **Activities** and **Notes** can be attached to any of the above entities via polymorphic associations

### Polymorphic Associations

Two key polymorphic patterns are used throughout:
1. `activitable` - Activities can belong to Companies, Contacts, or Deals (app/models/activity.rb:2)
2. `notable` - Notes can belong to Companies, Contacts, or Deals (app/models/note.rb:2)

### Deal Pipeline Stages

Deals follow a defined sales pipeline (app/models/deal.rb:11-18):
- lead → qualification → proposal → negotiation → closed_won / closed_lost

### Activity Types and Statuses

Activities support four types: call, email, meeting, task (app/models/activity.rb:8-13)
Activity statuses: pending, completed, cancelled (app/models/activity.rb:15-19)

## Development Commands

### Starting the Application
```bash
bin/rails server              # Start the Rails server
bin/dev                       # Start the dev server (runs bin/rails server)
```

### Database Commands
```bash
bin/rails db:create           # Create the database
bin/rails db:migrate          # Run pending migrations
bin/rails db:seed             # Load seed data
bin/rails db:reset            # Drop, create, migrate, and seed
bin/rails db:schema:load      # Load schema without running migrations
```

### Testing
```bash
bin/rails test                # Run all tests
bin/rails test:system         # Run system tests only
bin/rails test test/models/company_test.rb  # Run a specific test file
```

### Code Quality
```bash
bin/rubocop                   # Run RuboCop linter (Omakase Ruby styling)
bin/rubocop -a                # Auto-correct RuboCop offenses
bin/brakeman                  # Run security vulnerability scanner
```

### Asset Management
```bash
bin/rails tailwindcss:watch   # Watch and compile Tailwind CSS
bin/rails tailwindcss:build   # Build Tailwind CSS for production
```

### Rails Console
```bash
bin/rails console             # Start interactive console
bin/rails console --sandbox   # Start console in sandbox mode (rollback on exit)
```

### MCP Server
```bash
bin/rails mcp:server          # Start the Model Context Protocol server
```

The MCP server provides programmatic access to CRM data via the Model Context Protocol. It exposes 16 read-only tools:
- **Companies**: list_companies, get_company, search_companies
- **Contacts**: list_contacts, get_contact, search_contacts
- **Deals**: list_deals, get_deal, search_deals, filter_deals_by_stage
- **Activities**: list_activities, get_activity, list_activities_for
- **Notes**: list_notes, get_note, list_notes_for

See [README_MCP.md](README_MCP.md) for detailed documentation.

## Technical Stack

- **Framework**: Rails 8.0.3 with Ruby 3.4.6
- **Database**: SQLite3 (development and test)
- **Frontend**: Hotwire (Turbo + Stimulus), Importmap
- **Styling**: Tailwind CSS (currently via CDN, see app/views/layouts/application.html.erb:21)
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **WebSockets**: Solid Cable
- **MCP Server**: Model Context Protocol server (gem 'mcp' v0.4.0) for external integrations

## Code Conventions

- Uses **Omakase Ruby styling** via rubocop-rails-omakase (.rubocop.yml:2)
- Models validate presence and format where appropriate
- Email validation uses `URI::MailTo::EMAIL_REGEXP`
- Constants for enums are defined as frozen hashes (e.g., Deal::STAGES, Activity::TYPES)
- Polymorphic associations use `dependent: :destroy` to cascade deletions

## Important Implementation Notes

### Model Validations
- Companies require name, optional email with format validation (app/models/company.rb:7-8)
- Contacts require first_name and last_name, optional email validation (app/models/contact.rb:7-9)
- Deals require title, validate amount ≥ 0, and enforce stage inclusion (app/models/deal.rb:7-9)
- Activities require activity_type, description, and validate status inclusion (app/models/activity.rb:4-6)

### Associations
- `belongs_to` associations use `optional: true` where appropriate (e.g., Contact can exist without Company)
- All `has_many` associations use `dependent: :destroy` for cleanup
- Polymorphic associations are consistently named with `-able` suffix (activitable, notable)

### Routes
- All main resources use standard RESTful routes (config/routes.rb:2-6)
- Root path points to home#dashboard (config/routes.rb:19)
- Health check endpoint available at `/up` for load balancers (config/routes.rb:12)

## Custom Slash Commands

This project includes a feature management system accessible via slash commands:

### Feature Management
- `/feature:crear` - Create new feature with structure
- `/feature:crear-prd` - Create Product Requirements Document
- `/feature:crear-plan` - Create technical implementation plan
- `/feature:crear-jtbd` - Create Job-to-be-Done analysis
- `/feature:organizar-plan` - Organize technical plan by user capabilities
- `/feature:programar` - Schedule tasks from the organized plan
- `/feature:estado` - Show detailed feature status
- `/feature:listar` - List all features with status
- `/feature:cambiar` - Change current feature in pipeline
- `/feature:archivar` - Archive completed feature
- `/feature:papelera` - Move feature to trash
- `/feature:restaurar` - Restore archived/deleted feature

### Learning System
- `/aprender` - Analyze conversation and update CLAUDE.md with relevant information

## Specialized Agents

This project has configured specialized agents:
- **rails-architect**: For Rails architecture decisions and SOLID principles
- **hotwire-specialist**: For Hotwire/Turbo/Stimulus implementations
- **tailwind-specialist**: For Tailwind CSS styling
- **product-owner**: For feature definition and Job-to-be-Done analysis
- **context-engineer**: For gathering relevant project context
- **feature-flow-manager**: For managing feature development workflow
