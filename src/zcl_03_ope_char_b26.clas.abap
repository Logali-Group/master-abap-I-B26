CLASS zcl_03_ope_char_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_03_ope_char_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


*    "Funciones de Longitud
*
*    " ---------------------------------------------------------
*    " CASO 1: Usando STRING (Dinámico) -> Se usan backticks ` `
*    " ---------------------------------------------------------
*    " Al usar `...`, creamos un STRING real, no un CHAR.
*    " Texto: "Logali Group" (12 caracteres) + 4 espacios = 16 total
*
*    DATA(lv_string) = `Logali Group    `.
*
*    " STRLEN en STRING: Cuenta TODO, incluidos los espacios finales.
*
*    DATA(lv_len_str) = strlen( lv_string ).
*
*    " NUMOFCHAR en STRING: Sigue ignorando los espacios finales (cuenta caracteres 'visibles').
*
*    DATA(lv_num_str) = numofchar( lv_string ).
*
*    out->write( '--- RESULTADOS CON STRING (`...`) ---' ).
*    out->write( |Texto: "{ lv_string }"| ).
*    out->write( |STRLEN:      { lv_len_str }| ).  " Resultado: 16
*    out->write( |NUMOFCHAR:   { lv_num_str }| ).  " Resultado: 12
*
*    " ---------------------------------------------------------
*    " CASO 2: Usando CHAR (Fijo) -> Se usan comillas ' '
*    " ---------------------------------------------------------
*
*    DATA(lv_char)   = 'Logali Group    '.
*
*    " En campos tipo CHAR, AMBAS funciones ignoran los espacios de relleno.
*    DATA(lv_len_char) = strlen( lv_char ).
*
*    DATA(lv_num_char) = numofchar( lv_char ).
*
*    out->write( ' ' ).
*    out->write( '--- RESULTADOS CON CHAR (''...'') ---' ).
*    out->write( |Texto: "{ lv_char }"| ).
*    out->write( |STRLEN:      { lv_len_char }| ). " Resultado: 12
*    out->write( |NUMOFCHAR:   { lv_num_char }| ). " Resultado: 12


*    "Funciones de búsqueda
*    DATA lv_string TYPE string VALUE 'LOGALI local'.
*    DATA(lv_num)   = strlen( lv_string ).
*
*    "count
*
*    lv_num = count( val = lv_string sub = 'LO' ). "encuentra el número de coincidencias con el patron exacto
*    out->write( lv_num ).
*
*    lv_num = count_any_of( val = lv_string sub = 'LO' ). "encuentra las coincidencias no importa el orden
*    out->write( lv_num ). "encuentra el caracter L dos veces y O una vez
*
*
*    lv_num = count_any_not_of( val = lv_string sub = 'LO'  ).
*    out->write( lv_num ). "devuelve todas las posiciones que no coinciden con el patrón
*
*
*   "FIND
*   lv_num = find( val = lv_string sub = 'LI' ).
*   out->write( lv_num ).
*
*   lv_num = find_any_of( val = lv_string sub = 'LI' ).
*   out->write( lv_num ).
*
*   lv_num = find_any_not_of( val = lv_string sub = 'LI' ).
*   out->write( lv_num ).


    "Funciones de procesamiento

    "   DATA lv_string TYPE string VALUE ' Logali Group! Welcome to ABAP Cloud Master  '.

*   "Change Case of characters
*   out->write( |TO_UPPER         = {   to_upper(  lv_string ) } | ).
*   out->write( |TO_LOWER         = {   to_lower(  lv_string ) } | ).
*   out->write( |TO_MIXED         = {   to_mixed(  lv_string ) } | ).
*   out->write( |FROM_MIXED       = { from_mixed(  lv_string ) } | ).

*   "ejemplo más claro de tomixed y frommixed
*   DATA(lv_camel_case) = 'SalesOrderItems'.
*
*   " Resultado: SALES_ORDER_ITEMS
*   out->write( |De Camel a Snake: { from_mixed( lv_camel_case ) }| ).
*
*   DATA(lv_snake_case) = 'GET_MATERIAL_DATA'.
*   " Resultado: getMaterialData
*   " El parámetro 'sep = _' le dice a la función qué carácter debe eliminar para unir las palabras.
*
*   out->write( |De Snake a Camel: { to_mixed( val = lv_snake_case sep = '_' ) }| ).


*   "Change order of characters
*   out->write( |REVERSE             = {  reverse( lv_string ) } | ).
*   out->write( |SHIFT_LEFT  (places)= {  shift_left(  val = lv_string places   = 5  ) } | ).
*   out->write( |SHIFT_RIGHT (places)= {  shift_right( val = lv_string places   = 5  ) } | ).
*   out->write( |SHIFT_LEFT  (circ)  = {  shift_left(  val = lv_string circular = 5  ) } | ).
*   out->write( |SHIFT_RIGHT (circ)  = {  shift_right( val = lv_string circular = 5  ) } | ).


