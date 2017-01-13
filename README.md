# bash-git-pull-request
Wrapper to automatically create pull requests on github through the command line.

# What does this do?
The script will:
- Check that `brew` is installed
  - Check that `hub` is installed from brew
- Create the new branch with the supplied branch name
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
