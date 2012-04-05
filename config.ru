# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rednote::Application

require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token'
      end
    end
    message['ext'] = nil
    callback.call(message)
  end
end

faye = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
faye.add_extension(ServerAuth.new)
faye.listen(9292)
run faye
