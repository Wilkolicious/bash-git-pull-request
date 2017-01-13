# bash-git-pull-request
Wrapper to automatically create pull requests on github through the command line.

## Suggested installation
```BASH
cd ~/
mkdir .bash
cd .bash
git clone https://github.com/Wilkolicious/bash-git-pull-request.git
```

Put the following in your `.bash_profile` or `.bashrc`, or whichever resource file.
```BASH 
export BASHGITPULLREQUESTS==~/.bash/bash-git-pull-request
source "${BASHGITPULLREQUESTS}/main.sh"
```
