# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rsmt_session',
  :secret      => 'b9f532f1c67607d29d29be7734c1ed32e52d57de7dd79e51add6f540fc3370074c76c1ca5271d550092b6dc7b239b150402e097f7b11d05a3fe5987de15152bf'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
