pageextension 50101 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter("Post Code")
        {
            field("Associated to Website"; Rec."Associated to Website")
            {
                ToolTip = 'Specifies the value of the Associated to Website field.';
                ApplicationArea = All;
            }
        }
    }
}