CLASS zcl_05_fs_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_05_fs_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


 " Tabla de números
   DATA lt_numeros TYPE TABLE OF i WITH EMPTY KEY.

   lt_numeros = VALUE #( ( 10 ) ( 20 ) ( 30 ) ).

   out->write( |Tabla original: 10, 20, 30| ).
   out->write( |\n Multiplicar x2 CON Field Symbol:| ).


   " Declarar Field Symbol
   FIELD-SYMBOLS <fs_num> TYPE i.

   " Con ASSIGNING (SÍ funciona)
   LOOP AT lt_numeros ASSIGNING <fs_num>. "Con estructura tendría que cargar cambios con APPEND
     <fs_num> = <fs_num> * 2.
   ENDLOOP.

   out->write( |Resultado: { lt_numeros[ 1 ] }, { lt_numeros[ 2 ] }, { lt_numeros[ 3 ] }| ).
   out->write( | Sí cambió porque FS apunta al ORIGINAL| ).



*  " ============================================
*   " Leer vuelos de tabla demo
*   " ============================================
*   out->write( |========================================| ).
*   out->write( |  DESCUENTO 10% EN VUELOS              | ).
*   out->write( |========================================| ).
*   out->write( |\n| ).
*
*
*   SELECT FROM /dmo/flight
*          FIELDS carrier_id,
*                 connection_id,
*                 flight_date,
*                 price,
*                 currency_code
*          WHERE carrier_id = 'AA'
*          INTO TABLE @DATA(lt_flights)
*          UP TO 5 ROWS.
*
*
*   IF lt_flights IS INITIAL.
*     out->write( |No hay vuelos| ).
*     RETURN.
*   ENDIF.
*
*
*   out->write( |ANTES DEL DESCUENTO:| ).
*
*
*   LOOP AT lt_flights INTO DATA(ls_flight).
*     out->write( |{ ls_flight-carrier_id } { ls_flight-connection_id } - { ls_flight-price } { ls_flight-currency_code }| ).
*   ENDLOOP.
*
*
*   " ============================================
*   " Aplicar descuento con FS en línea
*   " ============================================
*   out->write( |\n| ).
*   out->write( |Aplicando 10% descuento...| ).
*   out->write( |\n| ).
*
*
*   " Declaración EN LÍNEA
*   LOOP AT lt_flights ASSIGNING FIELD-SYMBOL(<flight>).
*     DATA(lv_precio_anterior) = <flight>-price.
*     <flight>-price = <flight>-price * '0.90'.
*     out->write( |{ <flight>-carrier_id } { <flight>-connection_id }: { lv_precio_anterior } -> { <flight>-price }| ).
*   ENDLOOP.
*
*
*   out->write( |\n Descuento aplicado directamente| ).
*


*" ============================================
*   " Actualizar emails de clientes
*   " ============================================
*   out->write( |========================================| ).
*   out->write( |  ACTUALIZAR DOMINIO EMAIL             | ).
*   out->write( |========================================| ).
*   out->write( |\n| ).
*
*
*   SELECT FROM /dmo/customer
*          FIELDS customer_id,
*                 first_name,
*                 last_name,
*                 email_address
*          WHERE email_address LIKE '%@flight.example.de'
*          INTO TABLE @DATA(lt_customers)
*          UP TO 5 ROWS.
*
*
*   IF lt_customers IS INITIAL.
*     out->write( |No hay clientes con @flight.example| ).
*     RETURN.
*   ENDIF.
*
*
*   out->write( |Clientes encontrados: { lines( lt_customers ) }| ).
*   out->write( |\n| ).
*
*
*
*
*   "Actualizar con Field Symbol en línea
*   LOOP AT lt_customers ASSIGNING FIELD-SYMBOL(<customer>).
*     DATA(lv_email_viejo) = <customer>-email_address.
*     " Cambiar dominio
*     <customer>-email_address = replace(
*       val  = <customer>-email_address
*       sub  = 'flight.example.de'
*       with = 'empresa.com'
*
*
*     ).
*
*
*     out->write( |{ <customer>-first_name } { <customer>-last_name }:| ).
*     out->write( |  Antes: { lv_email_viejo }| ).
*     out->write( |  Ahora: { <customer>-email_address }| ).
*     out->write( |\n| ).
*ENDLOOP.


