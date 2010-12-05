$(document).ready(function () {
  $form = $('form#new_call');
  $form.find('.artists,.albums,.songs').hide();

  $form.find('button.search').click(function () {
    $.getJSON('/lyrics/search', $form.serialize(), function (data) {
      if (data.length == 0) {
        alert('No artists found');
      }
      else {
        var items = $.map(data, function (e, i) {
          return '<li><a href="'+e.link+'">'+e.name+'</a></li>';
        });
        $('dt.artists').html('<ul>'+items.join('\n')+'</ul>');
        $('.artists').show();
        $('.search').hide();
      }
    });
  });

  $('.artists a').live('click', function (e) {
    e.preventDefault();
    var $link = $(this);
    $.getJSON('/lyrics/search', {artist_url: $link.attr('href')}, function (data) {
      if (data.albums.length == 0 && data.songs.length == 0) {
        alert('No data found for this artist');
      }
      else {
        var albums, songs;
        albums = $.map(data.albums, function (e, i) {
          return '<li><a href="'+e.link+'">'+e.name+'</a></li>';
        });
        songs = $.map(data.songs, function (e, i) {
          return '<option value="'+e.link+'">'+e.name+'</option>';
        });
        $('dt.albums').html('<ul>'+albums.join('\n')+'</ul>');
        $('#call_lyric_url').html(songs.join('\n'));
        $('.artists').hide();
        $('.albums').show();
        $('.songs').show();
      }
    });
  });

  $('.albums a').live('click', function (e) {
    e.preventDefault();
    var $link = $(this);
    $.getJSON('/lyrics/search', {album_url: $link.attr('href')}, function (data) {
      if (data.length == 0) {
        alert('No data found for this album');
      }
      else {
        var items = $.map(data, function (e, i) {
          return '<option value="'+e.link+'">'+e.name+'</option>';
        });
        $('#call_lyric_url').html(items.join('\n'));
        $('.albums').hide();
        $('.songs').show();
      }
    });
  });

  $form.submit(function () {
    if ($.trim($('#call_name').val()) == '') {
      alert('Name cannot be blank');
      return false;
    }
    if ($.trim($('#call_number').val()) == '') {
      alert('Number cannot be blank');
      return false;
    }
    if ($('#call_number').val().match(/^\d\d\d\d\d\d\d\d\d\d$/) == null) {
      alert('Number must be a valid 10 digit phone number');
      return false;
    }
    if ($.trim($('#call_lyric_url').val()) == '') {
      alert('You must choose a song');
      return false;
    }
  });

  $form.fadeIn('medium');
});