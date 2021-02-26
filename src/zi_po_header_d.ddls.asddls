@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'po header'
@Metadata.allowExtensions: true
define root view entity ZI_PO_HEADER_D as select from zrishi_d_podoc
composition[0..*] of ZI_PO_ITEM_D as _Item 
association[1] to ZI_RISHI_POStatus as _Status on $projection.po_status = _Status.Status
{
    key purchase_uuid,
    purchase_doc ,
    po_desc,
    po_status,
    po_priority,
    ccode ,
    @Semantics.amount.currencyCode: 'currency'
    zrishi_d_podoc.total_poprice,
    zrishi_d_podoc.currency,
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
