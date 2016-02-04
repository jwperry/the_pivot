$(document).ready(function () {
  // var $artists = $('.artist');
  // var $categories = $('.category');
  var $bids = $('.bid');
  var $listings = $('.listing');

  // $('#artist_filter_name').on('keypress', function () {
  //   var currentName = this.value.toLowerCase();
  //
  //   $artists.each(function (index, artist) {
  //     var $artist = $(artist);
  //     var $artistName = $artist.find('h2 span').text().toLowerCase();
  //
  //     if ($artistName.startsWith(currentName)) {
  //       $artist.show();
  //     } else {
  //       $artist.hide();
  //     }
  //   });
  // });
  //
  // $('#category_filter_name').on('keypress', function () {
  //   var currentName = this.value.toLowerCase();
  //
  //   $categories.each(function (index, category) {
  //     var $category = $(category);
  //     var $categoryName = $category.find('h2').text().toLowerCase();
  //
  //     if ($categoryName.startsWith(currentName)) {
  //       $category.show();
  //     } else {
  //       $category.hide();
  //     }
  //   });
  // });

  $('#bid_status').on('change', function () {
    var currentStatus = $('#bid_status :selected').text();

    $bids.each(function (index, bid) {
      var $bid = $(bid);
      var $bidStatus = $bid.find('.bid-status').text();

      if ($bidStatus === currentStatus || currentStatus === 'all') {
        $bid.show();
      } else {
        $bid.hide();
      }
    });
  });

  $('#job_status').on('change', function () {
    var currentStatus = $('#job_status :selected').text();

    $listings.each(function (index, listing) {
      var $listing = $(listing);
      var $jobStatus = $listing.find('.job-status').text();

      if ($jobStatus === currentStatus || currentStatus === 'all') {
        $listing.show();
      } else {
        $listing.hide();
      }
    });
  });
});
