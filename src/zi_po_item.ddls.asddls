@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'item data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #B,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_po_item as select from zpurchase_item
association to parent zi_po_header as _Header on $projection.purchase_doc = _Header.purchase_doc
 {
    key purchase_doc,
    key purchase_item ,
    short_text ,
    
    @Semantics.amount.currencyCode : 'currency'
    price,
    currency,
    @Semantics.quantity.unitOfMeasure: 'unit'
    quantity,
    unit,
    @Semantics.systemDateTime.lastChangedAt: true
    change_date_time,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_change_date_time,
    _Header
}
