page 50002 "Item Ledger Entries_IT"
{
    Caption = 'Item Ledger Entries';
    DataCaptionExpression = GetCaption;
    DataCaptionFields = "Item No.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table32;
    SourceTableView = SORTING (Entry No.)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EntryNo';
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ItemNo';
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("Posting Date"; "Posting Date")
                {
                    Caption = 'PostingDate';
                }
                field("Entry Type"; "Entry Type")
                {
                    Caption = 'EntryType';
                }
                field("Document No."; "Document No.")
                {
                    Caption = 'DocumentNo';
                }
                field(Description; Description)
                {
                    Caption = 'Description';
                }
                field("Location Code"; "Location Code")
                {
                    Caption = 'LocationCode';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'RemainingQuantity';
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed.';
                    Visible = true;
                }
                field("Invoiced Quantity"; "Invoiced Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'InvoicedQuantity';
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                    Visible = true;
                }
                field(Open; Open)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Open';
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field(Positive; Positive)
                {
                    Caption = 'Positive';
                }
                field("Document Date"; "Document Date")
                {
                    Caption = 'DocumentDate';
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Caption = 'UnitofMeasureCode';
                }
                field("Item Category Code"; "Item Category Code")
                {
                    Caption = 'ItemCategoryCode';
                }
                field("Completely Invoiced"; "Completely Invoiced")
                {
                    Caption = 'CompletelyInvoiced';
                }
                field("Serial No."; "Serial No.")
                {
                    Caption = 'SerialNo';
                }
                field("Item Tracking"; "Item Tracking")
                {
                    Caption = 'ItemTracking';
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Caption = 'ReturnReasonCode';
                }
            }
        }
    }

    actions
    {
    }

    var
        Navigate: Page "344";
        DimensionSetIDFilter: Page "481";

    local procedure GetCaption(): Text
    var
        GLSetup: Record "98";
        ObjTransl: Record "377";
        Item: Record "27";
        ProdOrder: Record "5405";
        Cust: Record "18";
        Vend: Record "23";
        Dimension: Record "348";
        DimValue: Record "349";
        SourceTableName: Text;
        SourceFilter: Text;
        Description: Text[100];
    begin
    end;
}

