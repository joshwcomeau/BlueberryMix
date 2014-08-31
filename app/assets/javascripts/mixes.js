$(document).ready(function() {
  console.log("loaded");
  // Only fire on pages that have a set player.
  if ( $(".set_player").length ) {



    var url = $(".set_player").data('url');

    var wavesurfer = Object.create(WaveSurfer);

    wavesurfer.init({
        container: document.querySelector('.set_player'),
        waveColor: 'violet',
        progressColor: 'purple',
        normalize: true
    });

    wavesurfer.on('ready', function () {
        wavesurfer.play();
    });

    wavesurfer.load(url);
  }
});