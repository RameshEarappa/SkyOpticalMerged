pageextension 50105 "Sales Order Subform Ext" extends "Sales Order Subform"
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