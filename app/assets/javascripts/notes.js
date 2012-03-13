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

            $('#input_hint').empty();
        });

        $('#note_publish').on('keypress', '#note_summary', function(e) {
            if (e.ctrlKey && (e.which == 13 || e.which == 10)) {
                $(this).parent('form').find(':submit').trigger('click');
            }
        });

        $('#note_publish').on('input', '#note_summary', function(e) {
            console.log(e.type);
            var $this = $(this);
            var remain = (500 - $this.attr('value').length);

            if (remain < 0) {
                $('#input_hint').html('<span class="alert alert-warning">输入超出范围'+remain+'</span>');
            } else if (remain == 500) {
                $('#input_hint').empty();
            } else {
                $('#input_hint').html('<span class="alert alert-info">还可以输入'+remain+'字</span>');
            }
        });

    } else if (location.pathname.match(/^\/users\/\d+/)) {
        var user_id=location.pathname.match(/\d+/g);
        rednote.pager('/users/'+user_id+'/page').start();
        rednote.spin.spinning($('ul.nav-tabs'), $('#tabspin'));
    }
});
