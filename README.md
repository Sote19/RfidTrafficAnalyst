# RFID Traffic Analyst <br> Desarrolladores: Xavi Conde, Gerard Soteras
Sistema IoT con RFID que mide el interés de visitantes en ferias comerciales mediante el análisis del flujo y tiempo de permanencia en los stands, todo en tiempo real.
<hr>

## 💡  Explicación de la idea del proyecto
<details>
  <summary>Explicación 🔽</summary>
  
  En este proyecto exploraremos el mundo de los dispositivos IoT y la tecnología de transmisión por radiofrecuencia. Abordaremos temas como las ondas de radio y los distintos tipos de frecuencias existentes, en un ámbito innovador y en continuo desarrollo como el de los dispositivos IoT. Para ello, hemos optado por trabajar con la tecnología RFID, que combina los aspectos técnicos que buscamos analizar y desarrollar en este proyecto.
  
  El sistema funcionará de la siguiente manera: a los participantes se les proporcionarán etiquetas RFID pasivas, que serán detectadas por antenas RFID estratégicamente colocadas en el recinto. Estas antenas, conectadas a un lector RFID integrado en una Raspberry Pi, ampliarán el alcance de la señal según el tamaño del espacio. Los datos recopilados en tiempo real serán almacenados en una base de datos para su posterior análisis, generando informes que permitirán interpretar las preferencias del público y optimizar futuras estrategias.
  
  El objetivo principal es diseñar un sistema IoT para recopilar información en ferias comerciales, proporcionando a las empresas datos valiosos sobre el interés que generan entre los asistentes. Este sistema permitirá realizar un conteo preciso de las personas que se aproximan a cada puesto, así como medir el tiempo que permanecen en ellos. Además, la información recopilada se utilizará para obtener una visión general de los intereses del público, ayudando a las empresas a comprender mejor las preferencias de la población.

</details>

## 🎯  Objetivo que se persigue
<details>
  <summary>Explicación 🔽</summary>
  
  *Con todo esto hemos realizado la siguiente estructura, donde resume los objetivos que buscaremos cumplir.*

- **1 (Objetivo General)** - Diseñar y desarrollar una red de dispositivos IoT que utilice tecnología de transmisión por radiofrecuencia para recopilar y analizar datos en tiempo real.
- - **1.1 (Objetivo Específico)** - Programar dispositivos IoT capaces de interactuar mediante tecnología de radiofrecuencia.  
- - - **1.1.1 (Objetivo Operativo)** - Implementar placas Raspberry Pi con antenas RFID compatibles para gestionar la detección y transmisión de datos.  
- - - **1.1.2 (Objetivo Operativo)** - Configurar y trabajar con etiquetas RFID pasivas para la identificación precisa de participantes.  

- **2 (Objetivo General)** - Aplicar el sistema IoT en ferias comerciales y eventos para generar datos valiosos sobre el comportamiento del público y mejorar estrategias empresariales.  
- - **2.1 (Objetivo Específico)** - Optimizar la autonomía y capacidad del sistema para recopilar y analizar datos en entornos dinámicos. 
- - - **2.1.1 (Objetivo Operativo)** - Recopilar datos en tiempo real sobre el número de asistentes, ubicación y tiempo de permanencia en cada puesto.  
- - **2.2 (Objetivo Específico)** - Asegurar la integridad, confidencialidad y disponibilidad de los datos recopilados por el sistema.
- - - **2.2.1 (Objetivo Operativo)** - Implementar reglas de acceso y control en la base de datos para garantizar la seguridad de la información.
- - - **2.2.2 (Objetivo Operativo)** - Usar protocolos cifrados para la transmisión de datos y mantener copias de seguridad automáticas para prevenir pérdida de información.  


</details>

