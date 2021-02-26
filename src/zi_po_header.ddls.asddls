@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'po header'
define root view entity zi_po_header as select from zpurchase_doc
composition[0..*] of zi_po_item as _Item 
association[1] to ZI_RISHI_POStatus as _Status on $projection.po_status = _Status.Status
{
    key purchase_doc ,
    po_desc,
    po_status,
    po_priority,
    ccode ,
    total_poprice,
    zpurchase_doc.currency,
    @Semantics.user.createdBy: true
    create_by,
    @Semantics.systemDateTime.createdAt: true
    created_date_time ,
    @Semantics.systemDateTime.lastChangedAt: true
    changed_date_time ,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    lcl_last_changedtime,
    _Item,
    _Status
}
