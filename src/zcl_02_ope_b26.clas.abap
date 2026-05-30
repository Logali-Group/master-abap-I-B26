CLASS zcl_02_ope_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_02_ope_b26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_num_a TYPE i VALUE 20,
          lv_num_b TYPE i VALUE 5,
          lv_total TYPE p LENGTH 6 DECIMALS 2.

*    "+
*    lv_total = lv_num_a + lv_num_b.
*    out->write( | Number a { lv_num_a }  Number b { lv_num_b } Total: { lv_total }  |    ).
*
*    "ADD
*    ADD 5 TO lv_total.
*
*    out->write( | Total: { lv_total } | ).
*
*    "+=
*    lv_total += 5. "acumulador
*
*    out->write( | Total: { lv_total } | ).
*
*    lv_total = lv_num_a + lv_num_b + lv_total.
*
*    out->write( | Total: { lv_total } | ).
*
*    CLEAR lv_total. "limpiamos la variable

*esto es un comment

    "CTRL + >< Comentar
    "CTRL + SHIFT + >< Descomentar

*   "Resta
*   lv_total = lv_num_a - lv_num_b. "esto es una suma
*   out->write( | Number a: { lv_num_a }  Number b: { lv_num_b } Total: { lv_total }  |    ).
*
*   "SUBTRACT
*   SUBTRACT 2 FROM lv_total.
*   out->write( | Total: { lv_total } | ).
*
*   lv_total = lv_num_a - 1.
*   out->write( | Total: { lv_total } | ).


*  "Multi
*   lv_total = lv_num_a  * lv_num_b.
*   out->write( | Number a: { lv_num_a }  Number b: { lv_num_b } Total: { lv_total }  |    ).
*
*   MULTIPLY lv_total BY 5.
*   MULTIPLY lv_total BY lv_num_a.
*   out->write( | Number a: { lv_num_a }  Number b: { lv_num_b } Total: { lv_total }  |    ).
*
*   lv_total = lv_total * 2.
*   out->write( | Number a: { lv_num_a }  Number b: { lv_num_b } Total: { lv_total }  |    ).


*   "DIVIDE
*   lv_total = lv_num_a / lv_num_b.
*   out->write( | Number a: { lv_num_a }  Number b: { lv_num_b } Total: { lv_total }  |    ).
*
*   DIVIDE lv_total BY 2.
*   out->write( | Total: { lv_total } | ).
*
*   CLEAR lv_total.
*
*   lv_total = ( lv_num_a + lv_num_b ) / 3.
*   out->write( | Total: { lv_total } | ).
*
*    "DIV
*   lv_num_a = 9.
*   lv_num_b = 4.
*   lv_total = lv_num_a / lv_num_b.
*   out->write( | Total: { lv_total } | ).
*
*   lv_total = lv_num_a DIV lv_num_b. "regresa el resultado entero de la division, sin el residuo
*   out->write( | Total: { lv_total } | ).
*
******MOD
*   lv_total = lv_num_a / lv_num_b.
*   out->write( | Total: { lv_total } | ).
*
*   lv_total = lv_num_a MOD lv_num_b. "devuelve el resto de la división, 9 en 4 cabe 2 veces y resta 1, por eso regresa 1
*   out->write( | Total: { lv_total } | ).



*****EXP
*   lv_num_a = 3.
*   out->write( | Number a: { lv_num_a } | ).
*
*   lv_num_a = lv_num_a ** 2.
*
*   out->write( | Number a: { lv_num_a } | ).
*
*   CLEAR lv_num_a.
*
*   lv_num_a = 3.
*   DATA(lv_exp) = 3.
*   lv_num_a = lv_num_a ** lv_exp.
*   out->write( | Number a: { lv_num_a } | ).
*
*   " ipow
*   DATA(lv_result) = ipow( base = 2 exp = 3 ).
*   out->write( lv_result ).
*
*
*   "sqrt
*   lv_num_a = sqrt( 25 ).
*   out->write( | Total SQRT: { lv_num_a } | ).
*
*   lv_num_a = 9.
*   lv_num_a = sqrt( lv_num_a ).
*   out->write( | Total SQRT: { lv_num_a } | ).

    "Conversiones Data

*    DATA: lv_string TYPE string VALUE `12345`,
*          lv_int    TYPE i.
*    DATA: lv_date    TYPE d,
*          lv_decimal TYPE p LENGTH 3 DECIMALS 2.

*    lv_int = lv_string.
*
*    out->write( 'OK' ).
*    out->write( lv_int ).
*
*    lv_string = `LOGALI`.
*    lv_date = lv_string.
*
*    out->write( |String value: { lv_string }| ).
*    out->write( |Date Value: { lv_date DATE = USER }| ).

    "DUMP
*  lv_string  = `1234678`.
*  lv_decimal = lv_string.
*  out->write( lv_decimal ).

*    lv_date = cl_abap_context_info=>get_system_date( ).
*    out->write( | { lv_date DATE = USER } | ).



*    "1. Truncamiento de Caracteres (Pérdida de datos)
*    DATA: lv_string TYPE string VALUE `LOGALI`,
*          lv_char   TYPE c LENGTH 2.
*
*    " Se intenta guardar "LOGALI" (6 caracteres) en una variable de solo 2
*    lv_char = lv_string.
*    out->write( lv_char ).


* "Declaraciones en línea
*   DATA(lv_mult) = 8 * 16. "ver el tipo que toma en el depurador
*   out->write( lv_mult ). "numero entero
*
*   DATA(lv_div) = 8 / 16.
*   out->write( lv_div ). "ver el tipo que toma en el depurador
*                          "Se redondea el número
*   DATA(lv_text) = 'ABAP I - 2023'.
*   out->write( lv_text ).


* "Date and Time
*   DATA: lv_date  TYPE d,
*         lv_date2 TYPE d,
*         lv_time  TYPE t,
*         lv_time2 TYPE c LENGTH 6.
*
*   lv_date  = cl_abap_context_info=>get_system_date(  ).
*   lv_time  = cl_abap_context_info=>get_system_time(  ). "hora del sistema
*
*  "Cálculos de fecha y hora
*   lv_date  = '20260101'.
*   lv_date2 = '20260622'.
*
*   DATA(lv_days) = lv_date2 - lv_date. "probar también con resultado solo de 30 días
*
*   out->write( lv_days ).
*   out->write( lv_date ).
*
*
*      "Offset
*   DATA(lv_month) = lv_date2+4(2). "mes
*   out->write( |mes: { lv_month } | ).
*
*   DATA(lv_year) = lv_date2(4).
*   out->write( |año: { lv_year  } | ). "año
*
*   DATA(lv_day) = lv_date2+6(2).
*   out->write( | día: { lv_day } | ).  "día
*
*
*   lv_date = cl_abap_context_info=>get_system_date(  ) + 10.
*   out->write( lv_date ).


    out->write( TEXT-001 ).
    out->write( TEXT-msg ).


  ENDMETHOD.
ENDCLASS.
