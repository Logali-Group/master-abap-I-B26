CLASS ycl_sql_gen2_b26 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS YCL_SQL_GEN2_B26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " ── 1 · Departamentos (nueve, con estructura de árbol para la clase 12) ──
    DELETE FROM zsql_dept_b26.

    INSERT zsql_dept_b26 FROM TABLE @( VALUE #(
      ( dept_id = 'DIR' dept_name = 'Direccion General'  parent_dept = ''    city = 'Madrid'    budget = '2000000.00' )
      ( dept_id = 'TEC' dept_name = 'Tecnologia'         parent_dept = 'DIR' city = 'Madrid'    budget = '900000.00' )
      ( dept_id = 'DEV' dept_name = 'Desarrollo'         parent_dept = 'TEC' city = 'Madrid'    budget = '450000.00' )
      ( dept_id = 'QAS' dept_name = 'Calidad'            parent_dept = 'TEC' city = 'Barcelona' budget = '200000.00' )
      ( dept_id = 'INF' dept_name = 'Infraestructura'    parent_dept = 'TEC' city = 'Bilbao'    budget = '250000.00' )
      ( dept_id = 'COM' dept_name = 'Comercial'          parent_dept = 'DIR' city = 'Barcelona' budget = '700000.00' )
      ( dept_id = 'VEN' dept_name = 'Ventas'             parent_dept = 'COM' city = 'Sevilla'   budget = '500000.00' )
      ( dept_id = 'MKT' dept_name = 'Marketing'          parent_dept = 'COM' city = 'Madrid'    budget = '200000.00' )
      ( dept_id = 'HUE' dept_name = 'Innovacion'         parent_dept = 'ZZZ' city = 'Lisboa'    budget = '100000.00' ) ) ).

    " ── 2 · Empleados didácticos 1..9 (ahora con departamento) ──
    DELETE FROM zsql_emp_b26 WHERE emp_id < 1000.

    INSERT zsql_emp_b26 FROM TABLE @( VALUE #(
      ( emp_id = 1 first_name = 'Ana'    last_name = 'Gomez'     emp_role = 'Developer'  city = 'Madrid'    salary = '32000.00' hire_date = '20180315' active = 'X' dept_id = 'DEV' )
      ( emp_id = 2 first_name = 'Carlos' last_name = 'Ruiz'      emp_role = 'Consultant' city = 'Barcelona' salary = '41000.00' hire_date = '20190701' active = 'X' dept_id = 'QAS' )
      ( emp_id = 3 first_name = 'Laura'  last_name = 'Perez'     emp_role = 'Architect'  city = 'Madrid'    salary = '55000.00' hire_date = '20150210' active = 'X' dept_id = 'INF' )
      ( emp_id = 4 first_name = 'Marta'  last_name = 'Diaz'      emp_role = 'Manager'    city = 'Sevilla'   salary = '61000.00' hire_date = '20120901' active = 'X' dept_id = 'VEN' )
      ( emp_id = 5 first_name = 'Ivan'   last_name = 'Lopez'     emp_role = 'Developer'  city = 'Bilbao'    salary = '29500.00' hire_date = '20220105' active = ''  dept_id = 'DEV' )
      ( emp_id = 6 first_name = 'Nuria'  last_name = 'Sanz'      emp_role = 'Consultant' city = 'Lisboa'    salary = '38000.00' hire_date = '20210620' active = 'X' dept_id = ''    )
      ( emp_id = 7 first_name = 'Oscar'  last_name = 'Vidal'     emp_role = 'Developer'  city = 'Madrid'    salary = '33000.00' hire_date = '20230301' active = 'X' dept_id = 'XXX' )
      ( emp_id = 8 first_name = 'Pilar'  last_name = 'Mena'      emp_role = 'Manager'    city = 'Barcelona' salary = '58000.00' hire_date = '20170415' active = 'X' dept_id = 'DEV' )
      ( emp_id = 9 first_name = 'Hugo'   last_name = 'Saez_100%' emp_role = 'Developer'  city = 'Madrid'    salary = '30000.00' hire_date = '20240101' active = 'X' dept_id = 'DEV' ) ) ).

    " ── 3 · Repartimos departamento entre los 50.000 de relleno ──
    UPDATE zsql_emp_b26 SET dept_id = 'DEV' WHERE emp_id >= 1000 AND emp_role = 'Developer'.
    UPDATE zsql_emp_b26 SET dept_id = 'QAS' WHERE emp_id >= 1000 AND emp_role = 'Consultant'.
    UPDATE zsql_emp_b26 SET dept_id = 'INF' WHERE emp_id >= 1000 AND emp_role = 'Architect'.
    UPDATE zsql_emp_b26 SET dept_id = 'VEN' WHERE emp_id >= 1000 AND emp_role = 'Manager'.

    COMMIT WORK.

    SELECT FROM zsql_emp_b26
      FIELDS COUNT(*)
      INTO @DATA(lv_emp).

    SELECT FROM zsql_dept_b26
      FIELDS COUNT(*)
      INTO @DATA(lv_dep).

    out->write( |Laboratorio listo: { lv_emp } empleados, { lv_dep } departamentos| ).
  ENDMETHOD.
ENDCLASS.
