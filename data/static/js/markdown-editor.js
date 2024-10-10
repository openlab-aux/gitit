// include the EasyMDE CSS dynamically (since it doesn't make sense without JS)
//
//var cssId = 'EasyMDECSS'
//if (!document.getElementById(cssId))
//{
//    var head  = document.getElementsByTagName('head')[0];
//    var link  = document.createElement('link');
//    link.id   = cssId;
//    link.rel  = 'stylesheet';
//    link.type = 'text/css';
//    link.href = '/static/easymde.min.js';
//    link.media = 'all';
//    head.appendChild(link);
//}

var easymde = new EasyMDE({ element: document.getElementById("editedText"), forceSync: true, autoDownloadFontAwesome : false, spellChecker : false });

// update the preview on every change, after `changeTimeout` ms.
(function (){
    var changeTimeout = 1 *1000;
    var noTimeout = true;
    easymde.codemirror.on("change", function(chgs){
        if (noTimeout === true) {
            noTimeout = false;
            window.setTimeout(
                function(){
                    noTimeout = true;
                    updatePreviewPane();
                },
                changeTimeout
            );
        };
    });
})();
