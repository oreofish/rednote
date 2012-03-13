$(function() {
    $('#search_douban').on('click', function(ev){
        var idnumber = $('#doubanid').attr("value");
        //$(ev).preventDefaults();
        console.log('clicked');
        DOUBAN.getBook({
            id:idnumber,
            callback:function(results){
                var book = DOUBAN.parseSubject(results);
                var name = "";
                var x;
                console.log(book);
                $('#book_title').attr("value",book.title);
                for ( x in book.attribute.author){
                        console.log(x);
                        name = name + book.attribute.author[x] + ";";
                }
                $('#book_author').attr("value",name);
                $('#book_subtitle').attr("value",book.attribute.subtitle);
                $('#book_cover').attr("value",book.link.image);
                $('#book_url').attr("value","http://book.douban.com/subject/"+idnumber);
            },
        });

    });

});
