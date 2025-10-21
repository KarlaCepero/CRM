# VCS History - Show Commit History

Display the commit history of the repository in a user-friendly format.

**Usage**: `/vcs/history [number-of-commits]`

## Implementation

Show the commit history using `git log` with formatting optimized for non-developers. Display commits in a clear, readable format with essential information.

Steps to execute:
1. Check if we're in a git repository
2. Use `git log` with custom formatting to show:
   - Commit hash (short version)
   - Commit date
   - Author name
   - Commit message
3. Limit to specified number of commits (default: 10)
4. Format output in a clean, readable way with proper line breaks between commits
5. Use a clear visual format that separates each commit entry with blank lines
6. Include proper spacing and formatting for terminal display readability

## Examples

```bash
/vcs/history
/vcs/history 5
/vcs/history 20
```

This will:
- Show the last 10 commits (or specified number)
- Display each commit with hash, date, author, and message
- Format the output for easy reading with proper line breaks
- Include blank lines between commits for better visual separation
- Use consistent formatting that's easy to scan in terminal output

## Output Format

Each commit should be displayed with:
- Proper line spacing between entries
- Clear visual separation using blank lines
- Consistent indentation and formatting
- Easy-to-read structure that avoids cramped text display

Example output format:
```
📋 **Repository History** (Last 10 commits)

**abc123** - *2025-09-10* by **Author**
commit message here

**def456** - *2025-09-10* by **Author**  
another commit message

**ghi789** - *2025-09-10* by **Author**
third commit message
```