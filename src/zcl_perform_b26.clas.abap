CLASS zcl_perform_b26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS structure.
    METHODS field_symbol.

  PRIVATE SECTION.
    TYPES lty_flights TYPE STANDARD TABLE OF /dmo/airport
                      WITH NON-UNIQUE KEY airport_id name.
    METHODS loop_fs CHANGING c_flights TYPE lty_flights.
    METHODS loop_struct CHANGING c_flights TYPE lty_flights.
ENDCLASS.



CLASS zcl_perform_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA(lo_flights) = NEW zcl_perform_b26( ).
    lo_flights->structure( ).      "Enfoque 1: Con estructura
    lo_flights->field_symbol( ).   "Enfoque 2: Con field symbol
    out->write( 'OK' ).

  ENDMETHOD.

  METHOD structure.
    DATA lt_flights TYPE lty_flights.

    SELECT FROM /dmo/airport
      FIELDS *
      INTO TABLE @lt_flights.

    loop_struct( CHANGING c_flights = lt_flights ).
  ENDMETHOD.

  METHOD loop_struct.
    LOOP AT c_flights INTO DATA(ls_flight).
      ls_flight-country = 'CO'.
      MODIFY c_flights FROM ls_flight.
    ENDLOOP.
  ENDMETHOD.

  METHOD field_symbol.
    DATA lt_flights TYPE lty_flights.

    SELECT FROM /dmo/airport
      FIELDS *
      INTO TABLE @lt_flights.

    loop_fs( CHANGING c_flights = lt_flights ).
  ENDMETHOD.

  METHOD loop_fs.
    LOOP AT c_flights ASSIGNING FIELD-SYMBOL(<lfs_flight>).
      <lfs_flight>-country = 'CO'.
    ENDLOOP.
  ENDMETHOD.


ENDCLASS.
