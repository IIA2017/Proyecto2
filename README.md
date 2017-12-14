# Proyecto 2: 

Cuando el detector de presencia no detecte ninguna persona, que haya un led rojo encendido. Cuando dicho detector compruebe que hay una persona que se encienda una luz led verde y muestre por pantalla la hora en la que ha detectado la presencia. 
Por otro lado, cuando el sensor de luminosidad detecte que es de noche (habrá que establecer un nivel de luminosidad que sea de noche), que encienda el led verde. Mientras tanto, que esté apagado. 


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
- Batería


- Placa Waspmote | ![waspmote](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/waspmote.png)
- Placa de prototipado | 
- miniUSB Cable | ![miniUSB](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/cable_usb.jpg)
- Luz led rojo | ![led](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/led.jpg)
- Luz led verde | ![led](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/led.jpg)
- 1x Waspmote Events Board | ![events](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/events_board.png)
- 1x PIR Sensor | ![PIR](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/PIR_sensor.png)
- 1x Luminosity Sensor | ![luminosity](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/PIR_luminosity.png)
- WIFI Pro Onchip | ![wifi](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/wifi.png)
- Batería |




![waspmote](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/waspmote.png)
![waspmoteinout](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/waspmoteinout.png)

### Funcionamiento de la placa:

1. El sensor recoge la información de la habitación y se estabiliza.
2. Tras esto, el sensor enciende una luz roja en caso de que no detecte presencia.
3. Cuando detecta algún movimiento, el sensor detecta presencia y enciende un led verde.
4. Por último, se ha establecido que es de noche cuando el nivel de iluminación cae por debajo de los 10 luxes. Cuando el sensor de luminosidad detecta una caída por debajo de este umbral, se detiene todo el proceso anterior y deja encendido el led verde.

### Configuración de la placa:

![events](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/events_board.png)

1. En el socket 1 de la Waspmote Events Sensor Board v3.0 se ha conectado el sensor de presencia. Esto se ha realizado conectado las patillas de la siguiente forma:

![PIR Sensor](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/PIR_sensor.png)


- La patilla GND se ha conectado en el pin 21 de la Waspmote.
- La patilla de VCC se ha conectado al pin 17 de la Waspmote.
- La salida del sensor se ha conectado al pin 18 de la Waspmote.

2. El socket 5 de esta placa se ha utilizado para conectar el sensor de luminosidad.

3. En la placa Waspmote PRO v1.5 se han utilizado los pines Analog 6 para encender el led verde y la Analog 7 para el led rojo.


### Programación:

Para la programación del sensor PIR, se han partido de los siguientes ejemplos: Ev_v30_02_PIR y Ev_v30_14_luxes. A continuación se realiza una explicación del código incluyendo los diferentes cambios aplicados para lograr el objetivo planteado anteriormente.
 
En primer lugar se definen las bibliotecas a utilizar y las variables que posteriormente utilizaremos. Además se asocia el sensor pir con su socket correspondiente.

![code1](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code1.png)


Tras esto se inicia el programa y se establecen los pines 19 y 20 como salidas. Además se activa por primera vez el sensor PIR para su estabilización y se activan las interrupciones.

![code2](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code2.png)

Una vez estabilizado el sensor, se comienza a leer la información del sensor y a su vez entra en funcionamiento el sensor de luminosidad. Si el nivel de luminosidad está por encima de 10 luxes (hemos tomado que por encima de 10 luxes es de día) existen dos posibilidades:

- El sensor PIR detecta movimiento (value==1) y, tras apagar el led rojo, enciende el led verde.
- El sensor PIR no detecta movimiento y se enciende el led rojo. 

![code3](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code3.png)

Realizada la primera comprobación, el sensor PIR entra en modo sleep durante 10 segundos o hasta que se produzca una interrupción.

![code4](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code4.png)

En caso de que se produzca una interrupción, se activa una alarma que manda un mensaje por pantalla avisando de la misma.

![code5](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code5.png)

 Inmediatamente después de la interrupción se realiza una nueva lectura del sensor, repitiendose el proceso explicado anteriormente para encender un led u otro. Por otro lado, una vez terminado este proceso se para la interrupción.

![code6](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code6.png)

Por último, en caso de que los luxes estén por debajo de 10 (es de noche) no se realiza el proceso anterior, sino que directamente se mantiene el led verde encendido hasta que el nivel de luxes supere ese umbral.  Un detalle a tener en cuenta es que se ha utilizado la interrupción RCP cada 10 segundos, por lo que la lectura de los luxes no es continua, sino que se realiza una lectura de este sensor en intervalos de este mismo tiempo.

![code7](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code7.png)

Instalaciones Industriales Avanzadas - Bloque II

Master en Ingeniería Industrial

Universidad de Almería

