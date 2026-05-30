CLASS zcl_exce_log_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_exce_log_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( 'This is my first class in ABAP' ).

    DATA name TYPE string VALUE 'María'.

    DATA age TYPE i VALUE 53.

    age = 54.

    DATA decimal TYPE p LENGTH 8 DECIMALS 2 VALUE '234.34'.

    DATA empresa TYPE c LENGTH 10 VALUE 'Logali'.

    name = 'Juana'.

    DATA date TYPE d.

    date = '20260606'.

    out->write(  | Datos emp: { name } - { age } - { empresa } | ).


        TYPES: BEGIN OF lty_employee,
              id TYPE i,
              name TYPE string,
              age TYPE i,
        END OF lty_employee.

        DATA ls_employee TYPE lty_employee.

        ls_employee = VALUE #( age = 25 id = 123 name = 'Carlos'   ).

        out->write( ls_employee ).


        CONSTANTS id TYPE i VALUE 123.

        "id = 456.

        DATA(result) = 4 + 7.
        out->write( result ).

        DATA(STRING) = `XYZ`.

        DATA(CHAR) = 'ABC'.

        out->write( STRING ).

  ENDMETHOD.

ENDCLASS.
