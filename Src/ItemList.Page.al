// page 31 "Item List"
// {
//     Caption = 'Items';
//     CardPageID = "Item Card";
//     Editable = false;
//     PageType = List;
//     PromotedActionCategories = 'New,Process,Report,Item,History,Special Prices & Discounts,Request Approval,Periodic Activities,Inventory,Attributes';
//     RefreshOnActivate = true;
//     SourceTable = Table27;

//     layout
//     {
//         area(content)
//         {
//             repeater(Item)
//             {
//                 Caption = 'Item';
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the number of the item.';
//                 }
//                 field(Description; Description)
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies a description of the item.';
//                 }
//                 field(Type; Type)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies if the item card represents a physical item (Inventory) or a service (Service).';
//                     Visible = IsFoundationEnabled;
//                 }
//                 field(Inventory; Inventory)
//                 {
//                     ApplicationArea = Basic, Suite, Invoicing;
//                     HideValue = IsService;
//                     ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
//                 }
//                 field("Created From Nonstock Item"; "Created From Nonstock Item")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies that the item was created from a nonstock item.';
//                     Visible = false;
//                 }
//                 field("Substitutes Exist"; "Substitutes Exist")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies that a substitute exists for this item.';
//                 }
//                 field("Stockkeeping Unit Exists"; "Stockkeeping Unit Exists")
//                 {
//                     ApplicationArea = Warehouse;
//                     ToolTip = 'Specifies that a stockkeeping unit exists for this item.';
//                     Visible = false;
//                 }
//                 field("Assembly BOM"; "Assembly BOM")
//                 {
//                     AccessByPermission = TableData 90 = R;
//                     ApplicationArea = Assembly;
//                     ToolTip = 'Specifies if the item is an assembly BOM.';
//                 }
//                 field("Production BOM No."; "Production BOM No.")
//                 {
//                     ApplicationArea = Manufacturing;
//                     ToolTip = 'Specifies the number of the production BOM that the item represents.';
//                 }
//                 field("Routing No."; "Routing No.")
//                 {
//                     ApplicationArea = Manufacturing;
//                     ToolTip = 'Specifies the number of the production routing that the item is used in.';
//                 }
//                 field("Base Unit of Measure"; "Base Unit of Measure")
//                 {
//                     ApplicationArea = Basic, Suite, Invoicing;
//                     ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
//                 }
//                 field("Shelf No."; "Shelf No.")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies where to find the item in the warehouse. This is informational only.';
//                     Visible = false;
//                 }
//                 field("Costing Method"; "Costing Method")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies how the item''s cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.';
//                     Visible = false;
//                 }
//                 field("Cost is Adjusted"; "Cost is Adjusted")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies whether the item''s unit cost has been adjusted, either automatically or manually.';
//                 }
//                 field("Standard Cost"; "Standard Cost")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.';
//                     Visible = false;
//                 }
//                 field("Unit Cost"; "Unit Cost")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies the cost per unit of the item.';
//                 }
//                 field("Last Direct Cost"; "Last Direct Cost")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the most recent direct unit cost that was paid for the item.';
//                     Visible = false;
//                 }
//                 field("Price/Profit Calculation"; "Price/Profit Calculation")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.';
//                     Visible = false;
//                 }
//                 field("Profit %"; "Profit %")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
//                     Visible = false;
//                 }
//                 field("Unit Price"; "Unit Price")
//                 {
//                     ApplicationArea = Basic, Suite, Invoicing;
//                     ToolTip = 'Specifies the price for one unit of the item, in LCY.';
//                 }
//                 field("Inventory Posting Group"; "Inventory Posting Group")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
//                     Visible = false;
//                 }
//                 field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
//                     Visible = false;
//                 }
//                 field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
//                     Visible = false;
//                 }
//                 field("Item Disc. Group"; "Item Disc. Group")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
//                     Visible = false;
//                 }
//                 field("Vendor No."; "Vendor No.")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the vendor code of who supplies this item by default.';
//                 }
//                 field("Vendor Item No."; "Vendor Item No.")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the number that the vendor uses for this item.';
//                     Visible = false;
//                 }
//                 field("Tariff No."; "Tariff No.")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies a code for the item''s tariff number.';
//                     Visible = false;
//                 }
//                 field("Search Description"; "Search Description")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies a search description that you use to find the item in lists.';
//                 }
//                 field("Overhead Rate"; "Overhead Rate")
//                 {
//                     ApplicationArea = Manufacturing;
//                     ToolTip = 'Specifies the item''s indirect cost as an absolute amount.';
//                     Visible = false;
//                 }
//                 field("Indirect Cost %"; "Indirect Cost %")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
//                     Visible = false;
//                 }
//                 field("Item Category Code"; "Item Category Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
//                     Visible = false;
//                 }
//                 field("Product Group Code"; "Product Group Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies a product group code associated with the item category.';
//                     Visible = false;
//                 }
//                 field(Blocked; Blocked)
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies that transactions with the item cannot be posted, for example, because the item is in quarantine.';
//                     Visible = false;
//                 }
//                 field("Last Date Modified"; "Last Date Modified")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies when the item card was last modified.';
//                     Visible = false;
//                 }
//                 field("Sales Unit of Measure"; "Sales Unit of Measure")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the unit of measure code used when you sell the item.';
//                     Visible = false;
//                 }
//                 field("Replenishment System"; "Replenishment System")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the type of supply order created by the planning system when the item needs to be replenished.';
//                     Visible = false;
//                 }
//                 field("Purch. Unit of Measure"; "Purch. Unit of Measure")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
//                     Visible = false;
//                 }
//                 field("Lead Time Calculation"; "Lead Time Calculation")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
//                     Visible = false;
//                 }
//                 field("Manufacturing Policy"; "Manufacturing Policy")
//                 {
//                     ApplicationArea = Manufacturing;
//                     ToolTip = 'Specifies if additional orders for any related components are calculated.';
//                     Visible = false;
//                 }
//                 field("Flushing Method"; "Flushing Method")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.';
//                     Visible = false;
//                 }
//                 field("Assembly Policy"; "Assembly Policy")
//                 {
//                     ApplicationArea = Assembly;
//                     ToolTip = 'Specifies which default order flow is used to supply this assembly item.';
//                     Visible = false;
//                 }
//                 field("Item Tracking Code"; "Item Tracking Code")
//                 {
//                     ApplicationArea = ItemTracking;
//                     ToolTip = 'Specifies how items are tracked in the supply chain.';
//                     Visible = false;
//                 }
//                 field("Default Deferral Template Code"; "Default Deferral Template Code")
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Default Deferral Template';
//                     Importance = Additional;
//                     ToolTip = 'Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.';
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part("Power BI Report FactBox"; 6306)
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Power BI Reports';
//                 Visible = PowerBIVisible;
//             }
//             part(; 875)
//             {
//                 ApplicationArea = All;
//                 SubPageLink = Source Type=CONST(Item),
//                               Source No.=FIELD(No.);
//                                              Visible = SocialListeningVisible;
//             }
//             part(; 876)
//             {
//                 ApplicationArea = All;
//                 SubPageLink = Source Type=CONST(Item),
//                               Source No.=FIELD(No.);
//                                              UpdatePropagation = Both;
//                                              Visible = SocialListeningSetupVisible;
//             }
//             part(; 9089)
//             {
//                 ApplicationArea = Advanced;
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//             }
//             part(;9090)
//             {
//                 ApplicationArea = Advanced;
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//                 Visible = false;
//             }
//             part(;9091)
//             {
//                 ApplicationArea = Advanced;
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//             }
//             part(;9109)
//             {
//                 ApplicationArea = Advanced;
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//                 Visible = false;
//             }
//             part(ItemAttributesFactBox;9110)
//             {
//                 ApplicationArea = Basic,Suite;
//             }
//             systempart(;Links)
//             {
//             }
//             systempart(;Notes)
//             {
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             group(Item)
//             {
//                 Caption = 'Item';
//                 Image = DataEntry;
//                 action("&Units of Measure")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = '&Units of Measure';
//                     Image = UnitOfMeasure;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category4;
//                     RunObject = Page 5404;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     Scope = Repeater;
//                     ToolTip = 'Set up the different units that the item can be traded in, such as piece, box, or hour.';
//                 }
//                 action(Attributes)
//                 {
//                     AccessByPermission = TableData 7500=R;
//                     ApplicationArea = Advanced;
//                     Caption = 'Attributes';
//                     Image = Category;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category4;
//                     Scope = Repeater;
//                     ToolTip = 'View or edit the item''s attributes, such as color, size, or other characteristics that help to describe the item.';

