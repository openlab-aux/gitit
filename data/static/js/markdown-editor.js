var simplemde = new SimpleMDE({ element: document.getElementById("editedText"), forceSync: true });

// update the preview on every change, after `changeTimeout` ms.
(function (){
    var changeTimeout = 1 *1000;
    var noTimeout = true;
    simplemde.codemirror.on("change", function(chgs){
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
