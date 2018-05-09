# README

#WINDOWS

Download ruby version 2.5.1 for your system in https://rubyinstaller.org/downloads/

Download postgres version 9.6 in https://www.postgresql.org/download/windows/
Configure new role as in database.yml

In the instalation folder do:

``
bundle install
bundle exec rake db:migrate
rails s
``