  $(document).ready(function () {
    // Agregamos el evento click a los elementos con la clase "clickable"
    $(".clickable").click(function () {
        // Obtenemos el atributo "groupname" del elemento clicado
        const groupName = $(this).attr("groupname");

        // Si el groupname es "publicaciones", ocultamos la sección
        if (groupName === "publications") {
            $("#right-hand-column").show();
            $("section#individual-info").css("width" , "78%" ,"!important");
            
        } else {
            // En cualquier otro caso, mostramos la sección
            $("#right-hand-column").hide();
            $("section#individual-info").css("width" , "100%" , "!important");
            
        }
    });
});
