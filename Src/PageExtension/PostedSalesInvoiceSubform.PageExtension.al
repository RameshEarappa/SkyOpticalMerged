pageextension 50100 "Posted SalesInvSubform Ext" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Unit Cost (LCY)")
        {
            field("Item Sku"; Rec."Item Sku")
            {
                ToolTip = 'Specifies the value of the Item Sku field.';
                ApplicationArea = All;
            }
        }
    }
}