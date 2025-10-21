# VCS Init - Initialize Version Control System

Initialize a new version control repository in the current directory.

**Usage**: `/vcs/init`

## Implementation

Initialize a git repository in the current directory using `git init`. This command provides a simplified interface for non-developers to start version control in their project.

Steps to execute:
1. Run `git init` in the current directory
2. Create an initial .gitignore file with common exclusions if it doesn't exist
3. Confirm successful initialization
4. Provide guidance on next steps

## Examples

```bash
/vcs/init
```

This will:
- Initialize a new git repository
- Create a basic .gitignore file if needed
- Show confirmation message with next steps