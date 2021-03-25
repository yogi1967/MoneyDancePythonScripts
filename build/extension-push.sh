#!/bin/sh

PUSHDIR="../MoneydanceOpen/python_scripts"

echo
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@ PUSH - RUNNING to ${PUSHDIR} - module: "$1"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
echo

if ! test -f "./build/extension-build.sh"; then
  echo "@@ PLEASE RUN FROM THE PROJECT ROOT directory! @@"
  exit 1
fi

if [ "$1" = "" ]; then
  echo "@@@ NO PARAMETERS SUPPLIED."
  echo "Run from project root"
  echo "Usage ./build/extension-push.sh module_name"
  echo "Module name must be one of: toolbox, extract_data, useful_scripts, list_future_reminders"
  exit 1
fi

if [ "$1" != "toolbox" ] && [ "$1" != "extract_data" ] && [ "$1" != "useful_scripts" ] && [ "$1" != "list_future_reminders" ] && [ "$1" != "extension_tester" ]; then
  echo
  echo "@@ Incorrect Python / extension script name @@"
  echo "must be: toolbox, extract_data, useful_scripts, list_future_reminders, extension_tester"
  exit 1
fi

MODULE=$1

if ! test -d "${PUSHDIR}"; then
  echo "@@ ${PUSHDIR} directory missing? @@"
  exit 1
fi

if ! test -d "${PUSHDIR}/${MODULE}"; then
  echo "@@ ${PUSHDIR}/${MODULE} directory missing? @@"
  exit 1
fi

if ! test -f "./${MODULE}.zip"; then
  echo "@@ ./${MODULE}.zip missing? @@"
  exit 2
fi

if [ "${MODULE}" = "useful_scripts" ]; then

  echo "Skipping checks for non-extension"

else
  if ! test -f "./source/${MODULE}/${MODULE}.py"; then
    echo "@@ ./source/${MODULE}/${MODULE}.py missing? @@"
    exit 2
  fi

  if ! test -f "./source/${MODULE}/meta_info.dict"; then
    echo "@@ ./source/${MODULE}/meta_info.dict missing? @@"
    exit 2
  fi
  if ! test -f "./source/${MODULE}/script_info.dict"; then
    echo "@@ ./source/${MODULE}/script_info.dict missing? @@"
    exit 2
  fi
fi

cp "./source/${MODULE}"/* "${PUSHDIR}/${MODULE}/."
if [ $? -ne 0 ]; then
  echo "*** cp ./source/${MODULE}/* Failed??"
  exit 3
fi

if [ "${MODULE}" != "extension_tester" ]; then
  cp "./source/install-readme.txt" "${PUSHDIR}/${MODULE}/."
  if [ $? -ne 0 ]; then
    echo "*** cp ./source/install-readme.txt Failed??"
    exit 4
  fi
fi

rm -f "${PUSHDIR}/${MODULE}"/*.docx
rm -f "${PUSHDIR}/${MODULE}"/*.mxt

if [ "${MODULE}" = "toolbox" ]; then
  rm "${PUSHDIR}/${MODULE}/toolbox_version_requirements.dict"
fi

echo "Listing ${PUSHDIR}/${MODULE}"
ls -l "${PUSHDIR}/${MODULE}"

echo "@@@ module: ${MODULE} pushed over to ${PUSHDIR}"
