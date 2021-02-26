@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'item data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #B,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity ZI_PO_ITEM_D as select from zrishi_d_poitem
association to parent ZI_PO_HEADER_D as _Header on $projection.parent_uuid = _Header.purchase_uuid
 {
    key item_uuid,
    parent_uuid,
    purchase_item ,
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
