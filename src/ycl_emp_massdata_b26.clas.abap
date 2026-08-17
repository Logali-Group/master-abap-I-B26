CLASS ycl_emp_massdata_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_EMP_MASSDATA_B26 IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

*    TYPES ty_roles TYPE STANDARD TABLE OF string.
*
*    DATA lt_emp   TYPE STANDARD TABLE OF yemployee_b26.
*
*    DATA lt_roles TYPE ty_roles.
*
*    lt_roles = VALUE #(
*      ( `Developer` ) ( `Consultant` ) ( `Architect` ) ( `Manager` ) ).
*
*    DO 100000 TIMES.
*      DATA(lv_i) = sy-index.
*      APPEND VALUE #( emp_id         = lv_i
*                      emp_first_name = |Nombre{ lv_i }|
*                      emp_last_name  = |Apellido{ lv_i }|
*                      emp_age        = 20 + lv_i MOD 40
*                      emp_role       = lt_roles[ 1 + lv_i MOD 4 ]
*                      emp_addr_id    = 1 + lv_i MOD 3
*                      emp_email      = |emp{ lv_i }@test.com|
*                      emp_salary     = CONV #( 24000 + lv_i MOD 36000 )
*                      emp_currency   = 'EUR' ) TO lt_emp.
*    ENDDO.
*
*    MODIFY yemployee_b26 FROM TABLE @lt_emp.
*    COMMIT WORK.
*    out->write( |Insertados { lines( lt_emp ) } empleados| ).

*    DATA lv_begin TYPE timestampl.
*    DATA lv_end   TYPE timestampl.
*
*    GET TIME STAMP FIELD lv_begin.
*
*    SELECT FROM yemployee_b26
*      FIELDS emp_currency,
*             SUM( emp_salary ) AS total_salary
*      GROUP BY emp_currency
*      INTO TABLE @DATA(lt_salary).
*
*    GET TIME STAMP FIELD lv_end.
*    DATA(lv_seconds) = cl_abap_tstmp=>subtract(
*      tstmp1 = lv_end
*      tstmp2 = lv_begin ).
*
*    out->write( lt_salary ).
*    out->write( |Tiempo de la consulta: { lv_seconds DECIMALS = 6 } s| ).

MODIFY yaddress_b26 FROM TABLE @( VALUE #(
  ( addr_id = '00001' emp_id = 1 address_type = 'HOME' street_name = 'Gran Via'     house_number = '1'
    postal_code = '28013' city = 'Madrid'          country = 'ES' )
  ( addr_id = '00002' emp_id = 1 address_type = 'WORK' street_name = 'Calle Mayor' house_number = '22'
    postal_code = '28013' city = 'Madrid'          country = 'ES' )
  ( addr_id = '00003' emp_id = 2 address_type = 'HOME' street_name = 'Avenida Diagonal' house_number = '5'
    postal_code = '08019' city = 'Barcelona'       country = 'ES' ) ) ).
COMMIT WORK.


ENDMETHOD.
ENDCLASS.
