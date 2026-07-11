CLASS zcl_04_itab_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.

    "Estructura para datos de empleado
   TYPES: BEGIN OF ty_employee,
            id            TYPE n LENGTH 8,
            first_name    TYPE c LENGTH 40,
            last_name     TYPE c LENGTH 40,
            email         TYPE c LENGTH 50,
            phone_number  TYPE c LENGTH 20,
            salary        TYPE p LENGTH 8 DECIMALS 2,
            currency_code TYPE c LENGTH 3,
          END OF ty_employee.

   "Tipo de tabla para usar con VALUE
   TYPES ty_t_employees TYPE STANDARD TABLE OF ty_employee
         WITH EMPTY KEY.
ENDCLASS.



CLASS zcl_04_itab_b26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*
*     " Definición de la estructura anidada
*   DATA: BEGIN OF ls_empl_info,
*           BEGIN OF info,
*             id         TYPE i VALUE 123456,
*             first_name TYPE string VALUE `Laura`,
*             last_name  TYPE string VALUE `Martínez`,
*           END OF info,
*           BEGIN OF address,
*             city    TYPE string VALUE `Frankfurt`,
*             street  TYPE string VALUE `123 Main street`,
*             country TYPE string VALUE `Germany`,
*           END OF address,
*           BEGIN OF position,
*             department TYPE string VALUE `IT`,
*             salary     TYPE p DECIMALS 2 VALUE `2000.25`,
*           END OF position,
*         END OF ls_empl_info.
*
*   " ============================================
*   " SOLUCIÓN: Escribir cada subestructura
*   " ============================================
*
*   out->write( |========================================| ).
*   out->write( |EMPLOYEE INFORMATION| ).
*   out->write( |========================================| ).
*   out->write( |  | ).
*   out->write( |PERSONAL INFO:| ).
*   out->write( ls_empl_info-info ).
*   out->write( |  | ).
*   out->write( |ADDRESS:| ).
*   out->write( ls_empl_info-address ).
*   out->write( |  | ).
*   out->write( |POSITION:| ).
*   out->write( ls_empl_info-position ).
*   out->write( |========================================| ).
*
*
*"Acceso
*  "nested structure
*   ls_empl_info = VALUE #(
*                           info     = VALUE #( id = 1234598 first_name = 'María' last_name = 'Nova'  )
*                           address  = VALUE #( city = 'Madrid' street = 'Gran Vía' country = 'Spain' )
*                           position = VALUE #( department = 'Finance' salary = '2500.23' )  ).
*
*
*   out->write( |========================================| ).
*   out->write( |EMPLOYEE INFORMATION| ).
*   out->write( |========================================| ).
*   out->write( |  | ).
*   out->write( |PERSONAL INFO:| ).
*   out->write( ls_empl_info-info ).
*   out->write( |  | ).
*   out->write( |ADDRESS:| ).
*   out->write( ls_empl_info-address ).
*   out->write( |  | ).
*   out->write( |POSITION:| ).
*   out->write( ls_empl_info-position ).


*   "DEEP STRUCTURE
*
* " 1) Tipo estructurado para la tabla interna anidada
* TYPES: BEGIN OF lty_flights,
*          flight_date  TYPE /dmo/flight-flight_date,
*          price        TYPE /dmo/flight-price,
*          currency_code TYPE /dmo/flight-currency_code,
*        END OF lty_flights.
*
* " 2) Estructura profunda (DEEP): un campo es una TABLA INTERNA
* DATA: BEGIN OF ls_flight,
*         carrier   TYPE /dmo/flight-carrier_id    VALUE 'AA',
*         connid    TYPE /dmo/flight-connection_id VALUE '0017',
*         lt_flights TYPE TABLE OF lty_flights WITH EMPTY KEY,
*       END OF ls_flight.
*
* " 3) Llenamos la tabla anidada desde la tabla liberada /dmo/flight
* SELECT flight_date,
*        price,
*        currency_code
*   FROM /dmo/flight
*   WHERE carrier_id = @ls_flight-carrier
*   INTO CORRESPONDING FIELDS OF TABLE @ls_flight-lt_flights
*   UP TO 4 ROWS.
*
*
* out->write( |Flight details for { ls_flight-carrier } - { ls_flight-connid }| ).
* out->write( |Total flights found: { lines( ls_flight-lt_flights ) }| ).
*
*
* IF ls_flight-lt_flights IS NOT INITIAL.
*   out->write( ls_flight-lt_flights ).
* ELSE.
*   out->write( |No flights found| ).
* ENDIF.


*" Ejemplo básico: STANDARD TABLE
*" Caso de uso: Generar un listado simple de todas las reservas
*
*    out->write( '=== STANDARD TABLE ===' ).
*    out->write( ' ' ).
*
*    "Declaramos una tabla STANDARD con clave vacía
*    "Es el tipo más básico y común
*    DATA lt_reservas TYPE TABLE OF /dmo/booking
*         WITH EMPTY KEY.
*
*    "Traemos datos de la base de datos
*    "INTO TABLE carga todos los registros en la tabla interna
*    SELECT * FROM /dmo/booking
*      INTO TABLE @lt_reservas.
*
*    out->write( 'Datos cargados en memoria' ).
*    out->write( ' ' ).
*
*    "Ahora recorremos TODOS los registros
*    "Este es el uso típico de STANDARD TABLE
*    LOOP AT lt_reservas INTO DATA(ls_reserva).
*
*      "Mostramos solo los primeros 5 para no saturar la pantalla
*      IF sy-tabix <= 5.
*        out->write( ls_reserva-booking_id ).
*        out->write( ls_reserva-customer_id ).
*        out->write( ls_reserva-flight_price ).
*        out->write( ' ' ).
*      ENDIF.
*    ENDLOOP.
*    out->write( 'Proceso completado' ).
*    out->write( ' ' ).
*    out->write( 'STANDARD TABLE es ideal cuando:' ).
*    out->write( '- Procesamos todos los registros de inicio a fin' ).
*    out->write( '- No necesitamos buscar registros específicos' ).
*    out->write( '- Queremos el código más simple posible' ).

