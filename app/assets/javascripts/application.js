// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jcrop
//= require ckeditor/ckeditor
//= require rednote_utils
//= require_tree .
function scrolltop() {
    var __backtoptxt = "回到顶部";
    var __backtopele = $('<div class="backToTop"></div>').appendTo($("html body"))
    .attr("title", __backtoptxt).click(function() {
        window.scroll(0, 0);
    });
    
    var __backtopfuc = function() {
        var st = $(document).scrollTop(),
        winh = $(window).height();
        (st > 0)? __backtopele.show() : __backtopele.hide();
        //IE6
        if (!window.XMLHttpRequest) {
            __backToTopEle.css("top", st + winh - 166);
        }
    };
    $(window).bind("scroll", __backtopfuc);
    __backtopfuc();
};

var commentsManager = {
    bindHandlers: function() {
        var that = this;
        $('#main div.inner ul.list').find('div.item').each( function(idx, el) {
            that._bindCommentHandlerHelper($(el));
        });
    },

    // called by js response for newly created comments
    bindCommentHandler: function(id) {
        $note = $('#note'+id);
        this._bindCommentHandlerHelper($note);
    }, 

    _bindCommentHandlerHelper: function(obj) {
        var $link = obj.find('a.comments_link');
        var $list = obj.find('div.comments_list');

        $link.unbind('click');
        $link.bind( {
            'click': function(ev) {
                $list.toggle('blind');
            }
        });
    }
};

var time = {
    updateTime: function() {
        var $items = $('.item').has('.time');

        var getTime = function(date) {
            return {
                year: date.getFullYear(),
                month: date.getMonth()+1,
                day: date.getDay(), //星期
                day: date.getDate(), //日
                hour: date.getHours(),
                minute: date.getMinutes(),
                second: date.getSeconds(),
            };
        };
        
        var now = getTime(new Date());

        $items.each( function(idx, el) {
            var $time = $(el).find('.time');
            var creation = getTime(new Date($time.attr('data')));
            if (now.year == creation.year) {
                if (now.year == creation.year && now.month == creation.month && 
                    now.day == creation.day) {
                    if (now.hour == creation.hour) {
                        if (now.minute == creation.minute) {
                            var a = now.second - creation.second;
                            $time.html(a+"秒前");
                        } else {
                            var b = now.minute - creation.minute;
                            $time.html(b+"分钟前");
                        }
                    } else if (now.hour - creation.hour == 1 && creation.minute > now.minute  ) {
                        $time.html(now.minute+60-creation.minute+"分钟前");
                    } else {
                        var c = now.hour - creation.hour;
                        $time.html(c+"小时前");
                    }
                } else {
                    $time.html(creation.month+"月"+creation.day+"日"+creation.hour+":"+creation.minute);
                }
            } else {
                $time.html(creation.year+"年"+creation.month+"月"+creation.day+"日"+creation.hour+":"+creation.minute);
            }
        });

        setTimeout(time.updateTime, 60000);
    }
};

$(document).ready( function() {
    scrolltop();
    commentsManager.bindHandlers();
    time.updateTime();

    $('#cropbox').Jcrop({
        onChange: update_crop,
        onSelect: update_crop,
        setSelect: [300, 200, 200, 300],
        aspectRatio: 1
    });

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
    }

} );
