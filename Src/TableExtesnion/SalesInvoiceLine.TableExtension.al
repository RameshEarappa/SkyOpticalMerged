tableextension 50107 "Sales Inv Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Item Sku"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}