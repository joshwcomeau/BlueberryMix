$(document).ready(function() {
  console.log("loaded");
  // Only fire on pages that have a set player.
  if ( $(".set_player").length ) {
    var audioSection = $('.set_player');

    var audio = $('<audio>', {
         controls : 'controls'
    });

    console.log(this)

    var url = audioSection.data('url');
    $('<source>').attr('src', url).appendTo(audio);
    audioSection.html(audio);
    return false;
  }
});