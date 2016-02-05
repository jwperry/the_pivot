$(document).ready(function () {
  var $bids = $(".bid");
  var $listings = $(".listing");

  $("#bid_status").on("change", function () {
    var currentStatus = $("#bid_status :selected").text();

    $bids.each(function (index, bid) {
      var $bid = $(bid);
      var $bidStatus = $bid.find(".bid-status").text();

      if ($bidStatus === currentStatus || currentStatus === "all") {
        $bid.show();
      } else {
        $bid.hide();
      }
    });
  });

  $("#job_status").on("change", function () {
    var currentStatus = $("#job_status :selected").text();

    $listings.each(function (index, listing) {
      var $listing = $(listing);
      var $jobStatus = $listing.find(".job-status").text();

      if ($jobStatus === currentStatus || currentStatus === "all") {
        $listing.show();
      } else {
        $listing.hide();
      }
    });
  });
});
