page 50103 "Item Ledger Entries_IT"
{
    Caption = 'Item Ledger Entries';
    DataCaptionExpression = GetCaption;
    DataCaptionFields = "Item No.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EntryNo';
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ItemNo';
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'PostingDate';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    Caption = 'EntryType';
                }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'DocumentNo';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'LocationCode';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'RemainingQuantity';
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed.';
                    Visible = true;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'InvoicedQuantity';
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                    Visible = true;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Open';
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field(Positive; Rec.Positive)
                {
                    Caption = 'Positive';
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'DocumentDate';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Caption = 'UnitofMeasureCode';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Caption = 'ItemCategoryCode';
                }
                field("Completely Invoiced"; Rec."Completely Invoiced")
                {
                    Caption = 'CompletelyInvoiced';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    Caption = 'SerialNo';
                }
                field("Item Tracking"; Rec."Item Tracking")
                {
                    Caption = 'ItemTracking';
                }
                field("Return Reason Code"; Rec."Return Reason Code")
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
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";

    local procedure GetCaption(): Text
    var
        GLSetup: Record "General Ledger Setup";
        ObjTransl: Record "Object Translation";
        Item: Record Item;
        ProdOrder: Record "Production Order";
        Cust: Record Customer;
        Vend: Record Vendor;
        Dimension: Record Dimension;
        DimValue: Record "Dimension Value";
        SourceTableName: Text;
        SourceFilter: Text;
        Description: Text[100];
    begin
    end;
}

