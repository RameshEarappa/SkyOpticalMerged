pageextension 50106 "Posted Sales Inv Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Customer Email"; Rec."Customer Email")
            {
                ToolTip = 'Specifies the value of the Customer Email field.';
                ApplicationArea = All;
            }
            field("Order #"; Rec."Order #")
            {
                ToolTip = 'Specifies the value of the Order # field.';
                ApplicationArea = All;
            }
            field("Invoice Date"; Rec."Invoice Date")
            {
                ToolTip = 'Specifies the value of the Invoice Date field.';
                ApplicationArea = All;
            }
            field("Phone Number Billing"; Rec."Phone Number Billing")
            {
                ToolTip = 'Specifies the value of the Phone Number Billing field.';
                ApplicationArea = All;
            }
            field("Phone Number Shipping"; Rec."Phone Number Shipping")
            {
                ToolTip = 'Specifies the value of the Phone Number Shipping field.';
                ApplicationArea = All;
            }
            field("Order Status"; Rec."Order Status")
            {
                ToolTip = 'Specifies the value of the Order Status field.';
                ApplicationArea = All;
            }
            field("Order State"; Rec."Order State")
            {
                ToolTip = 'Specifies the value of the Order State field.';
                ApplicationArea = All;
            }
            field("Conversion rate"; Rec."Conversion rate")
            {
                ToolTip = 'Specifies the value of the Conversion rate field.';
                ApplicationArea = All;
            }
            field("Website associated to Names"; Rec."Website associated to Names")
            {
                ToolTip = 'Specifies the value of the Website associated to Names field.';
                ApplicationArea = All;
            }
            field("Website associated to"; Rec."Website associated to")
            {
                ToolTip = 'Specifies the value of the Website associated to field.';
                ApplicationArea = All;
            }
            field("Store Code"; Rec."Store Code")
            {
                ToolTip = 'Specifies the value of the Store Code field.';
                ApplicationArea = All;
            }
            field(Total_Amt_Before_Disc_and_VAT; Rec.Total_Amt_Before_Disc_and_VAT)
            {
                ToolTip = 'Specifies the value of the Total_Amt_Before_Disc_and_VAT field.';
                ApplicationArea = All;
            }
            field(Total_Discount_Amount; Rec.Total_Discount_Amount)
            {
                ToolTip = 'Specifies the value of the Total_Discount_Amount field.';
                ApplicationArea = All;
            }
            field(Total_VAT_Amount; Rec.Total_VAT_Amount)
            {
                ToolTip = 'Specifies the value of the Total_VAT_Amount field.';
                ApplicationArea = All;
            }
            field(Shipping_Charges; Rec.Shipping_Charges)
            {
                ToolTip = 'Specifies the value of the Shipping_Charges field.';
                ApplicationArea = All;
            }
            field(Total_Invoice_Amount; Rec.Total_Invoice_Amount)
            {
                ToolTip = 'Specifies the value of the Total_Invoice_Amount field.';
                ApplicationArea = All;
            }
            field(Total_Receipt_Amount; Rec.Total_Receipt_Amount)
            {
                ToolTip = 'Specifies the value of the Total_Receipt_Amount field.';
                ApplicationArea = All;
            }
            field("Invoice #"; Rec."Invoice #")
            {
                ToolTip = 'Specifies the value of the Invoice # field.';
                ApplicationArea = All;
            }
            // field(Cancelled; Rec.Cancelled)
            // {
            //     ToolTip = 'Specifies the value of the Cancelled field.';
            //     ApplicationArea = All;
            // }
        }
    }
}