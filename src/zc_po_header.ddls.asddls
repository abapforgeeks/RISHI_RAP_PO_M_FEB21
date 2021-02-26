@EndUserText.label: 'Header Info'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity zc_po_header as projection on zi_po_header {
@ObjectModel.text.element: ['po_desc']
 key purchase_doc,
 @Search:{defaultSearchElement: true, fuzzinessThreshold: 0.7,ranking: #HIGH }
 @Semantics.text: true
 po_desc,
 @Consumption.valueHelpDefinition: [{ entity:{ name:'ZC_POSTATUSVH',element: 'Status' } }]
 po_status,
 po_priority,
 ccode,
 create_by,
 created_date_time,
 changed_date_time,
 lcl_last_changedtime,
 _Status,
 total_poprice,
 currency,
 /* Associations */
 _Item   : redirected to composition child zc_po_item
}
