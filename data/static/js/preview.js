function updatePreviewPane() {
    $("#previewpane").hide();
    var url = location.pathname.replace(/_edit\//,"_preview/");
    $.post(
      url,
      {"raw" : $("#editedText").val()},
      function(data) {
        $('#previewpane').html(data);
        // Process any mathematics if we're using MathML
        if (typeof(convert) == 'function') { convert(); }
        // Process any mathematics if we're using MathJax
        if (typeof(window.MathJax) == 'object') {
          // http://docs.mathjax.org/en/latest/typeset.html
          var math = document.getElementById("MathExample");
          MathJax.Hub.Queue(["Typeset",MathJax.Hub,math]);
        }
      },
      "html");

    $('#previewpane').show();

};
$(document).ready(function(){
    $("#previewButton").show();
    $("#previewpane").before("<h1>Preview</h1>");
    updatePreviewPane();
    $("#editedText").focus();
});

