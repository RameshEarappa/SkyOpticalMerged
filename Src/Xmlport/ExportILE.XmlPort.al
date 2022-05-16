xmlport 50101 "Export ILE"
{
    Direction = Export;
    Encoding = UTF8;
    UseRequestPage = false;

    schema
    {
        tableelement("Item Ledger Entry"; "Item Ledger Entry")
        {
            XmlName = 'ItemLedgerEntries';
            fieldelement(EntryNo; "Item Ledger Entry"."Entry No.")
            {
            }
            fieldelement(ItemNo; "Item Ledger Entry"."Item No.")
            {
            }
            fieldelement(PostingDate; "Item Ledger Entry"."Posting Date")
            {
            }
            fieldelement(EntryType; "Item Ledger Entry"."Entry Type")
            {
            }
            fieldelement(DocumentNo; "Item Ledger Entry"."Document No.")
            {
            }
            fieldelement(Description; "Item Ledger Entry".Description)
            {
            }
            fieldelement(LocationCode; "Item Ledger Entry"."Location Code")
            {
            }
            fieldelement(Quantity; "Item Ledger Entry".Quantity)
            {
            }
            fieldelement(RemainingQuantity; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            fieldelement(InvoicedQuantity; "Item Ledger Entry"."Invoiced Quantity")
            {
            }
            fieldelement(Open; "Item Ledger Entry".Open)
            {
            }
            fieldelement(Positive; "Item Ledger Entry".Positive)
            {
            }
            fieldelement(DocumentDate; "Item Ledger Entry"."Document Date")
            {
            }
            fieldelement(UnitofMeasureCode; "Item Ledger Entry"."Unit of Measure Code")
            {
            }
            fieldelement(ItemCategoryCode; "Item Ledger Entry"."Item Category Code")
            {
            }
            fieldelement(CompletelyInvoiced; "Item Ledger Entry"."Completely Invoiced")
            {
            }
            fieldelement("SerialNo."; "Item Ledger Entry"."Serial No.")
            {
            }
            fieldelement(ItemTracking; "Item Ledger Entry"."Item Tracking")
            {
            }
            fieldelement(ReturnReasonCode; "Item Ledger Entry"."Return Reason Code")
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