//                     trigger OnAction()
//                     begin
//                         PAGE.RUNMODAL(PAGE::"Item Attribute Value Editor",Rec);
//                         CurrPage.SAVERECORD;
//                         CurrPage.ItemAttributesFactBox.PAGE.LoadItemAttributesData("No.");
//                     end;
//                 }
//                 action(FilterByAttributes)
//                 {
//                     AccessByPermission = TableData 7500=R;
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Filter by Attributes';
//                     Image = EditFilter;
//                     Promoted = true;
//                     PromotedCategory = Category10;
//                     PromotedOnly = true;
//                     ToolTip = 'Find items that match specific attributes. To make sure you include recent changes made by other users, clear the filter and then reset it.';

//                     trigger OnAction()
//                     var
//                         ItemAttributeManagement: Codeunit "7500";
//                         TypeHelper: Codeunit "10";
//                         CloseAction: Action;
//                         FilterText: Text;
//                         FilterPageID: Integer;
//                         ParameterCount: Integer;
//                     begin
//                         FilterPageID := PAGE::"Filter Items by Attribute";
//                         IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone THEN
//                           FilterPageID := PAGE::"Filter Items by Att. Phone";

//                         CloseAction := PAGE.RUNMODAL(FilterPageID,TempFilterItemAttributesBuffer);
//                         IF (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Phone) AND (CloseAction <> ACTION::LookupOK) THEN
//                           EXIT;

//                         IF TempFilterItemAttributesBuffer.ISEMPTY THEN BEGIN
//                           ClearAttributesFilter;
//                           EXIT;
//                         END;

//                         TempItemFilteredFromAttributes.RESET;
//                         TempItemFilteredFromAttributes.DELETEALL;
//                         ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer,TempItemFilteredFromAttributes);
//                         FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes,ParameterCount);

//                         IF ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery - 100 THEN BEGIN
//                           FILTERGROUP(0);
//                           MARKEDONLY(FALSE);
//                           SETFILTER("No.",FilterText);
//                         END ELSE BEGIN
//                           RunOnTempRec := TRUE;
//                           CLEARMARKS;
//                           RESET;
//                         END;
//                     end;
//                 }
//                 action(ClearAttributes)
//                 {
//                     AccessByPermission = TableData 7500=R;
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Clear Attributes Filter';
//                     Image = RemoveFilterLines;
//                     Promoted = true;
//                     PromotedCategory = Category10;
//                     PromotedOnly = true;
//                     ToolTip = 'Remove the filter for specific item attributes.';

//                     trigger OnAction()
//                     begin
//                         ClearAttributesFilter;
//                         TempItemFilteredFromAttributes.RESET;
//                         TempItemFilteredFromAttributes.DELETEALL;
//                         RunOnTempRec := FALSE;

//                         RestoreTempItemFilteredFromAttributes;
//                     end;
//                 }
//                 action("Va&riants")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Va&riants';
//                     Image = ItemVariant;
//                     RunObject = Page 5401;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     ToolTip = 'View how the inventory level of an item will develop over time according to the variant that you select.';
//                 }
//                 action("Substituti&ons")
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Substituti&ons';
//                     Image = ItemSubstitution;
//                     RunObject = Page 5716;
//                                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     ToolTip = 'View substitute items that are set up to be sold instead of the item.';
//                 }
//                 action(Identifiers)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Identifiers';
//                     Image = BarCode;
//                     RunObject = Page 7706;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.,Variant Code,Unit of Measure Code);
//                     ToolTip = 'View a unique identifier for each item that you want warehouse employees to keep track of within the warehouse when using handheld devices. The item identifier can include the item number, the variant code and the unit of measure.';
//                 }
//                 action("Cross Re&ferences")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Cross Re&ferences';
//                     Image = Change;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedOnly = true;
//                     RunObject = Page 5721;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     Scope = Repeater;
//                     ToolTip = 'Set up a customer''s or vendor''s own identification of the selected item. Cross-references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
//                 }
//                 action("E&xtended Texts")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'E&xtended Texts';
//                     Image = Text;
//                     RunObject = Page 391;
//                                     RunPageLink = Table Name=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
//                     Scope = Repeater;
//                     ToolTip = 'Select or set up additional text for the description of the item. Extended text can be inserted under the Description field on document lines for the item.';
//                 }
//                 action("Export Item")
//                 {

//                     trigger OnAction()
//                     var
//                         ExportItems: Codeunit "50002";
//                     begin
//                         CLEAR(ExportItems);
//                         ExportItems."Export Items"(Rec);
//                     end;
//                 }
//                 action(Translations)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Translations';
//                     Image = Translations;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category4;
//                     RunObject = Page 35;
//                                     RunPageLink = Item No.=FIELD(No.),
//                                   Variant Code=CONST();
//                     Scope = Repeater;
//                     ToolTip = 'Set up translated item descriptions for the selected item. Translated item descriptions are automatically inserted on documents according to the language code.';
//                 }
//                 group()
//                 {
//                     Visible = false;
//                     action(AdjustInventory)
//                     {
//                         ApplicationArea = Basic,Suite;
//                         Caption = 'Adjust Inventory';
//                         Enabled = InventoryItemEditable;
//                         Image = InventoryCalculation;
//                         Promoted = true;
//                         PromotedCategory = Category4;
//                         PromotedOnly = true;
//                         Scope = Repeater;
//                         ToolTip = 'Increase or decrease the item''s inventory quantity manually by entering a new quantity. Adjusting the inventory quantity manually may be relevant after a physical count or if you do not record purchased quantities.';
//                         Visible = IsFoundationEnabled;

//                         trigger OnAction()
//                         var
//                             AdjustInventory: Page "1327";
//                         begin
//                             COMMIT;
//                             AdjustInventory.SetItem("No.");
//                             AdjustInventory.RUNMODAL;
//                         end;
//                     }
//                 }
//                 group(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     action(DimensionsSingle)
//                     {
//                         ApplicationArea = Suite;
//                         Caption = 'Dimensions-Single';
//                         Image = Dimensions;
//                         RunObject = Page 540;
//                                         RunPageLink = Table ID=CONST(27),
//                                       No.=FIELD(No.);
//                         Scope = Repeater;
//                         ShortCutKey = 'Shift+Ctrl+D';
//                         ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
//                     }
//                     action(DimensionsMultiple)
//                     {
//                         AccessByPermission = TableData 348=R;
//                         ApplicationArea = Suite;
//                         Caption = 'Dimensions-&Multiple';
//                         Image = DimensionSets;
//                         ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

//                         trigger OnAction()
//                         var
//                             Item: Record "27";
//                             DefaultDimMultiple: Page "542";
//                         begin
//                             CurrPage.SETSELECTIONFILTER(Item);
//                             DefaultDimMultiple.SetMultiItem(Item);
//                             DefaultDimMultiple.RUNMODAL;
//                         end;
//                     }
//                 }
//             }
//             group(History)
//             {
//                 Caption = 'History';
//                 Image = History;
//                 group("E&ntries")
//                 {
//                     Caption = 'E&ntries';
//                     Image = Entries;
//                     action("Ledger E&ntries")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Ledger E&ntries';
//                         Image = ItemLedger;
//                         //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                         //PromotedCategory = Category5;
//                         RunObject = Page 38;
//                                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.)
//                                       ORDER(Descending);
//                         Scope = Repeater;
//                         ShortCutKey = 'Ctrl+F7';
//                         ToolTip = 'View the history of transactions that have been posted for the selected record.';
//                     }
//                     action("&Phys. Inventory Ledger Entries")
//                     {
//                         ApplicationArea = Warehouse;
//                         Caption = '&Phys. Inventory Ledger Entries';
//                         Image = PhysicalInventoryLedger;
//                         //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                         //PromotedCategory = Category5;
//                         RunObject = Page 390;
//                                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.);
//                         Scope = Repeater;
//                         ToolTip = 'View how many units of the item you had in stock at the last physical count.';
//                     }
//                 }
//             }
//             group(PricesandDiscounts)
//             {
//                 Caption = 'Prices and Discounts';
//                 action(Prices_Prices)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Special Prices';
//                     Image = Price;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category6;
//                     RunObject = Page 7002;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     Scope = Repeater;
//                     ToolTip = 'Set up different prices for the selected item. An item price is automatically used on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
//                 }
//                 action(Prices_LineDiscounts)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Special Discounts';
//                     Image = LineDiscount;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category6;
//                     RunObject = Page 7004;
//                                     RunPageLink = Type=CONST(Item),
//                                   Code=FIELD(No.);
//                     RunPageView = SORTING(Type,Code);
//                     Scope = Repeater;
//                     ToolTip = 'Set up different discounts for the selected item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
//                 }
//                 action(PricesDiscountsOverview)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Special Prices & Discounts Overview';
//                     Image = PriceWorksheet;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category6;
//                     ToolTip = 'View the special prices and line discounts that you grant for this item when certain criteria are met, such as vendor, quantity, or ending date.';

