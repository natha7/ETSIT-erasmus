$(document).on('turbolinks:load', function() {

  var relative_url = "/erasmus";

  var lang_elements = [
    {key: "name", label: "Language", input: "select"},
    {key: "currently_studying", label: "Currently Studying", input: "checkbox"},
    {key: "able_follow_lectures", label: "Able to follow lectures", input: "checkbox"},
    {key: "able_follow_lectures_extra_preparation", label: "Able to follow lectures with extra preparation", input: "checkbox"},
  ];
  var work_elements = [
    {key: "work_kind", label: "Position", input: "text"},
    {key: "firm_organisation", label: "Organisation", input: "text"},
    {key: "from", label: "From", input: "date"},
    {key: "to", label: "To", input: "date"},
    {key: "country", label: "Country", input: "select"},
  ];

  /**
   * Additional fields for students with working experience
   **/
  $('#seekingDegreeCheckbox').click(
    function(e) {
      $('#degree-seeking').toggleClass('hidden');
    }
  );

  /**
   * Additional fields for double-degree seeking students
   **/
  $('#no_work_experience_checkbox').click(
    function(e) {
      $('.other-work ').toggleClass('hidden');
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

  /**
    * Remove flash messages automatically
    */
  setTimeout(function(e){
    $('.flash-message').addClass('hidden');
  }, 4000);

  /**
    * Initialize cropper
    **/
  function initCropper(){
      var $image = $('#edit-picture-dialog-picture');
      if ($image.attr('src') !== relative_url + "/assets/placeholder.png") {
        $image.cropper({
          aspectRatio: 1,
          minContainerWidth: 150,
          maxContainerWidth: 250,
          minContainerHeight: 150,
          maxContainerHeight: 250,
          // minCanvasWidth: 250,
          // minCanvasHeight: 250,
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
    * Open multiple nominees modal
    */
  $('#multiple-nominees-button').click(function(e){
    e.stopPropagation();
    let availWidth = $('html').width();
    availWidth = availWidth > 900 ? 700 : (availWidth < 500 ? availWidth - 10 : availWidth*0.7)
    $('#several-nominee-dialog').dialog({ 
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

  });
  /**
    * Close multiple nominees modal
    */
  $('#several-nominee-dialog-close').click(
    function(e) {
        $('#several-nominee-dialog').dialog('close');
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
    var canvas = cropper.getCroppedCanvas({width: 150, height: 150})
    if (!canvas) {
      $('.messages-from-server').append($('<p class="message-from-server alert">An error ocurred</p>'));
      return false;
    }
    var canvasr = canvas.toDataURL();
    var oData = new FormData();
    var photo = dataURItoBlob(canvasr);
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

    oData.append("user[photo]", photo, "photo.png");
    oData.append("authenticity_token", $('#edit-picture-dialog form input[name="authenticity_token"]').val());

    var oReq = new XMLHttpRequest();
    oReq.open("POST", relative_url+"/user/file_upload_ajax");
    oReq.send(oData)
    $('#spinner').removeClass('hidden');
    $('.messages-from-server').empty();
    oReq.onload = function(oEvent) {

      $('#spinner').addClass('hidden');
      if (oReq.status == 200) {
        try {
          var url = JSON.parse(oReq.response).url;
          var $image = $('#edit-picture-dialog-picture');
          $image.attr('src', url);
          $image.cropper('destroy')
          initCropper();
          $('#actual-picture').attr('src', url);
          // $('.messages-from-server').append($('<p class="message-from-server notice">Uploaded correctly!</p>'));
          $('#edit-picture-dialog').dialog('close');
          location.reload();
        } catch (e) {
          console.error("An error ocurred when uploading the file", e)
          $('.messages-from-server').append($('<p class="message-from-server alert">An error ocurred</p>'));
        }
      } else {
        console.error("Error " + oReq.status + " occurred when trying to upload your file.");
        $('.messages-from-server').append($('<p class="alert">An error ocurred</p>'));
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
  
  /**
    * Collapse panels
    */
  $('.dashboard-section').click(function(e) {
    var content= $(this).parents('.row').children('.collapsible');
    var wasOpen = content.hasClass('show');

    $('.collapsible.show').removeClass('show');
    $('.caret').removeClass('reverse');
    $('.caret').addClass('no-reverse');
    if (!wasOpen) {
      var caret= $(this).find('.caret');
      content.toggleClass('show');
      caret.toggleClass('reverse');
      caret.toggleClass('no-reverse');
    }
  });

  /**
    * Delete language
    */
  function deleteLang() {
    $(this).parents('.lang').remove();
  }

  /**
    * Add callback to all delete buttons in language form
    */
  $('.delete-lang-button').click(deleteLang);


  /**
    * Add a new language
    */
  $('#add-lang').click(function(e){
    var numLang = $(".language-input").length;
    var $lang = $('<div class="lang"></div>');
     

    for (var i in lang_elements) {
      var element = lang_elements[i];
      var el = "student_application_form[languages][][" + element.key + "]";
      var $field = $('<div class="field"></div>');
      var $container = $('<div class="flex-container"></div>');
      var $label = $('<label/>').attr("for", el ).text(element.label);
      var $input = $('<input/>').attr('type', element.input)
              .attr('name',el)
              .attr('class', "language-input");
      if(element.input === 'select' && window.options) {
        $input = $('<select/>') 
              .attr('name',el)
              .attr('class', "language-input");
        for (var opt in window.options) {
          $option = $('<option/>') 
              .attr('value', window.options[opt])
              .text(window.options[opt])
          $input.append($option)
        }
      }
      if (element.input === "checkbox") {
        $label.attr("class", "checkBox")
        $container.append($input);
        $container.append($label);
      } else {
        $container.append($label);
        $container.append($input);
      }
      
      $field.append($container);
      $lang.append($field);

    }
    var $button = $('<button/>')
            .attr('type', "button")
            .attr('class', "delete-lang-button transparent-button small-button");
    $button.click(deleteLang);
    var $icon = $('<i/>')
            .attr('class', "mdi mdi-close");
    $button.append($icon);
    $lang.append($button);
    $('.lang-list').append($lang)

  });


  /**
    * Delete work
    */
  function deleteWork() {
    $(this).parents('.work').remove();
  }

  /**
    * Add callback to all delete buttons in work form
    */
  $('.delete-work-button').click(deleteWork);

  /**
    * Add a new work experience
    */
  $('#add-work').click(function(e){
    var $work = $('<div class="work"></div>');

    for (var i in work_elements) {
      var element = work_elements[i];
      var el = "student_application_form[work_experiences][]["+element.key+"]";
      var $field = $('<div class="field"></div>');
      var $container = $('<div class="flex-container"></div>');
      var $label = $('<label/>').attr("for", el ).text(element.label);

      var $input = $('<input/>').attr('type', element.input)
              .attr('name',el)
              .attr('class', "work-input");

      if(element.input === 'select' && window.options) {
        $input = $('<select/>') 
              .attr('name',el)
              .attr('class', "work-input");
        for (var opt in window.options) {
          $option = $('<option/>') 
              .attr('value', window.options[opt])
              .text(window.options[opt])
          $input.append($option)

        }
      }
      $container.append($label);
      $container.append($input);

      $field.append($container);
      $work.append($field);

    }
    var $button = $('<button/>')
            .attr('type', "button")
            .attr('class', "delete-work-button transparent-button small-button");
    $button.click(deleteWork);
    var $icon = $('<i/>')
            .attr('class', "mdi mdi-close");
    $button.append($icon);
    $work.append($button);
    $('.work-list').append($work)

  });


  $('#user_signed_student_application_form').change(function(e){ 
    if (e.target.files.length > 0) {
        // quitar disabled
        $('#upload-signed').prop('disabled', false)
    } else {
        // poner disabled
        $('#upload-signed').prop('disabled', true)
    }
  });

  $('.deletion').submit(function(e){
     return confirm("Are you sure you want to delete this file?");
  })

});