## 📝  Organización y roles del equipo
<details>
  <summary>Organización 🔽</summary>
  Al ser un grupo que en el primer año del grado ya trabajamos juntos en varios proyectos, la organización resultó sencilla.
  Hemos decidido que todos haremos de todo, pero cada uno tendrá un rol de “líder” en cada apartado en el que hemos distribuido el proyecto, este líder será el encargado únicamente de marcar el ritmo y de comunicar al resto del grupo cómo vamos en relación con los objetivos y fechas acordados al inicio.
  Al final de cada clase se pondrá en común el trabajo de cada integrante, con el objetivo de que todas las personas en todo momento sepan que se ha hecho ese día y si algún día hay una baja, que se pueda seguir trabajando con normalidad.
  En el aspecto de las tareas, todos haremos todas las tareas, sin excepción.
</details>

<details>
  <summary>Roles 🔽</summary>  
  
  - Xavi - Programación, Proxmox, gestores de tareas y escritos (GitHub)
  - Gerard - BBDD, Hardware, Redes, escritos (GitHub)
</details>

> [!IMPORTANT]
> Los líderes informan del tiempo, no quiere decir que trabajen más en esas áreas que otro compañero.

## 💻  Tecnologías a utilizar (lenguajes, framework, sistemas, software...)
<details>
  <summary>Programación 🔽</summary>

   - JavaScript
   - Node.JS
   - Python
</details>

<details>
  <summary>Base de Datos 🔽</summary>
  
  - Google Firebase o MySQL
</details>

<details>
  <summary>Cifrado 🔽</summary>
  
  En nuestro proyecto hemos elegido estas opciones de cifrado:
  - FALTA DECIDIR
</details>

<details>
  <summary>Certificados 🔽</summary>
  
  - OpenSSL -> TLS (de manera interna). 
  - Cloudflare SSL (de manera externa).
</details>

<details>
  <summary>Software 🔽</summary>
  
  - Visual Studio
  - Trello
  - GitHub
</details>

<hr>

## 🔨  Arquitectura del sistema
<details>
  <summary>Explicación 🔽</summary>
  Implementaremos una arquitectura basada en *tres capas*, diseñada para optimizar la recopilación, almacenamiento y análisis de datos provenientes de los dispositivos IoT con tecnología RFID. Esta estructura modular permite trabajar en cada capa de forma independiente, lo que facilita el desarrollo, la escalabilidad y el mantenimiento del sistema.
  
  Las tres capas se dividirán:
  - Capa de Dispositivos IoT (Cliente): Esta capa incluye las etiquetas RFID pasivas y las antenas RFID conectadas al Arduino. Los dispositivos detectan y transmiten los datos recopilados.
  - Capa de Procesamiento (Servidor): Encargada de recibir los datos desde los Arduinos, procesarlos, almacenarlos temporalmente y transferirlos a la base de datos central. Aquí se manejan las conexiones seguras y la lógica para garantizar la fiabilidad de los datos.
  - Capa de Almacenamiento y Análisis (BBDD): Se utiliza para almacenar de forma permanente los datos recopilados y procesados, permitiendo análisis posteriores. La base de datos será securizada para proteger la integridad y confidencialidad de la información.
</details>

<details>
  <summary>Tabla de arquitectura de los sistemas 🔽</summary>
  
  | Máquina       | S.O                  | Almacenamiento / Memoria| Servicio     | 
  |---------------|----------------------|-------------------------|--------------|
  | **Proxmox**   |Proxmox-VE 8.2        | 93Gb / 8Gb              |  Hypervisor  |
  | **Router**    |Ubuntu server 22.04.2 | 14Gb / 4Gb              |  DHCP        |
  | **MySQL**     |Ubuntu server 22.04.2 | 14Gb / 4Gb              |Base de datos |
  | **Pi-Hole**   |Debian 12.7.0         | 14Gb / 512Mb            |      DNS     |
  | **Arduino**   |                      |                         | Lector RFID  |
  | **NGinx**     |Ubuntu server 22.04.2 | 14Gb / 4Gb              |    Hosting   |
