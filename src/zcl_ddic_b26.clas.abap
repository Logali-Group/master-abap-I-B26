CLASS zcl_ddic_b26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DDIC_B26 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*        DATA(ls_employee) = value zst_employee_b26(
*                                                    employee_id = 1
*                                                    name        = 'Mateo'
*                                                    last_name   = 'García'
*                                                    age         = 30
*                                                    sex         = 'M'
*                                                     address-address_id = 1
*                                                     address-city       = 'New York'
*                                                     address-int_number = 2
*                                                     address-country    = 'US'
*                                                     address-street_name = 'Street 1'  ).
*
*        out->write( ls_employee ).
*
*
*        DATA(ls_employee2) = value zst_employee2_b26(
*                                                    employee_id = 1
*                                                    name        = 'Mateo'
*                                                    last_name   = 'García'
*                                                    age         = 30
*                                                    sex         = 'M'
*                                                    address_id = 1
*                                                    city       = 'New York'
*                                                    int_number = 2
*                                                    country    = 'US'
*                                                    street_name = 'Street 1'  ).
*
*        out->write( ls_employee2 ).


DATA(lt_empl_addr) = VALUE ZTT_EMP_ADDRESS_B26( ( address_id = 1
                                                  city       = 'New York'
                                                  int_number = 2
                                                  country    = 'US'
                                                  street_name = 'Street 1' )
                                               (  address_id = 2
                                                  city       = 'Madrid'
                                                  int_number = 2
                                                  country    = 'ES'
                                                  street_name = 'Street 1' ) ).


out->write( lt_empl_addr ).


        DATA(ls_employee3) = value zst_employee3_b26(
                                                    employee_id = 1
                                                    name        = 'Mateo'
                                                    last_name   = 'García'
                                                    age         = 30
                                                    sex         = 'M' ).
                                                    ls_employee3-address = VALUE #( ( address_id  = 1
                                                                           street_name = 'Street 1'
                                                                           int_number  = 2
                                                                           city        = 'New York'
                                                                           country     = 'US' )
                                                                          ( address_id  = 2
                                                                           street_name = 'Street 2'
                                                                           int_number  = 3
                                                                           city        = 'New York'
                                                                           country     = 'US' )  ).
         out->write( ls_employee3 ).


  ENDMETHOD.
ENDCLASS.