*" Example básico: SORTED TABLE
*" Caso de uso: Mostrar clientes en orden alfabético
*
*    out->write( '=== SORTED TABLE - Lista Ordenada ===' ).
*    out->write( ' ' ).
*
*    "Declaramos una tabla SORTED ordenada por apellido
*    "NON-UNIQUE permite que varios clientes tengan el mismo apellido
*    DATA lt_clientes TYPE SORTED TABLE OF /dmo/customer WITH NON-UNIQUE KEY last_name.
*
*    "Traemos clientes de la base de datos
*    "La tabla se ordena AUTOMÁTICAMENTE por apellido
*    SELECT * FROM /dmo/customer
*      INTO TABLE @lt_clientes.
*
*    out->write( 'Clientes cargados y ordenados automáticamente' ).
*    out->write( ' ' ).
*    out->write( 'Lista en orden alfabético por apellido:' ).
*    out->write( ' ' ).
*
*    "Recorremos la tabla - ya está ordenada
*    LOOP AT lt_clientes INTO DATA(ls_cliente).
*
*      "Mostramos solo los primeros 8
*      IF sy-tabix <= 50.
*        out->write( | { ls_cliente-last_name },{ ls_cliente-first_name } |  ).
*        out->write( ' ' ).
*      ENDIF.
*
*    ENDLOOP.
*
*    out->write( ' ' ).
*    out->write( 'SORTED TABLE es ideal cuando:' ).
*    out->write( '- Necesitamos datos ordenados automáticamente' ).
*    out->write( '- Haremos búsquedas frecuentes más adelante' ).
*    out->write( '- Queremos mostrar información ordenada al usuario' ).


*" Ejemplo básico: HASHED TABLE
*" Caso de uso: Cargar datos maestros de clientes
*
*    out->write( '=== HASHED TABLE - Datos Maestros ===' ).
*    out->write( ' ' ).
*
*    "Declaramos una tabla HASHED con clave única
*    "UNIQUE KEY significa que no puede haber dos clientes con el mismo ID
*    DATA lt_clientes TYPE HASHED TABLE OF /dmo/customer
*         WITH UNIQUE KEY customer_id.
*
*    "Cargamos todos los clientes
*    "Internamente se crea una estructura hash para búsquedas rápidas
*    SELECT * FROM /dmo/customer
*      INTO TABLE @lt_clientes
*      UP TO 20 ROWS.
*
*    out->write( 'Clientes cargados en estructura hash' ).
*    out->write( ' ' ).
*
*    "IMPORTANTE: HASHED TABLE no tiene orden específico
*    "Los registros están organizados según el hash, no alfabéticamente
*    out->write( 'Algunos clientes en la tabla:' ).
*    out->write( ' ' ).
*
*    LOOP AT lt_clientes INTO DATA(ls_cliente).
*
*      out->write(  | { ls_cliente-customer_id  } - { ls_cliente-last_name }, { ls_cliente-first_name } | ).
*
*    ENDLOOP.
*
*    out->write( 'HASHED TABLE es ideal cuando:' ).
*    out->write( '- Tenemos datos con clave única (como IDs)' ).
*    out->write( '- Haremos MUCHAS búsquedas más adelante' ).
*    out->write( '- La velocidad de búsqueda es crítica' ).
*    out->write( '- No nos importa el orden de los registros' ).
*
*
*data(lt_clientes2) = value /dmo/customer( ).



* out->write( '═══════════════════════════════════════════════' ).
*   out->write( '   SISTEMA DE GESTIÓN DE EMPLEADOS' ).
*   out->write( '═══════════════════════════════════════════════' ).
*   out->write( | | ).
*
*   "═══════════════════════════════════════════════════════════
*   " ESCENARIO 1: CARGA INICIAL DEL MES
*   " Usar VALUE cuando tenemos varios registros predefinidos
*   "═══════════════════════════════════════════════════════════
*   out->write( '--- ESCENARIO 1: Carga inicial del mes ---' ).
*   out->write( 'RR.HH. tiene 3 empleados nuevos que empiezan hoy' ).
*   out->write( | | ).
*
*   "VALUE permite crear la tabla con todos los datos de una vez
*   "Cada par de paréntesis internos representa UN empleado
*
*   DATA(lt_empleados_mes) = VALUE ty_t_employees( "standard
*
*     ( id = '00000001'
*       first_name = 'Carlos'
*       last_name = 'García'
*       email = 'carlos.garcia@empresa.com'
*       phone_number = '+34 912345601'
*       salary = '2500.00'
*       currency_code = 'EUR' )
*     ( id = '00000002'
*       first_name = 'Ana'
*       last_name = 'Martínez'
*       email = 'ana.martinez@empresa.com'
*       phone_number = '+34 912345602'
*       salary = '2800.00'
*       currency_code = 'EUR' )
*     ( id = '00000003'
*       first_name = 'Luis'
*       last_name = 'Rodríguez'
*       email = 'luis.rodriguez@empresa.com'
*       phone_number = '+34 912345603'
*       salary = '2600.00'
*       currency_code = 'EUR' )
*   ).
*
*   out->write( 'Empleados cargados con VALUE:' ).
*   out->write( | | ).
*
*   "Mostramos los empleados cargados
*   LOOP AT lt_empleados_mes INTO DATA(ls_emp).
*     out->write( |{ ls_emp-id } - { ls_emp-first_name } { ls_emp-last_name }| ).
*   ENDLOOP.
*
*   out->write( | | ).
*   out->write( 'VALUE es ideal para carga inicial' ).
*   out->write( '  porque podemos definir todos los registros de una vez' ).
*   out->write( | |  ).
*   out->write( | |  ).
*
*
*  "═══════════════════════════════════════════════════════════
*   " ESCENARIO 2: LLEGA UN DIRECTOR QUE DEBE IR PRIMERO
*   " Usar INSERT cuando necesitamos posición específica
*   "═══════════════════════════════════════════════════════════
*
*   out->write( '--- ESCENARIO 2: Llega el nuevo director ---' ).
*   out->write( 'Debe aparecer en la primera posición de la lista' ).
*   out->write( | | ).
*
*   "Forma clásica: usando estructura intermedia
*   DATA ls_director TYPE ty_employee.
*
*   ls_director-id = '00000004'.
*   ls_director-first_name = 'María'.
*   ls_director-last_name = 'Fernández'.
*   ls_director-email = 'maria.fernandez@empresa.com'.
*   ls_director-phone_number = '+34 912345604'.
*   ls_director-salary = '4500.00'.
*   ls_director-currency_code = 'EUR'.
*
*   "INSERT permite especificar la posición INDEX 1 = primera posición
*   INSERT ls_director INTO lt_empleados_mes INDEX 1.
*
*   out->write( 'Director insertado en posición 1 con INSERT' ).
*   out->write( | |  ).
*   out->write( 'Lista actualizada:' ).
*   out->write( | |  ).
*
*   LOOP AT lt_empleados_mes INTO ls_emp.
*
*     IF sy-tabix = 1.
*       out->write( |-> { ls_emp-id } - { ls_emp-first_name } { ls_emp-last_name } (DIRECTOR)| ).
*     ELSE.
*       out->write( |  { ls_emp-id } - { ls_emp-first_name } {  ls_emp-last_name }| ).
*     ENDIF.
*
*   ENDLOOP.
*
*   out->write( | |  ).
*
*   out->write( 'INSERT es ideal para posiciones específicas' ).
*   out->write( '  porque podemos usar INDEX para indicar dónde' ).
*   out->write( | |  ).
*   out->write( | |  ).
*
*
*  "═══════════════════════════════════════════════════════════
*   " ESCENARIO 3: VAN LLEGANDO SOLICITUDES DURANTE EL DÍA
*   " Usar APPEND para ir agregando al final
*   "═══════════════════════════════════════════════════════════
*
*   out->write( '--- ESCENARIO 3: Solicitudes durante el día ---' ).
*   out->write( 'Cada solicitud se agrega al final de la cola' ).
*   out->write( | |  ).
*
*   "APPEND siempre agrega al FINAL de la tabla
*   "Es más rápido que INSERT cuando no importa la posición
*
*   "Primera solicitud del día - usando estructura
*
*   DATA ls_nuevo_empleado TYPE ty_employee.
*
*   ls_nuevo_empleado-id = '00000005'.
*   ls_nuevo_empleado-first_name = 'Pedro'.
*   ls_nuevo_empleado-last_name = 'Sánchez'.
*   ls_nuevo_empleado-email = 'pedro.sanchez@empresa.com'.
*   ls_nuevo_empleado-phone_number = '+34 912345605'.
*   ls_nuevo_empleado-salary = '2400.00'.
*   ls_nuevo_empleado-currency_code = 'EUR'.
*
*   APPEND ls_nuevo_empleado TO lt_empleados_mes.
*
*   out->write( 'Solicitud 1: Pedro agregado al final con APPEND' ).
*
*   "Segunda solicitud - usando VALUE # directamente
*   APPEND VALUE #(
*     id = '00000006'
*     first_name = 'Laura'
*     last_name = 'López'
*     email = 'laura.lopez@empresa.com'
*     phone_number = '+34 912345606'
*     salary = '2700.00'
*     currency_code = 'EUR'
*   ) TO lt_empleados_mes.
*
*   out->write( 'Solicitud 2: Laura agregada al final con APPEND' ).
*   out->write( | |  ).
*   out->write( 'Lista final completa:' ).
*   out->write( | |  ).
*
*   LOOP AT lt_empleados_mes INTO ls_emp.
*     out->write( |{ sy-tabix }. { ls_emp-id } - {
*                   ls_emp-first_name } { ls_emp-last_name } | &&
*                 |({ ls_emp-salary } { ls_emp-currency_code })| ).
*   ENDLOOP.
*
*   out->write( | | ).
*   out->write( 'APPEND es ideal para agregar al final' ).
*   out->write( '  porque es la forma más rápida de añadir registros' ).
*   out->write( | | ).
*   out->write( | | ).


