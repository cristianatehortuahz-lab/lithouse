$(document).ready(function() {
  
  // 1. Al hacer clic en el icono del QR
  $('#qrIcon').on('click', function(event) {
    // Evita que el clic se propague a otros elementos (como el documento)
    event.stopPropagation(); 
    // Muestra u oculta el popover con un suave efecto de desvanecimiento
    $('#qrCodeImage').fadeToggle(200); 
  });

  // 2. Al hacer clic en el enlace "Cerrar"
  $('#qrCodeImage .qrCloseLink').on('click', function(event) {
    // Previene la acción por defecto del enlace (que es navegar a "#")
    event.preventDefault(); 
    // Oculta el popover
    $('#qrCodeImage').fadeOut(200); 
  });

  // 3. (Opcional pero recomendado) Cierra el popover si se hace clic en cualquier otro lugar de la página
  $(document).on('click', function() {
    if ($('#qrCodeImage').is(':visible')) {
      $('#qrCodeImage').fadeOut(200);
    }
  });

  // 4. Evita que el popover se cierre si se hace clic dentro de él
  $('#qrCodeImage').on('click', function(event) {
    event.stopPropagation();
  });

});
