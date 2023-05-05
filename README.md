# dokku-scripts
Scripts to help with UCSB ECI's installation of Dokku

# How to use

1. On your dokku machine, clone this repo:
   ```
   git clone https://github.com/ucsb-cs156/dokku-scripts.git
   ```
2. After creating an app with `dokku apps:create my-app`, you can **set up https** by typing:

   ```
   ./dokku-scripts/https.sh my-app my-email@ucsb.edu
   ```
   
   This automates the two `dokku letsencrypt...` commands.
   
3. After creating an app with `dokku apps:create my-app`, you can **set up postgres** by typing:

   ```
   ./dokku-scripts/db.sh my-app
   ```
   
   The script automates the entire process of doing the `dokku postgres...` commands to create
   the database, link it to the app, look up the IP address, parse out the username, password,
   and database name, and then construct and set the needed `JDBC_DATABASE_*` environment variables.
   