//                     trigger OnAction()
//                     var
//                         SalesPriceAndLineDiscounts: Page "1345";
//                     begin
//                         SalesPriceAndLineDiscounts.InitPage(TRUE);
//                         SalesPriceAndLineDiscounts.LoadItem(Rec);
//                         SalesPriceAndLineDiscounts.RUNMODAL;
//                     end;
//                 }
//                 action("Sales Price Worksheet")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Sales Price Worksheet';
//                     Image = PriceWorksheet;
//                     Promoted = true;
//                     PromotedCategory = Category6;
//                     RunObject = Page 7023;
//                                     ToolTip = 'Change to the unit price for the item or specify how you want to enter changes in the price agreement for one customer, a group of customers, or all customers.';
//                                     Visible = NOT IsOnPhone;
//                 }
//             }
//             group("Periodic Activities")
//             {
//                 Caption = 'Periodic Activities';
//                 action("Adjust Cost - Item Entries")
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Adjust Cost - Item Entries';
//                     Image = AdjustEntries;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category8;
//                     RunObject = Report 795;
//                                     ToolTip = 'Adjust inventory values in value entries so that you use the correct adjusted cost for updating the general ledger and so that sales and profit statistics are up to date.';
//                 }
//                 action("Post Inventory Cost to G/L")
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Post Inventory Cost to G/L';
//                     Image = PostInventoryToGL;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category8;
//                     RunObject = Report 1002;
//                                     ToolTip = 'Post the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.';
//                 }
//                 action("Physical Inventory Journal")
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Physical Inventory Journal';
//                     Image = PhysicalInventory;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category8;
//                     RunObject = Page 392;
//                                     ToolTip = 'Select how you want to maintain an up-to-date record of your inventory at different locations.';
//                 }
//                 action("Revaluation Journal")
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Revaluation Journal';
//                     Image = Journal;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Category8;
//                     RunObject = Page 5803;
//                                     ToolTip = 'View or edit the inventory value of items, which you can change, such as after doing a physical inventory.';
//                 }
//             }
//             group("Request Approval")
//             {
//                 Caption = 'Request Approval';
//                 Image = SendApprovalRequest;
//                 action(SendApprovalRequest)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Send A&pproval Request';
//                     Enabled = (NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
//                     Image = SendApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Category7;
//                     ToolTip = 'Request approval to change the record.';

//                     trigger OnAction()
//                     var
//                         ApprovalsMgmt: Codeunit "1535";
//                     begin
//                         IF ApprovalsMgmt.CheckItemApprovalsWorkflowEnabled(Rec) THEN
//                           ApprovalsMgmt.OnSendItemForApproval(Rec);
//                     end;
//                 }
//                 action(CancelApprovalRequest)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Cancel Approval Re&quest';
//                     Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
//                     Image = CancelApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Category7;
//                     ToolTip = 'Cancel the approval request.';

//                     trigger OnAction()
//                     var
//                         ApprovalsMgmt: Codeunit "1535";
//                         WorkflowWebhookManagement: Codeunit "1543";
//                     begin
//                         ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);
//                         WorkflowWebhookManagement.FindAndCancel(RECORDID);
//                     end;
//                 }
//             }
//             group(Workflow)
//             {
//                 Caption = 'Workflow';
//                 action(CreateApprovalWorkflow)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Create Approval Workflow';
//                     Enabled = NOT EnabledApprovalWorkflowsExist;
//                     Image = CreateWorkflow;
//                     ToolTip = 'Set up an approval workflow for creating or changing items, by going through a few pages that will guide you.';

//                     trigger OnAction()
//                     begin
//                         PAGE.RUNMODAL(PAGE::"Item Approval WF Setup Wizard");
//                     end;
//                 }
//                 action(ManageApprovalWorkflow)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Manage Approval Workflow';
//                     Enabled = EnabledApprovalWorkflowsExist;
//                     Image = WorkflowSetup;
//                     ToolTip = 'View or edit existing approval workflows for creating or changing items.';

//                     trigger OnAction()
//                     var
//                         WorkflowManagement: Codeunit "1501";
//                     begin
//                         WorkflowManagement.NavigateToWorkflows(DATABASE::Item,EventFilter);
//                     end;
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("&Create Stockkeeping Unit")
//                 {
//                     AccessByPermission = TableData 5700=R;
//                     ApplicationArea = Warehouse;
//                     Caption = '&Create Stockkeeping Unit';
//                     Image = CreateSKU;
//                     ToolTip = 'Create an instance of the item at each location that is set up.';

//                     trigger OnAction()
//                     var
//                         Item: Record "27";
//                     begin
//                         Item.SETRANGE("No.","No.");
//                         REPORT.RUNMODAL(REPORT::"Create Stockkeeping Unit",TRUE,FALSE,Item);
//                     end;
//                 }
//                 action("C&alculate Counting Period")
//                 {
//                     AccessByPermission = TableData 7380=R;
//                     ApplicationArea = Warehouse;
//                     Caption = 'C&alculate Counting Period';
//                     Image = CalculateCalendar;
//                     ToolTip = 'Prepare for a physical inventory by calculating which items or SKUs need to be counted in the current period.';

//                     trigger OnAction()
//                     var
//                         Item: Record "27";
//                         PhysInvtCountMgt: Codeunit "7380";
//                     begin
//                         CurrPage.SETSELECTIONFILTER(Item);
//                         PhysInvtCountMgt.UpdateItemPhysInvtCount(Item);
//                     end;
//                 }
//             }
//             action("Requisition Worksheet")
//             {
//                 ApplicationArea = Planning;
//                 Caption = 'Requisition Worksheet';
//                 Image = Worksheet;
//                 RunObject = Page 291;
//                                 ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
//             }
//             action("Item Journal")
//             {
//                 ApplicationArea = Advanced;
//                 Caption = 'Item Journal';
//                 Image = Journals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 40;
//                                 ToolTip = 'Open a list of journals where you can adjust the physical quantity of items on inventory.';
//             }
//             action("Item Reclassification Journal")
//             {
//                 ApplicationArea = Advanced;
//                 Caption = 'Item Reclassification Journal';
//                 Image = Journals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 393;
//                                 ToolTip = 'Change information on item ledger entries, such as dimensions, location codes, bin codes, and serial or lot numbers.';
//             }
//             action("Item Tracing")
//             {
//                 ApplicationArea = Advanced;
//                 Caption = 'Item Tracing';
//                 Image = ItemTracing;
//                 RunObject = Page 6520;
//                                 ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';
//             }
//             action("Adjust Item Cost/Price")
//             {
//                 ApplicationArea = Advanced;
//                 Caption = 'Adjust Item Cost/Price';
//                 Image = AdjustItemCost;
//                 RunObject = Report 794;
//                                 ToolTip = 'Adjusts the Last Direct Cost, Standard Cost, Unit Price, Profit %, or Indirect Cost % fields on selected item or stockkeeping unit cards and for selected filters. For example, you can change the last direct cost by 5% on all items from a specific vendor.';
//             }
//             action(ApplyTemplate)
//             {
//                 ApplicationArea = Basic,Suite;
//                 Caption = 'Apply Template';
//                 Ellipsis = true;
//                 Image = ApplyTemplate;
//                 ToolTip = 'Apply a template to update one or more entities with your standard settings for a certain type of entity.';

//                 trigger OnAction()
//                 var
//                     Item: Record "27";
//                     ItemTemplate: Record "1301";
//                 begin
//                     CurrPage.SETSELECTIONFILTER(Item);
//                     ItemTemplate.UpdateItemsFromTemplate(Item);
//                 end;
//             }
//             group(Display)
//             {
//                 Caption = 'Display';
//                 action(ReportFactBoxVisibility)
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Show/Hide Power BI Reports';
//                     Image = "Report";
//                     ToolTip = 'Select if the Power BI FactBox is visible or not.';