*"UNASSIGN
*   " ============================================
*   " UNASSIGN después de procesar
*   " ============================================
*   out->write( |========================================| ).
*   out->write( |  PROCESAR PRECIO Y LIBERAR FS         | ).
*   out->write( |========================================| ).
*   out->write( |\n| ).
*
*
*   DATA lv_precio TYPE p LENGTH 10 DECIMALS 2 VALUE '100.00'.
*   out->write( |Precio original: { lv_precio }| ).
*
*
*   " Asignar Field Symbol
*   ASSIGN lv_precio TO FIELD-SYMBOL(<precio>).
*   out->write( |FS asignado: { <precio> }| ).
*
*
*   " Aplicar IVA 21%
*   <precio> = <precio> * '1.21'.
*   out->write( |Con IVA (21%): { <precio> }| ).
*   out->write( |\n| ).
*
*
*   "Liberar Field Symbol
*  UNASSIGN <precio>.
*
*  DATA lv_precio2 TYPE p LENGTH 10 DECIMALS 2 VALUE '100.00'.
*  ASSIGN lv_precio2 TO <precio>.
*
*   out->write( |UNASSIGN ejecutado| ).
*   out->write( |   El FS ya no apunta al precio| ).
*   out->write( |\n| ).
*   out->write( |El dato original sigue: { lv_precio }| ).


*   " ============================================
*   " Agregar reserva al final
*   " ============================================
*   out->write( |========================================| ).
*   out->write( |  NUEVA RESERVA DE VUELO               | ).
*   out->write( |========================================| ).
*   out->write( |\n| ).
*
*
*   " Leer reservas existentes
*   SELECT FROM /dmo/booking
*          FIELDS booking_id,
*                 customer_id,
*                 carrier_id,
*                 connection_id,
*                 flight_date
*          INTO TABLE @DATA(lt_bookings)
*          UP TO 3 ROWS.
*
*
*   out->write( |Reservas actuales: { lines( lt_bookings ) }| ).
*
*
*   IF lt_bookings IS NOT INITIAL.
*     LOOP AT lt_bookings INTO DATA(ls_book).
*       out->write( |  { ls_book-booking_id } - Cliente { ls_book-customer_id }| ).
*     ENDLOOP.
*   ENDIF.
*
*
*   " ============================================
*   " APPEND: Nueva reserva
*   " ============================================
*   out->write( |\n| ).
*   out->write( |Agregar nueva reserva...| ).
*
*
*   "APPEND con Field Symbol
*   APPEND INITIAL LINE TO lt_bookings
*          ASSIGNING FIELD-SYMBOL(<new_booking>).
*
*
*   " Llenar datos
*   <new_booking>-booking_id = '9999'.
*   <new_booking>-customer_id = '000001'.
*   <new_booking>-carrier_id = 'AA'.
*   <new_booking>-connection_id = '0017'.
*   <new_booking>-flight_date = sy-datum.
*
*
*   out->write( |\n Reserva agregada:| ).
*   out->write( |   ID: { <new_booking>-booking_id }| ).
*   out->write( |   Cliente: { <new_booking>-customer_id }| ).
*   out->write( |   Vuelo: { <new_booking>-carrier_id } { <new_booking>-connection_id }| ).
*   out->write( |\n| ).
*   out->write( |Total reservas ahora: { lines( lt_bookings ) }| ).


