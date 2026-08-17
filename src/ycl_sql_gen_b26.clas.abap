CLASS ycl_sql_gen_b26 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS YCL_SQL_GEN_B26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_emp TYPE STANDARD TABLE OF zsql_emp_b26 WITH EMPTY KEY.

    DATA(lt_roles)  = VALUE string_table( ( `Developer` ) ( `Consultant` ) ( `Architect` ) ( `Manager` ) ).
    DATA(lt_cities) = VALUE string_table( ( `Madrid` ) ( `Barcelona` ) ( `Sevilla` ) ( `Bilbao` ) ( `Lisboa` ) ).

    DO 50000 TIMES.
      DATA(lv_i) = sy-index.
      APPEND VALUE #( emp_id     = 1000 + lv_i
                      first_name = |Nombre{ lv_i }|
                      last_name  = |Apellido{ lv_i }|
                      emp_role   = lt_roles[ 1 + lv_i MOD 4 ]
                      city       = lt_cities[ 1 + lv_i MOD 5 ]
                      salary     = 25000 + lv_i MOD 30000
                      hire_date  = |20{ 15 + lv_i MOD 10 }0{ 1 + lv_i MOD 9 }15|
                      active     = COND #( WHEN lv_i MOD 7 = 0 THEN '' ELSE 'X' ) ) TO lt_emp.
    ENDDO.

    DELETE FROM zsql_emp_b26 WHERE emp_id >= 1000.

    INSERT zsql_emp_b26 FROM TABLE @lt_emp.

    COMMIT WORK.

    out->write( |Generados { sy-dbcnt } empleados de relleno (emp_id >= 1000)| ).
  ENDMETHOD.
ENDCLASS.
