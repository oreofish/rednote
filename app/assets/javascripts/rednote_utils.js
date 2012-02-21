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

// handle flash messages and animations
rednote.flashController = {
    doMessage: function(msg) {
        this.stop();
        $('.flash').html('<div class="message notice"> '+msg+'  </div>');
        $('.flash').css('z-index', 'auto');
        $('.flash .message').hide().slideDown(500).delay(1000).slideUp(1000, function(){
            $('.flash').css('z-index', '-1');
        });
    }, 
    doFailure: function(msg) {
        this.stop();
        $('.flash').html('<div class="message alert"> '+msg+'  </div>');
        $('.flash').css('z-index', 'auto');
        $('.flash .message').show('bounce', { times: 2 }, 1000).fadeOut('slow', function(){
            $('.flash').css('z-index', '-1');
        });
    }, 
    doSuccess: function(msg) {
        this.stop();
        $('.flash').html('<div class="message notice"> '+msg+'  </div>');
        $('.flash').css('z-index', 'auto');
        $('.flash .message').fadeIn('slow').delay(1000).fadeOut('slow', function(){
            $('.flash').css('z-index', '-1');
        });
    },
    stop: function() {
        $('.flash').stop();
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