//                     trigger OnAction()
//                     begin
//                         IF PowerBIVisible THEN
//                           PowerBIVisible := FALSE
//                         ELSE
//                           PowerBIVisible := TRUE;
//                         // save visibility value into the table
//                         CurrPage."Power BI Report FactBox".PAGE.SetFactBoxVisibility(PowerBIVisible);
//                     end;
//                 }
//             }
//         }
//         area(reporting)
//         {
//             group("Assembly/Production")
//             {
//                 Caption = 'Assembly/Production';
//                 action("Assemble to Order - Sales")
//                 {
//                     ApplicationArea = Assembly;
//                     Caption = 'Assemble to Order - Sales';
//                     Image = "Report";
//                     RunObject = Report 915;
//                                     ToolTip = 'View key sales figures for assembly components that may be sold either as part of assembly items in assemble-to-order sales or as separate items directly from inventory. Use this report to analyze the quantity, cost, sales, and profit figures of assembly components to support decisions, such as whether to price a kit differently or to stop or start using a particular item in assemblies.';
//                 }
//                 action("Where-Used (Top Level)")
//                 {
//                     ApplicationArea = Assembly;
//                     Caption = 'Where-Used (Top Level)';
//                     Image = "Report";
//                     RunObject = Report 99000757;
//                                     ToolTip = 'View where and in what quantities the item is used in the product structure. The report only shows information for the top-level item. For example, if item "A" is used to produce item "B", and item "B" is used to produce item "C", the report will show item B if you run this report for item A. If you run this report for item B, then item C will be shown as where-used.';
//                 }
//                 action("Quantity Explosion of BOM")
//                 {
//                     ApplicationArea = Assembly;
//                     Caption = 'Quantity Explosion of BOM';
//                     Image = "Report";
//                     RunObject = Report 99000753;
//                                     ToolTip = 'View an indented BOM listing for the item or items that you specify in the filters. The production BOM is completely exploded for all levels.';
//                 }
//                 group(Costing)
//                 {
//                     Caption = 'Costing';
//                     Image = ItemCosts;
//                     action("Inventory Valuation - WIP")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Inventory Valuation - WIP';
//                         Image = "Report";
//                         RunObject = Report 5802;
//                                         ToolTip = 'View inventory valuation for selected production orders in your WIP inventory. The report also shows information about the value of consumption, capacity usage and output in WIP. The printed report only shows invoiced amounts, that is, the cost of entries that have been posted as invoiced.';
//                     }
//                     action("Cost Shares Breakdown")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Cost Shares Breakdown';
//                         Image = "Report";
//                         RunObject = Report 5848;
//                                         ToolTip = 'View the item''s cost broken down in inventory, WIP, or COGS, according to purchase and material cost, capacity cost, capacity overhead cost, manufacturing overhead cost, subcontracted cost, variance, indirect cost, revaluation, and rounding. The report breaks down cost at a single BOM level and does not roll up the costs from lower BOM levels. The report does not calculate the cost share from items that use the Average costing method.';
//                     }
//                     action("Detailed Calculation")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Detailed Calculation';
//                         Image = "Report";
//                         RunObject = Report 99000756;
//                                         ToolTip = 'View the list of all costs for the item taking into account any scrap during production.';
//                     }
//                     action("Rolled-up Cost Shares")
//                     {
//                         ApplicationArea = Manufacturing;
//                         Caption = 'Rolled-up Cost Shares';
//                         Image = "Report";
//                         RunObject = Report 99000754;
//                                         ToolTip = 'View the cost shares of all items in the parent item''s product structure, their quantity and their cost shares specified in material, capacity, overhead, and total cost. Material cost is calculated as the cost of all items in the parent item''s product structure. Capacity and subcontractor costs are calculated as the costs related to produce all of the items in the parent item''s product structure. Material cost is calculated as the cost of all items in the item''s product structure. Capacity and subcontractor costs are the cost related to the parent item only.';
//                     }
//                     action("Single-Level Cost Shares")
//                     {
//                         ApplicationArea = Manufacturing;
//                         Caption = 'Single-Level Cost Shares';
//                         Image = "Report";
//                         RunObject = Report 99000755;
//                                         ToolTip = 'View the cost shares of all items in the item''s product structure, their quantity and their cost shares specified in material, capacity, overhead, and total cost. Material cost is calculated as the cost of all items in the parent item''s product structure. Capacity and subcontractor costs are calculated as the costs related to produce all of the items in the parent item''s product structure.';
//                     }
//                 }
//             }
//             group(Inventory)
//             {
//                 Caption = 'Inventory';
//                 action("Inventory - List")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory - List';
//                     Image = "Report";
//                     RunObject = Report 701;
//                                     ToolTip = 'View various information about the item, such as name, unit of measure, posting group, shelf number, vendor''s item number, lead time calculation, minimum inventory, and alternate item number. You can also see if the item is blocked.';
//                 }
//                 action("Inventory - Availability Plan")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory - Availability Plan';
//                     Image = ItemAvailability;
//                     RunObject = Report 707;
//                                     ToolTip = 'View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.';
//                 }
//                 action("Item/Vendor Catalog")
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Item/Vendor Catalog';
//                     Image = "Report";
//                     RunObject = Report 720;
//                                     ToolTip = 'View a list of the vendors for the selected items. For each combination of item and vendor, it shows direct unit cost, lead time calculation and the vendor''s item number.';
//                 }
//                 action("Phys. Inventory List")
//                 {
//                     ApplicationArea = Warehouse;
//                     Caption = 'Phys. Inventory List';
//                     Image = "Report";
//                     RunObject = Report 722;
//                                     ToolTip = 'View a list of the lines that you have calculated in the Phys. Inventory Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.';
//                 }
//                 action("Nonstock Item Sales")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Nonstock Item Sales';
//                     Image = "Report";
//                     RunObject = Report 5700;
//                                     ToolTip = 'View a list of item sales for each nonstock item during a selected time period. It can be used to review a company''s sale of nonstock items.';
//                 }
//                 action("Item Substitutions")
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Item Substitutions';
//                     Image = "Report";
//                     RunObject = Report 5701;
//                                     ToolTip = 'View or edit any substitute items that are set up to be traded instead of the item in case it is not available.';
//                 }
//                 action("Price List")
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Price List';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = Category9;
//                     RunObject = Report 715;
//                                     ToolTip = 'View, print, or save a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.';
//                 }
//                 action("Inventory Cost and Price List")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory Cost and Price List';
//                     Image = "Report";
//                     RunObject = Report 716;
//                                     ToolTip = 'View, print, or save a list of your items and their price and cost information. The report specifies direct unit cost, last direct cost, unit price, profit percentage, and profit.';
//                 }
//                 action("Inventory Availability")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory Availability';
//                     Image = "Report";
//                     RunObject = Report 705;
//                                     ToolTip = 'View, print, or save a summary of historical inventory transactions with selected items, for example, to decide when to purchase the items. The report specifies quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there are reorders.';
//                 }
//                 group("Item Register")
//                 {
//                     Caption = 'Item Register';
//                     Image = ItemRegisters;
//                     action("Item Register - Quantity")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Item Register - Quantity';
//                         Image = "Report";
//                         RunObject = Report 703;
//                                         ToolTip = 'View one or more selected item registers showing quantity. The report can be used to document a register''s contents for internal or external audits.';
//                     }
//                     action("Item Register - Value")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Item Register - Value';
//                         Image = "Report";
//                         RunObject = Report 5805;
//                                         ToolTip = 'View one or more selected item registers showing value. The report can be used to document the contents of a register for internal or external audits.';
//                     }
//                 }
//                 group(Costing)
//                 {
//                     Caption = 'Costing';
//                     Image = ItemCosts;
//                     action("Inventory - Cost Variance")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Inventory - Cost Variance';
//                         Image = ItemCosts;
//                         RunObject = Report 721;
//                                         ToolTip = 'View information about selected items, unit of measure, standard cost, and costing method, as well as additional information about item entries: unit amount, direct unit cost, unit cost variance (the difference between the unit amount and unit cost), invoiced quantity, and total variance amount (quantity * unit cost variance). The report can be used primarily if you have chosen the Standard costing method on the item card.';
//                     }
//                     action("Invt. Valuation - Cost Spec.")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Invt. Valuation - Cost Spec.';
//                         Image = "Report";
//                         RunObject = Report 5801;
//                                         ToolTip = 'View an overview of the current inventory value of selected items and specifies the cost of these items as of the date specified in the Valuation Date field. The report includes all costs, both those posted as invoiced and those posted as expected. For each of the items that you specify when setting up the report, the printed report shows quantity on stock, the cost per unit and the total amount. For each of these columns, the report specifies the cost as the various value entry types.';
//                     }
//                     action("Compare List")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Compare List';
//                         Image = "Report";
//                         RunObject = Report 99000758;
//                                         ToolTip = 'View a comparison of components for two items. The printout compares the components, their unit cost, cost share and cost per component.';
//                     }
//                 }
//                 group("Inventory Details")
//                 {
//                     Caption = 'Inventory Details';
//                     Image = "Report";
//                     action("Inventory - Transaction Detail")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Inventory - Transaction Detail';
//                         Image = "Report";
//                         RunObject = Report 704;
//                                         ToolTip = 'View transaction details with entries for the selected items for a selected period. The report shows the inventory at the beginning of the period, all of the increase and decrease entries during the period with a running update of the inventory, and the inventory at the close of the period. The report can be used at the close of an accounting period, for example, or for an audit.';
//                     }
//                     action("Item Charges - Specification")
//                     {
//                         ApplicationArea = ItemCharges;
//                         Caption = 'Item Charges - Specification';
//                         Image = "Report";
//                         RunObject = Report 5806;
//                                         ToolTip = 'View a specification of the direct costs that your company has assigned and posted as item charges. The report shows the various value entries that have been posted as item charges. It includes all costs, both those posted as invoiced and those posted as expected.';
//                     }
//                     action("Item Age Composition - Qty.")
//                     {
//                         ApplicationArea = Basic,Suite;
//                         Caption = 'Item Age Composition - Qty.';
//                         Image = "Report";
//                         RunObject = Report 5807;
//                                         ToolTip = 'View, print, or save an overview of the current age composition of selected items in your inventory.';
//                     }
//                     action("Item Expiration - Quantity")
//                     {
//                         ApplicationArea = ItemTracking;
//                         Caption = 'Item Expiration - Quantity';
//                         Image = "Report";
//                         RunObject = Report 5809;
//                                         ToolTip = 'View an overview of the quantities of selected items in your inventory whose expiration dates fall within a certain period. The list shows the number of units of the selected item that will expire in a given time period. For each of the items that you specify when setting up the report, the printed document shows the number of units that will expire during each of three periods of equal length and the total inventory quantity of the selected item.';
//                     }
//                 }
//                 group(Reports)
//                 {
//                     Caption = 'Inventory Statistics';
//                     Image = "Report";
//                     action("Inventory - Sales Statistics")
//                     {
//                         ApplicationArea = Suite;
//                         Caption = 'Inventory - Sales Statistics';
//                         Image = "Report";
//                         RunObject = Report 712;
//                                         ToolTip = 'View, print, or save a summary of selected items'' sales per customer, for example, to analyze the profit on individual items or trends in revenues and profit. The report specifies direct unit cost, unit price, sales quantity, sales in LCY, profit percentage, and profit.';
//                     }
//                     action("Inventory - Customer Sales")
//                     {
//                         ApplicationArea = Suite;
//                         Caption = 'Inventory - Customer Sales';
//                         Image = "Report";
//                         RunObject = Report 713;
//                                         ToolTip = 'View, print, or save a list of customers that have purchased selected items within a selected period, for example, to analyze customers'' purchasing patterns. The report specifies quantity, amount, discount, profit percentage, and profit.';
//                     }
//                     action("Inventory - Top 10 List")
//                     {
//                         ApplicationArea = Basic,Suite;
//                         Caption = 'Inventory - Top 10 List';
//                         Image = "Report";
//                         RunObject = Report 711;
//                                         ToolTip = 'View information about the items with the highest or lowest sales within a selected period. You can also choose that items that are not on hand or have not been sold are not included in the report. The items are sorted by order size within the selected period. The list gives a quick overview of the items that have sold either best or worst, or the items that have the most or fewest units on inventory.';
//                     }
//                 }
//                 group("Finance Reports")
//                 {
//                     Caption = 'Finance Reports';
//                     Image = "Report";
//                     action("Inventory Valuation")
//                     {
//                         ApplicationArea = Basic,Suite;
//                         Caption = 'Inventory Valuation';
//                         Image = "Report";
//                         RunObject = Report 1001;
//                                         ToolTip = 'View, print, or save a list of the values of the on-hand quantity of each inventory item.';
//                     }
//                     action(Status)
//                     {
//                         ApplicationArea = Basic,Suite;
//                         Caption = 'Status';
//                         Image = "Report";
//                         RunObject = Report 706;
//                                         ToolTip = 'View, print, or save the status of partially filled or unfilled orders so you can determine what effect filling these orders may have on your inventory.';
//                     }
//                     action("Item Age Composition - Value")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Item Age Composition - Value';
//                         Image = "Report";
//                         RunObject = Report 5808;
//                                         ToolTip = 'View, print, or save an overview of the current age composition of selected items in your inventory.';
//                     }
//                 }
//             }
//             group(Orders)
//             {
//                 Caption = 'Orders';
//                 action("Inventory Order Details")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory Order Details';
//                     Image = "Report";
//                     RunObject = Report 708;
//                                     ToolTip = 'View a list of the orders that have not yet been shipped or received and the items in the orders. It shows the order number, customer''s name, shipment date, order quantity, quantity on back order, outstanding quantity and unit price, as well as possible discount percentage and amount. The quantity on back order and outstanding quantity and amount are totaled for each item. The report can be used to find out whether there are currently shipment problems or any can be expected.';
//                 }
//                 action("Inventory Purchase Orders")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory Purchase Orders';
//                     Image = "Report";
//                     RunObject = Report 709;
//                                     ToolTip = 'View a list of items on order from vendors. It also shows the expected receipt date and the quantity and amount on back orders. The report can be used, for example, to see when items should be received and whether a reminder of a back order should be issued.';
//                 }
//                 action("Inventory - Vendor Purchases")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory - Vendor Purchases';
//                     Image = "Report";
//                     RunObject = Report 714;
//                                     ToolTip = 'View a list of the vendors that your company has purchased items from within a selected period. It shows invoiced quantity, amount and discount. The report can be used to analyze a company''s item purchases.';
//                 }
//                 action("Inventory - Reorders")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory - Reorders';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 717;
//                                     ToolTip = 'View a list of items with negative inventory that is sorted by vendor. You can use this report to help decide which items have to be reordered. The report shows how many items are inbound on purchase orders or transfer orders and how many items are in inventory. Based on this information and any defined reorder quantity for the item, a suggested value is inserted in the Qty. to Order field.';
//                 }
//                 action("Inventory - Sales Back Orders")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Inventory - Sales Back Orders';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 718;
//                                     ToolTip = 'Shows a list of order lines with shipment dates that are exceeded. The report also shows if there are other items for the customer on back order.';
//                 }
//             }
//         }
//         area(navigation)
//         {
//             group(Item)
//             {
//                 Caption = 'Item';
//                 action(ApprovalEntries)
//                 {
//                     AccessByPermission = TableData 454=R;
//                     ApplicationArea = Suite;
//                     Caption = 'Approvals';
//                     Image = Approvals;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedOnly = true;
//                     ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

