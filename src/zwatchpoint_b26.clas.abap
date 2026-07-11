CLASS zwatchpoint_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zwatchpoint_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "═══════════════════════════════════════════════════════════
    "CALCULAR PRECIOS CON DESCUENTO
    "═══════════════════════════════════════════════════════════

    out->write( |=== Calculando precios con descuento ===| ).

    " Leer vuelos de American Airlines
    DATA lt_flights TYPE TABLE OF /dmo/flight.

    SELECT * FROM /dmo/flight
      WHERE carrier_id = 'AA'
      INTO TABLE @lt_flights
      UP TO 5 ROWS.

    out->write( |Vuelos encontrados: { lines( lt_flights ) }| ).

    " AQUÍ ESTÁ EL PUNTO CLAVE
    " Este FOR es UNA SOLA INSTRUCCIÓN
    " NO puedes poner breakpoint dentro del FOR
    " Para ver cada iteración, necesitas un WATCHPOINT

    DATA lt_con_descuento TYPE TABLE OF /dmo/flight.

    lt_con_descuento = VALUE #(
      FOR flight IN lt_flights
      ( carrier_id      = flight-carrier_id
        connection_id   = flight-connection_id
        flight_date     = flight-flight_date
        plane_type_id   = flight-plane_type_id
        seats_max       = flight-seats_max
        seats_occupied  = flight-seats_occupied
        price           = flight-price * '0.9'      " 10% descuento
        currency_code   = flight-currency_code ) ).

    " Mostrar resultados
    out->write( |--- Precios con descuento ---| ).
    LOOP AT lt_con_descuento INTO DATA(ls_flight).
      out->write( |Vuelo { ls_flight-connection_id }: { ls_flight-price } { ls_flight-currency_code }| ).
    ENDLOOP.

    out->write( |=== Proceso terminado ===| ).

  ENDMETHOD.

ENDCLASS.
