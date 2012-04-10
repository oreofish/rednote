CKEDITOR.editorConfig = function( config )
{
    config.language = 'zh-cn';
    config.uiColor = '#eeeeee';
    //config.skin = 'v2';
    config.fontSize_defaultLabel = '14px';

    config.toolbar = 'Simple';
    config.toolbar_Text =   [
        { name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','SelectAll','Scayt','-','Undo','Redo' ] },
        { name: 'insert', items : [ 'Image','HorizontalRule','Smiley','PageBreak'] },
        '/',
        { name: 'styles', items : [ 'Styles','Format' ] },
        { name: 'basicstyles', items : [ 'Bold','Italic','Strike','-','RemoveFormat' ] },
        { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote' ] },
        { name: 'links', items : [ 'Link','Unlink','Anchor' ] },
        { name: 'tools', items         : [ 'Maximize','-','About' ] }
    ];

    config.toolbar_Simple =   [
        { name: 'insert', items : ['Smiley'] },
        { name: 'basicstyles', items : [ 'Bold','NumberedList','BulletedList'] },
        { name: 'links', items : [ 'Link','Unlink' ] },
    ];
    config.toolbarCanCollapse = false;
    config.contentsCss = '/ckeditor_config.css';
};
