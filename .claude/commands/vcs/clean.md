# VCS Clean - Reset to Clean State

Discard modifications and untracked files to return the repository to a clean state matching the current commit. Can clean all changes or specific files. This removes uncommitted changes and new files.

**Usage**: `/vcs/clean [files...]`

## Implementation

Clean the working directory by discarding modifications and removing untracked files. Can operate on all changes or specific files. This command restores files to exactly match the current commit state.

Steps to execute:
1. Check if we're in a git repository
2. Parse parameters to determine cleaning mode:
   - If specific files are provided: clean only those files
   - If no files specified: clean all changes (full clean)
3. Check current repository status to see what will be cleaned:
   - **Selective mode**: Only analyze specified files for modifications/untracked status
   - **Full mode**: Analyze all modified files and untracked files
4. If there are no changes to clean:
   - **Selective mode**: Inform user that specified files are already clean
   - **Full mode**: Inform user that repository is already clean
   - Exit without taking action
5. If there are changes to clean:
   - **Analyze and summarize changes** using the same intelligence as `vcs:diff`:
     - Run `git diff` and `git diff --cached` to understand actual changes
     - Analyze what type of work will be lost (features, fixes, configuration, etc.)
     - Identify which parts of the project are affected
     - Determine the scope and impact of changes being discarded
   - **Display comprehensive summary** with proper formatting:
     - **Work Summary**: What kind of work will be permanently lost
     - **Project Impact**: Which parts of the project are affected
     - **Detailed File Analysis**: For each modified file, explain what changes will be lost
     - **Untracked Files**: List new files that will be deleted
     - Use clear, non-technical language and proper spacing
   - **Ask for explicit confirmation** with clear warning about data loss
   - Require user to type "yes" or "y" to confirm (case-insensitive)
6. After confirmation:
   - **Selective mode**: 
     - Use `git checkout HEAD -- <file1> <file2> ...` to reset specific modified files
     - Use `rm <file>` to remove specific untracked files
     - Preserve other uncommitted changes not in the specified file list
   - **Full mode**: 
     - Run `git reset --hard HEAD` to discard all modifications
     - Run `git clean -fd` to remove untracked files and directories
   - Show confirmation of cleaning operation with summary
7. Handle edge cases:
   - **File validation**: Verify specified files exist in selective mode
   - **Glob pattern support**: Handle patterns like `*.js`, `src/**/*`
   - Repository with no commits (newly initialized)
   - Permission issues with untracked files
   - Files that cannot be removed

## Safety Features

- **Multiple confirmations**: Clear warnings about permanent data loss
- **Detailed preview**: Shows exactly what will be lost before cleaning
- **Explicit consent**: Requires typing confirmation, not just pressing Enter
- **No action on clean repo**: Skips operation if nothing to clean
- **Error handling**: Gracefully handles files that cannot be removed

## Examples

### Clean All Changes
```bash
/vcs/clean
```

This will:
- Analyze current repository state
- Show what files will be affected
- Ask for confirmation before proceeding
- Discard all modifications and remove untracked files
- Return repository to clean state matching current commit

### Clean Specific Files
```bash
/vcs/clean src/auth.js README.md
```

Clean only the specified files, preserving other uncommitted changes.

```bash
/vcs/clean *.js
```

Clean all JavaScript files in the current directory using glob patterns.

```bash
/vcs/clean src/components/**/*
```

Clean all files in the components directory and subdirectories.

### Full Clean Example Interaction:
```
🧹 **Repository Cleanup Analysis**

## Work that will be permanently lost:
**Bug fixes and documentation improvements** - Code quality enhancements

## Project impact:
**Core application logic and project documentation** - Essential project files

---

## Detailed Analysis of Changes to be Discarded:

**📄 `src/main.js`** - Main Application Logic
- **What will be lost**: Authentication bug fixes and error handling improvements
- **Why it matters**: These fixes resolve login issues and improve user experience  
- **Impact**: Users may continue experiencing authentication problems

**📄 `README.md`** - Project Documentation
- **What will be lost**: Installation instructions and usage examples
- **Why it matters**: Helps new developers get started with the project
- **Impact**: Project setup may be unclear for new contributors

**📄 `config.json`** - Application Configuration
- **What will be lost**: Updated database connection settings
- **Why it matters**: Ensures application connects to correct development environment
- **Impact**: Application may fail to start properly

## Files that will be deleted:

**📄 `temp_notes.txt`** - New file (142 bytes)
**📄 `debug.log`** - New file (1.2 KB)

---

⚠️  **CRITICAL WARNING: This action cannot be undone!**

**You will permanently lose**:
- Important bug fixes in core application
- Documentation improvements for team collaboration  
- Configuration changes for development environment
- 2 new files with notes and debugging information

**Total impact**: 5 files will be affected

Type "yes" to proceed with cleaning: _
```

After confirmation:
```
✅ **Repository Cleaned Successfully!**

**Actions taken**:
- Discarded modifications in 3 files
- Removed 2 untracked files
- Repository now matches commit: abc123d - "feat: add user authentication"

Your working directory is now clean and matches the current commit exactly.
```

### Selective Clean Example Interaction:
```
🧹 **Selective Repository Cleanup Analysis**

## Files requested for cleaning:
`src/auth.js`, `README.md`

## Work that will be permanently lost in selected files:
**Authentication improvements and documentation updates** - Targeted fixes

## Project impact:
**Authentication system and project documentation** - Selected components only

---

## Detailed Analysis of Changes to be Discarded:

**📄 `src/auth.js`** - Authentication Logic
- **What will be lost**: Login validation improvements and error handling
- **Why it matters**: These changes fix authentication bugs
- **Impact**: Users may continue experiencing login issues

**📄 `README.md`** - Project Documentation  
- **What will be lost**: Updated installation instructions
- **Why it matters**: Helps new developers understand setup process
- **Impact**: Setup documentation remains outdated

## Files that will remain unchanged:

**📄 `config.json`** - Configuration changes preserved
**📄 `src/main.js`** - Core application changes preserved  
**📄 `temp_notes.txt`** - Untracked file preserved

---

⚠️  **WARNING: This action cannot be undone!**

**You will permanently lose changes in**:
- `src/auth.js` - Authentication improvements
- `README.md` - Documentation updates

**Preserved changes**: 3 other modified files will remain untouched

Type "yes" to proceed with selective cleaning: _
```

**Warning**: This command permanently destroys uncommitted work. In selective mode, only specified files are affected, preserving other changes. Use with caution and only when you're certain you want to lose changes in the selected files.