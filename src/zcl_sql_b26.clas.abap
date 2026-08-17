CLASS zcl_sql_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES tt_emp TYPE STANDARD TABLE OF zsql_emp_b26 WITH EMPTY KEY.

    DATA out TYPE REF TO if_oo_adt_classrun_out.

    METHODS titulo IMPORTING iv_texto TYPE string.
    METHODS traza  IMPORTING iv_texto TYPE string.
    METHODS reset.
    METHODS b2_insert.
    METHODS b3_update.
    METHODS b4_modify.
    METHODS b5_delete.
    METHODS b6_luw.
    METHODS b7_select.
ENDCLASS.



CLASS ZCL_SQL_B26 IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.
    me->out = out.
    reset( ).
    b2_insert( ).
    b3_update( ).      "" se van descomentando a medida que avanza la clase
    b4_modify( ).
    b5_delete( ).
    b6_luw( ).
     b7_select( ).
  ENDMETHOD.


  METHOD titulo.
    out->write( |\n───── { iv_texto } ─────| ).
  ENDMETHOD.


  METHOD traza.
    out->write( |   { iv_texto }  →  sy-subrc = { sy-subrc }, sy-dbcnt = { sy-dbcnt }| ).
  ENDMETHOD.


  METHOD reset.
    DELETE FROM zsql_emp_b26 WHERE emp_id < 1000.
    COMMIT WORK.
    titulo( 'Escenario reiniciado (emp_id 1..999 vacíos)' ).
  ENDMETHOD.


  METHOD b2_insert.


    "───── 2.1 · Insertar UN registro ─────
    titulo( '2.1 · INSERT de un registro' ).

    DATA(ls_ana) = VALUE zsql_emp_b26( emp_id     = 1
                                       first_name = 'Ana'
                                       last_name  = 'Gómez'
                                       emp_role   = 'Developer'
                                       city       = 'Madrid'
                                       salary     = '32000.00'
                                       hire_date  = '20220301'
                                       active     = 'X' ).

    INSERT zsql_emp_b26 FROM @ls_ana.
    traza( 'Insertamos a Ana' ).
    COMMIT WORK.                      " confirmamos este paso y seguimos

    " la misma clave otra vez: no hay error, solo sy-subrc = 4
    INSERT zsql_emp_b26 FROM @ls_ana.
    traza( 'Insertamos a Ana OTRA VEZ' ).
    COMMIT WORK.

    "───── 2.2 · Insertar VARIOS registros ─────
    titulo( '2.2 · INSERT de varios registros' ).

    DATA(lt_emp) = VALUE tt_emp(
      ( emp_id = 2 first_name = 'Carlos' last_name = 'Ruiz'  emp_role = 'Consultant' city = 'Barcelona' salary = '28000.00' hire_date = '20210915' active = 'X' )
      ( emp_id = 3 first_name = 'Laura'  last_name = 'Pérez' emp_role = 'Manager'    city = 'Sevilla'   salary = '45000.00' hire_date = '20190401' active = 'X' )
      ( emp_id = 4 first_name = 'Marta'  last_name = 'Lopes' emp_role = 'Developer'  city = 'Lisboa'    salary = '31000.00' hire_date = '20230110' active = 'X' ) ).