"CORRESPONDING

   "=================================================================
   " DEMOSTRACIÓN 1: Copia Básica de Campos Coincidentes
   "=================================================================
   " Definimos un tipo local con solo los campos que necesitamos.
   " La tabla origen /dmo/flight tiene muchos más campos, pero solo
   " queremos trabajar con estos tres.

   TYPES: BEGIN OF lty_flights,
            carrier_id    TYPE /dmo/carrier_id,
            connection_id TYPE /dmo/connection_id,
            flight_date   TYPE /dmo/flight_date,
          END OF lty_flights.

   DATA: gt_my_flights TYPE STANDARD TABLE OF lty_flights,
         gs_my_flight  TYPE lty_flights.

   " Obtenemos todos los vuelos en EUR de la base de datos
   SELECT FROM /dmo/flight
     FIELDS *
     WHERE currency_code EQ 'EUR'
     INTO TABLE @DATA(gt_flights).

*   out->write( |=======================================================| ).
*   out->write( |  CASO 1: Copia básica con campos coincidentes        | ).
*   out->write( |=======================================================| ).
*   out->write( | | ).
*   out->write( |Tabla origen tiene { lines( gt_flights ) } registros con TODOS los campos| ).
*
*   " FORMA ANTIGUA: Usando MOVE-CORRESPONDING
*
*   MOVE-CORRESPONDING gt_flights TO gt_my_flights.
*
*   out->write( |FORMA ANTIGUA: MOVE-CORRESPONDING gt_flights TO gt_my_flights.| ).
*   out->write( |Resultado: { lines( gt_my_flights ) } registros copiados| ).
*   out->write( gt_my_flights ).
*   out->write( | | ).
*
*   " Limpiamos para demostrar la forma moderna
*   CLEAR gt_my_flights.
*
*   " FORMA MODERNA: Usando el operador CORRESPONDING
*   gt_my_flights = CORRESPONDING #( gt_flights ).
*
*   out->write( |FORMA MODERNA: gt_my_flights = CORRESPONDING #( gt_flights ).| ).
*   out->write( |Resultado: { lines( gt_my_flights ) } registros copiados| ).
*   out->write( gt_my_flights ).
*   out->write( |==> Ambas formas producen el MISMO resultado| ).
*   out->write( |\n\n| ).


 "=================================================================
   " DEMOSTRACIÓN 2: Agregar Registros Sin Borrar los Existentes
   "=================================================================
   " Ahora imaginen que gt_my_flights ya tiene datos y queremos
   " AGREGAR más registros sin perder los que ya teníamos.
   " Esto es muy común cuando acumulamos datos de diferentes fuentes.

*
*   out->write( |=======================================================| ).
*   out->write( |  CASO 2: Agregar datos conservando los existentes    | ).
*   out->write( |=======================================================| ).
*   out->write( | | ).
*
*
*   " Primero llenamos gt_my_flights con algunos vuelos en EUR
*   SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'EUR'
*     INTO TABLE @gt_flights
*     UP TO 3 ROWS.
*
*
*   gt_my_flights = CORRESPONDING #( gt_flights ).
*
*
*   out->write( |Comenzamos con { lines( gt_my_flights ) } vuelos en EUR| ).
*   out->write( gt_my_flights ).
*   out->write( | | ).
*
*
*   " Ahora obtenemos vuelos en USD y queremos AGREGARLOS
*   SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'USD'
*     INTO TABLE @gt_flights
*     UP TO 3 ROWS.
*
*
*   out->write( |Queremos agregar { lines( gt_flights ) } vuelos en USD| ).
*   out->write( | | ).
*
*
*   " FORMA ANTIGUA: MOVE-CORRESPONDING con KEEPING TARGET LINES
*   MOVE-CORRESPONDING gt_flights TO gt_my_flights KEEPING TARGET LINES.
*   out->write( |FORMA ANTIGUA: MOVE-CORRESPONDING gt_flights TO gt_my_flights KEEPING TARGET LINES.| ).
*
*
*   out->write( |Resultado: Ahora tenemos { lines( gt_my_flights ) } vuelos totales| ).
*   out->write( |Los primeros 3 EUR se conservaron + 3 USD se agregaron| ).
*   out->write( gt_my_flights ).
*   out->write( | | ).
*
*
*   " Reiniciamos para demostrar la forma moderna
*   CLEAR gt_my_flights.
*"-------------------------------------
*
*   SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'EUR'
*     INTO TABLE @DATA(gt_flights_eur)
*     UP TO 3 ROWS.
*
*
*   gt_my_flights = CORRESPONDING #( gt_flights_eur ).
*
*
*   " FORMA MODERNA: CORRESPONDING con BASE
*   gt_my_flights = CORRESPONDING #( BASE ( gt_my_flights ) gt_flights ).
*   out->write( |FORMA MODERNA: gt_my_flights = CORRESPONDING #( BASE ( gt_my_flights ) gt_flights ).| ).
*
*
*   out->write( |Resultado: Ahora tenemos { lines( gt_my_flights ) } vuelos totales| ).
*   out->write( |Los primeros 3 EUR se conservaron + 3 USD se agregaron| ).
*   out->write( gt_my_flights ).
*   out->write( |==> Ambas formas producen el MISMO resultado| ).
*   out->write( |\n\n| ).
*
*
*
* out->write( |=======================================================| ).
*   out->write( |  CASO 3: Mapeo de campos con nombres diferentes      | ).
*   out->write( |=======================================================| ).
*   out->write( | | ).
*
*   " Definimos un tipo donde los campos se llaman diferente
*   TYPES: BEGIN OF lty_flights_renamed,
*            carrier    TYPE /dmo/carrier_id,      "En origen: carrier_id
*            connection TYPE /dmo/connection_id,   "En origen: connection_id
*            date       TYPE /dmo/flight_date,     "En origen: flight_date
*          END OF lty_flights_renamed.
*
*   DATA gt_flights_renamed TYPE STANDARD TABLE OF lty_flights_renamed.
*
*   " Obtenemos datos origen
*   SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'EUR'
*     INTO TABLE @gt_flights
*     UP TO 5 ROWS.
*
*   out->write( |Tabla origen tiene campos: carrier_id, connection_id, flight_date| ).
*   out->write( |Tabla destino tiene campos: carrier, connection, date| ).
*   out->write( |Los nombres NO coinciden, pero la información es la misma.| ).
*   out->write( | | ).
*
*   " Con CORRESPONDING necesitamos usar MAPPING para indicar
*   " qué campo origen corresponde a qué campo destino
*
*
*   gt_flights_renamed = CORRESPONDING #( gt_flights MAPPING carrier    = carrier_id
*                                                            connection = connection_id
*                                                            date       = flight_date ).
*   out->write( |Usamos MAPPING para relacionar los campos:| ).
*   out->write( |  carrier    = carrier_id| ).
*   out->write( |  connection = connection_id| ).
*   out->write( |  date       = flight_date| ).
*   out->write( | | ).
*   out->write( |Resultado con campos mapeados:| ).
*   out->write( gt_flights_renamed ).
*   out->write( | | ).



*"READ TABLE
*
*
*   " Obtenemos datos de aeropuertos para trabajar
*   SELECT FROM /dmo/airport
*     FIELDS *
*     WHERE country EQ 'DE'
*     INTO TABLE @DATA(lt_airports).
*
*
*   IF sy-subrc EQ 0.
*     "============================================================
*     " CASO 1: Lectura por ÍNDICE (posición)
*     "============================================================
*     out->write( |CASO 1: Acceso por ÍNDICE (muy rápido siempre)| ).
*     out->write( |-------------------------------------------| ).
*
*
*     " Forma tradicional: READ TABLE con INDEX
*     READ TABLE lt_airports INTO DATA(ls_airport1) INDEX 1.
*     out->write( |Forma antigua: READ TABLE ... INDEX 1| ).
*     out->write( ls_airport1 ).
*
*
*     " Forma moderna: Expresión de tabla con corchetes
*     DATA(ls_airport2) = lt_airports[ 2 ].
*     out->write( |Forma moderna: lt_airports[ 2 ]| ).
*     out->write( ls_airport2 ).
*
*
*     " Si el índice puede no existir, usar OPTIONAL
*     DATA(ls_safe) = VALUE #( lt_airports[ 999 ] OPTIONAL ).
*     out->write( |Con OPTIONAL no falla si no existe el índice| ).
*     out->write( |\n| ).
*
*
*    "============================================================
*     " CASO 2: Lectura por CLAVE (campo específico)
*     "============================================================
*     out->write( |CASO 2: Acceso por CAMPO (lento si hay muchos registros)| ).
*     out->write( |-------------------------------------------| ).
*
*
*     " Forma tradicional: WITH KEY
*     READ TABLE lt_airports INTO DATA(ls_berlin)
*       WITH KEY city = 'Berlin'.
*
*
*     out->write( |Forma antigua: WITH KEY city = 'Berlin'| ).
*     out->write( ls_berlin ).
*
*
*     " Forma moderna: campo = valor entre corchetes
*     DATA(ls_munich) = lt_airports[ city = 'Munich' ].
*     out->write( |Forma moderna: lt_airports[ city = 'Munich' ]| ).
*     out->write( ls_munich ).
*
*
*     IF line_exists( lt_airports[ city  = 'Munich' ] ).
*       out->write( 'The flight exists in the database' ).
*     ELSE. "
*       out->write( 'The flight doesn´t exists in the database' ).
*     ENDIF.
*
*
*     DATA(lv_index) = line_index( lt_airports[ city  = 'Munich' ]  ).
*     out->write( lv_index ).
*
*
*
*
*     " Acceso directo a un componente específico
*     DATA(lv_name) = lt_airports[ city = 'Hamburg' ]-name.
*     out->write( |Acceso a componente: ...[ city = 'Hamburg' ]-name| ).
*     out->write( |Resultado: { lv_name }| ).
*     out->write( |\n| ).
*
*
*   "============================================================
*     " CASO 3: Lectura OPTIMIZADA con tabla SORTED
*     "============================================================
*     out->write( |CASO 3: Acceso OPTIMIZADO con tabla SORTED| ).
*     out->write( |-------------------------------------------| ).
*
*
*     " Declaramos tabla con clave para búsquedas rápidas
*     DATA gt_sorted TYPE SORTED TABLE OF /dmo/airport
*       WITH NON-UNIQUE KEY airport_id
*       WITH UNIQUE SORTED KEY key_name COMPONENTS name.
*
*
*     SELECT FROM /dmo/airport
*       FIELDS *
*       INTO TABLE @gt_sorted.
*
*
*     " IMPORTANTE: Especificar KEY primary_key para usar optimización
*
*
*     DATA(ls_fast) = gt_sorted[ KEY primary_key airport_id = 'FRA'  ].
*
*     "Claves secundarias
*     "DATA(ls_fast2) =  gt_sorted[ KEY key_name name = 'Frankfurt' ].
*
*
*     out->write( |Con KEY primary_key: Búsqueda MUY rápida| ).
*     out->write( ls_fast ).
*
*
*     " Sin KEY funciona pero es menos eficiente
*
*
*     DATA(ls_slow) = gt_sorted[ airport_id = 'MUC' ].
*
*
*     out->write( |Sin KEY: Funciona pero más lento en tablas grandes| ).
*     out->write( ls_slow ).
*     out->write( |\n| ).

*ENDIF.


*  " Estructuras para productos
*   TYPES: BEGIN OF ty_producto,
*            id       TYPE i,
*            nombre   TYPE string,
*            precio   TYPE p LENGTH 10 DECIMALS 2,
*            categoria TYPE string,
*          END OF ty_producto.
*
*   TYPES: BEGIN OF ty_producto_con_descuento,
*            id              TYPE i,
*            nombre          TYPE string,
*            precio_original TYPE p LENGTH 10 DECIMALS 2,
*            descuento       TYPE i,
*            precio_final    TYPE p LENGTH 10 DECIMALS 2,
*          END OF ty_producto_con_descuento.
*
*   DATA lt_productos TYPE TABLE OF ty_producto.
*   DATA lt_productos_descuento TYPE TABLE OF ty_producto_con_descuento.
*
*   "=================================================================
*   " CASO 1: Generar catálogo de productos con FOR UNTIL
*   "=================================================================
*
*   out->write( |CASO 1: Generar productos automáticamente| ).
*   out->write( |======================================| ).
*
*   " SIN FOR (forma tradicional - muchas líneas):
*   " DO 10 TIMES.
*   "   APPEND VALUE #( id = sy-index
*   "                   nombre = |Producto { sy-index }|
*   "                   precio = 100 + ( sy-index * 20 )
*   "                   categoria = ... ) TO lt_productos.
*   " ENDDO.
*
*   " CON FOR (forma moderna - una sola expresión):
*
*   lt_productos = VALUE #(
*     FOR i = 1 UNTIL i > 10
*     ( id        = i
*       nombre    = |Producto { i }|
*       precio    = 100 + ( i * 20 )
*       categoria = COND #( WHEN i <= 5 THEN 'Basico' ELSE 'Premium' ) )
*     ).
*
*   out->write( |Generados { lines( lt_productos ) } productos| ).
*   out->write( lt_productos ).
*   out->write( |\n| ).
*
*   "=================================================================
*
*  " CASO 2: Aplicar descuento a todos con FOR...IN
*   "=================================================================
*   out->write( |CASO 2: Aplicar descuentos según precio| ).
*   out->write( |==================================| ).
*
*   " SIN FOR (forma tradicional):
*   " LOOP AT lt_productos INTO DATA(ls_prod).
*   "   DATA(ls_con_desc) = VALUE ty_producto_con_descuento( ... ).
*   "   IF ls_prod-precio >= 200.
*   "     ls_con_desc-descuento = 20.
*   "   ELSE...
*   "   ls_con_desc-precio_final = ls_prod-precio * ...
*   "   APPEND ls_con_desc TO lt_productos_descuento.
*   " ENDLOOP.
*
*   " CON FOR (forma moderna con COND):
*
*   lt_productos_descuento = VALUE #(
*
*     FOR ls_prod IN lt_productos
*     LET descuento_aplicado = COND i( WHEN ls_prod-precio >= 200 THEN 20 "Transformación a entero para guardarlo en la variable
*                                      WHEN ls_prod-precio >= 150 THEN 15
*                                       ELSE 10 )
*     IN
*     ( id              = ls_prod-id
*       nombre          = ls_prod-nombre
*       precio_original = ls_prod-precio
*       descuento       = descuento_aplicado
*       precio_final    = ls_prod-precio * ( 100 - descuento_aplicado ) / 100 )
*   ).
*
*   out->write( |Todos los productos con descuento aplicado:| ).
*
*   LOOP AT lt_productos_descuento INTO DATA(ls_desc).
*     out->write( |{ ls_desc-nombre }: { ls_desc-precio_original } EUR -> { ls_desc-precio_final } EUR ({ ls_desc-descuento }% desc)| ).
*   ENDLOOP.
*
*   out->write( |\n| ).
*
*
*  "=================================================================
*   " CASO 3: Filtrar solo productos Premium con FOR...IN WHERE
*   "=================================================================
*
*   out->write( |CASO 3: Reporte solo de productos Premium| ).
*   out->write( |====================================| ).
*
*   " SIN FOR (forma tradicional):
*   " DATA lt_premium TYPE TABLE OF ty_producto.
*   " LOOP AT lt_productos INTO DATA(ls_producto).
*   "   IF ls_producto-categoria = 'Premium'.
*   "     APPEND ls_producto TO lt_premium.
*   "   ENDIF.
*   " ENDLOOP.
*   " CON FOR WHERE (filtrar y copiar):
*
*   DATA lt_solo_premium TYPE TABLE OF ty_producto.
*
*   lt_solo_premium = VALUE #( FOR ls_prod IN lt_productos WHERE ( categoria = 'Premium'  )
*                                ( ls_prod ) ).
*
*   out->write( |Productos Premium: { lines( lt_solo_premium ) } de { lines( lt_productos ) }| ).
*   out->write( lt_solo_premium ).
*   out->write( |\n| ).


