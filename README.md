# ETSIT-erasmus
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/bccabf42125f4b20b005d05a68835527)](https://app.codacy.com/app/sonsoleslp/ETSIT-erasmus?utm_source=github.com&utm_medium=referral&utm_content=ging/ETSIT-erasmus&utm_campaign=Badge_Grade_Dashboard)

Application for managing the registration process of incoming students at ETSIT-UPM.
Currently working towards supporting the eIDAS specification.

## Installation
This is a step-by-step guide on how to install the ETSIT-erasmus application from scratch. If you already have rails installed, you can skip the first part. There is a comprehensive guide for each one of the three main operating systems.

### Ubuntu

```bash
sudo apt-get install git
```
Install rbenv from https://github.com/rbenv/rbenv and ruby-build as plugin

```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
~/.rbenv/bin/rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```
Reboot terminal
```
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```
Reboot terminal
```
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
rbenv install 2.5.1
```

```
sudo gem install bundler
sudo apt-get install postgresql postgresql-contrib libpq-dev
sudo gem update --system
```
Nokogiri might give problems when trying to install bundler. To fix them:
```
sudo apt-get install libxslt-dev libxml2-dev
sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev (insert s and not S to accept)
gem install nokogiri
bundle update --bundler
gem install bundler
```
Create user and give ownership as in config/database.yml


```
sudo -u postgres psql (to enter in the postgreSQL console)  
CREATE ROLE loguser WITH CREATEDB LOGIN PASSWORD 'password';
```
Now, execute the following command in the postgreSQL console to make your user superuser. This way, the 'loguser' user will have access rights to the databases.

```
ALTER USER loguser WITH superuser;
```

Afterwards, we create the databases needed.

```
CREATE DATABASE logapp_dev OWNER loguser;
CREATE DATABASE logapp_prod OWNER loguser;
CREATE DATABASE logapp_test OWNER loguser;
\q (exit from postgreSQL console)
```
Modify the file 'pg_hba.conf' opening a terminal at folder '/etc/postgresql/(your version)/main' using the command:
sudo nano ./pg_hba.conf

Substitute the line:
```
# 'local' is for Unix domain socket connections only
local   all             postgres                   peer
```
for:
```
# 'local' is for Unix domain socket connections only
local   all             postgres                   md5
```
To allow password access and then restart the service:
```
/etc/init.d/postgresql restart
```

### Windows

Download ruby version 2.5.1 for your system in https://rubyinstaller.org/downloads/

Download postgres version 9.6 in https://www.postgresql.org/download/windows/
Configure new role as in database.yml

Install rails:
```
gem install rails -v 5.2.0
```
In the instalation folder do:

```
bundle install
bundle exec rake db:migrate
rails s
```

### MacIntosh

```bash
brew install git
```
Install rbenv from https://github.com/rbenv/rbenv and ruby-build as plugin

```
brew install rbenv
~/.rbenv/bin/rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
rbenv install 2.5.1
rbenv global 2.5.1
```

Reboot Terminal
```
brew install postgres
gem install bundler
bundle install
```
Create user and give ownership as in config/database.yml


```
sudo -u postgres psql (to enter in the postgreSQL console)  
CREATE ROLE loguser WITH CREATEDB LOGIN PASSWORD 'password';
```
Now, execute the following command in the postgreSQL console to make your user superuser. This way, the 'loguser' user will have access rights to the databases.

```
ALTER USER loguser WITH superuser;
```

Afterwards, we create the databases needed.

```
CREATE DATABASE logapp_dev OWNER loguser;
CREATE DATABASE logapp_prod OWNER loguser;
CREATE DATABASE logapp_test OWNER loguser;

\q (exit from postgreSQL console)
```

## Running the application

The following files are needed in order to run the project: 
- config/config.yml
- config/secrets.yml
- vendor/certs/key.pem (you need to create the folder 'certs')
- vendor/certs/cert.pem
- vendor/saml2-node/eidas.json

**To purge database and recreate:**
Rename 'database.yml.example' to 'database.yml'
```
rake db:drop db:create db:migrate db:populate
```

**Create an admin user:**

Use this rake task in order to create an admin user to manage the incoming students
```
rake db:create_admin email=admin@myuniversity.org password=password
```

**To start rails:**
```
rails s
```
Open browser on `http://localhost:3000/erasmus`

