alias gitrequest=_gitrequest

# USAGE: gitrequest BRANCH_NAME COMMIT_MESSAGE
# E.g. gitrequest fixspellingmistakebashtest "FIX: Help page spelling mistake"
function _gitrequest()
{
  source ./config.sh

  # Brew
  hash brew 2>/dev/null 1>&2

  if [ "${?:-0}" -eq 0 ]
  then
    echo -e "${COL_GRN}Detected brew is installed${COL_END}"
  else
    echo -e ${COL_MAG}'You need to install `brew` to use this alias. This can be done by running: /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" '${COL_END}
    echo -e ${COL_MAG}'Would you like to install `brew`? [y/n]'${COL_END}
    read installhub
    if [[ "$installhub" == "y" ]]
    then
      return 1;
    else
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
  fi

  # Hub
  brew ls --versions hub 2>/dev/null 1>&2

  if [ "${?:-0}" -eq 0 ]
  then
    echo -e "${COL_GRN}Detected hub is installed${COL_END}"
  else
    echo -e ${COL_MAG}'You need to install `hub` to use this alias. This can be done by running `brew install hub`'${COL_END}
    echo -e ${COL_MAG}'Would you like to install `hub`? [Y/n]'${COL_END}
    read installhub
    if [[ "$installhub" == "n" ]]
    then
      return 1;
    else
      brew install hub
    fi
  fi

  # Generate random hash
  # Credit to 'earthgecko' @ https://gist.github.com/earthgecko/3089509
  RAND_HASH=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

  # Determine branch prefix
  if [ $1 -ne ${KNOWN_PREFIX}* ] # If the given branch starts with the prefix, don't inject prefix
  then
    gitbranchprefix="$RAND_HASH"_
  fi

  # Checkout the desired branch
  if ! git checkout -B $gitbranchprefix$1
  then
    echo -e ${COL_RED}$?${COL_END}
    return 1
  fi

  # Commit
  if [ ! -z "$2" ]  #If the commit argument has been supplied
  then
    echo -e "${COL_GRN}Committing changes${COL_END}"
    commitmsg="${2:-0}"
    if ! git commit -m "$commitmsg" #Commit or echo error
    then
      echo -e ${COL_RED}$?${COL_END}
      return 1
    fi
  else
    echo -e "${COL_GRN}Commit message not supplied - not committing${COL_END}"
  fi

  # Push the branch from local to remote
  echo -e "${COL_GRN}Pushing to branch $gitbranchprefix$1 on origin${COL_END}"
  if ! git push -u origin $gitbranchprefix$1
  then
    echo -e ${COL_RED}$?${COL_END}
    return 1
  fi

  # Create a pull request on remote
  echo -e "${COL_GRN}Creating pull request on origin${COL_END}"
  hub pull-request
  if [ "${?:-0}" -ne 0 ]
  then
    echo -e "${COL_RED}Failed to create pull request on origin${COL_END}"
    return 1
  fi

  #Checkout back to master
  if [[ "$CHECKOUT_MASTER_AFTER_FINISH" == true ]]
  then
    echo -e "${COL_GRN}Checking out master${COL_END}"
    git checkout master
    if [ "${?:-0}" -ne 0 ]
    then
      echo -e "${COL_RED}Failed to checkout master${COL_END}"
      return 1
    fi
  else
    echo -e "${COL_YEL}WARNING: Remember that you're still on branch ${gitbranchprefix}${1}!${COL_END}"
  fi

  return 0
}