"Ordenar registros - en qué tipos de tablas?
   " Obtenemos vuelos desde la CDS View estándar

*   SELECT FROM /DMO/I_Flight
*     FIELDS AirlineID,
*            ConnectionID,
*            FlightDate,
*            Price,
*            CurrencyCode
*     WHERE CurrencyCode = 'EUR'
*     INTO TABLE @DATA(lt_vuelos)
*     UP TO 10 ROWS.
*
*   out->write( |Datos originales sin ordenar:| ).
*   out->write( lt_vuelos ).
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 1: SORT por clave primaria (ascendente por defecto)
*   "=================================================================
*
*   out->write( |CASO 1: Ordenar por clave primaria| ).
*   out->write( |================================| ).
*
*   " Como lt_vuelos se declaró inline con DATA(...), tiene clave vacía.
*   " SORT ordenará por TODOS los campos en orden de aparición.
*
*   SORT lt_vuelos.
*
*   out->write( |Después de SORT (clave primaria ascendente):| ).
*   out->write( lt_vuelos ).
*   out->write( |\n| ).
*
*
*   "=================================================================
*   " CASO 2: SORT DESCENDING (orden inverso)
*   "=================================================================
*
*   out->write( |CASO 2: Ordenar descendente| ).
*   out->write( |=======================| ).
*
*   SORT lt_vuelos DESCENDING.
*
*   out->write( |Después de SORT DESCENDING:| ).
*   out->write( lt_vuelos ).
*   out->write( |\n| ).
*
*
*   "=================================================================
*   " CASO 3: SORT BY campo específico
*   "=================================================================
*
*   out->write( |CASO 3: Ordenar por campo específico (FlightDate)| ).
*   out->write( |=============================================| ).
*
*   " Ordenar solo por fecha de vuelo (ascendente)
*   SORT lt_vuelos BY FlightDate.
*
*   out->write( |Ordenado por FlightDate ascendente:| ).
*
*   LOOP AT lt_vuelos INTO DATA(ls_vuelo).
*     out->write( |{ ls_vuelo-AirlineID }{ ls_vuelo-ConnectionID } - { ls_vuelo-FlightDate } - { ls_vuelo-Price } { ls_vuelo-CurrencyCode }| ).
*   ENDLOOP.
*
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 4: SORT BY campo descendente
*   "=================================================================
*   out->write( |CASO 4: Ordenar por precio (más caro primero)| ).
*   out->write( |=========================================| ).
*
*   " Ordenar por precio de mayor a menor
*   SORT lt_vuelos BY Price DESCENDING.
*
*   out->write( |Ordenado por Price descendente:| ).
*
*   LOOP AT lt_vuelos INTO ls_vuelo.
*     out->write( |{ ls_vuelo-AirlineID }{ ls_vuelo-ConnectionID } - Precio: { ls_vuelo-Price } { ls_vuelo-CurrencyCode }| ).
*   ENDLOOP.
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 5: SORT múltiples campos con diferentes direcciones
*   "=================================================================
*
*   out->write( |CASO 5: Ordenar por varios campos| ).
*   out->write( |=============================| ).
*
*   " Primero por aerolínea (ascendente), luego por precio (descendente)
*   SORT lt_vuelos BY AirlineID ASCENDING
*                     Price DESCENDING.
*
*   out->write( |Ordenado por CarrierID (asc) y luego Price (desc):| ).
*
*   LOOP AT lt_vuelos INTO ls_vuelo.
*     out->write( |{ ls_vuelo-AirlineID } - { ls_vuelo-ConnectionID } - { ls_vuelo-Price } EUR| ).
*   ENDLOOP.
*   out->write( |\n| ).


