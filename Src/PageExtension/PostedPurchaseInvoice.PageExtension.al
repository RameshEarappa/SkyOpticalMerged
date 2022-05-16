pageextension 50107 "Posted Purch Inv Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Posting Date")
        {
            // field(Cancelled; Rec.Cancelled)
            // {
            //     ToolTip = 'Specifies the value of the Cancelled field.';
            //     ApplicationArea = All;
            // }
        }
    }
}