rednote.notesManager = {
    init: function() {
        var that = this;
        if (!rednote.util.isScrollVisible()) {
            //TODO: add timeout loading of nextpage
        }

        $(window).bind("scroll", rednote.notesManager.checkAndLoadNextPage);

        var blocks = {}
        blocks['kind'] = function divKindFor(kind) {
            var map = {
                'text':  1,
                'link':  2,
                'image': 3,
                'code':  4,
                'book':  5
            };
            return '<div class="group"> \
                      <input id="note_kind" name="note[kind]" type="hidden" value="'+map[kind]+'"/> \
                    </div> \
                ';
        };

        blocks['text'] =  
            '<div class="group"> \
              <textarea cols="40" id="note_description" name="note[description]" rows="4"> \
              </textarea> \
            </div> \
        ';

        blocks['code'] =  
            '<div class="group"> \
              <div class="columns wat-cf"> \
                <div class="column left"> \
                  <label for="note_代码片段：">代码片段：</label><br /> \
                  <textarea cols="40" id="note_description" name="note[description]" rows="8"></textarea> \
                </div> \
                <div class="column right"> \
                  <label class="label">选择语言</label><br/> \
                  <select id="language_id" name="language[id]"><option value="C">C</option> \
                    <option value="Clojure">Clojure</option> \
                    <option value="CSS">CSS</option> \
                    <option value="Delphi">Delphi</option> \
                    <option value="DIFF">DIFF</option> \
                    <option value="ERB">ERB</option> \
                    <option value="Groovy">Groovy</option> \
                    <option value="HAML">HAML</option> \
                    <option value="HTML">HTML</option> \
                    <option value="Java">Java</option> \
                    <option value="JavaScript">JavaScript</option> \
                    <option value="JSON">JSON</option> \
                    <option value="PHP">PHP</option> \
                    <option value="Python">Python</option> \
                    <option value="Ruby">Ruby</option> \
                    <option value="SQL">SQL</option> \
                    <option value="XML">XML</option> \
                    <option value="YAML">YAML</option> \
                  </select> \
                </div> \
              </div> \
            </div> \
        ';

        blocks['image'] =  
            '<div class="group"> \
              <label>上传图片：</label>      \
              <input id="note_upload" name="note[upload]" type="file" /> \
              <input id="note_upload_cache" name="note[upload_cache]" type="hidden" /> \
            </div> \
        ';

        blocks['book'] =  
            '<div class="group"> \
              <label>上传书籍：</label>      \
              <input id="note_upload" name="note[upload]" type="file" /> \
            </div> \
        ';

        blocks['link'] =  
            '<div class="group"> \
              <label>链接</label><br /> \
              <input id="note_description" name="note[description]" size="30" type="text" /> \
            </div> \
        ';

        var $attach_blk = $('#main .note_publish #attachment_block');
        var last_clicked_kind = "";

        $('#main .notes_main .note_publish a').each( function(idx, el) {
            $(el).bind( {
                'click': function(ev) {
                    var kind = $(this).attr('class');
                    var visbile = $attach_blk.css('display') !== 'none';

                    console.log('last_clicked_kind: ' + last_clicked_kind 
                                + ', kind: ' + kind);
                    if (last_clicked_kind === "") {
                        $attach_blk.html(blocks[kind]+blocks['kind'](kind));
                        $attach_blk.toggle('slide');

                    } else if (last_clicked_kind === kind) {
                        $attach_blk.toggle('slide');

                    } else {
                        if (visbile) {
                            $attach_blk.toggle('slide', function() {
                                $attach_blk.html(blocks[kind]+blocks['kind'](kind));
                                $attach_blk.toggle('slide');
                            });
                        } else { 
                            $attach_blk.html(blocks[kind]+blocks['kind'](kind));
                            $attach_blk.toggle('slide');
                        }
                    }
                    last_clicked_kind = kind;
                }
            });
        });

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
                $('#pager_loading').toggleClass('hidden');
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
                $('#pager_loading').toggleClass('hidden');
                $(window).bind("scroll", rednote.notesManager.checkAndLoadNextPage);
            }
        });
    }
};

$(function() {
    if (location.pathname === "/" || location.pathname === "/notes")
        rednote.notesManager.init();
});

