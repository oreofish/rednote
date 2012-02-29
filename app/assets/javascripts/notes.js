$(function() {
    if (location.pathname === "/" || location.pathname === "/notes") {
        rednote.pager('/notes/page').start();

        $('ul.nav-pills').on('show', function (e) {
            console.log('change' + e.target.toString());
            var nowtab = e.target // activated tab
            var id = $(nowtab).attr('href').substr(1);
            $('#'+id).find('#new_note')[0].reset();
            if (id === "text") {
                if (CKEDITOR.instances["note_code"]) {
                    CKEDITOR.instances["note_code"].setData('');
                }
            }
        });

    } else if (location.pathname.match(/^\/users/)) {
        rednote.pager('/users/page').start();
        $('ul.nav-tabs a:first').tab('show');
        rednote.spin.spinning($('ul.nav-tabs'), $('#tabspin'));
    }
});

