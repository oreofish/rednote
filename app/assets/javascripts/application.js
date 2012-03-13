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
        $('#main-contents ul.list').find('div.item').each( function(idx, el) {
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

var removeAlert = {
    remove: function() { 
        var that = this;
        $('#main-contents').find('a.toremove').each( function(idx, el) {
            that.bindRemoveAlertHelper($(el));
        });
    },

    bindRemoveAlertHelper: function(link) {
        link.click(function(){
//            link.alert({
//                resizeable:false,
//                height:140,
//                modal:true,
//                buttons:{
//                    "Delete":function(){
//                        $(this).dialog("close");
//                        return true;
//                    },
//
//                    Cancel: function() {
//                        $(this).dialog("close");
//                        return false;
//                    }
//                }
//            });
        });
        link.confirm();
    },

    bindRemoveAlert: function(obj) {
        var $link= obj.find('a.toremove').first();
        this.bindRemoveAlertHelper($link);
    },
};

$(document).ready( function() {
    scrolltop();
    commentsManager.bindHandlers();
    removeAlert.remove();

    rednote.updateNoteTime();
} );