*  " ============================================
*   " Insertar cliente VIP en posición 1
*   " ============================================
*   out->write( |========================================| ).
*   out->write( |  LISTA DE CLIENTES                    | ).
*   out->write( |========================================| ).
*   out->write( |\n| ).
*
*
*   " Leer clientes
*   SELECT FROM /dmo/customer
*          FIELDS customer_id,
*                 first_name,
*                 last_name,
*                 city
*          INTO TABLE @DATA(lt_customers)
*          UP TO 3 ROWS.
*
*
*   out->write( |LISTA ORIGINAL:| ).
*
*
*   DATA(lv_pos) = 1.
*
*
*   LOOP AT lt_customers INTO DATA(ls_cust).
*     out->write( |{ lv_pos }. { ls_cust-customer_id } - { ls_cust-first_name } { ls_cust-last_name }| ).
*     lv_pos = lv_pos + 1.
*   ENDLOOP.
*
*
*   " ============================================
*   " INSERT en posición 1
*   " ============================================
*   out->write( |\n| ).
*   out->write( |Insertar cliente VIP en posición 1...| ).
*
*
*   " INSERT con Field Symbol
*   INSERT INITIAL LINE INTO lt_customers
*          ASSIGNING FIELD-SYMBOL(<vip_customer>)
*          INDEX 3.
*
*
*   <vip_customer>-customer_id = '999999'.
*   <vip_customer>-first_name = 'Laura'.
*   <vip_customer>-last_name = 'Martinez'.
*   <vip_customer>-city = 'Madrid'.
*   out->write( |Cliente VIP insertado al principio| ).
*
*
*   " ============================================
*   " Mostrar lista actualizada
*   " ============================================
*   out->write( |\n| ).
*   out->write( |LISTA ACTUALIZADA:| ).
*   lv_pos = 1.
*
*
*   LOOP AT lt_customers ASSIGNING FIELD-SYMBOL(<customer>).
*     DATA(lv_tag) = COND string(
*       WHEN <customer>-customer_id = '999999'
*       THEN 'VIP'
*       ELSE '' ).
*     out->write( |{ lv_pos }. { <customer>-customer_id } - { <customer>-first_name } { <customer>-last_name } { lv_tag }| ).
*     lv_pos = lv_pos + 1.
*   ENDLOOP.


  " ============================================
   " Buscar vuelo específico
   " ============================================
   out->write( |========================================| ).
   out->write( |  BUSCAR Y ACTUALIZAR VUELO            | ).
   out->write( |========================================| ).
   out->write( |\n| ).


   " Leer vuelos
   SELECT FROM /dmo/flight
          FIELDS carrier_id,
                 connection_id,
                 flight_date,
                 price,
                 currency_code
          WHERE carrier_id = 'LH'
          INTO TABLE @DATA(lt_flights)
          UP TO 5 ROWS.


   IF lt_flights IS INITIAL.
     out->write( |No hay vuelos| ).
     RETURN.
   ENDIF.


   out->write( |Vuelos en sistema:| ).


   LOOP AT lt_flights INTO DATA(ls_flight).
     out->write( |  { ls_flight-carrier_id } { ls_flight-connection_id } - { ls_flight-price } { ls_flight-currency_code }| ).
   ENDLOOP.


   " ============================================
   " READ: Buscar vuelo específico
   " ============================================
   out->write( |\n| ).
   out->write( | Buscar vuelo LH 0400...| ).


   " READ TABLE con Field Symbol
   READ TABLE lt_flights
        ASSIGNING FIELD-SYMBOL(<flight>)
        WITH KEY carrier_id = 'LH'
                 connection_id = '0400'.


   IF sy-subrc = 0.
     out->write( | Vuelo encontrado:| ).
     out->write( |  Precio actual: { <flight>-price } { <flight>-currency_code }| ).


     " Aplicar descuento especial
     DATA(lv_precio_anterior) = <flight>-price.
     <flight>-price = <flight>-price * '0.85'.
     out->write( |  Descuento 15% aplicado| ).
     out->write( |  Precio nuevo: { <flight>-price } { <flight>-currency_code }| ).


   ELSE.
     out->write( | Vuelo no encontrado| ).
   ENDIF.


   " ============================================
   " READ: Por índice
   " ============================================
   out->write( |\n| ).
   out->write( | Leer vuelo en posición 2...| ).

READ TABLE lt_flights
        ASSIGNING FIELD-SYMBOL(<flight2>)
        INDEX 2.

IF sy-subrc = 0.
     out->write( | { <flight2>-carrier_id } { <flight2>-connection_id } - { <flight2>-price } { <flight2>-currency_code }| ).
   ENDIF.

" ============================================
   " Mostrar tabla final
   " ============================================
   out->write( |\n| ).
   out->write( |VUELOS ACTUALIZADOS:| ).

 LOOP AT lt_flights ASSIGNING FIELD-SYMBOL(<f>).
     out->write( |  { <f>-carrier_id } { <f>-connection_id } - { <f>-price } { <f>-currency_code }| ).
   ENDLOOP.












 ENDMETHOD.




ENDCLASS.
