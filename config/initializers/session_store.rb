# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_evolution_session',
  :secret      => '2d01387681c2eccb8bdbd46e6aa7a4204e5872709c5505d95b3122d9dfe2180da6145b778e2cccc7c85196eb26ea3b16f0e533abcfdfb42f26ae1909515e660b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
