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
   
4. To configure `ADMIN_EMAILS` for `my-app`, run:

   ```
   ./dokku-scripts/admin.sh my-app
   ```
   
   The default script adds the instructor for the course, along with all TAs and LAs.
   
   You may find it helpful to make a copy of this script, edit it to add your team's emails,
   and then use that script instead, like this:
   
   One time steps:
   ```
   cp ./dokku-scripts/admin.sh team.sh
   vim team.sh # edit to add your team members
   chmod u+x team.sh
   ```
   
   Then do:
   
   ```
   ./team.sh my-app
   ```
   
5. To configure Google OAuth for `my-app`, create a client id and client secret [as explained here](https://ucsb-cs156.github.io/topics/oauth/oauth_google_setup.html), then run:

   ```
   ./dokku-scripts/google-oauth.sh my-app
   ```
   The script will prompt you for the Google Client Id and Client Secret. Copy/paste the values
   from the Google Developer Console, and the script will set the appropriate environment variables
   for you (`GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`).
   
   
