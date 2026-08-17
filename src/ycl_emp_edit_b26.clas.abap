CLASS ycl_emp_edit_b26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.
    CONSTANTS c_lock_object TYPE if_abap_lock_object=>tv_name VALUE 'EYEMPLOYEE_B26'.
ENDCLASS.



CLASS YCL_EMP_EDIT_B26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( |El proceso se ha iniciado| ).

    DATA lv_emp_id TYPE yemployee_b26-emp_id VALUE 1.

    TRY.
        " 1 · Obtener la instancia del objeto de bloqueo
        DATA(lo_lock) = cl_abap_lock_object_factory=>get_instance( iv_name = c_lock_object ).

        " 2 · SOLICITAR el bloqueo para UN registro concreto
        lo_lock->enqueue(
          it_parameter = VALUE #( ( name = 'EMP_ID' value = REF #( lv_emp_id ) ) )
          it_table_mode = VALUE #( ( table_name = 'YEMPLOYEE_B26'
                                     mode       = if_abap_lock_object=>cs_mode-write_lock ) )
          _scope       = if_abap_lock_object=>cs_scope-no_update_program ).

        out->write( |Bloqueo OK sobre el empleado { lv_emp_id }. Usuario: { sy-uname }| ).

        " 3 · Trabajo "de negocio" mientras el registro está protegido
        UPDATE yemployee_b26
           SET emp_role = 'Manager'
         WHERE emp_id   = @lv_emp_id.
        COMMIT WORK.

        out->write( 'Registro modificado. Mantengo el bloqueo 30 segundos...' ).
        WAIT UP TO 30 SECONDS.          "  ← ventana para la simulación multiusuario

        " 4 · LIBERAR el bloqueo
        lo_lock->dequeue(
          it_parameter = VALUE #( ( name = 'EMP_ID' value = REF #( lv_emp_id ) ) )
          _scope       = if_abap_lock_object=>cs_scope-no_update_program ).

        out->write( 'Bloqueo liberado.' ).

      CATCH cx_abap_foreign_lock INTO DATA(lx_foreign).
        out->write( |El registro { lv_emp_id } está bloqueado por: { lx_foreign->user_name }| ).

      CATCH cx_abap_lock_failure INTO DATA(lx_failure).
        out->write( |Error técnico de bloqueo: { lx_failure->get_text( ) }| ).

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
