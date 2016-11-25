#!/bin/bash

read -p "Would like to do a force push? [Y/N] " push
read -p "Would like to do to import database? [Y/N] " db

export APP_NAME="gfb-api"
export HEROKU_REMOTE="heroku-$APP_NAME"

echo
echo "# Creating a new Heroku App"
echo
heroku apps:create --region eu --remote $HEROKU_REMOTE $APP_NAME

if [[ $db == "Y" ]]; then
  echo
  echo "# Creating a Heroku MYSQL instance"
  echo
  # heroku addons:create cleardb:ignite --app $APP_NAME
  heroku addons:create jawsdb-maria:kitefin --app $APP_NAME
fi

export DSN=`heroku config -s | grep JAWSDB_MARIA_URL | awk -F\' '{print $2}'`
export DB_USER=`heroku config -s | grep JAWSDB_MARIA_URL | awk -F:// '{print $2}' | awk -F: '{print $1}'`
export DB_PASS=`heroku config -s | grep JAWSDB_MARIA_URL | awk -F: '{print $3}' | awk -F@ '{print $1}'`
export DB_HOST=`heroku config -s | grep JAWSDB_MARIA_URL | awk -F: '{print $3}' | awk -F@ '{print $2}' | awk -F/ '{print $1}'`
export DB_NAME=`heroku config -s | grep JAWSDB_MARIA_URL | awk -F/ '{print $4}' | awk -F\? '{print $1}' | sed "s/\'//g"`
export DB_PORT=`heroku config -s | grep JAWSDB_MARIA_URL | awk -F: '{print $4}' | awk -F/ '{print $1}'`

export JAWSDB_MARIA_URL="$DB_USER:$DB_PASS@tcp($DB_HOST:$DB_PORT)/$DB_NAME"
echo
echo "# Configuring Heroku ready for $APP_NAME"
echo
heroku config:set \
--app $APP_NAME \
DSN=$DSN \
GFB_API_KEYS=$GFB_API_KEYS \
SQL_MARIADB_DSN=$JAWSDB_MARIA_URL \
GFB_API_DATABASE_USER=$DB_USER \
GFB_API_DATABASE_PASSWORD=$DB_PASS \
GFB_API_DATABASE_HOST=$DB_HOST \
GFB_API_DATABASE_NAME=$DB_NAME \
GFB_API_DATABASE_PORT=$DB_PORT

if [[ $db == "Y" ]]; then
  echo
  echo "# Importing Heroku JAWSDB $DB_NAME"
  echo

  export GC_BACKUP_PATH=`gsutil ls $GFB_GC_DB_BACKUP_URL | tail -n 1`
  export BACKUP_FILE=$(basename "$GC_BACKUP_PATH" ${s%.*})
  export SQL_BACKUP_FILE=$(basename "$GC_BACKUP_PATH" .tar.gz)

  gsutil cp $GC_BACKUP_PATH /tmp
  tar -xzvf /tmp/$BACKUP_FILE -C /tmp
  mysql -h$DB_HOST -u$DB_USER -p$DB_PASS --reconnect $DB_NAME < /tmp/dbs/$SQL_BACKUP_FILE
fi

echo
echo "# Pushing the current branch to Heroku's master"
echo
export CURRENT_BRANCH_NAME=`git branch | grep "^\*" | cut -d" " -f2`

if [[ $push == "Y" ]]; then
  git push -f $HEROKU_REMOTE $CURRENT_BRANCH_NAME:master
else
  git push $HEROKU_REMOTE $CURRENT_BRANCH_NAME:master
fi

echo
echo "# Opening App"
echo "*NOTE.* You may have to refresh as the app can be slow to start"
echo
open `heroku apps:info --app $APP_NAME | grep "Web URL" | cut -c16-`

echo
echo "All done"
echo

