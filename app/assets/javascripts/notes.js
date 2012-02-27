$(function() {
    if (location.pathname === "/" || location.pathname === "/notes") {
        rednote.pager('/notes/page').start();

    } else if (location.pathname.match(/^\/users\//)) {
        rednote.pager('/users/page').start();
    }

});

