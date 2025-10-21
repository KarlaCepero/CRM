# VCS Help - Version Control System Help

Display helpful information about all available VCS commands.

**Usage**: `/vcs/help`

## Implementation

Show a comprehensive help guide for all VCS commands, designed for non-developers to understand version control concepts and usage.

Steps to execute:
1. Display an overview of what version control is
2. List all available VCS commands with descriptions
3. Provide common workflow examples
4. Include troubleshooting tips
5. Show git concepts explained in simple terms

## Examples

```bash
/vcs/help
```

This will display:

### Version Control System (VCS) Commands

Version control helps you track changes to your files over time, like having a save history for your entire project.

#### Available Commands:

- **`/vcs/init`** - Start version control in this folder
- **`/vcs/save [file-description] [-m "message"]`** - Save current changes with a description (auto-generates message if not provided, supports natural language file selection)
- **`/vcs/load [commit]`** - Go back to a previous saved version (shows history if no commit specified)
- **`/vcs/history [number]`** - See all previous saves
- **`/vcs/diff`** - See what changes you've made since last save
- **`/vcs/tag [message]`** - Mark important milestones (auto-generates timestamp if no message)
- **`/vcs/clean [files...]`** - Discard changes and return to clean state (can target specific files or clean everything)
- **`/vcs/help`** - Show this help information

#### Common Workflow:

1. **Start a new project**: `/vcs/init`
2. **Make changes to your files**
3. **Check what changed**: `/vcs/diff` to see your progress
4. **Save your progress**: `/vcs/save "Added new feature"` or simply `/vcs/save` for auto-generated message
5. **Save specific files**: `/vcs/save "JavaScript files" -m "Fix bugs"` for selective commits
6. **Continue working and saving**: `/vcs/save "Fixed bug"` or `/vcs/save`
7. **Mark important milestones**: `/vcs/tag "version 1.0"` or `/vcs/tag` for timestamp
8. **Check your history**: `/vcs/history` or `/vcs/load` to see all saves
9. **Go back if needed**: `/vcs/load abc123f` or `/vcs/load version-1-0`
10. **Discard unwanted changes**: `/vcs/clean` to start fresh or `/vcs/clean specific-file.js`

#### Tips:

- Save often with descriptive messages, or let the system auto-generate them
- Use `/vcs/diff` before saving to see what changed and get intelligent impact analysis
- Save specific files using natural language: `/vcs/save "all JavaScript files"` or `/vcs/save "files in src folder"`
- Create tags for important milestones like releases or major features
- Use `/vcs/load` without parameters to see history and choose which version to load
- Manual commit messages should describe what you did
- Auto-generated messages analyze your changes and create appropriate descriptions
- Use `/vcs/clean` to discard unwanted changes and start fresh
- You can always go back to any previous save or tag

#### Auto-Generated Commit Messages:

When you use `/vcs/save` without a message, the system will:
- Analyze what files you've changed
- Understand the type of work you've done
- Generate a professional commit message like:
  - `feat: add user login functionality`
  - `fix: resolve database connection issue`
  - `docs: update installation guide`
  - `config: setup development environment`