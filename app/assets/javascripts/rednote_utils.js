/*
 * =====================================================================================
 *
 *       Filename:  rednote_utils.js
 *
 *    Description:  common API for rednote
 *
 *        Version:  1.0
 *        Created:  2012年02月15日 11时33分25秒
 *       Revision:  none
 *
 *         Author:  Sian Cao
 *        Company:  Red Flag Linux Co.
 *
 * =====================================================================================
*/

rednote = {}

rednote.util = {
    serverIP: function() {
        var server = location.host.replace(/:\d*/, '');
        if (/localhost/.test(server)) {
            server = '127.0.0.1';
        }
        return server;
    },

    scrollNearBottom: function() {
        var totalHeight, currentScroll, visibleHeight;
        if (document.documentElement.scrollTop)
            currentScroll = document.documentElement.scrollTop;
        else
            currentScroll = document.body.scrollTop;

        if (document.documentElement.scrollHeight)
            totalHeight = document.documentElement.scrollHeight;
        else
            totalHeight = document.documentElement.offsetHeight;

        visibleHeight = document.documentElement.clientHeight;

        if (totalHeight <= currentScroll + visibleHeight + 40)
            return true;
        else
            return false;
    }, 

    isScrollVisible: function() {
        var totalHeight, visibleHeight;
        if (document.documentElement.scrollHeight)
            totalHeight = document.documentElement.scrollHeight;
        else
            totalHeight = document.documentElement.offsetHeight;

        visibleHeight = document.documentElement.clientHeight;
        if (visibleHeight > totalHeight)
            return true;
        else
            return false;
    }
};

rednote.pager = function(action) {
    var update_action = action;
    return {
        start: function() {
            var that = this;
            if (!rednote.util.isScrollVisible()) {
                //TODO: add timeout loading of nextpage
            }

            $(window).bind("scroll", function() {
                that.checkAndLoadNextPage();
            });
        },

        checkAndLoadNextPage: function() {
            if (rednote.util.scrollNearBottom()) {
                this.refreshNextPage();
            }
        },

        refreshNextPage: function() {
            var that = this;
            console.log('try refreshNextPage');
            $.ajax({
                url: update_action,
                beforeSend: function() {
                    $('#pager_loading').toggleClass('hidden');
                    $(window).unbind("scroll");
                }, 
                success: function(data) {
                    if (data.trim().length == 0)
                        return;

                    var cb = eval(data);
                    if ( typeof cb === "function" ) {
                        console.log('load next page');
                        cb();
                    }
                },
                complete: function() {
                    $('#pager_loading').toggleClass('hidden');
                    $(window).bind("scroll", function() {
                        that.checkAndLoadNextPage();
                    });
                }
            });
        },
    };
};

// handle flash messages and animations
rednote.flashController = {
    _message: function(style, msg) {
        var $flash = $('div.flash');
        $flash.stop();
        $flash.html('<div class="' + style + '"> ' + 
                    '<div class="message"> ' + msg + ' </div>  </div>');
        $flash.css('z-index', 'auto');
        $flash.hide().fadeIn(500).delay(1000).fadeOut('slow', function(){
            $flash.css('z-index', '-1');
        });
    }, 
    doFailure: function(msg) {
        this._message("alert", msg);
    }, 
    doSuccess: function(msg) {
        this._message("notice", msg);
    },
    stop: function() {
        $('div.flash').stop();
    }
};

rednote.logger = {
    record: function(msg) {
        console.log(msg);
        rednote.flashController.doSuccess("<b>有更新，刷新显示</b>" );
    }
};

function setup_faye(){
    var server = location.host.replace(/:\d*/, '');
    if (/localhost/.test(server)) {
        server = '127.0.0.1';
    }
    var client = new Faye.Client('http://'+server+':9292/faye');

    client.subscribe("/notes/*",function(data){
        //eval(data);
    });

    // faye 
    var Slot = {
        incoming: function(message, callback) {
            switch( message['channel'] ) {
                case "/notes/new":
                case "/notes/destroy":
                    rednote.logger.record(message);
                    break;
            }
            callback(message);
        },

        outgoing: function(message, callback) {
            callback(message);
        }
    };

    client.addExtension(Slot);
};

$(function(){
    setup_faye();
});
