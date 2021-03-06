# bash-git-pull-request
Wrapper to automatically create pull requests on github through the command line using `homebrew` and `hub`.

Really, you should be switching to your feature/bugfix branch before starting work, but this script will pretend you are working off your base branch (such as `master`) before switching

# Requirements
- OSX/macOS
- Homebrew

# What does this do?
The script will:
- Check that `brew` is installed
  - Check that `hub` is installed from brew
- Create the new branch with the supplied branch name
  - If branch name does not begin with the prefix given in `config.sh`, then a random hash is prefixed to the branch name.
- If the commit message is supplied, it will commit any changes using the commit message
  - If no commit message supplied, it will simply not commit anything
- Push the changes to the branch on `origin`
- Create the pull request (where you enter the pull request title in your command line editor)

## Suggested installation
```BASH
cd ~/
mkdir .bash
cd .bash
git clone https://github.com/Wilkolicious/bash-git-pull-request.git
```

Put the following in your `.bash_profile` or `.bashrc`, or whichever resource file.
```BASH 
export BASHGITPULLREQUESTS=~/.bash/bash-git-pull-request
source "${BASHGITPULLREQUESTS}/main.sh"
```

Now source or reload your terminal, e.g.
```BASH
source ~./bash_profile
```

Installation should be gucci.

## Usage
```BASH
# USAGE: gitrequest BRANCH_NAME COMMIT_MESSAGE
gitrequest fixspellingmistakebashtest "FIX: Help page spelling mistake"
```
