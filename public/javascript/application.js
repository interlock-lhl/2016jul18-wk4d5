$(document).ready(function() {

  $("#ratingbutton").rating({showCaption: false, showClear: false, min:0, max:5, step:1, size:'md'});
  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()

  function upvote(song_id) {
    $.ajax({
      url: '/api/upvotes',
      method: 'POST',
      data: { song_id: song_id },
      success: function(data) {
        $('button.upvote[data-song-id=' + song_id +']').text(data.action == 'up' ? 'Downvote' : 'Upvote')
        $('td.upvote_counter[data-song-id=' + song_id +']').text(data.upvotes)
        console.log(data);
      },
      error: function() {
        console.log('error!')
      }
    });
  }

  $('button.upvote').on('click', function() {
    var song_id = $(this).attr('data-song-id');
    upvote(song_id);
  });

  function render_review(review) {
    $('div.row.reviews').append(
      $('<div class="col-md-6 col-md-offset-3">' +
        '<blockquote>' +
          '<p>' + review.created_at + '</p>' +
          '<p>' + review.user.username + ' rated ' + review.rating + ' stars and said: ' + review.content + '</p>' +
        '</blockquote>' +
      '</div>')
    );
  }
  var song_id = $('body').attr('data-song-id');

  if (song_id != undefined) {
    $.ajax({
      url: '/api/songs/' + song_id + '/reviews',
      method: 'GET', // optional
      success: function(data) {
        console.log(data);
        for(var i = 0; i < data.length; i++) {
          render_review(data[i]);
        }
      }
    });

    $('form').on('submit', function(event) {
      event.preventDefault();
      var data = {
        content: $(this).find('[name=content]').val(),
        rating: $(this).find('[name=rating]').val()
      };

      $.ajax({
        url: '/api/songs/' + song_id + '/reviews',
        method: 'POST', // optional
        data: JSON.stringify(data),
        contentType: 'json',
        success: function(data) {
          render_review(data);
        }
      });
    });
  }


});
