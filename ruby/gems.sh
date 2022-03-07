#Install gem:
  gem install $package
#Uninstall:
  gem uninstall $package
#Download gem file:
  gem fetch $package

#Bundler:
  gem install bundler

  #Define gems you want to bundle:
  vi Gemfile
    source 'https://rubygems.org'
    gem 'nokogiri'
    gem 'rack', '~> 2.0.1'
    gem 'rspec'
  git add Gemfile Gemfile.lock

  #'bundler' or 'bundle' are interchangeable

  #Usage:
    #install gems locally
      bundle install
    #create gem files in vendor/cache:
      bundle package
    #config:
      bundle config set cache_all true
    #info like path where gem installed:
      bundle info $package
    #bundler doesn't bundle itself:
      cd vendor/cache/
      gem fetch bundler
      #will get deleted on next bundler run

