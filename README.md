# Proyecto 2: 

Cuando el detector de presencia no detecte ninguna persona, que haya un led rojo encendido. Cuando dicho detector compruebe que hay una persona que se encienda una luz led verde y muestre por pantalla la hora en la que ha detectado la presencia. 
Por otro lado, cuando el sensor de luminosidad detecte que es de noche (habrá que establecer un nivel de luminosidad que sea de noche), que encienda el led verde. Mientras tanto, que esté apagado. 


## Materiales:

- Placa Waspmote 

![waspmote](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/waspmote.png)

- Placa de prototipado 

![prototipado](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/prototipado.jpg) 

- miniUSB Cable 

![miniUSB](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/cable_usb.jpg)

- Luz led rojo 

![led](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/led.jpg)

- Luz led verde 

![led](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/led.jpg)

- 1x Waspmote Events Board 

![events](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/events_board.png)

- 1x PIR Sensor 

![PIR](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/PIR_sensor.png)

- 1x Luminosity Sensor 

![luminosity](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/luminosity.png)

- WIFI Pro Onchip 

![wifi](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/wifi.png)

- Batería

![bateria](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/bateria.jpg)




### Funcionamiento de la placa:

![waspmote](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/waspmoteinout.png)

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




### Ampliación: ¿Cómo podría enviarse la hora de la última detección de presencia a otra placa Waspmote utilizando WIFI Pro Onchip?

#### Inicialización fecha y hora

En primer lugar, es necesario introducir la fecha y hora en la placa. En función de los componentes que se disponen no es posible leer los datos a partir del sistema al que esta se encuentra conectada, para que la placa realizase dicha operación de forma autónoma los datos de día y hora se deberían leer a partir de una tarjeta con conexión GPRS o 3G.
A continuación, se describe el código que realiza dicha operación de almacenamiento de los datos de hora y fecha.
Se requiere por pantalla que es necesario almacenar los datos correspondientes.
 
![code8](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code8.png)

A partir de este punto se requiere que se introduzcan por pantalla los datos actuales correspondientes a: año, mes, día, horas, minutos y segundos. Estas acciones están apoyadas por la función GetData() que se mostrará posteriormente.

-	Introducción del año:
 
![code9](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code9.png)

-	Introducción del mes:
 
![code10](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code10.png)

-	Introducción del día:
 
![code11](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code11.png)

-	Introducción de la hora:
 
![code12](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code12.png)

-	Introducción de los minutos:
 
![code13](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code13.png)

-	Introducción de los segundos:
 
![code14](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code14.png)

Se crea un buffer en el cual se almacenan los datos que se han ido requiriendo por pantalla, para tenerlos disponibles cuando en los siguientes pasos sea necesario su uso.
 
![code15](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code15.png)

Finalmente, con la función RTC.setTime se actualiza la información de fecha y hora que utilizará la placa.

Con la función siguiente se verifica que los datos que se van introduciendo en los puntos anteriores son de dos enteros como máximo, cabe mencionar, que es necesario introducir los datos de forma correcta, ya que la siguiente función no diferencia entre datos válidos o no.
 
 
![code16](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code16.png)



#### Envío de aviso

Para la comunicación de la placa WASPMOTE, dada la imposibilidad de realizar la simulación de comunicación con otra placa, por la falta de material, se ha decidido realizar la comunicación mediante el Protocolo de Control de Transmisión con un teléfono móvil.
 El Protocolo de control de transmisión (en inglés Transmission Control Protocol o TCP), es uno de los protocolos fundamentales en Internet. Fue creado entre los años 1973 y 1974 por Vint Cerf y Robert Kahn.
Muchos programas dentro de una red de datos compuesta por redes de computadoras pueden usar TCP para crear “conexiones” entre sí a través de las cuales puede enviarse un flujo de datos. El protocolo garantiza que los datos serán entregados en su destino sin errores y en el mismo orden en que se transmitieron. También proporciona un mecanismo para distinguir distintas aplicaciones dentro de una misma máquina, a través del concepto de puerto.
TCP da soporte a muchas de las aplicaciones más populares de Internet (navegadores, intercambio de ficheros, clientes FTP, etc.) y protocolos de aplicación HTTP, SMTP, SSH y FTP.
 
- Funcionamiento del protocolo en detalle:

