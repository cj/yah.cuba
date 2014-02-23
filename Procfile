/*web: bundle exec rackup -s thin -p $PORT*/
/*web: bundle exec puma -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12} -w ${PUMA_WORKERS:-2} -p $PORT -e ${RACK_ENV:-development}*/
web: bundle exec unicorn -p $PORT -c ./unicorn.rb
