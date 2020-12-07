$(document).ready(function () {
  $('.bi-list').click(function () {
    $('#hidden-links').slideDown();
    $(this).fadeToggle(125);
    setTimeout(() => { $('.bi-x').fadeToggle(); }, 125);
  });

  $('.bi-x').click(function () {
    $('#hidden-links').slideUp();
    $(this).fadeToggle(125);
    setTimeout(() => { $('.bi-list').fadeToggle(); }, 125);
  });
});