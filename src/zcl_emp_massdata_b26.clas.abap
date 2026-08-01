CLASS zcl_emp_massdata_b26 DEFINITION
PUBLIC
FINAL
CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_emp_massdata_b26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    TYPES ty_roles TYPE STANDARD TABLE OF string.
*
*    DATA lt_emp TYPE STANDARD TABLE OF zemployee_b26.
*
*    DATA lt_roles TYPE ty_roles.
*
*    DATA lt_currencies TYPE ty_roles.
*
*    lt_roles = VALUE #(
*
*    ( `Developer` ) ( `Consultant` ) ( `Architect` ) ( `Manager` ) ).
*
*    lt_currencies = VALUE #( ( `EUR` ) ( `USD` ) ( `GBP` ) ).
*
*
*    DO 100000 TIMES.
*
*      DATA(lv_i) = sy-index.
*
*      APPEND VALUE #( emp_id = lv_i
*
*      emp_first_name = |Nombre{ lv_i }|
*
*      emp_last_name = |Apellido{ lv_i }|
*
*      emp_age = 20 + lv_i MOD 40
*
*      emp_role = lt_roles[ 1 + lv_i MOD 4 ]
*
*      emp_addr_id = 1 + lv_i MOD 3
*
*      emp_email = |emp{ lv_i }@test.com|
*
*      emp_salary = CONV #( 24000 + lv_i MOD 36000 )
*
*      emp_currency = lt_currencies[ 1 + lv_i MOD 3 ] ) TO lt_emp.
*
*    ENDDO.
*
*
*    MODIFY zemployee_b26 FROM TABLE @lt_emp.
*
*    COMMIT WORK.
*
*    out->write( |Insertados { lines( lt_emp ) } empleados| ).
*



" `sum`, `avg`, `min`, `max`, `count(arg)`, `count(*)`

    DATA lv_begin TYPE timestampl.
    DATA lv_end   TYPE timestampl.

    GET TIME STAMP FIELD lv_begin.

    SELECT FROM zemployee_b26
      FIELDS emp_currency,
             SUM( emp_salary ) AS total_salary
      GROUP BY emp_currency
      INTO TABLE @DATA(lt_salary).

    GET TIME STAMP FIELD lv_end.

    DATA(lv_seconds) = cl_abap_tstmp=>subtract(
      tstmp1 = lv_end
      tstmp2 = lv_begin ).

    out->write( lt_salary ).
    out->write( |Tiempo de la consulta: { lv_seconds DECIMALS = 6 } s| ).



  ENDMETHOD.

ENDCLASS.
