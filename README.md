# README


# LINUX

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
rbenv use 
```

# WINDOWS

Download ruby version 2.5.1 for your system in https://rubyinstaller.org/downloads/

Download postgres version 9.6 in https://www.postgresql.org/download/windows/
Configure new role as in database.yml

In the instalation folder do:

``
bundle install
bundle exec rake db:migrate
rails s
``
