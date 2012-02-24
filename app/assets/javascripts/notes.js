rednote.notesManager = {
    init: function() {
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
            '<div class="block inner"> \
              <textarea cols="40" id="note_description" name="note[description]" rows="10"> \
              </textarea> \
              <script type="text/javascript"> \
              if (CKEDITOR.instances["note_description"]) { \
                  CKEDITOR.remove(CKEDITOR.instances["note_description"]); \
              } \
              CKEDITOR.replace("note_description", { "language":"en", "customConfig":"/ckeditor_config.js" }); \
              </script> \
            </div> \
        ';

        blocks['code'] =  
            '<div class="block inner"> \
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
            '<div class="block inner"> \
              <label>上传图片：</label>      \
              <input id="note_upload" name="note[upload]" type="file" /> \
              <input id="note_upload_cache" name="note[upload_cache]" type="hidden" /> \
            </div> \
        ';

        blocks['book'] =  
            '<div class="block inner"> \
              <label>上传书籍：</label>      \
              <input id="note_upload" name="note[upload]" type="file" /> \
            </div> \
        ';

        blocks['link'] =  
            '<div class="block inner"> \
              <label>链接</label><br /> \
              <input id="note_description" name="note[description]" size="30" type="text" /> \
            </div> \
        ';

        var $attach_blk = $('#main .note_publish #attachment_block');
        var last_clicked_kind = "";

        $('#main .note_publish a').each( function(idx, el) {
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
};

$(function() {
    rednote.notesManager.init();
    if (location.pathname === "/" || location.pathname === "/notes") {
        rednote.pager('/notes/page').start();

    } else if (location.pathname.match(/^\/users\//)) {
        rednote.pager('/users/page').start();
    }
});

