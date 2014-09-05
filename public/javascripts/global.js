$(function() {
  
  $('a.delete').each( function(index) {
    $(this).click( function() {
    	$.ajax({
        url:      "/pull/" + $(this).attr('data-pull_id'),
        type:     "DELETE",
        dataType: 'json',
        success: function( stuff ) {
          location.reload();  
        },
      });
    });
  });
  
});