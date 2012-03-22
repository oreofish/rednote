$(function() {
    if ($.inArray(location.pathname, ["/notes"])) {
        rednote.createPager('/notes/page').start();

        $('#note_publish').on('keypress', '#note_summary', function(e) {
            if (e.ctrlKey && (e.which == 13 || e.which == 10)) {
                $(this).parent('form').find(':submit').trigger('click');
            }
        });

        $('#note_publish').on('input', '#note_summary', function(e) {
            console.log(e.type);
            var $this = $(this);
            var remain = (160 - $this.attr('value').length);

            if (remain < 0) {
                $('#input_hint').html('<span class="alert alert-warning">输入超出范围'+remain+'</span>');
            } else if (remain == 160) {
                $('#input_hint').empty();
            } else {
                $('#input_hint').html('<span class="alert alert-info">还可以输入'+remain+'字</span>');
            }
        });

        // bootstrap-typeahead captures key events, so delegation won't work here.
        $('#tag_input').on('keypress', function(e) {
            if (e.which == 13 || e.which == 10) {
                var span = $('<span><span class="label">'+$(this).val()+
                             '</span><a data-dismiss="alert" href="#">×</a></span>');
                $('#pending_tag_list').append(span);
                $(this).val('');
            }
        });

        $('#new_note').on('submit', function() {
            var list = $('#pending_tag_list').find('span.label').map( function(){
                return $(this).text(); 
            });
            $('#note_tag_list').attr('value', Array.prototype.join.call(list, ','));
        });

        // update data-source for tags completion
        $('#new_note').on('ajax:success', function() {
            $.getJSON("/notes/taglist", function(data) {
                // HACK: force typeahead to update its data-source
                $('#tag_input').removeData('typeahead').data('source', data);
            });
        });

    } else if (location.pathname.match(/^\/users\/\d+/)) {
        var user_id=location.pathname.match(/\d+/g);
        var pager = rednote.createPager('/users/'+user_id+'/page');
        pager.start();
        $('a[data-toggle="tab"]').on('shown', function() {
            if ($(this).attr('href').match(/\/users\/\d+$/)) {
                pager.start();
            } else {
                pager.stop();
            }
        });

        rednote.spin.spinning($('ul.nav-tabs'), $('#tabspin'));
    }
});