*DATA lv_string TYPE string VALUE ' Logali Group! Welcome to ABAP Cloud Master ! Master CLoud '.
*
*" Extract a Substring
*   out->write( |SUBSTRING        = {  substring(        val = lv_string off = 9 len = 6 ) } | ).
*   out->write( |SUBSTRING_FROM   = {  substring_from(   val = lv_string sub = 'ABAP'     ) } | ).
*   out->write( |SUBSTRING_AFTER  = {  substring_after(  val = lv_string sub = 'ABAP'     ) } | ).
*   out->write( |SUBSTRING_TO     = {  substring_to(     val = lv_string sub = 'ABAP'     ) } | ).
*   out->write( |SUBSTRING_BEFORE = {  substring_before( val = lv_string sub = 'ABAP'     ) } | ).
*
*   " Condense, REPEAT and Segment
*   out->write( |CONDENSE         = {   condense( val = lv_string ) } | ).
*   out->write( |REPEAT           = {   repeat(   val = lv_string occ = 2 ) } | ).
*   out->write( |SEGMENT1         = {   segment(  val = lv_string sep = '!' index = 1 ) } |  ).
*   out->write( |SEGMENT2         = {   segment(  val = lv_string sep = '!' index = 2 ) } |  ).
*   out->write( |SEGMENT2         = {   segment(  val = lv_string sep = '!' index = 3 ) } |  ).


*  "Contains
*   DATA: lv_text    TYPE string,
*         lv_pattern TYPE string.
*
*   lv_text = 'The employee`s number is: 123-456-7898'.
*   lv_pattern = `\d{3}-\d{3}-\d{4}`. " Patrón para un número de teléfono
*
*   IF contains( val = lv_text pcre = lv_pattern ).
*     out->write( 'The text contains a phone number' ).
*   ELSE.
*     out->write( 'The text doesn`t contains a phone number' ).
*   ENDIF.
*
*   "match
*   DATA(lv_number) = match( val = lv_text pcre = lv_pattern occ = 1 ).
*   out->write( lv_number ).

*   "Contains
*   DATA: lv_string  TYPE string,
*         lv_pattern TYPE string.
*
*   lv_string = 'Please contact us at supportlogali.com for more information'.
*   lv_pattern = `\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b`. " regex for a email
*
*   IF contains( val = lv_string pcre = lv_pattern ). "verdadero
*     out->write( 'The text contains an email address' ).
*
*     DATA(lv_count) = count( val = lv_string pcre = lv_pattern )." cuantas veces hay coincidencias
*     out->write( lv_count ).
*
*     DATA(lv_pos) = find( val = lv_string pcre = lv_pattern occ = 1 ). " dónde está en lv_String
*     out->write( lv_pos ).
*
*   ELSE.
*     out->write( 'The text does not contain an email address' ).
*   ENDIF.



*   "Concatenación
*   DATA: lv_string_a TYPE string VALUE 'Welcome to Logali Group',
*         lv_string_b TYPE string.
*
*   "si no le especifico el espacio, quedan juntos
*   lv_string_b = 'ABAP' && ` ` && 'Student'.
*
*
*   DATA(lv_fin_string) = | Concatenation 1: { lv_string_a } / { lv_string_b } |.
*   out->write( lv_fin_string ).
*
*
*   CONCATENATE lv_string_a lv_string_b INTO DATA(lv_fin_string2) SEPARATED BY ' '. "or space
*   out->write( | Concatenation 2: { lv_fin_string2 } | ).
*
*
*   "Insert
*   DATA(lv_ins_string) = insert( val = '123CLIENT02' sub = 'INV' off = 3 ).
*   out->write(  lv_ins_string  ).
*
*   lv_ins_string = insert( val = '123CLIENT02' sub = `INV` ).
*   out->write(  lv_ins_string  ).


    " IF BIFURCACION

*" 1. IF - Validar descuento según monto de compra
*   "=================================================================
*   out->write( '=== IF: CALCULAR DESCUENTO POR MONTO ===' ).
*
*   DATA(lv_monto_compra) = 15.
*
*   DATA(lv_descuento) = 0.
*
*   IF lv_monto_compra >= 1000.
*     lv_descuento = 10.  "10% de descuento
*     out->write( |Monto: { lv_monto_compra } - Descuento: { lv_descuento }%| ).
*   ELSEIF lv_monto_compra >= 500.
*     lv_descuento = 5.   "5% de descuento
*     out->write( |Monto: { lv_monto_compra } - Descuento: { lv_descuento }%| ).
*   ELSE.
*     out->write( |Monto: { lv_monto_compra } - Sin descuento| ).
*   ENDIF.
*
*   out->write( | | ).

    "CASE