*"MODIFY
*   " Estructura simple
*   TYPES: BEGIN OF ty_vuelo,
*            id     TYPE i,
*            precio TYPE i,
*            estado TYPE string,
*          END OF ty_vuelo.
*   DATA lt_vuelos TYPE TABLE OF ty_vuelo.
*
*   " Crear algunos vuelos
*   lt_vuelos = VALUE #(
*     ( id = 1 precio = 200 estado = 'Disponible' )
*     ( id = 2 precio = 300 estado = 'Disponible' )
*     ( id = 3 precio = 250 estado = 'Disponible' )
*   ).
*
*   out->write( |Datos originales:| ).
*   out->write( lt_vuelos ).
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 1: MODIFY por índice (posición específica)
*   "=================================================================
*
*   out->write( |CASO 1: Modificar el segundo vuelo por índice| ).
*
*   " Crear nueva estructura con los cambios
*   DATA(ls_cambio) = VALUE ty_vuelo( id = 2 precio = 350 estado = 'Promoción' ).
*
*   " Modificar la posición 2
*   MODIFY lt_vuelos FROM ls_cambio INDEX 2.
*   out->write( lt_vuelos ).
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 2: MODIFY en LOOP con FIELD-SYMBOL (más común y eficiente)
*   "=================================================================
*   out->write( |CASO 2: Aplicar descuento 10% a todos| ).
*   " Modificar directamente cada registro en el LOOP
*
*   LOOP AT lt_vuelos ASSIGNING FIELD-SYMBOL(<fs_vuelo>).
*     <fs_vuelo>-precio = <fs_vuelo>-precio * 90 / 100.  " 10% descuento
*     <fs_vuelo>-estado = 'Rebajado'.
*   ENDLOOP.
*
*   out->write( lt_vuelos ).
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 3: MODIFY condicional (solo algunos registros)
*   "=================================================================
*
*   out->write( |CASO 3: Cambiar estado solo si precio < 300| ).
*
*   LOOP AT lt_vuelos ASSIGNING FIELD-SYMBOL(<fs_v>).
*     IF <fs_v>-precio < 300.
*       <fs_v>-estado = 'Oferta Especial'.
*     ENDIF.
*   ENDLOOP.
*
*   out->write( lt_vuelos ).
*   out->write( |\n| ).
**

