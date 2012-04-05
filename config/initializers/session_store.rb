# Be sure to restart your server when you modify this file.

Rednote::Application.config.session_store :cookie_store, key: '_rednote_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Rednote::Application.config.session_store :active_record_store
#ActionController::Base.session = {
#  :key         => '_fullcalendar_session',
#  :secret      => '7581268e9ed13bd530ce8658b0bcb194efce95731a3761ce21113097d4eb87445dcb4eaf960623fd60e5e693261a91a4168e377ace790caa62baa361532151c3'
#}
