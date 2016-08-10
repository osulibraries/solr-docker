#!/bin/bash
set -e

# Exit if the CI environment vriables are not set
for var in SOLR_CORE_NAME SOLR_CONFIG_DIR CI_BUILD_REPO CI_BUILD_REF ; do
  if [ -z "${!var}" ] ; then
    echo "CI Environment varaibles not set. Proceding with Solr startup."
    exit 0
  fi
done

git clone $CI_BUILD_REPO /tmp/repo
cd /tmp/repo
git checkout $CI_BUILD_REF

echo "Creating Solr core: $SOLR_CORE_NAME..."
coresdir="/opt/solr/server/solr/mycores"
mkdir -p $coresdir
coredir="$coresdir/$SOLR_CORE_NAME"

if [[ ! -d $coredir ]]; then
  mkdir  -p $coredir
  cp -r "/tmp/repo/$SOLR_CONFIG_DIR" "$coredir/conf"
  touch "$coredir/core.properties"
  echo "Successfully created $SOLR_CORE_NAME"
else
    echo "Core $SOLR_CORE_NAME already exists"
fi

set -- solr -f
