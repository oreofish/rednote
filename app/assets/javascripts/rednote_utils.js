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
                    $('#pager_loading').spin(rednote.spin.defaultOpts);
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
                    setTimeout(function() {
                        $('#pager_loading').spin(false);
                    }, 600);

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
    notifyCount: 0,

    _message: function(style, title, msg) {
        title = title || "通知";
        msg = msg || "";
        var $flash = $('div.flash');
        var templ = '<div class="alert alert-block ' + style + ' fade in">' +
            '<a class="close" data-dismiss="alert" href="#">×</a>' +
            '<strong>' + title + '</strong>' + msg + '</div>';
        if (!this.notifyCount) {
            $(templ).insertBefore($('#flash_content').find('a.more'));
        } else {
            $flash.append(templ); 
        }
    }, 
    setup: function() {
        // setup toggle monitor
        var that = this;
        var $ctx = $('#flash_content');
        $ctx.find('a.more').hide();

        $ctx.bind({
            'DOMNodeInserted': function() {
                console.log('DOMNodeInserted');
                that.notifyCount++;
                if (that.notifyCount < 2) {
                    that.hideMore();
                } else {
                    that.showMore();
                }
            },
            'DOMNodeRemoved': function() {
                that.notifyCount--;
                if (that.notifyCount < 2) {
                    that.hideMore();
                } else {
                    that.showMore();
                }
            }
        });

    }, 
    showMore: function() {
        var $ctx = $('#flash_content');
        $ctx.find('a.more').fadeIn('fast');
    },
    hideMore: function() {
        var $ctx = $('#flash_content');
        $ctx.find('a.more').fadeOut('fast');
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

rednote.spin = {
    defaultOpts: {
        lines: 12, // The number of lines to draw
        length: 4, // The length of each line
        width: 4, // The line thickness
        radius: 8, // The radius of the inner circle
        color: '#000', // #rgb or #rrggbb
        speed: 0.8, // Rounds per second
        trail: 57, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: true, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: 'auto', // Top position relative to parent in px
        left: 'auto' // Left position relative to parent in px
    },

    spinning: function(tabs, target) {
        console.log('spinning');
        var that = this;
        tabs.on({
            'show': function() {
                target.spin(that.defaultOpts);
            },
            'shown': function() {
                setTimeout( function() {
                    target.spin(false);
                }, 600 );
            }
        });
    }
};

rednote.logger = {
    notifyCreate: function(msg) {
        console.log(msg);
        var data = eval("("+msg+")");
        var log = " ";

        if (data.status === true) {
            if (CONFIG.user !== data.nickname) {
                rednote.flashController.doSuccess("有新笔记，请刷新显示");
            }

        } else {
            for (attr in data.errors) {
                if (typeof attr !== "function") {
                    log += " " + data.errors[attr];
                }
            }
            rednote.flashController.doFailure("新建笔记失败", log);
        }
    },

    notifyDestroy: function(msg) {
        console.log(msg);
        var data = eval("("+msg+")");
        console.log(data.nickname);
        if (CONFIG.user !== data.nickname) {
            rednote.flashController.doSuccess("有笔记被删除，请刷新");
        }
    },

    updateinfo: function(msg) {
        console.log(msg);
        var $info = $('#update_info');
        var num=$info.text().match(/\d+/);
        
        num=Number(num)+1;
        $info.text( $info.text().replace(/(\d+)/,num) );
        $info.attr("style","");

        var $note = $( "#note"+ eval("(" + msg['data'] + ")").note_id);
        $note.find('a.comments_link').addClass("label-warning");
    }
}

function setup_faye(){
    var server = location.host.replace(/:\d*/, '');
    if (/localhost/.test(server)) {
        server = '127.0.0.1';
    }
    var client = new Faye.Client('http://'+server+':9292/faye');
    var strs = document.cookie.substring(document.cookie.indexOf("current_user_id=")+16,document.cookie.length);
    var str = strs.substring(0,strs.indexOf(";"));
    if ( strs.indexOf(";") == -1 ) {
        str = strs;
    }

    client.subscribe("/notes/*",function(data){
        //eval(data);
    });

    client.subscribe("/comments/new/"+str,function(data){
        //eval(data);
    });
    // faye 
    var Slot = {
        incoming: function(message, callback) {
            switch( message['channel'] ) {
                case "/notes/new":
                    rednote.logger.notifyCreate(message['data']);
                    break;

                case "/notes/destroy":
                    rednote.logger.notifyDestroy(message['data']);
                    break;

                case "/comments/new/"+str:
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
        setSelect: [0, 0, 100, 100],
        aspectRatio: 1
    });
    }
};

function preview(el,size,coords){
    var rx = size/coords.w;
    var ry = size/coords.h;
    var lw = $('#cropbox').width();
    var lh = $('#cropbox').height();

    el.css({
        width: Math.round(rx * lw) + 'px',
        height: Math.round(ry * lh) + 'px',
        marginLeft: '-' + Math.round(rx * coords.x) + 'px',
        marginTop: '-' + Math.round(ry * coords.y) + 'px'
    });
}

function update_crop(coords) {
    var lw = $('#cropbox').width();
    var ratio = $('#cropbox').attr('date') / lw ;

    preview($('#preview1'),180,coords); 
    preview($('#preview2'),48,coords); 
    $("#crop_x").val(Math.round(coords.x * ratio));
    $("#crop_y").val(Math.round(coords.y * ratio));
    $("#crop_w").val(Math.round(coords.w * ratio));
    $("#crop_h").val(Math.round(coords.h * ratio));
};

function judge(box,value) {
    var input = box.find('input');
    var span = box.find('span');

    input.focusout(function() {
        if(input.val() === "") {
            box.removeClass("success");
            box.addClass("error");
            span.text("不能为空"); 
        } else {
            $.get("/users/search_"+value,{val:input.val()},function(bool){
                if (bool === "ture") {
                    box.removeClass("error");
                    box.addClass("success");
                    span.text("可以注册");
                } else {
                    box.removeClass("success");
                    box.addClass("error");
                    span.text("用户已经存在"); 
                }
            })
        }
    });
};

function waring() {
    var box_nickname = $('#nickname_input');
    var box_email = $('#email_input');

    judge(box_nickname,"nickname");
    judge(box_email,"email");
};

function updatetimeprogress() {
    var $item = $('#timeprogress');
    var $bar = $item.find('.bar');

    var time = new Date();
    var day = time.getDay();
    var hour = time.getHours();
    var minuter = time.getMinutes();
    var workhour = 8;

    if (1 <= day && day <= 5 ) {
        var numerator = (day-1) * workhour * 60;
        if (hour - 9 >= 0) {
            numerator += (hour-9) * 60 + minuter;
        }
        var denominator = 5 * workhour * 60;
        var value = numerator / denominator  * 100;
    }

    $bar.css('width',value+'%');
    setTimeout(updatetimeprogress,60000);

};

$(function(){
    rednote.flashController.setup();
    setup_faye();
    jcrop.crop();
    waring();
    updatetimeprogress();
});