*    INSERT zsql_emp_b26 FROM TABLE @lt_emp.
*    traza( 'Insertamos 3 empleados de golpe' ).
*    COMMIT WORK.

    "───── 2.3 · Un duplicado dentro del grupo · TRY / CATCH ─────
    titulo( '2.3 · INSERT con un duplicado dentro' ).

    DATA(lt_dup) = VALUE tt_emp(
      ( emp_id = 5 first_name = 'Iván'  last_name = 'Soler' emp_role = 'Architect' city = 'Bilbao'  salary = '52000.00' hire_date = '20180620' active = 'X' )
      ( emp_id = 3 first_name = 'Laura' last_name = 'Pérez' emp_role = 'Manager'   city = 'Sevilla' salary = '45000.00' hire_date = '20190401' active = 'X' )   " ← esta YA existe
      ( emp_id = 6 first_name = 'Nuria' last_name = 'Vidal' emp_role = 'Developer' city = 'Madrid'  salary = '30000.00' hire_date = '20240201' active = 'X' ) ).

    TRY.
        INSERT zsql_emp_b26 FROM TABLE @lt_dup.
        traza( 'Insertamos el grupo con duplicado' ).
        COMMIT WORK.

      CATCH cx_sy_open_sql_db.
        ROLLBACK WORK.                " deshacemos ESTE paso: no queda nada a medias
        out->write( '   Hay una clave repetida → no se ha insertado ninguno de los tres' ).
    ENDTRY.

    "───── 2.4 · La versión tolerante ─────
    titulo( '2.4 · ACCEPTING DUPLICATE KEYS' ).

    INSERT zsql_emp_b26 FROM TABLE @lt_dup ACCEPTING DUPLICATE KEYS.
    traza( 'El mismo grupo, ahora tolerante' ).
    COMMIT WORK.

    SELECT FROM zsql_emp_b26
      FIELDS COUNT(*)
      WHERE emp_id < 1000
      INTO @DATA(lv_total).
    out->write( |   Empleados en el escenario: { lv_total }   (deben ser 6)| ).

  ENDMETHOD.


  METHOD b3_update.


    "───── 3.1 · Actualizar UN registro (fila completa) ─────
    titulo( '3.1 · UPDATE de un registro con área de trabajo' ).

    SELECT SINGLE FROM zsql_emp_b26
      FIELDS *
      WHERE emp_id = 1
      INTO @DATA(ls_emp).

    ls_emp-city   = 'Toledo'.
    ls_emp-salary = ls_emp-salary + 1000.

    UPDATE zsql_emp_b26 FROM @ls_emp.
    traza( 'UPDATE fila completa' ).

    " clave que no existe: no crea nada
    UPDATE zsql_emp_b26 FROM @( VALUE zsql_emp_b26( emp_id = 999 last_name = 'Fantasma' ) ).
    traza( 'UPDATE de una clave inexistente' ).
    COMMIT WORK.

    "───── 3.2 · Actualizar MÚLTIPLES registros ─────
    titulo( '3.2 · UPDATE masivo desde tabla interna' ).

    SELECT FROM zsql_emp_b26
      FIELDS *
      WHERE emp_role = 'Developer' AND emp_id < 1000
      INTO TABLE @DATA(lt_dev).

    LOOP AT lt_dev ASSIGNING FIELD-SYMBOL(<dev>).
      <dev>-salary = <dev>-salary * '1.10'.        " subida del 10 %
    ENDLOOP.

    UPDATE zsql_emp_b26 FROM TABLE @lt_dev.
    traza( 'UPDATE masivo de developers' ).
    COMMIT WORK.

    "───── 3.3 · Actualizar COLUMNAS ─────
    titulo( '3.3 · UPDATE de columnas concretas' ).

    UPDATE zsql_emp_b26
       SET active = 'X',
           city   = 'Madrid'
     WHERE emp_id = 5.
    traza( 'UPDATE SET de dos columnas' ).
    COMMIT WORK.

    "───── 3.4 · Actualizar columnas CON EXPRESIONES ─────
    titulo( '3.4 · UPDATE con expresiones en el SET' ).

    UPDATE zsql_emp_b26
       SET salary = salary + 500
     WHERE emp_role = 'Manager' AND emp_id < 1000.
    traza( 'Subida lineal de 500 a los consultores' ).

    " la variable se tipa DESDE el campo de la tabla: siempre compatible
    DATA lv_bonus TYPE zsql_emp_b26-salary VALUE '250.00'.

    UPDATE zsql_emp_b26
       SET salary = salary + @lv_bonus
     WHERE city = 'Madrid' AND emp_id < 1000.
    traza( 'Bonus por ciudad usando variable host' ).
    COMMIT WORK.

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, emp_role, city, salary
      WHERE emp_id < 1000
      ORDER BY emp_id
      INTO TABLE @DATA(lt_final).
    out->write( lt_final ).


  ENDMETHOD.


  METHOD b4_modify.

    "───── 4.1 · MODIFY de un registro ─────
    titulo( '4.1 · MODIFY de un registro: las dos caras' ).

    DATA(ls_new) = VALUE zsql_emp_b26( emp_id     = 10
                                       first_name = 'Elena'
                                       last_name  = 'Navarro'
                                       emp_role   = 'Developer'
                                       city       = 'Zaragoza'
                                       salary     = '33000.00'
                                       hire_date  = '20250901'
                                       active     = 'X' ).

    MODIFY zsql_emp_b26 FROM @ls_new.
    traza( 'MODIFY 1ª vez (no existía → INSERT)' ).

    ls_new-city = 'Bilbao'.
    MODIFY zsql_emp_b26 FROM @ls_new.
    traza( 'MODIFY 2ª vez (ya existía → UPDATE)' ).

    "───── 4.2 · MODIFY de múltiples registros ─────
    titulo( '4.2 · MODIFY masivo: mezcla de nuevos y existentes' ).

    DATA(lt_mix) = VALUE tt_emp(
      ( emp_id = 1  first_name = 'Ana'  last_name = 'Gómez'   emp_role = 'Architect'  city = 'Toledo'   salary = '38000.00' hire_date = '20220301' active = 'X' )  " existe → UPDATE
      ( emp_id = 11 first_name = 'Hugo' last_name = 'Ferrer'  emp_role = 'Consultant' city = 'Valencia' salary = '27000.00' hire_date = '20250401' active = 'X' )  " nuevo  → INSERT
      ( emp_id = 12 first_name = 'Sara' last_name = 'Iglesias' emp_role = 'Manager'   city = 'Madrid'   salary = '48000.00' hire_date = '20250501' active = 'X' ) ). " nuevo  → INSERT

    MODIFY zsql_emp_b26 FROM TABLE @lt_mix.
    traza( 'MODIFY masivo (1 update + 2 insert en UNA sentencia)' ).

  ENDMETHOD.


  METHOD b5_delete.

