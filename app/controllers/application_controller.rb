require 'socket'
require "net/http"

class ApplicationController < ActionController::Base
  before_filter :authenticate_user!, :except => [:search_nickname, :search_email]
  protect_from_forgery
  helper_method :local_ip 
  helper_method :broadcast
  helper :all

  def broadcast(channel, *msg, &block)
    if block_given?
      message = {
        :channel => channel,
        :data => capture(&block),
        :ext => {:auth_token => FAYE_TOKEN}
      }
    else
      message = {
        :channel => channel,
        :data => msg,
        :ext => {:auth_token => FAYE_TOKEN}
      }
    end
    uri = URI.parse("http://"+local_ip+":9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def local_ip
    # turn off reverse DNS resolution temporarily
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

  def string_replace(num,obj)
    #num is 1 can execute the first gsub ……
    obj = obj.gsub(/@([a-zA-Z0-9_]+)/,'<a href=\1>@\1</a>') if (num >= 1) # replace @nickname to a link
    obj = obj.gsub(/(http+:\/\/[^\s]*)/,'<a href=\1>\1</a>') if (num >= 2) # replace url to a link
    obj = obj.gsub(/\?$/,"<img height=\"18\" src=\"/images/wenhao.jpg\" width=\"18\">") if (num >= 3) #replace question to a image
    return obj.html_safe
  end

end