//                     trigger OnAction()
//                     begin
//                         ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
//                     end;
//                 }
//             }
//             group(Availability)
//             {
//                 Caption = 'Availability';
//                 Image = Item;
//                 action("Items b&y Location")
//                 {
//                     AccessByPermission = TableData 14=R;
//                     ApplicationArea = Location;
//                     Caption = 'Items b&y Location';
//                     Image = ItemAvailbyLoc;
//                     ToolTip = 'Show a list of items grouped by location.';

//                     trigger OnAction()
//                     begin
//                         PAGE.RUN(PAGE::"Items by Location",Rec);
//                     end;
//                 }
//                 group("&Item Availability by")
//                 {
//                     Caption = '&Item Availability by';
//                     Image = ItemAvailability;
//                     action("<Action5>")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Event';
//                         Image = "Event";
//                         ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
//                         end;
//                     }
//                     action(Period)
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Period';
//                         Image = Period;
//                         RunObject = Page 157;
//                                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                         ToolTip = 'Show the projected quantity of the item over time according to time periods, such as day, week, or month.';
//                     }
//                     action(Variant)
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Variant';
//                         Image = ItemVariant;
//                         RunObject = Page 5414;
//                                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                         ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
//                     }
//                     action(Location)
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Location';
//                         Image = Warehouse;
//                         RunObject = Page 492;
//                                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                         ToolTip = 'View the actual and projected quantity of the item per location.';
//                     }
//                     action("BOM Level")
//                     {
//                         ApplicationArea = Assembly;
//                         Caption = 'BOM Level';
//                         Image = BOMLevel;
//                         ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByBOM);
//                         end;
//                     }
//                     action(Timeline)
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Timeline';
//                         Image = Timeline;
//                         ToolTip = 'Get a graphical view of an item''s projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.';

