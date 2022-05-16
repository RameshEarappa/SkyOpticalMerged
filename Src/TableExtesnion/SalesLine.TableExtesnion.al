tableextension 50103 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50000; "Item Sku"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}