# VCS Tag - Create Version Tags

Create a tag for the current commit to mark important milestones or versions. Tags help you identify specific points in your project's history that are significant.

**Usage**: `/vcs/tag [tag-message]`

## Implementation

Create a git tag on the current commit with either a provided message or an automatically generated timestamp. This command provides an easy way to mark important versions or milestones in your project.

Steps to execute:
1. Check if we're in a git repository
2. Verify that there are commits to tag (repository is not empty)
3. If a tag message is provided:
   - Use the provided message as the tag name (sanitized for git compatibility)
   - Remove special characters and spaces, replace with hyphens
4. If no tag message is provided:
   - Generate a timestamp in format: "YYYY-MM-DD_HH-MM" (using current local time)
   - Use this timestamp as the tag name
5. Check if the tag already exists to avoid conflicts
6. Create the tag using `git tag "<tag-name>"`
7. Show confirmation with:
   - The tag name that was created
   - The commit hash and message it points to
   - Explanation of what the tag represents
   - Instructions on how to push tags if needed

## Tag Naming Rules

- Convert spaces to hyphens
- Remove or replace special characters that aren't git-compatible
- Keep tag names concise and meaningful
- Timestamp format: YYYY-MM-DD_HH-MM (e.g., "2024-03-15_14-30")

## Examples

```bash
/vcs/tag "version 1.0"
```
Creates tag named "version-1-0" pointing to current commit.

```bash
/vcs/tag "stable release"
```
Creates tag named "stable-release" pointing to current commit.

```bash
/vcs/tag
```
Creates tag with current timestamp (e.g., "2024-03-15_14-30") pointing to current commit.

This will:
- Create a lightweight git tag on the current commit
- Use provided message (sanitized) or auto-generate timestamp
- Show confirmation with tag details and commit information
- Provide guidance on pushing tags to remote repository if needed

Example output:
```
✅ **Tag Created Successfully!**

**Tag name**: version-1-0
**Points to commit**: a1b2c3d - "feat: add user authentication system"
**Created**: March 15, 2024 at 2:30 PM

This tag marks: **version 1.0** - A significant milestone in your project

💡 **Tip**: To share this tag with others, use: `git push origin version-1-0`
```