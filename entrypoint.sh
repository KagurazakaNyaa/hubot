#!/bin/sh

printf "\\n********* Installing adapter $HUBOT_ADAPTER_PACKAGE *********\\n"
npm install --save $HUBOT_ADAPTER_PACKAGE

if [ -n "$EXTRA_PACKAGES" ]; then
  printf "\\n********* Using extra packages overwrite external-scripts.json *********\\n"
  node -e "console.log(JSON.stringify('$EXTRA_PACKAGES'.split(',')))" > external-scripts.json
fi

printf "\\n********* Installing packages from external-scripts.json *********\\n"
npm install --save $(jq -r '.[]' ./external-scripts.json | paste -sd" " -)

HUBOT_VERSION=$(jq -r '.dependencies.hubot' package.json)

printf "\\n****************** Starting %s (Hubot %s) ******************\\n" "$HUBOT_NAME" "${HUBOT_VERSION}"

bin/hubot -a $HUBOT_ADAPTER -n $BOT_NAME "$@"
