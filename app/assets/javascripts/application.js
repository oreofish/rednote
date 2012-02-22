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
//= require rednote_utils
//= require_tree .
function scrolltop() {
    var __backtoptxt = "回到顶部";
    var __backtopele = $('<div class="backToTop"></div>').appendTo($("html body"))
    .attr("title", __backtoptxt).click(function() {
        window.scroll(0, 0);
        //$("html, body").animate({ scrollTop: 0 }, 500);
    }),
    __backtopfuc = function() {
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
        var $items = $('.item').has('.comments_link');
        $items.each( function(idx, el) {
            var $link = $(el).find('.comments_link');
            var $list = $(el).find('.comments_list');

            $link.unbind('click');
            $link.bind( {
                'click': function(ev) {
                    $list.toggle('blind');
                }
            });
        });
    }
};

var time = {
    updatetime: function() {
        var $items = $('.item').has('.time');

        var $now = new Date();
        var now_year = $now.getFullYear();
        var now_month = $now.getMonth()+1;
        var now_day = $now.getDay(); //星期
        var now_date = $now.getDate(); //日
        var now_hour = $now.getHours();
        var now_minute = $now.getMinutes();
        var now_second = $now.getSeconds();

        $items.each( function(idx, el) {
            var $time = $(el).find('.time');
            var $create_at = $time.attr('data').split(" ");// xxxx-xx-xx xx:xx:xx +0800

            var create_year   = parseInt($create_at[0].split("-")[0]);
            var create_month  = parseInt($create_at[0].split("-")[1]);
            var create_date   = parseInt($create_at[0].split("-")[2]);
            var create_hour   = parseInt($create_at[1].split(":")[0]);
            var create_minute = parseInt($create_at[1].split(":")[1]);
            var create_second = parseInt($create_at[1].split(":")[2]);

                if (now_year == create_year && now_month == create_month && now_date == create_date) {
                        if (now_hour == create_hour) {
                            if (now_minute == create_minute) {
                                var a = now_second - create_second;
                                $time.html(a+"秒前");
                            } else {
                                var b = now_minute - create_minute;
                                $time.html(b+"分钟前");
                            }
                        } else if (now_hour - create_hour == 1 && create_minute > now_minute  ) {
                                $time.html(now_minute+60-create_minute+"分钟前");
                               } else {
                                var c = now_hour - create_hour;
                                $time.html(c+"小时前");
                               }
                    } else {
                        $time.html(create_month+"月"+create_date+"日"+create_hour+":"+create_minute);
                    }
        });
    window.setTimeout("time.updatetime();",60000);
    }
};


$(document).ready( function() {
    scrolltop();
    commentsManager.bindHandlers();
    time.updatetime();
} );
