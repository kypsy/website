web: bundle exec puma -C config/puma.rb
worker: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake resque:work QUEUE=*
release: bundle exec rake db:migrate
