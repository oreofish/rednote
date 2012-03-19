$(function() {
    $('#projectcontent').on('click', 'a[href="close"]', function(ev) {
        
        var $tag=$(ev.target).parents('div.taskeditview').first();
        var id = $tag.attr("taskid");

        $.get("/tasks/"+id+"/show_partical/", {}, function(task){
            $('#task'+id).find('p1.task-content').text(task.content);
            $('#task'+id).find('p1.task-estimate').text(task.estimate);
        });

    });
});