*DATA(lv_estado_orden) = 'X'.
*
*CASE lv_estado_orden.
*  WHEN 'A'.
*    out->write( 'APROBADA - Proceder con la entrega' ).
*  WHEN 'P'.
*    out->write( 'PENDIENTE - Esperando aprobación' ).
*  WHEN 'R'.
*    out->write( 'RECHAZADA - Contactar con compras' ).
*  WHEN OTHERS.
*    out->write( 'DESCONOCIDO - Verificar sistema' ).
*ENDCASE.

*"DO
*DATA(lv_numero_factura) = 10001.
*
*DATA(lv_contador) = 0.
*
*DO 5 TIMES.
*  lv_contador = lv_contador + 1.
*  out->write( |Factura { lv_contador }: FAC-{ lv_numero_factura }| ).
*  lv_numero_factura = lv_numero_factura + 1.
*ENDDO.

*"WHILE
*DATA(lv_deuda_total) = 5000.
*
*DATA(lv_pago_acumulado) = 0.
*
*DATA(lv_numero_pago) = 0.
*
*WHILE lv_pago_acumulado < lv_deuda_total.
*
*  lv_numero_pago = lv_numero_pago + 1.
*  DATA(lv_pago) = 1500.
*  lv_pago_acumulado = lv_pago_acumulado + lv_pago.
*
*  out->write( |Pago { lv_numero_pago }: { lv_pago } - Acumulado: { lv_pago_acumulado }| ).
*ENDWHILE.


*    TYPES: BEGIN OF ty_venta,
*             vendedor TYPE string,
*             monto    TYPE i,
*           END OF ty_venta.
*
*    DATA: lt_ventas TYPE TABLE OF ty_venta.
*
*    lt_ventas = VALUE #(
*      ( vendedor = 'Juan' monto = 1000 )
*      ( vendedor = 'Maria' monto = 1500 )
*      ( vendedor = 'Juan' monto = 2000 )
*      ( vendedor = 'Maria' monto = 500 )
*    ).
*
*    DATA(lv_total_ventas) = 0.
*
*    LOOP AT lt_ventas INTO DATA(ls_venta).
*      lv_total_ventas = lv_total_ventas + ls_venta-monto.
*      out->write( |{ ls_venta-vendedor }: { ls_venta-monto }| ).
*      out->write( lv_total_ventas ).
*    ENDLOOP.

"SWITCH

*  " 7. SWITCH - Calcular comisión según categoría de producto
*    "=================================================================
*
*    out->write( '=== SWITCH: CALCULAR COMISIÓN POR CATEGORÍA ===' ).
*
*    DATA(lv_categoria) = 'ALIMENTOS'. "ELECTRO, ROPA, ALIMENTOS
*
*    DATA(lv_precio_producto) = 1000.
*
*    DATA(lv_comision) = SWITCH decfloat34( lv_categoria
*      WHEN 'ELECTRO'   THEN lv_precio_producto * '0.15'  "15%
*      WHEN 'ROPA'      THEN lv_precio_producto * '0.10'  "10%
*      WHEN 'ALIMENTOS' THEN lv_precio_producto * '0.05'  "5%
*      ELSE                  lv_precio_producto * '0.03'  "3%
*    ).
*
*    out->write( |Categoría: { lv_categoria }| ).
*    out->write( |Precio: { lv_precio_producto } - Comisión: { lv_comision }| ).
*    out->write( | | ).


"COND

 " 8. COND - Determinar prioridad de envío
    "=================================================================
    out->write( '=== COND: PRIORIDAD DE ENVÍO SEGÚN CLIENTE ===' ).

    DATA(lv_tipo_cliente) = 'X'. "VIP, REGULAR, NUEVO

    DATA(lv_prioridad) = COND string(
      WHEN lv_tipo_cliente = 'VIP'     THEN 'ENVÍO EXPRESS - 24 horas'
      WHEN lv_tipo_cliente = 'REGULAR' THEN 'ENVÍO ESTÁNDAR - 3-5 días'
      WHEN lv_tipo_cliente = 'NUEVO'   THEN 'ENVÍO ESTÁNDAR - 5-7 días'
      ELSE                                  'ENVÍO REGULAR - 7-10 días'
    ).

    out->write( |Cliente: { lv_tipo_cliente }| ).
    out->write( |Prioridad: { lv_prioridad }| ).
    out->write( | | ).











  ENDMETHOD.

ENDCLASS.
