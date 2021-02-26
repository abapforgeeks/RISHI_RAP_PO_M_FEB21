CLASS lhc_purchaseitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calPOTotalPrice FOR DETERMINE ON SAVE
      IMPORTING keys FOR PurchaseItem~calPOTotalPrice .

ENDCLASS.

CLASS lhc_purchaseitem IMPLEMENTATION.

  METHOD calPOTotalPrice.
    DATA: lv_total_price TYPE p DECIMALS 2 LENGTH 8.
    DATA:lt_po_final_data TYPE TABLE FOR UPDATE zi_po_header\\PurchaseHeader.
    "read PO Detatils
    READ ENTITIES OF zi_po_header IN LOCAL MODE ENTITY PurchaseHeader ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_po_data).
    "Cal PO Total Price for all the PO Items
    LOOP AT lt_po_data ASSIGNING FIELD-SYMBOL(<LFS_po_data>).

      READ ENTITIES OF zi_po_header IN LOCAL MODE
        ENTITY PurchaseHeader BY \_Item
          FIELDS ( price currency quantity )
        WITH VALUE #( ( %key = <LFS_po_data>-%key ) )
        RESULT DATA(lt_item_data).
      IF lt_item_data IS NOT INITIAL.
        LOOP AT lt_item_data ASSIGNING FIELD-SYMBOL(<lfs_item>) .
          lv_total_price += <lfs_item>-price * <lfs_item>-quantity.
        ENDLOOP.
        <lfs_po_data>-total_poprice = lv_total_price.
      ENDIF..
      CLEAR lt_item_data.

    ENDLOOP.
"final itab
    lt_po_final_data = VALUE #( FOR ls_header_price IN lt_po_data
( purchase_doc = ls_header_price-purchase_doc
currency = ls_header_price-currency
total_poprice = ls_header_price-total_poprice
%control-total_poprice = if_abap_behv=>mk-on ) ).

"update PO totall price
    MODIFY ENTITIES OF zi_po_header IN LOCAL MODE
    ENTITY PurchaseHeader
    UPDATE FROM lt_po_final_data
    REPORTED DATA(lt_reported).
    reported-purchaseheader = CORRESPONDING #( lt_reported-purchaseheader ).




  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_po_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS copyPO FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseHeader~copyPO RESULT result.
    METHODS validatePOStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR PurchaseHeader~validatePOStatus.

ENDCLASS.

CLASS lhc_zi_po_header IMPLEMENTATION.

  METHOD copyPO.

    SELECT MAX( purchase_doc ) FROM zpurchase_doc INTO @DATA(lv_podocument).
    "Read the PO Document
    READ ENTITIES OF zi_po_header IN LOCAL MODE ENTITY PurchaseHeader
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_po_data).

    "Modify the purchase Document with the maximum one
    LOOP AT lt_po_data ASSIGNING FIELD-SYMBOL(<lfs_podata>).
      lv_podocument = lv_podocument + 1.
      <lfs_podata>-purchase_doc = condense( lv_podocument ).
    ENDLOOP.

    "Create new entry from lt_po_data.
    MODIFY ENTITIES OF zi_po_header IN LOCAL MODE ENTITY PurchaseHeader
    CREATE FIELDS ( purchase_doc
                     po_desc
                     ccode
                     po_status
                     po_priority )
    WITH CORRESPONDING #( lt_po_data )
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    "Send back the result
    result = VALUE #( FOR ls_create IN lt_po_data INDEX INTO lv_index
    ( %cid_ref = keys[ lv_index ]-%cid_ref
    %key = keys[ lv_index ]-purchase_doc
    %param = CORRESPONDING #( ls_create ) ) ).


  ENDMETHOD.

  METHOD validatePOStatus.
    READ ENTITIES OF zi_po_header IN LOCAL MODE
         ENTITY PurchaseHeader
           FIELDS ( po_status )
           WITH CORRESPONDING #( keys )
         RESULT DATA(lt_po_data).

    LOOP AT lt_po_data INTO DATA(ls_po_data).
      CASE ls_po_data-po_status.
        WHEN '1'.  " Created
        WHEN '2'.  " Open
        WHEN '3'.  " In Process

        WHEN OTHERS.
          APPEND VALUE #( %key = ls_po_data-%key ) TO failed-purchaseheader.
          DATA(lo_message) = new_message( id = 'ZRISHI_MSGCL'
                                         number = '001'
                                         severity =  if_abap_behv_message=>severity-error
                                         v1 = ls_po_data-po_status

           ).
          APPEND VALUE #( %key = ls_po_data-%key
                          %msg = lo_message
                          %element-po_status = if_abap_behv=>mk-on ) TO reported-purchaseheader.
      ENDCASE.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