</details>

<hr>

# Estilo de Marca
## 🛡️ Logotipo
<details>
  <summary>Explicación 🔽</summary>
  En este proyecto, hemos diseñado un logotipo que refleja los valores de innovación y dinamismo asociados a nuestra tecnología RFID. La forma principal está inspirada en una onda, un elemento que simboliza tanto la conectividad como el flujo constante de información, pilares fundamentales de nuestra actividad. La onda se presenta atravesando un objeto, lo que transmite una sensación de movimiento y energía, reforzando la idea de una tecnología que nunca se detiene y que conecta de manera fluida diferentes elementos.
  
  Los colores principales seleccionados para el logotipo son:
  - Azul (#136AD3): Representa la confianza, la estabilidad y el carácter tecnológico de nuestra marca. Es un color asociado tradicionalmente con la innovación y la precisión técnica.
  - Naranja (#F26419): Un tono vibrante que aporta energía, creatividad y entusiasmo, equilibrando la seriedad del azul con un toque más humano y cercano.
  
  Como color auxiliar, se utiliza el negro (#000000), que añade contraste, elegancia y versatilidad al diseño, permitiendo que el logotipo funcione eficazmente en una variedad de aplicaciones y contextos.
  
  Este logotipo no solo busca ser visualmente atractivo, sino también comunicar de manera clara y efectiva los valores que nuestra empresa representa. Es una imagen moderna, versátil y funcional, diseñada para destacar en un entorno competitivo.
</details>

<details>
  <summary>Paleta de color 🔽</summary>
  
![paleta de color](assets/paleta_rfid.png)
</details>
  
<details>
  <summary>Imagen del logotipo 🔽</summary>

![logotipo rfid](assets/rfid_logo.png)
</details>

<hr>

# 🚀 PROXMOX
Proxmox Virtual Environment (Proxmox VE) es un entorno de virtualización de servidores de código abierto. Es una distribución de GNU/Linux basada en Debian, con una versión modificada del Kernel Ubuntu LTS​ y permite desplegar y gestionar máquinas virtuales y contenedores LXC.

Para la creación de nuestro proyecto, vamos a usar Proxmox. Utilizaremos uno de los ordenadores disponibles en el aula para montar nuestro servidor PROXMOX, con el que trabajaremos para crear todos los servicios que necesitamos.

## 🟠  Entorno ProxMox
<details>
  <summary>Explicación 🔽</summary>
  Dentro de Proxmox, configuraremos una red NAT para que todas las máquinas virtuales que creemos tengan conexión entre ellas.
  Como elementos principales, tendremos tres Ubuntu Servers. Uno de ellos funcionará como router virtual y proporcionará DHCP El otro nos proporcionara el hosting usando Nginx y un tercero nos proporcionará un hosting de respaldo. 
  Estos tres servidores acompañados de una maquina virtual que trabajará como cliente y un contenedor LXC que nos proporcionará el servicio DNS utilizando Pi-Hole.
    
  Para crear la red NAT con la que se comunicarán las máquinas dentro de Proxmox, añadiremos un "Linux Bridge" y lo configuraremos para crear la red interna, a la que llamaremos vmbr1. Por defecto, la red externa (en nuestro caso la del aula) se llama vmbr0.
  
  El proceso que seguimos fue el siguiente: primero, instalamos y configuramos la máquina router. Al añadir la máquina, le asignamos la nueva interfaz de red que creamos anteriormente en el apartado de hardware. Una vez configurado el router, duplicamos la máquina para crear el equipo cliente, y modificamos el netplan para que tenga su propia dirección IP dentro de la red interna. En los anexos dejamos el primer borrador de la arquitectura de red que hicimos.
  
  ### Configuración de QEMU
  Instalaremos en la máquina cliente y en el router el paquete qemu-guest-agent. Gracias a esto, podremos administrar las máquinas virtuales de una manera más fácil.
  Una vez instalado en las máquinas, es necesario configurar las máquinas virtuales que nos ofrece Proxmox.
</details>

> 📎 [**Ver _anexo 1_ para entorno ProxMox**](#anexo-1-entorno-proxmox)

## 🕸️  Arquitectura de Red
<details>
  <summary>Explicación 🔽</summary>
  Para nuestro proyecto, hemos configurado una red virtual utilizando Proxmox, en la cual hemos desplegado todos los servicios esenciales para nuestro gestor de contraseñas. En la imagen se observa la división entre el 'Entorno Aula' y el 'Entorno Proxmox'.
  En el Entorno Aula (100.77.20.0/24), contamos con acceso a internet y dispositivos físicos que se comunican con el router, mientras que en el Entorno Proxmox (10.20.30.0/24), hemos creado una red privada donde residen los servidores y servicios internos, proporcionando un entorno controlado para nuestro sistema.
  
  Cada dispositivo en Proxmox cumple un rol específico:
  - Router: conecta ambas redes, actúa como gateway y distribuye direcciones IP mediante DHCP en la red de Proxmox.
  - Pi-hole (10.20.30.2): configurado como servidor DNS, filtra y redirige las solicitudes DNS dentro de la red interna.
  - Nginx (10.20.30.20): ofrece el servicio web (Nginx), primeramente accesible desde la red del aula mediante una regla en IPTables. 
  - Firebase: proporciona los servicios de base de datos y hosting necesarios para el funcionamiento del gestor de contraseñas.
  
  En la imagen, los dispositivos que ofrecen servicios se encuentran subrayados en verde, mientras que aquellos que consumen servicios están subrayados en rojo.
  También se ha indicado si las IPs son estáticas para facilitar la configuración y el acceso a cada servicio. De esta forma, el diseño asegura que cada dispositivo esté claramente identificado y cumpla su función en la red interna de Proxmox.
</details>

<details>
  <summary>Imagen de arquitectura de red final 🔽</summary>
  
  ![diagrama de red](assets/diagrama_red.PNG)
</details>

<details>
  <summary>Tabla de arquitectura de red final 🔽</summary>
  
  | Máquinas         | IP                                         | IP Gateway                          | Red                           |
  |------------------|--------------------------------------------|-------------------------------------|-------------------------------|
  | Proxmox          | 100.77.20.113                              | 100.77.20.1                         | 100.77.20.0/24                |
  | VM Ubuntu Router | 100.77.20.77 (externa)<br>10.20.30.1 (interna) | 100.77.20.1 (externa)<br>10.20.30.1 (interna) | vmbr0 (100.77.20.0/24)<br>vmbr1 (10.20.30.0/24) |
  | Nginx            | DHCP (fija por MAC a la IP 10.20.30.20)    | 10.20.30.1                          | vmbr1 (10.20.30.0/24)         | 
  | Pihole           | 10.20.30.5                                 | 10.20.30.1                          | vmbr1 (10.20.30.0/24)         |
  | FireBase         | 10.20.30.6                                 | 10.20.30.1                          | vmbr1 (10.20.30.0/24)         |
  | VM Ubuntu Cliente| DHCP                                       | 10.20.30.1                          | vmbr1 (10.20.30.0/24)         |

</details>

> [!IMPORTANT]
> Las funciones del cliente y Nginx se verán modificadas por la futura integración de Cloudflare en el proyecto. Más adelante veremos como afecta.

<hr>

# 📎 Anexos
En este apartado se encuentran los detalles más específicos de configuración del proyecto.

## Anexo 1
<details>
  <summary>Ver anexo 🔽</summary>
</details>

<hr>

# 🚩 Informe de errores
En este apartado se encuantran todas las dificultades y errores que han ido surgiendo a medida que progresava el proyecto.

## Errores con ...
<details>
  <summary>Ver informe 🔽</summary>
</details>
