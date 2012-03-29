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
//= require jquery-ui
//= require jquery_ujs
//= require spin
//= require jquery-spin
//= require twitter/bootstrap
//= require jcrop
//= require jquery-notetime
//= require ckeditor/ckeditor
//= require rednote_utils
//= require jquery.purr
//= require best_in_place
//= require books
//= require plupload
//= require plupload.settings
//= require jquery.plupload.queue
//= require plupload.flash
//= require plupload.html4
//= require plupload.html5
//= require plupload.gears
//= require jquery-ui
//= require fullcalendar
//= require hamlcoffee
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone-relational
//= require backbone/rednote
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

$(document).ready( function() {
    scrolltop();

    $('body').on('ajax:success timeupdate', function() {
        console.log('update notetime');
        $('.live-timestamp').updateNoteTime();
    });

    (function repeatSelf() {
        $('body').trigger('timeupdate');
        setTimeout(repeatSelf, 60000);
    })();
} );
