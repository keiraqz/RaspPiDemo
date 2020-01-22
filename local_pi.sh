#!/bin/bash
# TODO TODO: NOT WORKING YET
# or let the web app do the tunneling??


export REMOTE_USER="ec2-user"
export REMOTE_DB_IP="10.205.208.47"
export FLASK_PORT=5000
export PEM_PATH="$HOME/.ssh/customer-insights.pem"

# for flask
echo "ssh -f $REMOTE_USER@$REMOTE_DB_IP -L $FLASK_PORT:0.0.0.0:$FLASK_PORT -N -i $PEM_PATH"
lsof -i tcp:${FLASK_PORT} | awk 'NR!=1 {print $2}' | xargs kill
ssh -f $REMOTE_USER@$REMOTE_IP -L $FLASK_PORT:0.0.0.0:$FLASK_PORT -N -i $PEM_PATH
