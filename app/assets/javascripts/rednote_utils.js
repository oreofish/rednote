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
    _message: function(style, title, msg) {
        var $flash = $('div.flash');
        var templ = '<div class="alert alert-block ' + style + 'fade in">' +
            '<a class="close" data-dismiss="alert" href="#">×</a>' +
            '<h4 class="alert-heading">' + title + '</h4>' +
            '<p> ' + msg + '</p>' + '</div>';
        $flash.append(templ); 
    }, 
    doFailure: function(title, msg) {
        this._message("alert-error", title, msg);
    }, 
    doSuccess: function(title, msg) {
        this._message("alert-success", title, msg);
    },
    doInfo: function(title, msg) {
        this._message("alert-info", title, msg);
    }
};

rednote.logger = {
    record: function(msg) {
        console.log(msg);
        rednote.flashController.doInfo(msg['channel'], msg['data'] );
    },

    updateinfo: function(msg) {
        console.log(msg);
        var $info = $('#update_info');
        var num=$info.text().match(/\d+/);
        
        num=Number(num)+1;
        $info.text( $info.text().replace(/(\d+)/,num) );

        var $note = $( "#note"+ eval("(" + msg['data'] + ")").note_id);
        $note.find('div.item').addClass("label-info");
    }
}


function setup_faye(){
    var server = location.host.replace(/:\d*/, '');
    if (/localhost/.test(server)) {
        server = '127.0.0.1';
    }
    var client = new Faye.Client('http://'+server+':9292/faye');

    client.subscribe("/notes/*",function(data){
        //eval(data);
    });

    client.subscribe("/comments/new/"+document.cookie.substring(document.cookie.indexOf("current_user_id=")+16,document.cookie.length),function(data){
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
                case "/comments/new/"+document.cookie.substring(document.cookie.indexOf("current_user_id=")+16,document.cookie.length):
                    rednote.logger.updateinfo(message);
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

jcrop = {
    crop: function() { $('#cropbox').Jcrop({
        onChange: update_crop,
        onSelect: update_crop,
        setSelect: [300, 200, 200, 300],
        aspectRatio: 1
    });
    }
};

function update_crop(coords) {
    var rx = 100/coords.w;
    var ry = 100/coords.h;
    var lw = $('#cropbox').width();
    var lh = $('#cropbox').height();
    var ratio = $('#cropbox').attr('date') / lw ;

    $('#preview').css({
        width: Math.round(rx * lw) + 'px',
        height: Math.round(ry * lh) + 'px',
        marginLeft: '-' + Math.round(rx * coords.x) + 'px',
        marginTop: '-' + Math.round(ry * coords.y) + 'px'
    });
    $("#crop_x").val(Math.round(coords.x * ratio));
    $("#crop_y").val(Math.round(coords.y * ratio));
    $("#crop_w").val(Math.round(coords.w * ratio));
    $("#crop_h").val(Math.round(coords.h * ratio));
};

$(function(){
    setup_faye();
    jcrop.crop();
});