*
*    "───── 5.1 · Eliminar UN registro ─────
*    titulo( '5.1 · DELETE de un registro' ).
*
*    DELETE FROM zsql_emp_b26 WHERE emp_id = 12.
*    traza( 'DELETE … WHERE clave' ).
*
*    " variante: la clave viene en un área de trabajo
*    DELETE zsql_emp_b26 FROM @( VALUE zsql_emp_b26( emp_id = 11 ) ).
*    traza( 'DELETE … FROM @wa' ).
*
*    " clave que no existe
*    DELETE FROM zsql_emp_b26 WHERE emp_id = 998.
*    traza( 'DELETE de una clave inexistente' ).
*
*    "───── 5.2 · Eliminar MÚLTIPLES registros ─────
*    titulo( '5.2 · DELETE masivo desde tabla interna' ).
*
*    DATA(lt_bajas) = VALUE tt_emp( ( emp_id = 6 ) ( emp_id = 5 ) ).
*
*    DELETE zsql_emp_b26 FROM TABLE @lt_bajas.
*    traza( 'DELETE … FROM TABLE (solo se usa la clave)' ).
*
*    "───── 5.3 · Eliminar con FILTROS ─────
*    titulo( '5.3 · DELETE con condiciones' ).
*
*    DELETE FROM zsql_emp_b26 WHERE active = '' AND emp_id < 1000.
*    traza( 'Baja de los inactivos' ).
*
*    DELETE FROM zsql_emp_b26 WHERE hire_date < '20200101' AND emp_id < 1000.
*    traza( 'Baja de los anteriores a 2020' ).
*
*    "   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DELETE FROM zsql_emp_b26.   ← SIN WHERE: borra TODA la tabla (del mandante actual)
*
*    SELECT FROM zsql_emp_b26
*      FIELDS COUNT(*)
*      WHERE emp_id < 1000
*      INTO @DATA(lv_quedan).
*    out->write( |   Sobreviven { lv_quedan } registros en el escenario| ).

  ENDMETHOD.


  METHOD b6_luw. " Logical Unit Work o Unidad Lógica de Trabajo
