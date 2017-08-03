#!/bin/bash
CWD=`pwd`

##### Functions
function init () {
  git submodule update --init --recursive
  ./autogen.sh
  ./configure --disable-shared --enable-static
}   # end of init

function clean () {
  make clean
  rm -rf deploy || true
}   # end of clean

function build () {
  clean && init
  make CPPFLAGS=-I$(brew --prefix openssl)/include LDFLAGS=-L$(brew --prefix openssl)/lib
}   # end of build

function deploy () {
  build
  mkdir -p deploy

  tools=("idevice_id ideviceinfo idevicename idevicepair idevicesyslog ideviceimagemounter idevicescreenshot ideviceenterrecovery idevicedate idevicebackup idevicebackup2 ideviceprovision idevicedebugserverproxy idevicediagnostics idevicedebug idevicenotificationproxy idevicecrashreport idevicelocation")
  for file in $tools
  do
    cp ./tools/$file deploy/
  done

  cp package.json deploy/
  npm publish deploy
}

function usage () {
  echo "usage: [[[-i | --init ] [-c | --clean ] [-b | --build]]"
}

##### Main
while [ "$1" != "" ]; do
  case $1 in
      -i | --init )           init
                              exit
                              ;;
      -c | --clean )          clean
                              exit
                              ;;
      -b | --build )          build
                              exit
                              ;;
      -d | --deploy )         deploy
                              exit
                              ;;
      -h | --help )           usage
                              exit
                              ;;
      * )                     usage
                              exit 1
  esac
  shift
done