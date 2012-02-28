jQuery ->
  $(".alert-message").alert()
  #$(".tabs").button()
  $(".carousel").carousel()
  #$(".collapse").collapse() # this is not needed for collapse to work
  $(".dropdown-toggle").dropdown()
  $(".modal").modal()
  $("a[rel=popover]").popover()
  #$(".navbar").scrollspy() # conflict with below!!!
  $(".nav-pills a:first").tab "show"
  $(".tooltip").tooltip()
  $(".typeahead").typeahead()
  $("a[rel=tooltip]").tooltip()