*
*    "───── 6.1 · ROLLBACK WORK ─────
*    titulo( '6.1 · ROLLBACK WORK: deshacer' ).
*
*    SELECT SINGLE FROM zsql_emp_b26
*      FIELDS city
*      WHERE emp_id = 1
*      INTO @DATA(lv_city).
*    out->write( |   Ciudad antes:            { lv_city }| ).
*
*    UPDATE zsql_emp_b26 SET city = 'ERROR-DE-CARGA' WHERE emp_id = 1.
*
*    SELECT SINGLE FROM zsql_emp_b26
*      FIELDS city
*      WHERE emp_id = 1
*      INTO @lv_city.
*    out->write( |   Dentro de la LUW veo:    { lv_city }   ← el cambio ya lo veo YO| ).
*
*    ROLLBACK WORK.
*
*    SELECT SINGLE FROM zsql_emp_b26
*      FIELDS city
*      WHERE emp_id = 1
*      INTO @lv_city.
*    out->write( |   Después del ROLLBACK:    { lv_city }   ← como si nunca hubiera pasado| ).
*
*    "───── 6.2 · COMMIT WORK ─────
*    titulo( '6.2 · COMMIT WORK: confirmar' ).
*
*    UPDATE zsql_emp_b26 SET city = 'Valencia' WHERE emp_id = 1.
*    COMMIT WORK.
*    out->write( |   COMMIT ejecutado → sy-subrc = { sy-subrc }| ).
*
*    ROLLBACK WORK.        " ya no puede deshacer nada: el commit cerró la LUW
*
*    SELECT SINGLE FROM zsql_emp_b26
*      FIELDS city
*      WHERE emp_id = 1
*      INTO @lv_city.
*    out->write( |   Tras COMMIT + ROLLBACK:  { lv_city }   ← el ROLLBACK llega tarde| ).

  ENDMETHOD.


  METHOD b7_select.



    "───── 7.1 · SELECT SINGLE ─────
    titulo( '7.1 · SELECT SINGLE: una fila y punto' ).

    SELECT SINGLE FROM zsql_emp_b26
      FIELDS emp_id, first_name, last_name, salary
      WHERE emp_id = 1
      INTO @DATA(ls_uno).

    out->write( ls_uno ).
    out->write( |   sy-subrc = { sy-subrc } (4 = no encontrado)| ).

    "───── 7.5 · SELECT de columnas concretas ─────
    titulo( '7.5 · Solo las columnas que necesito' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, city
      WHERE emp_id < 1000
      ORDER BY last_name
      INTO TABLE @DATA(lt_cols).
    out->write( lt_cols ).

    "───── 7.3 · INTO TABLE y APPENDING TABLE ─────
    titulo( '7.3 · INTO TABLE vs APPENDING TABLE' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, city
      WHERE city = 'Madrid' AND emp_id < 1000
      INTO TABLE @DATA(lt_acum).
    out->write( |   Tras INTO TABLE:      { lines( lt_acum ) } filas| ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, city
      WHERE city = 'Bilbao' AND emp_id < 1000
      APPENDING TABLE @lt_acum.
    out->write( |   Tras APPENDING TABLE: { lines( lt_acum ) } filas (no se ha vaciado)| ).

    "───── 7.4 · INTO CORRESPONDING FIELDS OF TABLE ─────
    titulo( '7.4 · INTO CORRESPONDING FIELDS: cuando los nombres coinciden' ).

    TYPES: BEGIN OF ty_ficha,
             city      TYPE zsql_emp_b26-city,
             last_name TYPE zsql_emp_b26-last_name,
             etiqueta  TYPE string,          " campo que NO existe en la tabla
           END OF ty_ficha.

    DATA lt_fichas TYPE STANDARD TABLE OF ty_ficha WITH EMPTY KEY.

    SELECT FROM zsql_emp_b26
      FIELDS last_name, city
      WHERE emp_id < 1000
      INTO CORRESPONDING FIELDS OF TABLE @lt_fichas.
    out->write( lt_fichas ).

    "───── 7.6 · UP TO n ROWS ─────
    titulo( '7.6 · UP TO n ROWS: el top 3 de sueldos' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, salary
      ORDER BY salary DESCENDING
      INTO TABLE @DATA(lt_top)
      UP TO 3 ROWS.

    out->write( lt_top ).

    "───── 7.2 · BYPASSING BUFFER ─────
    titulo( '7.2 · BYPASSING BUFFER: ignorar el buffer de tabla' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name
      WHERE emp_id = 1
      INTO TABLE @DATA(lt_sin_buffer)
      BYPASSING BUFFER.
    out->write( |   Leídas { lines( lt_sin_buffer ) } filas directamente de la base de datos| ).

    "───── 7.7 · SELECT … ENDSELECT ─────
    titulo( '7.7 · SELECT / ENDSELECT: fila a fila (y por qué casi nunca)' ).

    DATA lv_suma TYPE p LENGTH 13 DECIMALS 2.
    SELECT FROM zsql_emp_b26
      FIELDS salary
      WHERE emp_id < 1000
      INTO @DATA(lv_sal).

      lv_suma = lv_suma + lv_sal.

    ENDSELECT.
    out->write( |   Suma calculada fila a fila en ABAP:      { lv_suma }| ).

    SELECT FROM zsql_emp_b26
      FIELDS SUM( salary )
      WHERE emp_id < 1000
      INTO @DATA(lv_suma_sql).
    out->write( |   Suma calculada por la base de datos:     { lv_suma_sql }| ).

    "───── 7.8 · PACKAGE SIZE ─────
    titulo( '7.8 · PACKAGE SIZE: 50.000 filas sin reventar la memoria' ).

    DATA lv_paquetes TYPE i.
    DATA lv_filas    TYPE i.

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, salary
      WHERE emp_id >= 1000
      INTO TABLE @DATA(lt_paquete) PACKAGE SIZE 5000.

      lv_paquetes = lv_paquetes + 1.
      lv_filas    = lv_filas + lines( lt_paquete ).
      " aquí se procesaría cada paquete y se liberaría la memoria

    ENDSELECT.

    out->write( |   { lv_paquetes } paquetes · { lv_filas } filas en total| ).

  ENDMETHOD.
ENDCLASS.