//                         trigger OnAction()
//                         begin
//                             ShowTimelineFromItem(Rec);
//                         end;
//                     }
//                 }
//             }
//             group(ActionGroupCRM)
//             {
//                 Caption = 'Dynamics 365 for Sales';
//                 Visible = CRMIntegrationEnabled;
//                 action(CRMGoToProduct)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Product';
//                     Image = CoupledItem;
//                     ToolTip = 'Open the coupled Dynamics 365 for Sales product.';

//                     trigger OnAction()
//                     var
//                         CRMIntegrationManagement: Codeunit "5330";
//                     begin
//                         CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
//                     end;
//                 }
//                 action(CRMSynchronizeNow)
//                 {
//                     AccessByPermission = TableData 5331=IM;
//                     ApplicationArea = Suite;
//                     Caption = 'Synchronize';
//                     Image = Refresh;
//                     ToolTip = 'Send updated data to Dynamics 365 for Sales.';

//                     trigger OnAction()
//                     var
//                         Item: Record "27";
//                         CRMIntegrationManagement: Codeunit "5330";
//                         ItemRecordRef: RecordRef;
//                     begin
//                         CurrPage.SETSELECTIONFILTER(Item);
//                         Item.NEXT;

//                         IF Item.COUNT = 1 THEN
//                           CRMIntegrationManagement.UpdateOneNow(Item.RECORDID)
//                         ELSE BEGIN
//                           ItemRecordRef.GETTABLE(Item);
//                           CRMIntegrationManagement.UpdateMultipleNow(ItemRecordRef);
//                         END
//                     end;
//                 }
//                 group(Coupling)
//                 {
//                     Caption = 'Coupling', Comment='Coupling is a noun';
//                     Image = LinkAccount;
//                     ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.';
//                     action(ManageCRMCoupling)
//                     {
//                         AccessByPermission = TableData 5331=IM;
//                         ApplicationArea = Suite;
//                         Caption = 'Set Up Coupling';
//                         Image = LinkAccount;
//                         ToolTip = 'Create or modify the coupling to a Dynamics 365 for Sales product.';

//                         trigger OnAction()
//                         var
//                             CRMIntegrationManagement: Codeunit "5330";
//                         begin
//                             CRMIntegrationManagement.DefineCoupling(RECORDID);
//                         end;
//                     }
//                     action(DeleteCRMCoupling)
//                     {
//                         AccessByPermission = TableData 5331=IM;
//                         ApplicationArea = Suite;
//                         Caption = 'Delete Coupling';
//                         Enabled = CRMIsCoupledToRecord;
//                         Image = UnLinkAccount;
//                         ToolTip = 'Delete the coupling to a Dynamics 365 for Sales product.';

//                         trigger OnAction()
//                         var
//                             CRMCouplingManagement: Codeunit "5331";
//                         begin
//                             CRMCouplingManagement.RemoveCoupling(RECORDID);
//                         end;
//                     }
//                 }
//             }
//             group("Assembly/Production")
//             {
//                 Caption = 'Assembly/Production';
//                 Image = Production;
//                 action(Structure)
//                 {
//                     ApplicationArea = Assembly;
//                     Caption = 'Structure';
//                     Image = Hierarchy;
//                     ToolTip = 'View which child items are used in an item''s assembly BOM or production BOM. Each item level can be collapsed or expanded to obtain an overview or detailed view.';

//                     trigger OnAction()
//                     var
//                         BOMStructure: Page "5870";
//                     begin
//                         BOMStructure.InitItem(Rec);
//                         BOMStructure.RUN;
//                     end;
//                 }
//                 action("Cost Shares")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Cost Shares';
//                     Image = CostBudget;
//                     ToolTip = 'View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.';

//                     trigger OnAction()
//                     var
//                         BOMCostShares: Page "5872";
//                     begin
//                         BOMCostShares.InitItem(Rec);
//                         BOMCostShares.RUN;
//                     end;
//                 }
//                 group("Assemb&ly")
//                 {
//                     Caption = 'Assemb&ly';
//                     Image = AssemblyBOM;
//                     action("<Action32>")
//                     {
//                         ApplicationArea = Assembly;
//                         Caption = 'Assembly BOM';
//                         Image = BOM;
//                         RunObject = Page 36;
//                                         RunPageLink = Parent Item No.=FIELD(No.);
//                         ToolTip = 'View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.';
//                     }
//                     action("Where-Used")
//                     {
//                         ApplicationArea = Assembly;
//                         Caption = 'Where-Used';
//                         Image = Track;
//                         RunObject = Page 37;
//                                         RunPageLink = Type=CONST(Item),
//                                       No.=FIELD(No.);
//                         RunPageView = SORTING(Type,No.);
//                         ToolTip = 'View a list of BOMs in which the item is used.';
//                     }
//                     action("Calc. Stan&dard Cost")
//                     {
//                         AccessByPermission = TableData 90=R;
//                         ApplicationArea = Assembly;
//                         Caption = 'Calc. Stan&dard Cost';
//                         Image = CalculateCost;
//                         ToolTip = 'Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item''s assembly BOM or production BOM. The unit cost of a parent item must always equals the total of the unit costs of its components, subassemblies, and any resources.';

//                         trigger OnAction()
//                         begin
//                             CalculateStdCost.CalcItem("No.",TRUE);
//                         end;
//                     }
//                     action("Calc. Unit Price")
//                     {
//                         AccessByPermission = TableData 90=R;
//                         ApplicationArea = Assembly;
//                         Caption = 'Calc. Unit Price';
//                         Image = SuggestItemPrice;
//                         ToolTip = 'Calculate the unit price based on the unit cost and the profit percentage.';

//                         trigger OnAction()
//                         begin
//                             CalculateStdCost.CalcAssemblyItemPrice("No.");
//                         end;
//                     }
//                 }
//                 group(Production)
//                 {
//                     Caption = 'Production';
//                     Image = Production;
//                     action("Production BOM")
//                     {
//                         ApplicationArea = Manufacturing;
//                         Caption = 'Production BOM';
//                         Image = BOM;
//                         RunObject = Page 99000786;
//                                         RunPageLink = No.=FIELD(Production BOM No.);
//                         ToolTip = 'Open the item''s production bill of material to view or edit its components.';
//                     }
//                     action("Where-Used")
//                     {
//                         AccessByPermission = TableData 90=R;
//                         ApplicationArea = Advanced;
//                         Caption = 'Where-Used';
//                         Image = "Where-Used";
//                         ToolTip = 'View a list of BOMs in which the item is used.';

//                         trigger OnAction()
//                         var
//                             ProdBOMWhereUsed: Page "99000811";
//                         begin
//                             ProdBOMWhereUsed.SetItem(Rec,WORKDATE);
//                             ProdBOMWhereUsed.RUNMODAL;
//                         end;
//                     }
//                     action("Calc. Stan&dard Cost")
//                     {
//                         AccessByPermission = TableData 99000771=R;
//                         ApplicationArea = Assembly;
//                         Caption = 'Calc. Stan&dard Cost';
//                         Image = CalculateCost;
//                         ToolTip = 'Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item''s assembly BOM or production BOM. The unit cost of a parent item must always equals the total of the unit costs of its components, subassemblies, and any resources.';

