$(function() {

  $('#seekingDegreeCheckbox').click(
    function() {
      console.log(2);
      $('#degree-seeking').toggleClass('hidden');
    }
  );

  $('.flash-message').click(
    function(e) {
      $(this).toggleClass('hidden')
    }
  )

});