$(function() {
    if (location.pathname === "/" || location.pathname === "/notes") {
        rednote.pager('/notes/page').start();

        $('ul.nav-tabs').on('show', function (e) {
            var nowtab = e.target; // activated tab
            var id = $(nowtab).attr('href').substr(1);
            $('#'+id).find('#new_note')[0].reset();
            if (id === "text") {
                if (CKEDITOR.instances["note_code"]) {
                    CKEDITOR.instances["note_code"].setData('');
                }
            }
        });

        $('#note_publish').on('keypress', '#note_summary', function(e) {
            if (e.ctrlKey && (e.which == 13 || e.which == 10)) {
                $(this).parent('form').find(':submit').trigger('click');
            }
        });

    } else if (location.pathname.match(/^\/users\/\d+/)) {
        var user_id=location.pathname.match(/\d+/g);
        rednote.pager('/users/'+user_id+'/page').start();
        rednote.spin.spinning($('ul.nav-tabs'), $('#tabspin'));
    }
});

