$(function() {
  
  $('a.delete').each( function(index) {
    $(this).click( function() {
    	$.ajax({
        url:      "/" + $(this).attr('data-resource') + "/" + $(this).attr('data-id'),
        type:     "DELETE",
        dataType: 'json',
        success: function( stuff ) {
          location.reload();  
        },
      });
    });
  });
  
});