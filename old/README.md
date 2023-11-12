 # old/README.md

1. After creating an app with `dokku apps:create my-app`, you can **set up https** by typing:

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
   
   Example usage (actual secrets redacted):
   
   ```
   pconrad@dokku-00:~/dokku-scripts$ ./google-oauth.sh proj-courses
   Enter Google Client Id: 30574869948-9ec5i62vc7bdc0dlpm2blcmep7hns6hm.apps.googleusercontent.com
   Enter Google Client Secret: GOCSPX-kNfhoFAKEjH9FAKEyifsoa3
   -----> Setting config vars
          GOOGLE_CLIENT_ID:  30574869948-9ec5i62vc7bdc0dlpm2blcmep7hns6hm.apps.googleusercontent.com
   -----> Setting config vars
          GOOGLE_CLIENT_SECRET:  GOCSPX-kNfhoFAKEjH9FAKEyifsoa3
   =====> proj-courses env vars
   ADMIN_EMAILS:            phtcon@ucsb.edu,avishekde@ucsb.edu,vivianross@ucsb.edu,bzamoraflores@ucsb.edu,andrewpeng@ucsb.edu,rbriggs@ucsb.edu
   DATABASE_URL:            postgres://postgres:9954dFAKEs9dffFAKE88sdsef@dokku-postgres-proj-courses-db:5432/proj_courses_db
   DOKKU_PROXY_PORT:        80
   DOKKU_PROXY_PORT_MAP:    http:80:5000 https:443:5000
   DOKKU_PROXY_SSL_PORT:    443
   GOOGLE_CLIENT_ID:        30574869948-9ec5i62vc7bdc0dlpm2blcmep7hns6hm.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET:    GOCSPX-kNfhoFAKEjH9FAKEyifsoa3
   JDBC_DATABASE_PASSWORD:  9954dFAKEs9dffFAKE88sdsef
   JDBC_DATABASE_URL:       jdbc:postgresql://172.17.0.8:5432/proj_happycows_db
   JDBC_DATABASE_USERNAME:  postgres
   PRODUCTION:              true
   pconrad@dokku-00:~/dokku-scripts$ 
   ```
