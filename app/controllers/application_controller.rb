require 'socket'
require "net/http"

class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery
  helper_method :local_ip 
  helper_method :broadcast
  helper_method :attachmentKind, :attachmentKindValue
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

  def attachmentKind(val)
    if @kindsList.nil?
      # list of attachment kinds 
      @kindsList = [
        :empty, # stub, no used
        :text,
        :link,
        :image,
        :code,
        :book
      ]
    end

    @kindsList[val]
  end

  def attachmentKindValue(sym)
    if @kindsMap.nil?
      # list of attachment kinds 
      @kindsMap = {
        :text => 1,
        :link => 2,
        :image => 3,
        :code => 4,
        :book => 5
      }
    end

    @kindsMap[sym]
  end
end
