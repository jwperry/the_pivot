$(function(){
  $("#categories").on("change", function () {
    var selection = $("#categories :selected").text().toLowerCase();
    selection = selection.replace(/ /g, "-");

    var url = "/categories/" + selection;
    if (url) {
      window.location.href = url;
    }
    return false;
  });
});
