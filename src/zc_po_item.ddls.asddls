@EndUserText.label: 'Purchase Item'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity zc_po_item as projection on zi_po_item {
    key purchase_doc,
    key purchase_item,
    short_text,
    price,
    currency,
    quantity,
    unit,
    change_date_time,
    local_change_date_time,
    /* Associations */
    _Header : redirected to parent zc_po_header 
}