Las conexiones TCP se componen de tres etapas:
1. Establecimiento de conexión.
2. Transferencia de datos.
3. Fin de la conexión.
Para establecer la conexión se usa el procedimiento llamado “negociación en tres pasos” (3-way handshake). Para la desconexión se usa una “negociación en cuatro pasos” (4-way handshake). Durante el establecimiento de la conexión, se configuran algunos parámetros tales como el número de secuencia con el fin de asegurar la entrega ordenada de los datos y la robustez de la comunicación.

A partir de este punto se describe el código que realiza la operación anterior:
Inicialización de la función:   
 
![code17](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code17.png)

La tarjeta WIFI PRO onChip está conectada al SOCKET0, se inicializa este socket y se define el nombre de la red junto la contraseña.
Para definir el servidor, que estará conectado a la misma red se necesita definir el HOST y el PUERTO.
A continuación, se explican los pasos llevados a cabo para la comunicación de WASPMOTE con el servidor
 
Activación de la placa WIFI PRO ON CHIP:
 
![code18](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code18.png)

Se restablecen los valores predeterminados por defecto:
 
![code19](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code19.png)

WIFI PRO ON CHIP busca el nombre de la red proporcionado y verifica que coincide:
 
![code20](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code20.png)

Al igual que en el código anterior verifica que coincide la contraseña:
 
![code21](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code21.png)

Una vez que el módulo se ha establecido en la configuración correcta, se mantienen en la memoria no volátil del módulo. Además, es obligatorio reiniciar el módulo para obligar al módulo a usar la nueva configuración. Por lo que la función softReset () se usa para realizar un restablecimiento de software al módulo. Después de llamar a esta función, la nueva configuración tendrá efecto.
 
![code22](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code22.png)

Una vez que el módulo tiene una configuración válida en la memoria no volátil, automáticamente comienza a buscar unirse al punto de acceso. La función isConnected () permite saber si el módulo WiFi PRO ya está conectado al punto de acceso. Esta función devuelve valores verdaderos o falsos para proporcionar la información de estado.
 
![code23](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code23.png)

La función ping () envía un paquete de solicitud ICMP PING de dos bytes al host remoto definido como argumento de entrada. La entrada de la función puede ser un nombre lógico del host de destino o una dirección IP de host. Al recibir con éxito una respuesta ICMP PING del host, el tiempo de ida y vuelta en milisegundos se devuelve (RTT).
 
![code24](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code24.png)

La función setTCPclient () abre un socket de cliente de Protocolo de control de transmisión (TCP) e intenta conectarse al puerto especificado en el servidor definido como entrada. Por lo tanto, esta función necesita tres entradas diferentes:
- Host: el nombre del servidor puede ser cualquier nombre legal de servidor de Internet que pueda resolverse mediante el DNS del módulo (Dominio Configuración del Servidor de nombres). El nombre del servidor también se puede especificar como una dirección IP absoluta dada en punto decimal notación.
- Puerto remoto: se supone que el sistema del servidor está escuchando en el puerto especificado.
- Puerto local: este es el puerto local cuando se abre el socket TCP.
 
![code251](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code251.png)

![code252](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code252.png)

La función send () envía una secuencia de bytes al socket especificado por la entrada del manejador de socket. Esta función necesita dos entradas diferentes:
- Socket handle: Un manejador de socket TCP / UDP de un socket previamente abierto.
- Data: esta es la secuencia de datos para enviar al socket TCP / UDP. Este flujo de datos se puede definir como un simple mensaje de cadena o una matriz de bytes, especificando una tercera entrada para la longitud de la matriz de bytes a enviar.
 
![code26](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code26.png)

La función receive () recibe una secuencia de bytes del socket TCP / UDP especificado por el socket handle. Los datos recibidos sólo son válidos si ya se encuentran en el búfer de entrada del socket del módulo en el momento en que se emite este comando.

![code27](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code27.png)


La función closeSocket () permite al usuario cerrar un cliente TCP / UDP previamente abierto. La función necesita un parámetro de entrada para el identificador de socket:
Socket handle: el identificador de socket utilizado para abrir la conexión.
 
![code28](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/code28.png)
 
A continuación, se muestra cómo aparece en el receptor de la información a través del WiFi.
 
![mensaje](https://github.com/IIA2017/Proyecto2/blob/master/Imagenes/mensaje.png)





Instalaciones Industriales Avanzadas - Bloque II

Master en Ingeniería Industrial

Universidad de Almería

