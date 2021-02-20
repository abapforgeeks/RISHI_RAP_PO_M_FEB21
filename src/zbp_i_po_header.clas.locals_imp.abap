CLASS lhc_zi_po_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS copyPO FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseHeader~copyPO RESULT result.

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
    FAILED data(lt_failed)
    REPORTED data(lt_reported).

    "Send back the result
    result = VALUE #( FOR ls_create IN lt_po_data INDEX INTO lv_index
    ( %cid_ref = keys[ lv_index ]-%cid_ref
    %key = keys[ lv_index ]-purchase_doc
    %param = CORRESPONDING #( ls_create ) ) ).


  ENDMETHOD.

ENDCLASS.
