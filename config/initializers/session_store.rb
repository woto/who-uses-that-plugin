# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_plugin-stats_session',
  :secret      => '42aab608f3e3010bd35c85f48288bf54502139ac6945b6c898c13b7b1f2ba43b60a0addb5383553d4ef0727174a89dbdc0c303377855e60bcf5e6c2723706c1a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
