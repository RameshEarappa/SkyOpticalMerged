pageextension 50104 "Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter("Posting Date")
        {
            field(Cancelled; Rec.Cancelled)
            {
                ToolTip = 'Specifies the value of the Cancelled field.';
                ApplicationArea = All;
            }
        }
    }
}