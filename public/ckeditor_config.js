CKEDITOR.editorConfig = function( config )
{
    config.language = 'en';
    config.uiColor = '#AADC6E';

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
        { name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','SelectAll','Scayt','-','Undo','Redo' ] },
        { name: 'insert', items : [ 'Image','HorizontalRule','Smiley','PageBreak'] },
        { name: 'basicstyles', items : [ 'Bold','Italic','Strike','-','RemoveFormat','NumberedList','BulletedList'] },
        { name: 'links', items : [ 'Link','Unlink','Anchor' ] },
    ];
    config.toolbarCanCollapse = false;
};
