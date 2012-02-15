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
    .text(__backtoptxt).attr("title", __backtoptxt).click(function() {
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

$(document).ready( function() {
    scrolltop();
} );