//                         trigger OnAction()
//                         begin
//                             CalculateStdCost.CalcItem("No.",FALSE);
//                         end;
//                     }
//                     action("&Reservation Entries")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = '&Reservation Entries';
//                         Image = ReservationLedger;
//                         RunObject = Page 497;
//                                         RunPageLink = Reservation Status=CONST(Reservation),
//                                       Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.,Variant Code,Location Code,Reservation Status);
//                         ToolTip = 'View all reservations that are made for the item, either manually or automatically.';
//                     }
//                     action("&Value Entries")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = '&Value Entries';
//                         Image = ValueLedger;
//                         RunObject = Page 5802;
//                                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.);
//                         ToolTip = 'View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.';
//                     }
//                     action("Item &Tracking Entries")
//                     {
//                         ApplicationArea = ItemTracking;
//                         Caption = 'Item &Tracking Entries';
//                         Image = ItemTrackingLedger;
//                         ToolTip = 'View serial or lot numbers that are assigned to items.';

//                         trigger OnAction()
//                         var
//                             ItemTrackingDocMgt: Codeunit "6503";
//                         begin
//                             ItemTrackingDocMgt.ShowItemTrackingForMasterData(3,'',"No.",'','','','');
//                         end;
//                     }
//                     action("&Warehouse Entries")
//                     {
//                         ApplicationArea = Warehouse;
//                         Caption = '&Warehouse Entries';
//                         Image = BinLedger;
//                         RunObject = Page 7318;
//                                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.,Bin Code,Location Code,Variant Code,Unit of Measure Code,Lot No.,Serial No.,Entry Type,Dedicated);
//                         ToolTip = 'View the history of quantities that are registered for the item in warehouse activities. ';
//                     }
//                 }
//                 group(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     action(Statistics)
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Statistics';
//                         Image = Statistics;
//                         ShortCutKey = 'F7';
//                         ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

//                         trigger OnAction()
//                         var
//                             ItemStatistics: Page "5827";
//                         begin
//                             ItemStatistics.SetItem(Rec);
//                             ItemStatistics.RUNMODAL;
//                         end;
//                     }
//                     action("Entry Statistics")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'Entry Statistics';
//                         Image = EntryStatistics;
//                         RunObject = Page 304;
//                                         RunPageLink = No.=FIELD(No.),
//                                       Date Filter=FIELD(Date Filter),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                         ToolTip = 'View statistics for item ledger entries.';
//                     }
//                     action("T&urnover")
//                     {
//                         ApplicationArea = Advanced;
//                         Caption = 'T&urnover';
//                         Image = Turnover;
//                         RunObject = Page 158;
//                                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                         ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
//                     }
//                 }
//                 action("Co&mments")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 124;
//                                     RunPageLink = Table Name=CONST(Item),
//                                   No.=FIELD(No.);
//                     ToolTip = 'View or add comments for the record.';
//                 }
//             }
//             group("S&ales")
//             {
//                 Caption = 'S&ales';
//                 Image = Sales;
//                 action(Sales_Prices)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Prices';
//                     Image = Price;
//                     RunObject = Page 7002;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'View or set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
//                 }
//                 action(Sales_LineDiscounts)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Line Discounts';
//                     Image = LineDiscount;
//                     RunObject = Page 7004;
//                                     RunPageLink = Type=CONST(Item),
//                                   Code=FIELD(No.);
//                     RunPageView = SORTING(Type,Code);
//                     ToolTip = 'View or set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
//                 }
//                 action("Prepa&yment Percentages")
//                 {
//                     ApplicationArea = Prepayments;
//                     Caption = 'Prepa&yment Percentages';
//                     Image = PrepaymentPercentages;
//                     RunObject = Page 664;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     ToolTip = 'View or edit the percentages of the price that can be paid as a prepayment. ';
//                 }
//                 action(Orders)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Orders';
//                     Image = Document;
//                     RunObject = Page 48;
//                                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                     ToolTip = 'View a list of ongoing orders for the item.';
//                 }
//                 action("Returns Orders")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Returns Orders';
//                     Image = ReturnOrder;
//                     RunObject = Page 6633;
//                                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                     ToolTip = 'View ongoing sales or purchase return orders for the item.';
//                 }
//             }
//             group("&Purchases")
//             {
//                 Caption = '&Purchases';
//                 Image = Purchasing;
//                 action("Ven&dors")
//                 {
//                     ApplicationArea = Planning;
//                     Caption = 'Ven&dors';
//                     Image = Vendor;
//                     RunObject = Page 114;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'View the list of vendors who can supply the item, and at which lead time.';
//                 }
//                 action(Prices)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Prices';
//                     Image = Price;
//                     RunObject = Page 7012;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'View or set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
//                 }
//                 action("Line Discounts")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Line Discounts';
//                     Image = LineDiscount;
//                     RunObject = Page 7014;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'View or set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
//                 }
//                 action("Prepa&yment Percentages")
//                 {
//                     ApplicationArea = Prepayments;
//                     Caption = 'Prepa&yment Percentages';
//                     Image = PrepaymentPercentages;
//                     RunObject = Page 665;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     ToolTip = 'View or edit the percentages of the price that can be paid as a prepayment. ';
//                 }
//                 action(Orders)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Orders';
//                     Image = Document;
//                     RunObject = Page 56;
//                                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                     ToolTip = 'View a list of ongoing orders for the item.';
//                 }
//                 action("Return Orders")
//                 {
//                     ApplicationArea = SalesReturnOrder;
//                     Caption = 'Return Orders';
//                     Image = ReturnOrder;
//                     RunObject = Page 6643;
//                                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                     ToolTip = 'Open the list of ongoing return orders for the item.';
//                 }
//                 action("Nonstoc&k Items")
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Nonstoc&k Items';
//                     Image = NonStockItem;
//                     RunObject = Page 5726;
//                                     ToolTip = 'View the list of items that you do not carry in inventory. ';
//                 }
//             }
//             group(PurchPricesandDiscounts)
//             {
//                 Caption = 'Special Purchase Prices & Discounts';
//                 action("Set Special Prices")
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Set Special Prices';
//                     Image = Price;
//                     RunObject = Page 7012;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'Set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
//                 }
//                 action("Set Special Discounts")
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Set Special Discounts';
//                     Image = LineDiscount;
//                     RunObject = Page 7014;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     ToolTip = 'Set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
//                 }
//                 action(PurchPricesDiscountsOverview)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Special Prices & Discounts Overview';
//                     Image = PriceWorksheet;
//                     ToolTip = 'View the special prices and line discounts that you grant for this item when certain criteria are met, such as vendor, quantity, or ending date.';

//                     trigger OnAction()
//                     var
//                         PurchasesPriceAndLineDisc: Page "1346";
//                     begin
//                         PurchasesPriceAndLineDisc.LoadItem(Rec);
//                         PurchasesPriceAndLineDisc.RUNMODAL;
//                     end;
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("&Bin Contents")
//                 {
//                     ApplicationArea = Warehouse;
//                     Caption = '&Bin Contents';
//                     Image = BinContent;
//                     RunObject = Page 7379;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.';
//                 }
//                 action("Stockkeepin&g Units")
//                 {
//                     ApplicationArea = Warehouse;
//                     Caption = 'Stockkeepin&g Units';
//                     Image = SKU;
//                     RunObject = Page 5701;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'Open the item''s SKUs to view or edit instances of the item at different locations or with different variants. ';
//                 }
//             }
//             group(Service)
//             {
//                 Caption = 'Service';
//                 Image = ServiceItem;
//                 action("Ser&vice Items")
//                 {
//                     ApplicationArea = Service;
//                     Caption = 'Ser&vice Items';
//                     Image = ServiceItem;
//                     RunObject = Page 5988;
//                                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                     ToolTip = 'View instances of the item as service items, such as machines that you maintain or repair for customers through service orders. ';
//                 }
//                 action(Troubleshooting)
//                 {
//                     AccessByPermission = TableData 5900=R;
//                     ApplicationArea = Service;
//                     Caption = 'Troubleshooting';
//                     Image = Troubleshoot;
//                     ToolTip = 'View or edit information about technical problems with a service item.';

