DimensionesPersonalizadas

Con el objetivo de poder trabajar los datos de Google Analytics fuera de la herramienta y así evitar los problemas de sampling o análisis que tenemos en analytics necesitamos incorporar 3 nuevas dimensiones personalizadas. 

  1- Hit Timestamp - Será un identificativo de de hit que con el que sabremos en que momento se ha originado dicho hit a nivel de milisegundo 
  1- Session ID - Identificativo de sesión para identificar de manera única las sesiones
  3- Client ID - Identificativo de cliente para identificar a los usuarios 
  
Para poder implementar crear estas dimnesiones debemos crear en Google Analytics las 3 dimensiones. Os adjunto en el repositorio un contendor de Tag Manager para que podáis importarlo con las 3 nuevas variables para enviar en TODOS los hits que se den en la web. 

