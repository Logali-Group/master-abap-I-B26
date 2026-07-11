CLASS zdebugger_b26 DEFINITION
 PUBLIC
 FINAL
 CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zdebugger_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 1: DEMOSTRACIÓN DE F8 (CONTINUE/RESUME)
*    "═══════════════════════════════════════════════════════════
*    out->write( |--- SECCIÓN 1: F8 (Continue) ---| ).
*
*    DATA lv_inicio TYPE string VALUE 'Inicio del programa'.
*
*    out->write( lv_inicio ).
*
*    " Líneas que se ejecutarán cuando presiones F8
*    DATA lv_valor1 TYPE i VALUE 100.
*    DATA lv_valor2 TYPE i VALUE 200.
*    DATA lv_suma TYPE i.
*    lv_suma = lv_valor1 + lv_valor2.
*
*    "F8 en línea del BP anterior → Saltará directamente aquí
*    out->write( |Suma: { lv_suma }| ).
*
*
*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 2: DEMOSTRACIÓN DE F6 (STEP OVER)
*    "═══════════════════════════════════════════════════════════
*    out->write( |--- SECCIÓN 2: F6 (Step Over) ---| ).
*
*    DATA lt_flights TYPE TABLE OF /dmo/flight.
*
*    "F6 → Ejecuta el SELECT completo sin ver los detalles internos
*    " No entrará en el procesamiento interno del SELECT
*
*    SELECT * FROM /dmo/flight
*      WHERE carrier_id = 'AA'
*      INTO TABLE @lt_flights
*      UP TO 3 ROWS.
*
*    "F6 nuevamente → Ejecuta el lines() sin entrar en él
*
*    DATA(lv_cantidad) = lines( lt_flights ).
*
*    "F6 → Ejecuta esta línea
*
*    out->write( |Vuelos encontrados: { lv_cantidad }| ).
*
*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 3: DEMOSTRACIÓN DE F5 (STEP INTO)
*    "═══════════════════════════════════════════════════════════
*
*    out->write( |--- SECCIÓN 3: F5 (Step Into) ---| ).
*
*    DATA lv_precio TYPE /dmo/flight_price VALUE 1000.
*
*    "F5 → Entrará en el detalle
*
*    DATA(lt_precios) = VALUE string_table(
*      ( |1500| )
*      ( |2000| )
*      ( |2500| )
*    ).
*
*    "F6 aquí (no F5) - Solo verás el resultado
*
*    DATA lv_total_precios TYPE i VALUE 0.
*
*    LOOP AT lt_precios INTO DATA(lv_precio_str).
*      lv_total_precios = lv_total_precios + lv_precio_str.
*    ENDLOOP.
*
*"F6 no entra en el loop
*    out->write( |Total precios: { lv_total_precios }| ).
*
*
*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 4: DEMOSTRACIÓN DE F7 (STEP RETURN)
*    "═══════════════════════════════════════════════════════════
*
*    out->write( |--- SECCIÓN 4: F7 (Step Return) ---| ).
*
*    " Si en la sección 3 usaste F5 y entraste muy profundo en el código
*    " Presiona F7 -> Saldrás y volverás al nivel anterior
*
*
*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 5: DEMOSTRACIÓN DE shift+F8 (RUN TO LINE)
*    "═══════════════════════════════════════════════════════════
*
*    out->write( |--- SECCIÓN 5: shift+F8 (Run to Line) ---| ).
*
*    DATA lv_contador TYPE i VALUE 0.
*
*    " Estas líneas se ejecutarán cuando uses shift+F8
*
*    DO 10 TIMES.
*      lv_contador = lv_contador + 1.
*      " Imagina que aquí hay mucho código que funciona bien
*    ENDDO.
*
*    "CURSOR aquí
*    " presiona Ctrl+F8
*    " → Ejecutará TODO hasta aquí sin parar
*
*    out->write( |Contador después del loop: { lv_contador }| ).
*
*
*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 6: DEMOSTRACIÓN DE Shift+F12 (MOVE POINTER)
*    "═══════════════════════════════════════════════════════════
*    out->write( |--- SECCIÓN 6: Shift+F12 (Move Pointer) ---| ).
*
*    "Esta función es poderosa pero peligrosa
*    DATA lv_saldo TYPE i VALUE 1000.
*
*    out->write( |Saldo inicial: { lv_saldo }| ).
*
*    " PASO 2: Estás en línea 117
*    " La siguiente línea haría una resta
*
*    lv_saldo = lv_saldo - 500.  " Línea 121
*
*    " PASO 3: Sin ejecutar línea 121, coloca CURSOR en línea 126
*    " Shift+F12
*    " Saltará la resta, lv_saldo seguirá siendo 1000
*
*    out->write( |Saldo después de "saltar" la resta: { lv_saldo }| ).
*
*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 7: COMBINACIÓN DE TÉCNICAS
*    "═══════════════════════════════════════════════════════════
*
*    out->write( |--- SECCIÓN 7: Combinación ---| ).
*
*    " Escenario real: Procesar una lista de vuelos
*
*    SELECT * FROM /dmo/flight
*      WHERE carrier_id = 'LH'
*      INTO TABLE @lt_flights
*      UP TO 5 ROWS.
*
*    " Presiona F6 → Ejecuta el SELECT
*
*    out->write( |Total vuelos: { lines( lt_flights ) }| ).
*
*    " Procesar cada vuelo
*
*    DATA lv_vuelos_caros TYPE i VALUE 0.
*
*    LOOP AT lt_flights INTO DATA(ls_flight).
*      " Presiona F6 → Avanza una iteración
*      " Presiona F8 → Completa todo el loop
*      IF ls_flight-price > 500.
*        lv_vuelos_caros = lv_vuelos_caros + 1.
*      ENDIF.
*    ENDLOOP.
*
*    out->write( |Vuelos caros: { lv_vuelos_caros }| ).
*
*    "═══════════════════════════════════════════════════════════
*    " SECCIÓN 8: DEBUGGING DE EXPRESIONES COMPLEJAS
*    "═══════════════════════════════════════════════════════════
*
*    out->write( |--- SECCIÓN 8: Expresiones Complejas ---| ).
*
*    DATA(lv_precio_max) = REDUCE /dmo/flight_price(
*      INIT max = 0
*      FOR flight IN lt_flights
*      NEXT max = COND #( WHEN flight-price > max
*                         THEN flight-price
*                         ELSE max ) ).
*
*    "F6 → Ejecuta todo el REDUCE de una vez
*
*    out->write( |Precio máximo: { lv_precio_max }| ).
*
*    " Corresponding con mapeo
*    DATA: BEGIN OF ls_flight_simple,
*            carrier    TYPE /dmo/carrier_id,
*            connection TYPE /dmo/connection_id,
*            price      TYPE /dmo/flight_price,
*          END OF ls_flight_simple.
*
*    IF lines( lt_flights ) > 0.
*      ls_flight_simple = CORRESPONDING #( lt_flights[ 1 ] ).
*    ENDIF.
*
*    " Presiona F5 → Entra en el CORRESPONDING
*    out->write( |Vuelo simplificado - Carrier: { ls_flight_simple-carrier }| ).
*
*    "═══════════════════════════════════════════════════════════
*    " FINALIZACIÓN
*    "═══════════════════════════════════════════════════════════
*    "BREAKPOINT aquí
*    " Presiona F8 → Termina el programa
*    out->write( |=== FIN DEL PROGRAMA ===| ).



DATA(gs_customer) = VALUE /dmo/customer(
  first_name  = 'Laura'
  last_name   = 'Martinez'
  city        = 'Madrid' ).


" El nombre del campo viene de una VARIABLE
DATA(lv_field_name) = 'FIRST_NAME'.


ASSIGN gs_customer-(lv_field_name) TO FIELD-SYMBOL(<fs_generic>).

"""""""""""""""""""""""""""""""""""

 out->write( |=== EJEMPLO 5: Múltiples Campos Dinámicos ===| ).

   " Usar conversión a string para compatibilidad

   DATA lt_field_names TYPE TABLE OF string.

   lt_field_names = VALUE #( ( CONV string( 'FIRST_NAME' ) )
                             ( CONV string( 'LAST_NAME' ) )
                             ( CONV string( 'CITY' ) ) ).

   LOOP AT lt_field_names INTO DATA(lv_field).
     ASSIGN gs_customer-(lv_field) TO <fs_generic>.
     IF <fs_generic> IS ASSIGNED.
       out->write( |{ lv_field }: { <fs_generic> }| ).
       UNASSIGN <fs_generic>.
     ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
