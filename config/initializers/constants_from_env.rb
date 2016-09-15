# REDISTOGO_URL is used on Heroku
# REDIS_URL is set by docker-compose.yml
ENV_REDIS_URL = ENV['REDISTOGO_URL'] || ENV.fetch('REDIS_URL')

# Check existence
ENV.fetch('DATABASE_URL')
