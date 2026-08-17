CLASS zcl_sql2_b26 DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    DATA out TYPE REF TO if_oo_adt_classrun_out.

    METHODS titulo IMPORTING iv_texto TYPE string.
    METHODS traza  IMPORTING iv_texto TYPE string.

    METHODS b1_filtros.
    METHODS b2_expresiones.
    METHODS b3_dinamico.
    METHODS b4_multitabla.
ENDCLASS.



CLASS ZCL_SQL2_B26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me->out = out.
    b1_filtros( ).
    b2_expresiones( ).   "" se descomentan a medida que avanza la clase
    b3_dinamico( ).
    b4_multitabla( ).
  ENDMETHOD.


  METHOD titulo.
    out->write( |\n───── { iv_texto } ─────| ).
  ENDMETHOD.


  METHOD traza.
    out->write( |   { iv_texto }  →  sy-subrc = { sy-subrc }, sy-dbcnt = { sy-dbcnt }| ).
  ENDMETHOD.


  METHOD b1_filtros.

    titulo( '1.1 Operadores relacionales' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, emp_role, salary
      WHERE emp_id < 1000
        AND salary > 40000
      ORDER BY salary DESCENDING
      INTO TABLE @DATA(lt_mayores).

    out->write( lt_mayores ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, emp_role
      WHERE emp_id  < 1000
        AND emp_role <> 'Developer'
      INTO TABLE @DATA(lt_no_dev).

    out->write( lt_no_dev ).

    titulo( '1.2 BETWEEN' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, salary
      WHERE emp_id  < 1000
        AND salary BETWEEN 30000 AND 42000
      ORDER BY salary
      INTO TABLE @DATA(lt_banda).

    out->write( lt_banda ).

    DATA lv_desde TYPE d VALUE '20180101'.
    DATA lv_hasta TYPE d VALUE '20211231'.

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, hire_date
      WHERE emp_id    < 1000
        AND hire_date BETWEEN @lv_desde AND @lv_hasta
      ORDER BY hire_date
      INTO TABLE @DATA(lt_periodo).

    out->write( lt_periodo ).

    titulo( '1.3 LIKE' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name
      WHERE emp_id    < 1000
        AND last_name LIKE 'G%'
      INTO TABLE @DATA(lt_g).

    out->write( lt_g ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, emp_role
      WHERE emp_id   < 1000
        AND emp_role LIKE '%ant%'
      INTO TABLE @DATA(lt_ant).

    out->write( lt_ant ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, dept_id
      WHERE emp_id  < 1000
        AND dept_id LIKE '_E_%'
      INTO TABLE @DATA(lt_patron).

    out->write( lt_patron ).

    titulo( '1.4 ESCAPE' ).

    " Sin escape: el _ y el % se interpretan como comodines
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name
      WHERE emp_id    < 1000
        AND last_name LIKE '%_%'
      INTO TABLE @DATA(lt_sin_escape).

    traza( |LIKE '%_%' sin escape| ).
    out->write( lt_sin_escape ).

    " Con escape: buscamos un guion bajo LITERAL
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name
      WHERE emp_id    < 1000
        AND last_name LIKE '%#_%' ESCAPE '#'
      INTO TABLE @DATA(lt_con_escape).

    traza( |LIKE '%#_%' ESCAPE '#'| ).
    out->write( lt_con_escape ).

    " Y ahora el porcentaje literal
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name
      WHERE emp_id    < 1000
        AND last_name LIKE '%#%%' ESCAPE '#'
      INTO TABLE @DATA(lt_porcentaje).

    out->write( lt_porcentaje ).



    titulo( '1.5 IN con lista' ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, dept_id
      WHERE emp_id  < 1000
        AND dept_id IN ( 'DEV', 'QAS' )
      ORDER BY dept_id, emp_id
      INTO TABLE @DATA(lt_in).

    out->write( lt_in ).

    titulo( '1.6 IN con tabla de rangos' ).

    DATA lt_rango_sal TYPE RANGE OF zsql_emp_b26-salary.

    lt_rango_sal = VALUE #( sign = 'I'
                            ( option = 'BT' low = '30000.00' high = '40000.00' )
                            ( option = 'GE' low = '58000.00' ) ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, salary
      WHERE emp_id < 1000
        AND salary IN @lt_rango_sal
      ORDER BY salary
      INTO TABLE @DATA(lt_por_rango).

    out->write( lt_por_rango ).

    " Excluir: el mismo mecanismo, con sign = 'E'
    DATA lt_rango_dep TYPE RANGE OF zsql_emp_b26-dept_id.

    lt_rango_dep = VALUE #( ( sign = 'I' option = 'CP' low = '*E*' )
                            ( sign = 'E' option = 'EQ' low = 'DEV' ) ).

    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, dept_id
      WHERE emp_id  < 1000
        AND dept_id IN @lt_rango_dep
      INTO TABLE @DATA(lt_excl).

    out->write( lt_excl ).

    titulo( '1.7 NULL vs INITIAL' ).

    " Nuria (6) no tiene departamento: el campo está VACÍO, no es NULL
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, dept_id
      WHERE emp_id  < 1000
        AND dept_id IS INITIAL
      INTO TABLE @DATA(lt_sin_dep).

    traza( 'IS INITIAL' ).
    out->write( lt_sin_dep ).

    " Lo mismo con IS NULL: no encuentra nada
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, dept_id
      WHERE emp_id  < 1000
        AND dept_id IS NULL
      INTO TABLE @DATA(lt_nulos).

    traza( 'IS NULL' ).
    out->write( lt_nulos ).

    titulo( '1.8 AND / OR / NOT' ).

    " SIN paréntesis: AND tiene más prioridad que OR  →  resultado inesperado
    SELECT FROM zsql_emp_b26
      FIELDS COUNT(*)
      WHERE emp_id < 1000
        AND city   = 'Madrid'
         OR city   = 'Barcelona'
        AND salary > 50000
      INTO @DATA(lv_trampa).

    " CON paréntesis: dice lo que queríamos decir
    SELECT FROM zsql_emp_b26
      FIELDS COUNT(*)
      WHERE emp_id  < 1000
        AND ( city  = 'Madrid' OR city = 'Barcelona' )
        AND salary  > 50000
      INTO @DATA(lv_correcto).

    out->write( |Sin parentesis: { lv_trampa } filas| ).
    out->write( |Con parentesis: { lv_correcto } filas| ).

    " Y ahora sí, el resultado bueno con detalle
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, city, salary
      WHERE emp_id  < 1000
        AND ( city  = 'Madrid' OR city = 'Barcelona' )
        AND salary  > 50000
      ORDER BY emp_id
      INTO TABLE @DATA(lt_correcto).

    out->write( lt_correcto ).

    " NOT
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, city
      WHERE emp_id < 1000
        AND NOT ( city = 'Madrid' )
      INTO TABLE @DATA(lt_not).

    out->write( lt_not ).

*    "  Sumar en ABAP: 50.000 filas viajan para obtener UN número
*    SELECT FROM zsql_emp_b26
*      FIELDS salary
*      INTO TABLE @DATA(lt_salarios).
*
*    DATA lv_total TYPE p LENGTH 15 DECIMALS 2.
*    LOOP AT lt_salarios INTO DATA(ls).
*      lv_total = lv_total + ls-salary.
*    ENDLOOP.
*
*    "  Sumar en la base de datos: viaja UN número
*    SELECT FROM zsql_emp_b26
*      FIELDS SUM( CAST( salary AS DEC( 15,2 ) ) ) AS total
*      INTO @DATA(lv_total_db).

  ENDMETHOD.


  METHOD b2_expresiones.

    titulo( '2.1 Funciones de agregacion' ).

    SELECT FROM zsql_emp_b26
      FIELDS COUNT(*)                              AS cuantos,
             COUNT( DISTINCT dept_id )             AS cuantos_dept,
             MIN( salary )                         AS minimo,
             MAX( salary )                         AS maximo,
             SUM( CAST( salary AS DEC( 15,2 ) ) )  AS total,
             AVG( salary AS DEC( 11,2 ) )          AS media
      WHERE  active = 'X'
      INTO @DATA(ls_resumen).

    out->write( ls_resumen ).

    titulo( '2.2 DISTINCT' ).

    SELECT FROM  zsql_emp_b26
      FIELDS DISTINCT city, emp_role
      WHERE  emp_id < 1000
      ORDER BY city, emp_role
      INTO TABLE @DATA(lt_combi).

    out->write( lt_combi ).


    titulo( '2.3 GROUP BY + HAVING' ).

    SELECT FROM zsql_emp_b26
      FIELDS dept_id,
             COUNT(*)                     AS empleados,
             AVG( salary AS DEC( 11,2 ) ) AS media,
             MAX( salary )                AS mejor_pagado
      WHERE  active = 'X'
      GROUP BY dept_id
      ORDER BY dept_id
      INTO TABLE @DATA(lt_por_dept).

    out->write( lt_por_dept ).

    " HAVING: filtrar los GRUPOS, no las filas
    SELECT FROM zsql_emp_b26
      FIELDS dept_id,
             COUNT(*)                     AS empleados,
             AVG( salary AS DEC( 11,2 ) ) AS media
      WHERE  active = 'X'
      GROUP BY dept_id
      HAVING COUNT(*) > 5000
      ORDER BY empleados DESCENDING
      INTO TABLE @DATA(lt_grandes).

    out->write( lt_grandes ).

    titulo( '2.4 ORDER BY + OFFSET' ).

    " Top 5 de los mejor pagados
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, dept_id, salary
      WHERE  active = 'X'
      ORDER BY salary DESCENDING, emp_id ASCENDING
      INTO TABLE @DATA(lt_top)
      UP TO 5 ROWS.

    traza( 'Top 5' ).
    out->write( lt_top ).

    " Página 2: saltar 5 y coger los 5 siguientes
    SELECT FROM zsql_emp_b26
      FIELDS emp_id, last_name, dept_id, salary
      WHERE  active = 'X'
      ORDER BY salary DESCENDING, emp_id ASCENDING
      INTO TABLE @DATA(lt_pag2)
      UP TO 5 ROWS
      OFFSET 5.

    traza( 'Pagina 2' ).
    out->write( lt_pag2 ).



  ENDMETHOD.


  METHOD b3_dinamico.

    titulo( '3.1 Fuente y WHERE dinamicos' ).

    DATA lv_tabla TYPE string VALUE 'ZSQL_DEPT_B26'.
    DATA lt_where TYPE string_table.
    DATA lr_datos TYPE REF TO data.

    FIELD-SYMBOLS <lt_result> TYPE STANDARD TABLE.

    lt_where = VALUE #( ( `CITY = 'Madrid'` )
                        ( `AND BUDGET > 100000` ) ).

    " Creamos el contenedor con la forma de la tabla, en ejecución
    CREATE DATA lr_datos TYPE TABLE OF (lv_tabla).
    ASSIGN lr_datos->* TO <lt_result>.

    SELECT FROM (lv_tabla)
      FIELDS *
      WHERE (lt_where)
      INTO TABLE @<lt_result>.

    traza( |Leido de { lv_tabla }| ).
    out->write( <lt_result> ).


    titulo( '3.3 Un visor generico (y como protegerlo)' ).

    DATA lv_tab_usuario TYPE string VALUE 'ZSQL_DEPT_B26'.  " vendría de fuera
    DATA lv_campo       TYPE string VALUE 'CITY'.
    DATA lv_valor       TYPE string VALUE 'Madrid'.

    " 1 · Lista blanca: SOLO estas tablas se pueden consultar
    DATA(lt_permitidas) = VALUE string_table( ( `ZSQL_EMP_B26` )
                                              ( `ZSQL_DEPT_B26` ) ).

    IF NOT line_exists( lt_permitidas[ table_line = to_upper( lv_tab_usuario ) ] ).
      out->write( 'Tabla no permitida' ).
      RETURN.
    ENDIF.

    " 2 · El valor se entrecomilla escapando las comillas
    DATA(lv_cond) = |{ to_upper( lv_campo ) } = '{ replace( val  = lv_valor
                                                            sub  = |'|
                                                            with = |''|
                                                            occ  = 0 ) }'|.

    DATA lr_ref TYPE REF TO data.
    FIELD-SYMBOLS <lt_gen> TYPE STANDARD TABLE.

    CREATE DATA lr_ref TYPE TABLE OF (lv_tab_usuario).
    ASSIGN lr_ref->* TO <lt_gen>.

    SELECT FROM (lv_tab_usuario)
      FIELDS *
      WHERE (lv_cond)
      INTO TABLE @<lt_gen>
      UP TO 20 ROWS.

    out->write( <lt_gen> ).

  ENDMETHOD.


  METHOD b4_multitabla.

*    "  ❌ La mala: leer y luego buscar dentro de un bucle
*
*    SELECT FROM zsql_emp_b26 FIELDS * INTO TABLE @DATA(lt_emp).
*    LOOP AT lt_emp INTO DATA(ls_emp).
*      SELECT SINGLE FROM zsql_dept_b26          " <-- un viaje POR CADA empleado
*        FIELDS dept_name
*        WHERE dept_id = @ls_emp-dept_id
*        INTO @DATA(lv_nombre).
*    ENDLOOP.
*
*    "  ✅ La buena: un JOIN, un viaje
*    SELECT FROM zsql_emp_b26 AS e
*           INNER JOIN zsql_dept_b26 AS d ON d~dept_id = e~dept_id
*      FIELDS e~last_name, d~dept_name
*      INTO TABLE @DATA(lt_junto).


  titulo( '4.1 Alias' ).

  SELECT FROM zsql_emp_b26 AS e
    FIELDS e~emp_id      AS id,
           e~last_name   AS apellido,
           e~salary      AS sueldo
    WHERE  e~emp_id < 1000
    INTO TABLE @DATA(lt_alias).

  out->write( lt_alias ).

 titulo( '4.2 Subconsultas' ).

  " a) Escalar: los que ganan más que la media general
  SELECT FROM zsql_emp_b26
    FIELDS emp_id, last_name, salary
    WHERE  emp_id < 1000
      AND  salary > ( SELECT AVG( salary AS DEC( 11,2 ) ) FROM zsql_emp_b26 )
    ORDER BY salary DESCENDING
    INTO TABLE @DATA(lt_sobre_media).

  out->write( lt_sobre_media ).

  " b) ALL: gana más que TODOS los Developer
  SELECT FROM zsql_emp_b26
    FIELDS emp_id, last_name, salary
    WHERE  emp_id < 1000
      AND  salary > ALL ( SELECT salary FROM zsql_emp_b26
                           WHERE emp_role = 'Developer' AND emp_id < 1000 )
    INTO TABLE @DATA(lt_all).

  out->write( lt_all ).

  " c) ANY / SOME: gana más que ALGUNO de los Manager
  SELECT FROM zsql_emp_b26
    FIELDS emp_id, last_name, salary
    WHERE  emp_id < 1000
      AND  salary > ANY ( SELECT salary FROM zsql_emp_b26
                           WHERE emp_role = 'Manager' AND emp_id < 1000 )
    INTO TABLE @DATA(lt_any).

  out->write( lt_any ).

  " d) EXISTS: departamentos que TIENEN gente
  SELECT FROM zsql_dept_b26 AS d
    FIELDS d~dept_id, d~dept_name
    WHERE  EXISTS ( SELECT * FROM zsql_emp_b26 AS e
                     WHERE e~dept_id = d~dept_id )
    ORDER BY d~dept_id
    INTO TABLE @DATA(lt_con_gente).

  out->write( lt_con_gente ).

  " e) NOT EXISTS: departamentos VACÍOS
  SELECT FROM zsql_dept_b26 AS d
    FIELDS d~dept_id, d~dept_name
    WHERE  NOT EXISTS ( SELECT * FROM zsql_emp_b26 AS e
                         WHERE e~dept_id = d~dept_id )
    ORDER BY d~dept_id
    INTO TABLE @DATA(lt_vacios).

  out->write( lt_vacios ).

  " f) IN con subconsulta: empleados de departamentos de Madrid
  SELECT FROM zsql_emp_b26
    FIELDS emp_id, last_name, dept_id
    WHERE  emp_id  < 1000
      AND  dept_id IN ( SELECT dept_id FROM zsql_dept_b26
                         WHERE city = 'Madrid' )
    INTO TABLE @DATA(lt_madrid).

  out->write( lt_madrid ).


titulo( '4.3 INNER JOIN' ).

  SELECT FROM zsql_emp_b26 AS e
         INNER JOIN zsql_dept_b26 AS d ON d~dept_id = e~dept_id
    FIELDS e~emp_id,
           e~last_name,
           e~city      AS ciudad_empleado,
           d~dept_name,
           d~city      AS ciudad_departamento
    WHERE  e~emp_id < 1000
    ORDER BY e~emp_id
    INTO TABLE @DATA(lt_inner).

  out->write( lt_inner ).

titulo( '4.4 LEFT y RIGHT OUTER JOIN' ).

  " LEFT: TODOS los empleados, tengan o no departamento
  SELECT FROM zsql_emp_b26 AS e
         LEFT OUTER JOIN zsql_dept_b26 AS d ON d~dept_id = e~dept_id
    FIELDS e~emp_id,
           e~last_name,
           e~dept_id,
           d~dept_name
    WHERE  e~emp_id < 1000
    ORDER BY e~emp_id
    INTO TABLE @DATA(lt_left).

  out->write( lt_left ).

  " RIGHT: TODOS los departamentos, tengan o no empleados
  SELECT FROM zsql_emp_b26 AS e
         RIGHT OUTER JOIN zsql_dept_b26 AS d ON d~dept_id = e~dept_id
    FIELDS d~dept_id,
           d~dept_name,
           COUNT( e~emp_id ) AS empleados
    GROUP BY d~dept_id, d~dept_name
    ORDER BY d~dept_id
    INTO TABLE @DATA(lt_right).

  out->write( lt_right ).

  " Y exactamente lo mismo, escrito al revés con un LEFT
  SELECT FROM zsql_dept_b26 AS d
         LEFT OUTER JOIN zsql_emp_b26 AS e ON e~dept_id = d~dept_id
    FIELDS d~dept_id,
           d~dept_name,
           COUNT( e~emp_id ) AS empleados
    GROUP BY d~dept_id, d~dept_name
    ORDER BY d~dept_id
    INTO TABLE @DATA(lt_left_dept).

  out->write( lt_left_dept ).

  titulo( '4.5 LEFT y RIGHT EXCLUDING' ).

  " LEFT EXCLUDING: empleados cuyo departamento NO EXISTE  →  los huérfanos
  SELECT FROM zsql_emp_b26 AS e
         LEFT OUTER JOIN zsql_dept_b26 AS d ON d~dept_id = e~dept_id
    FIELDS e~emp_id, e~last_name, e~dept_id
    WHERE  e~emp_id  < 1000
      AND  d~dept_id IS NULL
    INTO TABLE @DATA(lt_huerfanos).

  traza( 'Empleados con departamento inexistente' ).
  out->write( lt_huerfanos ).

  " RIGHT EXCLUDING: departamentos SIN empleados
  SELECT FROM zsql_emp_b26 AS e
         RIGHT OUTER JOIN zsql_dept_b26 AS d ON d~dept_id = e~dept_id
    FIELDS d~dept_id, d~dept_name
    WHERE  e~emp_id IS NULL
    ORDER BY d~dept_id
    INTO TABLE @DATA(lt_dept_vacios).

  traza( 'Departamentos sin nadie' ).
  out->write( lt_dept_vacios ).

titulo( '4.6 CROSS y conciliacion completa' ).

  " CROSS JOIN: producto cartesiano, sin condición ON
  SELECT FROM zsql_emp_b26 AS e
         CROSS JOIN zsql_dept_b26 AS d
    FIELDS e~last_name, d~dept_name
    WHERE  e~emp_id < 1000
    INTO TABLE @DATA(lt_cross).

  traza( |CROSS: { lines( lt_cross ) } filas (9 x 9)| ).
  out->write( lt_cross ).

  " ABAP SQL NO admite FULL OUTER JOIN.
  " Equivalencia: LEFT OUTER + departamentos sin pareja, unidos con UNION ALL.

  SELECT FROM zsql_emp_b26 AS e
         LEFT OUTER JOIN zsql_dept_b26 AS d ON d~dept_id = e~dept_id
    FIELDS e~dept_id AS en_empleados,
           d~dept_id AS en_departamentos,
           COUNT(*)  AS cuantos
    GROUP BY e~dept_id, d~dept_id
  UNION ALL
  SELECT FROM zsql_dept_b26 AS d
         LEFT OUTER JOIN zsql_emp_b26 AS e ON e~dept_id = d~dept_id
    FIELDS CAST( ' ' AS CHAR( 4 ) ) AS en_empleados,
           d~dept_id               AS en_departamentos,
           COUNT( e~emp_id )       AS cuantos
    WHERE e~emp_id IS NULL
    GROUP BY d~dept_id
    INTO TABLE @DATA(lt_conciliacion).

  out->write( lt_conciliacion ).

    ENDMETHOD.
ENDCLASS.
