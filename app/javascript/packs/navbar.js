$(document).ready(function () {
  $('.bi-list').click(function () {
    $('#hidden-links').slideDown();
    $(this).fadeToggle(500);
    setTimeout(() => { $('.bi-x').fadeToggle(); }, 500);
  });

  $('.bi-x').click(function () {
    $('#hidden-links').slideUp();
    $(this).fadeToggle(500);
    setTimeout(() => { $('.bi-list').fadeToggle(); }, 500);
  });
});