rednote.notesManager = {
    init: function() {
        var that = this;
        if (!rednote.util.isScrollVisible()) {
            //TODO: add timeout loading of nextpage
        }

        $(window).bind("scroll", rednote.notesManager.checkAndLoadNextPage);
    },

    checkAndLoadNextPage: function() {
        if (rednote.util.scrollNearBottom()) {
            rednote.notesManager.refreshNextPage();
        }
    },

    refreshNextPage: function() {
        console.log('try refreshNextPage');
        $.ajax({
            url: '/notes/page',
            beforeSend: function() {
                //TODO: busy waiting here
                console.log('send load request');
                $(window).unbind("scroll", rednote.notesManager.checkAndLoadNextPage);
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
                $(window).bind("scroll", rednote.notesManager.checkAndLoadNextPage);
            }
        });
    }
};

$(function() {
    rednote.notesManager.init();
});