*"Eliminar registros
*   " Obtener clientes
*
*   SELECT FROM /DMO/I_Customer
*     FIELDS CustomerID, FirstName, LastName, CountryCode
*     INTO TABLE @DATA(lt_clientes)
*     UP TO 15 ROWS.
*
*   out->write( |Clientes iniciales: { lines( lt_clientes ) }| ).
*   out->write( lt_clientes ).
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 1: DELETE INDEX (eliminar por posición)
*   "=================================================================
*   out->write( |CASO 1: Eliminar el segundo cliente (posición 2)| ).
*
*   DELETE lt_clientes INDEX 2.
*
*   out->write( |Después de DELETE INDEX 2: { lines( lt_clientes ) } clientes| ).
*   out->write( lt_clientes ).
*   out->write( |\n| ).
*
*
*   "=================================================================
*   " CASO 2: DELETE WHERE (eliminar por condición)
*   "=================================================================
*   out->write( |CASO 2: Eliminar clientes de Alemania| ).
*
*   DELETE lt_clientes WHERE CountryCode = 'DE'.
*
*   out->write( |Después de DELETE WHERE: { lines( lt_clientes ) } clientes| ).
*   out->write( lt_clientes ).
*   out->write( |\n| ).
*
*
* "=================================================================
*   " CASO 3: DELETE ADJACENT DUPLICATES (eliminar duplicados)
*   "=================================================================
*   out->write( |CASO 3: Eliminar duplicados por país| ).
*
*   " IMPORTANTE: Primero SORT, luego DELETE ADJACENT
*   SORT lt_clientes BY CountryCode.
*
*   DELETE ADJACENT DUPLICATES FROM lt_clientes COMPARING CountryCode.
*
*   out->write( |Solo un cliente por país: { lines( lt_clientes ) }| ).
*   out->write( lt_clientes ).
*   out->write( |\n| ).
*
*
*  "=================================================================
*   " CASO 4: CLEAR vs FREE vs VALUE #()
*   "=================================================================
*   out->write( |CASO 4: Tres formas de vaciar una tabla| ).
*
*   DATA lt_temp TYPE TABLE OF /dmo/i_customer.
*
*   SELECT FROM /DMO/I_Customer
*     FIELDS *
*     INTO CORRESPONDING FIELDS OF TABLE @lt_temp
*     UP TO 50 ROWS.
*
*   out->write( |Tabla con { lines( lt_temp ) } registros| ).
*   " Opción 1: CLEAR (mantiene memoria)
*
*   CLEAR lt_temp.
*
*   out->write( |Después de CLEAR: { lines( lt_temp ) } - memoria reservada| ).
*
*   " Rellenar otra vez
*   SELECT FROM /DMO/I_Customer
*     FIELDS *
*     INTO CORRESPONDING FIELDS OF TABLE @lt_temp
*     UP TO 50 ROWS.
*
*   " Opción 2: FREE (libera memoria)
*   FREE lt_temp.
*
*   out->write( |Después de FREE: { lines( lt_temp ) } - memoria liberada| ).
*
*   " Rellenar otra vez
*   SELECT FROM /DMO/I_Customer
*     FIELDS *
*     INTO CORRESPONDING FIELDS OF TABLE @lt_temp
*     UP TO 50 ROWS.
*
*   " Opción 3: VALUE #() (forma moderna, igual que CLEAR)
*
*   lt_temp = VALUE #( ).
*   out->write( |Después de VALUE #(): { lines( lt_temp ) } - forma moderna| ).
*   out->write( |\n| ).



*  " Estructura COMPLETA para uso interno
*   TYPES: BEGIN OF ty_empleado_completo,
*            id           TYPE i,
*            nombre       TYPE string,
*            salario      TYPE p LENGTH 10 DECIMALS 2,
*            departamento TYPE string,
*            telefono     TYPE string,
*          END OF ty_empleado_completo.
*
*   " Estructura REDUCIDA para uso público (sin salario ni teléfono)
*   TYPES: BEGIN OF ty_empleado_publico,
*            id           TYPE i,
*            nombre       TYPE string,
*            departamento TYPE string,
*          END OF ty_empleado_publico.
*
*   DATA lt_empleados_completo TYPE TABLE OF ty_empleado_completo.
*
*   DATA lt_empleados_publico TYPE TABLE OF ty_empleado_publico.
*
*   "=================================================================
*   " CASO 1: Sin EXCEPT - Copia automática por nombres coincidentes
*   "=================================================================
*
*   out->write( |CASO 1: CORRESPONDING simple (sin EXCEPT)| ).
*   out->write( |======================================| ).
*
*   " Datos completos
*   lt_empleados_completo = VALUE #(
*     ( id = 1 nombre = 'Ana García' salario = 45000 departamento = 'IT' telefono = '600111222' )
*     ( id = 2 nombre = 'Carlos López' salario = 38000 departamento = 'Ventas' telefono = '600333444' )
*     ( id = 3 nombre = 'María Ruiz' salario = 52000 departamento = 'IT' telefono = '600555666' )
*   ).
*   out->write( |Datos internos (completos):| ).
*   out->write( lt_empleados_completo ).
*
*   " CORRESPONDING copia SOLO los campos que coinciden en nombre
*   " Como ty_empleado_publico NO tiene salario ni telefono,
*   " esos campos NO se copian automáticamente
*
*   lt_empleados_publico = CORRESPONDING #( lt_empleados_completo ).
*
*   out->write( |Datos públicos (sin salario ni teléfono):| ).
*   out->write( lt_empleados_publico ).
*   out->write( |\n| ).
*
*   "=================================================================
*   " CASO 2: EXCEPT - Excluir campos que SÍ existen en destino
*   "=================================================================
*   out->write( |CASO 2: EXCEPT - Excluir campo específico| ).
*   out->write( |====================================| ).
*
*   " Para demostrar EXCEPT, necesitamos estructuras donde
*   " AMBAS tengan los mismos campos
*
*   TYPES: BEGIN OF ty_empleado_con_telefono,
*            id           TYPE i,
*            nombre       TYPE string,
*            departamento TYPE string,
*            telefono     TYPE string,
*          END OF ty_empleado_con_telefono.
*
*   DATA lt_empleados_destino TYPE TABLE OF ty_empleado_con_telefono.
*
*   " Ahora SÍ podemos usar EXCEPT porque 'telefono' existe en ambas estructuras
*   " pero queremos excluirlo de la copia
*
*   lt_empleados_destino = CORRESPONDING #( lt_empleados_completo EXCEPT telefono ).
*
*   out->write( |Copiado TODO excepto teléfono:| ).
*   out->write( lt_empleados_destino ).
*   out->write( |Observa: teléfono está vacío aunque existía en origen| ).
*   out->write( |\n| ).
*
*
*   "=================================================================
*   " CASO 3: DISCARDING DUPLICATES
*   "=================================================================
*   out->write( |CASO 3: DISCARDING DUPLICATES| ).
*   out->write( |==========================| ).
*
*   TYPES: BEGIN OF ty_venta,
*            producto TYPE string,
*            cantidad TYPE i,
*          END OF ty_venta.
*
*   " Tabla origen con duplicados (sin clave)
*   DATA lt_ventas_dia TYPE TABLE OF ty_venta WITH EMPTY KEY.
*
*   " Tabla destino con clave única (no permite duplicados)
*   DATA lt_ventas_consolidadas TYPE SORTED TABLE OF ty_venta
*     WITH UNIQUE KEY producto.
*
*   " Ventas del día con productos repetidos
*   lt_ventas_dia = VALUE #(
*     ( producto = 'Laptop' cantidad = 2 )
*     ( producto = 'Mouse' cantidad = 5 )
*     ( producto = 'Laptop' cantidad = 1 )    " Duplicado - se ignora
*     ( producto = 'Teclado' cantidad = 3 )
*     ( producto = 'Mouse' cantidad = 2 )     " Duplicado - se ignora
*   ).
*
*   out->write( |Ventas del día: { lines( lt_ventas_dia ) } registros| ).
*
*   out->write( lt_ventas_dia ).
*
*   " Sin DISCARDING DUPLICATES → DUMP (error en runtime)
*   " lt_ventas_consolidadas = CORRESPONDING #( lt_ventas_dia ). " ¡ESTO FALLA!
*   " Con DISCARDING DUPLICATES → Toma el primero, ignora duplicados
*
*   lt_ventas_consolidadas = CORRESPONDING #( lt_ventas_dia DISCARDING DUPLICATES ).
*
*   out->write( |Consolidadas: { lines( lt_ventas_consolidadas ) } productos únicos| ).
*   out->write( lt_ventas_consolidadas ).
*   out->write( |\n| ).


