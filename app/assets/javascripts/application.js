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
        //link.confirm();
    },

    bindRemoveAlert: function(obj) {
        var $link= obj.find('a.toremove').first();
        this.bindRemoveAlertHelper($link);
    },
};

$(document).ready( function() {
    scrolltop();
    removeAlert.remove();

    $('body').on('ajax:success timeupdate', function() {
        console.log('update notetime');
        $('.live-timestamp').updateNoteTime();
    });

    (function repeatSelf() {
        $('body').trigger('timeupdate');
        setTimeout(repeatSelf, 60000);
    })();

} );


// codes for full calendar events
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/events/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/events/resize"
    });
}

function linkToEvent(event, dayDelta, minuteDelta){
    window.location.href='/events/' + event.id;
}

function showEventDetails(event){
    $('#event_desc').html(event.description);
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")'>Edit</a>");
    if (event.recurring) {
        title = event.title + "(Recurring)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>");
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + true + ")'>Delete All In Series</a>")
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", \"future\")'>Delete All Future Events</a>")
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete</a>");
    }
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){
            $('#desc_dialog').dialog('destroy')
        }
        
    });
    
}


function editEvent(event_id){
    jQuery.ajax({
        data: 'id=' + event_id,
        dataType: 'script',
        type: 'get',
        url: "/events/edit"
    });
}

function deleteEvent(event_id, delete_all){
    jQuery.ajax({
        data: 'id=' + event_id + '&delete_all='+delete_all,
        dataType: 'script',
        type: 'post',
        url: "/events/destroy"
    });
}

function showPeriodAndFrequency(value){
    switch (value) {
        case 'Daily':
            $('#period').html('day');
            $('#frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('#frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('#frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('#frequency').show();
            break;
            
        default:
            $('#frequency').hide();
    }
}
