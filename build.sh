#!/bin/bash

#set -e
scriptdir="$( cd "$(dirname "$0")" ; pwd -P )"

# Check if the shell is interactive.
if [[ $- == *i* ]]; then
  red=`tput setaf 1`
  green=`tput setaf 2`
  reset=`tput sgr0`
fi

VERBOSE=true
FORCE=false
CLEAN=false
CONFIGURE_ONLY=false
CONFIG=nsh

for i in "$@"
do
case $i in
    -v|--verbose)
    VERBOSE=true
    ;;
    -f|--force)
    FORCE=true
    ;;
    -c|--clean)
    CLEAN=true
    ;;
    --configure)
    CONFIGURE_ONLY=true
    ;;
    --config=*)
    CONFIG=$(echo $i | cut -f2 -d=)
    ;;
    *)
    # unknown option
    ;;
esac
done

run_command() {
  if $VERBOSE; then
    echo
    $1
  else
    $1 &>/dev/null
  fi
}

check_command_status() {
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    printf " ${red}error${reset}\n"
    if ! $VERBOSE; then
        printf "Re-run the script with --verbose flag to see the output.\n"
    fi
    exit 1
  else
    printf " ${green}success${reset}\n"
  fi
}

#
#   Build NuttX OS base code
#

NUTTX_CONFIG="stm32f051-discovery:$CONFIG"

if [ -r "$scriptdir/nuttx/.config" ] && ($FORCE || $CLEAN); then
    printf "Cleaning NuttX (already configured)..."
    run_command "make -C $scriptdir/nuttx distclean -j8"
    check_command_status
fi

if [ ! -r "$scriptdir/nuttx/.config" ] || $FORCE; then
    printf "Configuring NuttX...\n"
    run_command "$scriptdir/nuttx/tools/configure.sh $NUTTX_CONFIG"
    run_command "make -C $scriptdir/nuttx context"
    check_command_status
else
    printf "NuttX already configured (use --force to override)\n"
fi

if $CONFIGURE_ONLY; then
  exit 0
fi

printf "Building NuttX ...\n"
run_command "make -C $scriptdir/nuttx -j8"
check_command_status


printf "Build finished!\n"
