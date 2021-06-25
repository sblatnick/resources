#INSTALLATION
  #Debian: https://www.itzgeek.com/post/how-to-install-ruby-on-rails-on-debian-10-debian-9/

  #Install Dependencies:
  sudo apt install -y curl gnupg2 dirmngr git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
  sudo apt remove nodejs-doc
  sudo apt install -y libnode72

  #Install nodejs:
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt-get install nodejs
  sudo apt-get install gcc g++ make

  #Install yarn:
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install yarn

  #Install rbenv (simpler and lighter weight than rvm)
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  exec $SHELL

  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  exec $SHELL

  #Install latest Ruby:
  rbenv install 3.0.1

  #Set system default to this version:
  rbenv global 3.0.1

  #Check:
  ruby -v

  #Install bundler:
  gem install bundler

  #Install rails:
  gem install rails
  rails -v

#CREATE APP
  rails new ${webapp}
  cd ${webapp}
  #The app is created in a new git repo

#RUN
  rails server -b 0.0.0.0
  #Browser: http://localhost:3000

  #Gemfile to add libraries:
  gem 'module'
  
  #Create db table Model:
  rails generate model table column number:integer
  
  #Prep:
    rails db:migrate
  #Initialize from db/seeds.rb
    rails db:seed

    #Alternatively:
      #Initialize DB:
      rake db:seed
      rake db:setup
      #Reset:
      rake db:reset

#Route:
  config/routes.rb:
    Rails.application.routes.draw do
      get "/articles", to: "articles#index"
    end
#Action:
  generate controller Articles index
  generate controller Articles index --skip-routes
#View:
  app/views/articles/index.html.erb