//                     trigger OnAction()
//                     var
//                         TroubleshootingHeader: Record "5943";
//                     begin
//                         TroubleshootingHeader.ShowForItem(Rec);
//                     end;
//                 }
//                 action("Troubleshooting Setup")
//                 {
//                     ApplicationArea = Service;
//                     Caption = 'Troubleshooting Setup';
//                     Image = Troubleshoot;
//                     RunObject = Page 5993;
//                                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     ToolTip = 'View or edit your settings for troubleshooting service items.';
//                 }
//             }
//             group(Resources)
//             {
//                 Caption = 'Resources';
//                 Image = Resource;
//                 action("Resource &Skills")
//                 {
//                     ApplicationArea = Jobs;
//                     Caption = 'Resource &Skills';
//                     Image = ResourceSkills;
//                     RunObject = Page 6019;
//                                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     ToolTip = 'View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
//                 }
//                 action("Skilled R&esources")
//                 {
//                     AccessByPermission = TableData 5900=R;
//                     ApplicationArea = Jobs;
//                     Caption = 'Skilled R&esources';
//                     Image = ResourceSkills;
//                     ToolTip = 'View a list of all registered resources with information about whether they have the skills required to service the particular service item group, item, or service item.';

//                     trigger OnAction()
//                     var
//                         ResourceSkill: Record "5956";
//                     begin
//                         CLEAR(SkilledResourceList);
//                         SkilledResourceList.Initialize(ResourceSkill.Type::Item,"No.",Description);
//                         SkilledResourceList.RUNMODAL;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     var
//         CRMCouplingManagement: Codeunit "5331";
//         WorkflowWebhookManagement: Codeunit "1543";
//     begin
//         SetSocialListeningFactboxVisibility;

//         CRMIsCoupledToRecord :=
//           CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID) AND CRMIntegrationEnabled;

//         OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

//         CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
//         CurrPage.ItemAttributesFactBox.PAGE.LoadItemAttributesData("No.");

//         WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

//         SetWorkflowManagementEnabledState;

//         // Contextual Power BI FactBox: send data to filter the report in the FactBox
//         CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection("No.",FALSE);
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         EnableControls;
//     end;

//     trigger OnFindRecord(Which: Text): Boolean
//     var
//         Found: Boolean;
//     begin
//         IF RunOnTempRec THEN BEGIN
//           TempItemFilteredFromAttributes.COPY(Rec);
//           Found := TempItemFilteredFromAttributes.FIND(Which);
//           IF Found THEN
//             Rec := TempItemFilteredFromAttributes;
//           EXIT(Found);
//         END;
//         EXIT(FIND(Which));
//     end;

//     trigger OnNextRecord(Steps: Integer): Integer
//     var
//         ResultSteps: Integer;
//     begin
//         IF RunOnTempRec THEN BEGIN
//           TempItemFilteredFromAttributes.COPY(Rec);
//           ResultSteps := TempItemFilteredFromAttributes.NEXT(Steps);
//           IF ResultSteps <> 0 THEN
//             Rec := TempItemFilteredFromAttributes;
//           EXIT(ResultSteps);
//         END;
//         EXIT(NEXT(Steps));
//     end;

//     trigger OnOpenPage()
//     var
//         CRMIntegrationManagement: Codeunit "5330";
//         ClientTypeManagement: Codeunit "4";
//     begin
//         CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
//         IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
//         SetWorkflowManagementEnabledState;
//         IsOnPhone := ClientTypeManagement.IsClientType(CLIENTTYPE::Phone);

//         // Contextual Power BI FactBox: filtering available reports, setting context, loading Power BI related user settings
//         CurrPage."Power BI Report FactBox".PAGE.SetNameFilter(CurrPage.CAPTION);
//         CurrPage."Power BI Report FactBox".PAGE.SetContext(CurrPage.OBJECTID(FALSE));
//         PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,CurrPage.OBJECTID(FALSE));
//     end;

//     var
//         TempFilterItemAttributesBuffer: Record "7506" temporary;
//         TempItemFilteredFromAttributes: Record "27" temporary;
//         TempItemFilteredFromPickItem: Record "27" temporary;
//         ApplicationAreaSetup: Record "9178";
//         PowerBIUserConfiguration: Record "6304";
//         SetPowerBIUserConfig: Codeunit "6305";
//         CalculateStdCost: Codeunit "5812";
//         ItemAvailFormsMgt: Codeunit "353";
//         ApprovalsMgmt: Codeunit "1535";
//         ClientTypeManagement: Codeunit "4";
//         SkilledResourceList: Page "6023";
//                                  IsFoundationEnabled: Boolean;
//     [InDataSet]

//     SocialListeningSetupVisible: Boolean;
//         [InDataSet]
//         SocialListeningVisible: Boolean;
//         CRMIntegrationEnabled: Boolean;
//         CRMIsCoupledToRecord: Boolean;
//         OpenApprovalEntriesExist: Boolean;
//         [InDataSet]
//         IsService: Boolean;
//         [InDataSet]
//         InventoryItemEditable: Boolean;
//         EnabledApprovalWorkflowsExist: Boolean;
//         CanCancelApprovalForRecord: Boolean;
//         IsOnPhone: Boolean;
//         RunOnTempRec: Boolean;
//         EventFilter: Text;
//         PowerBIVisible: Boolean;
//         CanRequestApprovalForFlow: Boolean;
//         CanCancelApprovalForFlow: Boolean;
//         RunOnPickItem: Boolean;

//     procedure SelectActiveItems(): Text
//     var
//         Item: Record "27";
//     begin
//         EXIT(SelectInItemList(Item));
//     end;

//     local procedure SelectInItemList(var Item: Record "27"): Text
//     var
//         ItemListPage: Page "31";
//     begin
//         Item.SETRANGE(Blocked,FALSE);
//         ItemListPage.SETTABLEVIEW(Item);
//         ItemListPage.LOOKUPMODE(TRUE);
//         IF ItemListPage.RUNMODAL = ACTION::LookupOK THEN
//           EXIT(ItemListPage.GetSelectionFilter);
//     end;

//     procedure GetSelectionFilter(): Text
//     var
//         Item: Record "27";
//         SelectionFilterManagement: Codeunit "46";
//     begin
//         CurrPage.SETSELECTIONFILTER(Item);
//         EXIT(SelectionFilterManagement.GetSelectionFilterForItem(Item));
//     end;

//     procedure SetSelection(var Item: Record "27")
//     begin
//         CurrPage.SETSELECTIONFILTER(Item);
//     end;

//     local procedure SetSocialListeningFactboxVisibility()
//     var
//         SocialListeningMgt: Codeunit "871";
//     begin
//         SocialListeningMgt.GetItemFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
//     end;

//     local procedure EnableControls()
//     begin
//         IsService := (Type = Type::Service);
//         InventoryItemEditable := Type = Type::Inventory;
//     end;

//     local procedure SetWorkflowManagementEnabledState()
//     var
//         WorkflowManagement: Codeunit "1501";
//         WorkflowEventHandling: Codeunit "1520";
//     begin
//         EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode + '|' +
//           WorkflowEventHandling.RunWorkflowOnItemChangedCode;

//         EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item,EventFilter);
//     end;

//     local procedure ClearAttributesFilter()
//     begin
//         CLEARMARKS;
//         MARKEDONLY(FALSE);
//         TempFilterItemAttributesBuffer.RESET;
//         TempFilterItemAttributesBuffer.DELETEALL;
//         FILTERGROUP(0);
//         SETRANGE("No.");
//     end;

//     [Scope('Internal')]
//     procedure SetTempFilteredItemRec(var Item: Record "27")
//     begin
//         TempItemFilteredFromAttributes.RESET;
//         TempItemFilteredFromAttributes.DELETEALL;

//         TempItemFilteredFromPickItem.RESET;
//         TempItemFilteredFromPickItem.DELETEALL;

//         RunOnTempRec := TRUE;
//         RunOnPickItem := TRUE;

//         IF Item.FINDSET THEN
//           REPEAT
//             TempItemFilteredFromAttributes := Item;
//             TempItemFilteredFromAttributes.INSERT;
//             TempItemFilteredFromPickItem := Item;
//             TempItemFilteredFromPickItem.INSERT;
//           UNTIL Item.NEXT = 0;
//     end;

//     local procedure RestoreTempItemFilteredFromAttributes()
//     begin
//         IF NOT RunOnPickItem THEN
//           EXIT;

//         TempItemFilteredFromAttributes.RESET;
//         TempItemFilteredFromAttributes.DELETEALL;
//         RunOnTempRec := TRUE;

//         IF TempItemFilteredFromPickItem.FINDSET THEN
//           REPEAT
//             TempItemFilteredFromAttributes := TempItemFilteredFromPickItem;
//             TempItemFilteredFromAttributes.INSERT;
//           UNTIL TempItemFilteredFromPickItem.NEXT = 0;
//     end;
// }

