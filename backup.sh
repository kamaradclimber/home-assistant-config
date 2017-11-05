#!/bin/bash

dir=/var/lib/hass/

find $dir -maxdepth 1 -type f -name "*.yaml" |
  grep -v -e secrets -e known_devices |
  while read file; do
    cp $file .
    git add $(basename $file)
  done

git diff --cached --exit-code &> /dev/null
diff_code=$?

if [[ "$diff_code" -eq 1 ]]; then
  git commit -m "Auto backup of configuration $(date)"
fi

git push origin master
