$(document).on('turbolinks:load', function() {
  /**
   * Additional fields for double-degree seeking students
   **/
  $('#seekingDegreeCheckbox').click(
    function(e) {
      $('#degree-seeking').toggleClass('hidden');
    }
  );
 /**
   * Close flash message
   **/
  $('.flash-message').click(
    function(e) {
      $(this).toggleClass('hidden');
    }
  );

  function initCropper(){
      var $image = $('#edit-picture-dialog-picture');
      if ($image.attr('src') !== "/assets/placeholder.png") {
        $image.cropper({
          aspectRatio: 1,
          minContainerWidth: 250,
          maxContainerWidth: 250,
          minContainerHeight: 250,
          maxContainerHeight: 250,
          minCanvasWidth: 250,
          minCanvasHeight: 250,
          minCropBoxWidth: 150,
          maxCropBoxWidth: 150,
          minCropBoxHeight: 150,
          maxCropBoxHeight: 150,
          background: false,
          guides: false,
          crop: function(event) {
          }
        });
     }
  }

 /**
   * Open picture modal
   **/
  $('.edit-picture').click(
    function(e) {
      let availWidth = $('html').width();
      availWidth = availWidth > 900 ? 700 : (availWidth < 500 ? availWidth - 10 : availWidth*0.7)
      $('#edit-picture-dialog').dialog({ 
        modal:true, 
        minWidth: availWidth,
        show: {
                effect: "scale",
                duration: 200
              },
              hide: {
                effect: "explode",
                duration: 200
              }
      });
      var $image = $('#edit-picture-dialog-picture');
      initCropper();
      
      // Get the Cropper.js instance after initialized
  });


  /**
    * Close picture modal
    */
  $('#edit-picture-dialog-close').click(
    function(e) {
        $('#edit-picture-dialog').dialog('close');
    }
  )

  /**
    * Convert Base64 to Blob
    */
  function dataURItoBlob(dataURI) {
    var byteString;
    if (dataURI.split(',')[0].indexOf('base64') >= 0)
        byteString = atob(dataURI.split(',')[1]);
    else
        byteString = unescape(dataURI.split(',')[1]);

    // separate out the mime component
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];

    // write the bytes of the string to a typed array
    var ia = new Uint8Array(byteString.length);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }

    return new Blob([ia], {type:mimeString});
}
  /**
    * Generate cropped picture
    */
  $('#edit-picture-dialog form').submit(function() {
    var $image = $('#edit-picture-dialog-picture');
    var cropper = $image.data('cropper');
    var canvasr = cropper.getCroppedCanvas({width: 150, height: 150}).toDataURL()
    var oData = new FormData();
    var photo = dataURItoBlob(canvasr);
    console.log(22)
    // Download to check if the picture is OK
    /*var a = document.createElement("a");
    document.body.appendChild(a);
    a.style = "display: none";
    a.href = url = window.URL.createObjectURL(photo);;
    a.download = "photo.png";
    a.click();
    */
    // $('<input />').attr('type', 'hidden')
    //           .attr('name', "photo")
    //           .attr('value', canvasr)
    //           .appendTo('#edit-picture-dialog form');

    oData.append("photo", photo, "photo.png");
    var oReq = new XMLHttpRequest();
    oReq.open("POST", "/user/file_upload");
    oReq.send(oData)
    oReq.onload = function(oEvent) {
    if (oReq.status == 200) {
      console.log("Uploaded!");
    } else {
      console.error("Error " + oReq.status + " occurred when trying to upload your file.");
    }

  };
  return false;
  //  return true;
  });

  /**
    * Load a new picture to be cropped
    */
  $(".image-edit-actions .input-file").change(function(e){
    if (e.target.files[0]) {
      var reader = new FileReader();
      reader.onload = function (ev) {
        var $image = $('#edit-picture-dialog-picture');
        $image.attr('src', ev.target.result);
        $image.cropper('destroy')
        initCropper();
      }
      reader.readAsDataURL(e.target.files[0]);
    }
  });
  $('.dashboard-section').click(function(e){
    var content= $(this).parents('.row').children('.collapsible')
    var caret= $(this).find('.caret')
    console.log($(this), caret)
    content.toggleClass('show');
    caret.toggleClass('reverse');
    caret.toggleClass('no-reverse');
  });

});