# GUIO APP

**Luego de tener instalado Flutter y Maven en la PC**

1 - Abrir Android Studio.

2 - Abrir la consola de Android Studio.

3 - Ubicarse en .\Guio\UnlamProyecto\Backend\guio

4 - Ejecutar mvn spring-boot:run

**Para ejecutar en Navegador Chrome**

5a - Ubicarse en .\Guio\UnlamProyecto\Frontend\guio_proyecto

6a - Ejecutar flutter pub get

7a - En el archivo navegacion.dart dejar comentada la linea 137 y descomentar la linea 136

7a - Ejecutar flutter run -d chrome --web-browser-flag "--disable-web-security"

**Para ejecutar en emulador mobile**

5b - Iniciar emulador

6b - Ubicarse en .\Guio\UnlamProyecto\Frontend\guio_proyecto

7b - Ejecutar flutter pub get

7b - En el archivo navegacion.dart dejar descomentada la linea 137 y comentar la linea 136

8b - Ejecutar flutter run
