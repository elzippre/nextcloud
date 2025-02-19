# Install Nextcloud Docker 
#!/bin/bash

APPNAME="nextcloud"

# Create a new group
sudo groupadd $APPNAME

# Create a new user and add to the group
sudo useradd -m -g $APPNAME -s /bin/bash $APPNAME

# Set a password for the new user
echo "Set a password for the new user:"
sudo passwd $APPNAME

# Add the new user to the Docker group (optional)
sudo usermod -aG docker $APPNAME

echo "User $APPNAME created and added to group $APPNAME."

# Copy folders and files to new user
sudo install -D -m 660 -g $APPNAME -o $APPNAME  \
   -t /data/$APPNAME/$APPNAME/ ./$APPNAME/*
sudo chown $APPNAME ./$APPNAME/.env
sudo cp -p ./$APPNAME/.env /data/$APPNAME/$APPNAME/

# Login as new user and run docker
sudo -u $APPNAME docker compose -f /data/$APPNAME/$APPNAME/docker-compose.yaml \
     --env-file /data/$APPNAME/$APPNAME/.env up -d 