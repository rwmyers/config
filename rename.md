# Zsh Autocompletion Migration Guide

## Context
The user's Zsh environment has been migrated away from manually `source`-ing completion scripts to the standard Zsh `fpath` + `compinit` lazy-loading mechanism. This improves shell startup performance and avoids infinite recursion bugs with plugins like `fzf-tab`.

The primary configuration repo (`~/src/config`) has already been updated. However, there is a secondary repository (`~/src/gdotfiles`) that is still manually sourcing completion scripts, bypassing the new standard.

## Goal
Migrate the completion scripts within the `gdotfiles` repository to use the Zsh autoloading standard.

## Instructions for the LLM

Please execute the following steps within the `~/src/gdotfiles` repository:

### Step 1: Rename Completion Files
Zsh's `compinit` requires autoloaded completion files to begin with an underscore (`_`). 
Rename all files inside `~/src/gdotfiles/.local/completions/` to prepend an underscore.
*   Example: `aflags` -> `_aflags`
*   Example: `bugged` -> `_bugged`
*   Example: `tmux` -> `_tmux` (Note: Ensure this doesn't conflict with any existing `_tmux` completions)

### Step 2: Refactor the Script Syntax
Update the contents of every renamed file in `~/src/gdotfiles/.local/completions/` to match the standard `#compdef` format.

**Remove:**
1.  Any explicit function wrappers that enclose the entire script (e.g., `_my_command() { ... }`).
2.  The explicit execution call at the bottom (e.g., `_my_command "$@"`).
3.  Any explicit `compdef` calls at the bottom (e.g., `compdef _my_command my_command`).

**Add/Ensure:**
1.  The very first line of the file MUST be: `#compdef <command_name>`
2.  The script logic should sit at the top level of the file (no surrounding function block).

**Example Transformation:**

*Before (Sourced Style):*
```zsh
_my_tool() {
  local -a args
  args=('foo' 'bar')
  _describe 'args' args
}
compdef _my_tool my_tool
```

*After (Autoload Style):*
```zsh
#compdef my_tool
local -a args
args=('foo' 'bar')
_describe 'args' args
```

### Step 3: Remove the Manual Source Loop
Delete the script that manually loops through and sources these files.
1.  Locate `~/src/gdotfiles/completions`.
2.  Remove or comment out the line: `for f in ~/src/gdotfiles/.local/completions/*; do source $f; done`

### Notes
The parent environment (`~/.zshrc`) is already configured to include `~/.local/completions` (which is a symlink to `~/src/gdotfiles/.local/completions`) in its `fpath` before calling `compinit`. Once these files are renamed and refactored, Zsh will automatically detect and lazy-load them.
