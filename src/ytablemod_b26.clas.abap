CLASS ytablemod_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YTABLEMOD_B26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

 MODIFY yemployee_b26 FROM TABLE @( VALUE #( (   emp_id        = 1
                                                 emp_first_name = 'Ana'
                                                 emp_last_name  = 'Gomez'
                                                 emp_age        = 28
                                                 emp_role       = 'Consultant'
                                                 emp_addr_id    = '10'
                                                 emp_email      = 'ana.gomez@test.com' )
                                               ( emp_id         = 2
                                                 emp_first_name = 'Carlos'
                                                 emp_last_name  = 'Ruiz'
                                                 emp_age        = 35
                                                 emp_role       = 'Architect'
                                                 emp_addr_id    = '20'
                                                 emp_email      = 'carlos.ruiz@test.com' )
                                               ( emp_id         = 3
                                                 emp_first_name = 'Laura'
                                                 emp_last_name  = 'Perez'
                                                 emp_age        = 42
                                                 emp_role       = 'Manager'
                                                 emp_addr_id    = '30'
                                                 emp_email      = 'laura.perez@test.com' ) ) ).




  ENDMETHOD.
ENDCLASS.