*    out->write( |Ejemplo de CONV - Conversiones de tipo| ).
*    out->write( |===================================| ).
*
*    " CASO: Cálculo de precio con IVA
*    DATA lv_precio TYPE p LENGTH 10 DECIMALS 2 VALUE '100.00'.
*    DATA lv_iva TYPE p LENGTH 5 DECIMALS 2 VALUE '0.21'.
*
*    " Sin CONV (necesitas variable auxiliar)
*    " DATA lv_mensaje TYPE string.
*    " DATA lv_total_aux TYPE p LENGTH 10 DECIMALS 2.
*    " lv_total_aux = lv_precio * ( 1 + lv_iva ).
*    " lv_mensaje = lv_total_aux.
*
*    " Con CONV (directo, sin variable auxiliar)
*    DATA(lv_mensaje) = |Precio final: { CONV string( lv_precio * ( 1 + lv_iva ) ) } EUR|.
*
*    out->write( lv_mensaje ).
*
*    " Otro ejemplo: convertir tabla SORTED a STANDARD
*    DATA lt_numeros_sorted TYPE SORTED TABLE OF i WITH NON-UNIQUE DEFAULT KEY.
*    lt_numeros_sorted = VALUE #( ( 3 ) ( 1 ) ( 4 ) ( 1 ) ( 5 ) ).
*
*    TYPES  tt_numeros_standard TYPE STANDARD TABLE OF i WITH EMPTY KEY.
*    DATA(lt_numeros_standard) = CONV tt_numeros_standard( lt_numeros_sorted ).
*
*    out->write( |Tabla convertida de SORTED a STANDARD| ).
*    out->write( lt_numeros_standard ).


