alias gitrequest=_gitrequest

# USAGE: gitrequest BRANCH_NAME COMMIT_MESSAGE
# E.g. gitrequest fixspellingmistakebashtest "FIX: Help page spelling mistake"
function _gitrequest()
{
  # Brew
  hash brew 2>/dev/null 1>&2

  if [ "${?:-0}" -eq 0 ]
  then
    echo 'Detected brew is installed'
  else
    echo 'You need to install `brew` to use this alias. This can be done by running: /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" '
    echo 'Would you like to install `brew`? [y/n]'
    read installhub
    if [[ "$installhub" == "y" ]]
    then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
      return 1;
    fi
  fi

  # Hub
  brew ls --versions hub

  if [ "${?:-0}" -eq 0 ]
  then
    echo 'Detected hub is installed'
  else
    echo 'You need to install `hub` to use this alias. This can be done by running `brew install hub`'
    echo 'Would you like to install `hub`? [y/n]'
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
  if ! git checkout -B $gitbranchprefix$1
  then
    echo $?
    return 1
  fi

  # Commit
  if [ ! -z "$2" ]  #If the commit argument has been supplied
  then
    echo "Committing changes"
    commitmsg="${2:-0}"
    if ! git commit -m "$commitmsg" #Commit or echo error
    then
      echo $?
      return 1
    fi
  else
    echo 'Commit message not supplied - not committing'
  fi

  # Push the branch from local to remote
  echo "Pushing to branch $gitbranchprefix$1 on origin"
  if ! git push -u origin $gitbranchprefix$1
  then
    echo $?
    return 1
  fi

  # Create a pull request on remote
  echo "Creating pull request on origin"
  hub pull-request
  if [ "${?:-0}" -ne 0 ]
  then
    echo "Failed to create pull request on origin"
    return 1
  fi

  echo "Checking out master"
  git checkout master
  if [ "${?:-0}" -ne 0 ]
  then
    echo "Failed to checkout master"
    return 1
  fi

  return 0
}

