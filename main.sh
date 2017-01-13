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
    echo "You need to install hub to use this alias. You can do this by running brew install hub"
    return 1
  fi

  # Checkout the desired branch
  gitbranchprefix="greq_"
  if ! git checkout -B $gitbranchprefix$1
  then
    echo $?
    return 1
  fi

  # Commit if the argument is supplied
  if [ -z "${2:-0}" ] && ! [ git commit -m "${2:-0}" ]
  then
    echo $?
    return 1
  fi

  # # Push the branch from local to remote
  # if ! git push -u origin $gitbranchprefix$1
  # then
  #   echo $?
  #   return 1
  # fi

  # # Create a pull request on remote
  # hub pull-request
  # git checkout master

  # return 0
}