*"FILTER
*    " ============================================
*    " PASO 1: Definir la estructura de producto
*    " ============================================
*    TYPES: BEGIN OF ty_producto,
*             codigo   TYPE string,
*             nombre   TYPE string,
*             precio   TYPE p LENGTH 10 DECIMALS 2,
*             stock    TYPE i,
*             en_oferta TYPE abap_bool,
*           END OF ty_producto.
*
*    " ============================================
*    " PASO 2: Declarar la tabla de inventario
*    " CLAVE: La clave debe incluir los campos que vas a filtrar
*    " ============================================
*    DATA lt_inventario TYPE SORTED TABLE OF ty_producto
*      WITH NON-UNIQUE KEY en_oferta stock.
*
*    " ============================================
*    " PASO 3: Llenar el inventario con datos
*    " ============================================
*    lt_inventario = VALUE #(
*      ( codigo = 'LAP001' nombre = 'Laptop HP'      precio = 800  stock = 3  en_oferta = abap_true )
*      ( codigo = 'MOU001' nombre = 'Mouse Logitech' precio = 25   stock = 50 en_oferta = abap_true )
*      ( codigo = 'TEC001' nombre = 'Teclado Mecánico' precio = 120 stock = 15 en_oferta = abap_true )
*      ( codigo = 'MON001' nombre = 'Monitor Samsung' precio = 300  stock = 8  en_oferta = abap_false )
*      ( codigo = 'WEB001' nombre = 'Webcam HD'      precio = 60   stock = 2  en_oferta = abap_true )
*      ( codigo = 'AUR001' nombre = 'Auriculares'    precio = 45   stock = 20 en_oferta = abap_false )
*      ( codigo = 'IMP001' nombre = 'Impresora'      precio = 200  stock = 12 en_oferta = abap_true )
*    ).
*
*    " ============================================
*    " Mostrar inventario completo
*    " ============================================
*    out->write( |========================================| ).
*    out->write( |  INVENTARIO COMPLETO DE LA TIENDA     | ).
*    out->write( |========================================| ).
*    out->write( |Total de productos: { lines( lt_inventario ) }| ).
*    out->write( |\n| ).
*
*    LOOP AT lt_inventario INTO DATA(ls_prod).
*      DATA(lv_oferta_texto) = COND string( WHEN ls_prod-en_oferta = abap_true
*                                           THEN 'EN OFERTA'
*                                           ELSE '' ).
*
*      out->write( |{ ls_prod-codigo } - { ls_prod-nombre WIDTH = 20 } | &&
*                  |Precio: { ls_prod-precio WIDTH = 6 } EUR | &&
*                  |Stock: { ls_prod-stock WIDTH = 3 } { lv_oferta_texto }| ).
*    ENDLOOP.
*
*    out->write( |\n| ).
*
*    " ===========================================
*    " PASO 4: APLICAR FILTER
*    " ============================================
*    out->write( |========================================| ).
*    out->write( |  FILTRADO: Ofertas con Stock > 5      | ).
*    out->write( |========================================| ).
*
*    " FILTER
*    DATA(lt_productos_para_promocion) = FILTER #( lt_inventario WHERE en_oferta = abap_true AND stock > 5 ).
*
*
*
*    " ============================================
*    " PASO 5: Mostrar resultados filtrados
*    " ============================================
*
*
*    out->write( |Productos encontrados: { lines( lt_productos_para_promocion ) }| ).
*    out->write( |\n| ).
*
*    IF lt_productos_para_promocion IS NOT INITIAL.
*      out->write( |Estos productos van a la campaña de email:| ).
*      LOOP AT lt_productos_para_promocion INTO DATA(ls_promo).
*        out->write( |{ ls_promo-nombre } - { ls_promo-precio } EUR (Stock: { ls_promo-stock })| ).
*      ENDLOOP.
*    ELSE.
*      out->write( |No hay productos que cumplan los criterios| ).
*    ENDIF.
*
*    " ============================================
*    " PASO 6: Calcular valor total de la promoción
*    " ============================================
*    out->write( |\n| ).
*
*    DATA(lv_valor_total) = REDUCE i( INIT sum = 0
*                                      FOR prod IN lt_productos_para_promocion
*                                      NEXT sum = sum + ( prod-precio * prod-stock ) ).
*
*    out->write( |Valor total del inventario promocional: { lv_valor_total } EUR| ).


    out->write( |Ejemplo de CAST - Conversión de clases| ).
    out->write( |==================================| ).

    " Caso simple con referencias a datos
    TYPES: BEGIN OF ty_producto,
             id TYPE i,
             nombre TYPE string,
             precio TYPE p LENGTH 10 DECIMALS 2,
           END OF ty_producto.

    " Referencia genérica
    DATA lr_data TYPE REF TO data.
    lr_data = NEW ty_producto( id = 1 nombre = 'Laptop' precio = 1000 ).

    " CAST para acceder como tipo específico
    DATA(ls_producto) = CAST ty_producto( lr_data )->*.

    out->write( |Producto mediante CAST:| ).
    out->write( |  ID: { ls_producto-id }| ).
    out->write( |  Nombre: { ls_producto-nombre }| ).
    out->write( |  Precio: { ls_producto-precio }| ).

    " Acceso directo a componentes con CAST
    DATA(lv_precio) = CAST ty_producto( lr_data )->precio.
    out->write( |Precio directo: { lv_precio }| ).

    out->write( |\n| ).
    out->write( |RESUMEN CAST:| ).
    out->write( |• Convierte referencias genéricas a específicas| ).
    out->write( |• Necesario para downcasting en herencia| ).
    out->write( |• Permite acceso directo a componentes| ).


  ENDMETHOD.

ENDCLASS.
