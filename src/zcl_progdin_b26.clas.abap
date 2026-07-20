CLASS zcl_progdin_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_progdin_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

   "═══════════════════════════════════════════════════════════
   " EJEMPLO: OBJETO ANÓNIMO con SELECT
   "═══════════════════════════════════════════════════════════

   out->write( |=== EJEMPLO 6: Objeto Anónimo con SELECT ===| ).

   " Crear tabla interna anónima directamente en SELECT
   SELECT *
     FROM /dmo/carrier
     INTO TABLE NEW @DATA(lr_carriers)
     UP TO 5 ROWS.

   " Para usarla, desreferenciar

   out->write( |Aerolíneas encontradas: { lines( lr_carriers->* ) }| ).
   LOOP AT lr_carriers->* ASSIGNING FIELD-SYMBOL(<fs_carr>).
     out->write( |{ <fs_carr>-carrier_id }: { <fs_carr>-name }| ).
   ENDLOOP.

************************


   " EJEMPLO: CASO PRÁCTICO - Reporte Configurable
   "═══════════════════════════════════════════════════════════
   out->write( |=== EJEMPLO 2: Reporte Configurable ===| ).

   " Usuario selecciona qué campos quiere ver
   " Usar conversión a string para compatibilidad

   DATA lt_selected_fields TYPE TABLE OF string.


   lt_selected_fields = VALUE #( ( CONV string( 'CARRIER_ID' ) )
                                 ( CONV string( 'CONNECTION_ID' ) )
                                 ( CONV string( 'PRICE' ) ) ).
   " Leer datos
   SELECT * FROM /dmo/flight
     WHERE carrier_id = 'LH'
     INTO TABLE @DATA(lt_flights_report)
     UP TO 3 ROWS.

   " Mostrar solo los campos seleccionados
   DATA lv_line_number TYPE i VALUE 0.

   FIELD-SYMBOLS: <fs_generic> TYPE data.

   LOOP AT lt_flights_report ASSIGNING FIELD-SYMBOL(<fs_flight_rep>).

     lv_line_number = lv_line_number + 1.

     out->write( |--- Registro { lv_line_number } ---| ).

     LOOP AT lt_selected_fields INTO DATA(lv_selected_field).
       ASSIGN <fs_flight_rep>-(lv_selected_field) TO <fs_generic>.

       IF <fs_generic> IS ASSIGNED.
         out->write( |  { lv_selected_field }: { <fs_generic> }| ).
         UNASSIGN <fs_generic>.
       ENDIF.
     ENDLOOP.

   ENDLOOP.


"═══════════════════════════════════════════════════════════
   " EJEMPLO : SELECT DINÁMICO
   "═══════════════════════════════════════════════════════════
   out->write( |=== EJEMPLO 3: SELECT Dinámico ===| ).

   " El nombre de la tabla se decide en tiempo de ejecución

   DATA(lv_table_name) = '/DMO/CARRIER'.

   " SELECT dinámico - NO puede usar inline declaration
   "  Primero declaramos la tabla con tipo genérico

   DATA lt_dynamic_data TYPE STANDARD TABLE OF /dmo/carrier WITH EMPTY KEY.

   SELECT *
     FROM (lv_table_name)
     INTO TABLE @lt_dynamic_data
     UP TO 3 ROWS.

   out->write( |Registros leídos de { lv_table_name }: { lines( lt_dynamic_data ) }| ).

   " Mostrar los datos
   LOOP AT lt_dynamic_data ASSIGNING FIELD-SYMBOL(<fs_dynamic>).
     ASSIGN COMPONENT 'CARRIER_ID' OF STRUCTURE <fs_dynamic> TO <fs_generic>.
     IF <fs_generic> IS ASSIGNED.
       out->write( |Carrier ID: { <fs_generic> }| ).
       UNASSIGN <fs_generic>.
     ENDIF.
   ENDLOOP.

"

********Solución a variación de nombre de tabla y tipo
   out->write( |=== EJEMPLO 3: SELECT Verdaderamente Dinámico ===| ).

   DATA(lv_table_name2) = '/DMO/CUSTOMER'.

   "Declarar field symbol genérico
   FIELD-SYMBOLS <ft_data> TYPE ANY TABLE.

   "Crear tabla dinámica
   DATA lr_table TYPE REF TO data.

   CREATE DATA lr_table TYPE STANDARD TABLE OF (lv_table_name2).

   "Asignar al field symbol
   ASSIGN lr_table->* TO <ft_data>.

   "SELECT dinámico
   SELECT * FROM (lv_table_name2)
     INTO TABLE @<ft_data>
     UP TO 5 ROWS.

   out->write( |Tabla: { lv_table_name2 }| ).

   out->write( |Registros: { lines( <ft_data> ) }| ).

   LOOP AT <ft_data> ASSIGNING FIELD-SYMBOL(<fs>).
     out->write( <fs> ).
   ENDLOOP.







  ENDMETHOD.

ENDCLASS.
