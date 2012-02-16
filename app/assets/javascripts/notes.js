var notesManager = {
    init: function() {
        var that = this;
        $(window).bind("scroll", function() {
            $this = $(this);
            if (that.scrollAtBottom()) {
                that.refreshNextPage();
            } else {
                console.log( 'no need to load next page' );
            }
        });
    },

    scrollAtBottom: function() {
        var totalHeight, currentScroll, visibleHeight;
        if (document.documentElement.scrollTop)
            currentScroll = document.documentElement.scrollTop;
        else
            currentScroll = document.body.scrollTop;

        if (document.documentElement.scrollHeight)
            totalHeight = document.documentElement.scrollHeight;
        else
            totalHeight = document.body.scrollHeight;

        visibleHeight = document.documentElement.clientHeight;

        if (totalHeight <= currentScroll + visibleHeight)
            return true;
        else
            return false;
    }, 

    refreshNextPage: function() {
        console.log('try refreshNextPage');
        $.get('/notes/page', function(data) {
            console.log('load next page');
            if (data.trim().length == 0)
                return;

            var cb = eval(data);
            if ( typeof cb === "function" ) {
                cb();
            }
        });
    }
};

$(function() {
    notesManager.init();
});

