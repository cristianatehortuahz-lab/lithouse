// Se ejecuta cuando el documento HTML ha cargado completamente
$(document).ready(function () {

    // 1. Extraer la cédula de la URL (sin cambios)
    function getIdFromUrl() {
        try {
            const pathSegments = window.location.pathname.split('/');
            const idSegment = pathSegments.find(segment => segment.startsWith('id='));
            if (idSegment) {
                return idSegment.split('=')[1];
            }
            return null;
        } catch (error) {
            console.error("Error extrayendo la cédula de la URL:", error);
            $('#status-message').text("Error: No se pudo leer la cédula de la URL.");
            return null;
        }
    }

    const cedula = getIdFromUrl();

    if (!cedula) {
        $('#status-message').text("No se encontró una cédula en la URL.");
        return;
    }


    const apiUrl = `https://research-hub.urosario.edu.co/local-api/crear-perfil.php?cedula=${cedula}`;
    $.ajax({
        url: apiUrl,
        method: "GET",
        dataType: "json", // Esperamos una respuesta JSON
        success: function (response) {
            // Se valida que la respuesta exista y tenga un mensaje.
            if (response && response.mensaje) {

                // Ahora leemos directamente de 'response.status'
                if (response.status == 0) {
                    // Se muestra el mensaje de que el usuario ya existe.
                    $('#status-message').text(response.mensaje);
                    console.log(`Respuesta de la API: ${response.mensaje}`);
                } else {
                    // Si el status es diferente de 0, se asume que es la URL para redirigir.
                    const redirectUrl = response.mensaje;
                    window.location.href = redirectUrl;
                }

            } else {
                // Manejo para una respuesta inesperada o vacía.
                console.error("La respuesta de la API no tiene el formato esperado:", response);
                $('#status-message').text("La respuesta del servidor no es válida.");
            }
        },
        error: function (xhr, status, error) {
            console.error("Error en la llamada a la API:", status, error);
            $('#status-message').text(`Hubo un error al consultar el servicio web: ${status}`);
        }
    });

});