# Proyecto 2: 

Cuando el detector de presencia no detecte ninguna persona, que haya un led rojo encendido. Cuando dicho detector compruebe que hay una persona que se encienda una luz led verde y muestre por pantalla la hora en la que ha detectado la presencia. 
Por otro lado, cuando el sensor de luminosidad detecte que es de noche (habr� que establecer un nivel de luminosidad que sea de noche), que encienda el led verde. Mientras tanto, que est� apagado. 


## Materiales:

- Placa Waspmote
- Placa de prototipado
- miniUSB Cable
- Luz led rojo
- Luz led verde
- 1x Waspmote Events Board
- 1x PIR Sensor
- 1x Luminosity Sensor
- WIFI Pro Onchip
- Bater�a

### Funcionamiento de la placa:

1)El sensor recoge la informaci�n de la habitaci�n y se estabiliza.
2)Tras esto, el sensor enciende una luz roja en caso de que no detecte presencia.
3)Cuando detecta alg�n movimiento, el sensor detecta presencia y enciende un led verde.
4)Por �ltimo, se ha establecido que es de noche cuando el nivel de iluminaci�n cae por debajo de los 10 luxes. Cuando el sensor de luminosidad detecta una ca�da por debajo de este umbral, se detiene todo el proceso anterior y deja encendido el led verde.

### Configuraci�n de la placa:

1)En el socket 1 de la Waspmote Events Sensor Board v3.0 se ha conectado el sensor de presencia. Esto se ha realizado conectado las patillas de la siguiente forma:

[[https://github.com/IIA2017/Proyecto2/Imagenes/PIR_sensor.png|alt=PIR_sensor]]


- La patilla GND se ha conectado en el pin 21 de la Waspmote.
- La patilla de VCC se ha conectado al pin 17 de la Waspmote.
- La salida del sensor se ha conectado al pin 18 de la Waspmote.

2)  El socket 5 de esta placa se ha utilizado para conectar el sensor de luminosidad.

3) En la placa Waspmote PRO v1.5 se han utilizado los pines Analog 6 para encender el led verde y la Analog 7 para el led rojo.


### Programaci�n:

Para la programaci�n del sensor PIR, se han partido de los siguientes ejemplos: Ev_v30_02_PIR y Ev_v30_14_luxes. A continuaci�n se realiza una explicaci�n del c�digo incluyendo los diferentes cambios aplicados para lograr el objetivo planteado anteriormente.
 
En primer lugar se definen las bibliotecas a utilizar y las variables que posteriormente utilizaremos. Adem�s se asocia el sensor pir con su socket correspondiente.




Tras esto se inicia el programa y se establecen los pines 19 y 20 como salidas. Adem�s se activa por primera vez el sensor PIR para su estabilizaci�n y se activan las interrupciones.

Una vez estabilizado el sensor, se comienza a leer la informaci�n del sensor y a su vez entra en funcionamiento el sensor de luminosidad. Si el nivel de luminosidad est� por encima de 10 luxes (hemos tomado que por encima de 10 luxes es de d�a) existen dos posibilidades:

El sensor PIR detecta movimiento (value==1) y, tras apagar el led rojo, enciende el led verde.
El sensor PIR no detecta movimiento y se enciende el led rojo. 
Realizada la primera comprobaci�n, el sensor PIR entra en modo sleep durante 10 segundos o hasta que se produzca una interrupci�n.

En caso de que se produzca una interrupci�n, se activa una alarma que manda un mensaje por pantalla avisando de la misma.

 Inmediatamente despu�s de la interrupci�n se realiza una nueva lectura del sensor, repitiendose el proceso explicado anteriormente para encender un led u otro. Por otro lado, una vez terminado este proceso se para la interrupci�n.



Por �ltimo, en caso de que los luxes est�n por debajo de 10 (es de noche) no se realiza el proceso anterior, sino que directamente se mantiene el led verde encendido hasta que el nivel de luxes supere ese umbral.  Un detalle a tener en cuenta es que se ha utilizado la interrupci�n RCP cada 10 segundos, por lo que la lectura de los luxes no es continua, sino que se realiza una lectura de este sensor en intervalos de este mismo tiempo.


Instalaciones Industriales Avanzadas - Bloque II

Master en Ingenier�a Industrial

Universidad de Almer�a

