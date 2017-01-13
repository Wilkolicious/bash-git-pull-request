alias gitrequest=_gitrequest

# USAGE: gitrequest BRANCH_NAME COMMIT_MESSAGE
# E.g. gitrequest fixspellingmistakebashtest "FIX: Help page spelling mistake"
function _gitrequest()
{
  brew ls --versions hub

  if [ "${?:-0}" -eq 0 ]
  then
    echo "Detected hub is installed"
  else
    echo "You need to install \`hub\` to use this alias. This can be done by running \`brew install hub\`."
    echo "Would you like to install \`hub\`? [y/n]"
    read installhub
    if [[ "$installhub" == "y" ]]
    then
      brew install hub
    else
      return 1;
    fi
  fi

  # Checkout the desired branch
  gitbranchprefix="greq_"
  if ! git checkout -b $gitbranchprefix$1
  then
    echo $?
    return 1
  fi

  # Commit
  if [ ! -z "$2" ]  #If the commit argument has been supplied
  then
    commitmsg="${2:-0}"
    if ! git commit -m "$commitmsg" #Commit or echo error
    then
      echo $?
      return 1
    fi
  fi

  # Push the branch from local to remote
  if ! git push -u origin $gitbranchprefix$1
  then
    echo $?
    return 1
  fi

  # Create a pull request on remote
  hub pull-request
  git checkout master

  return 0
}

