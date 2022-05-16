tableextension 50105 "Sales Inv Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Customer Email"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Order #"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Phone Number Billing"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Phone Number Shipping"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Order Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Order State"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Conversion rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Website associated to Names"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Website associated to"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Store Code"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; Total_Amt_Before_Disc_and_VAT; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; Total_Discount_Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; Total_VAT_Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; Shipping_Charges; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; Total_Invoice_Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; Total_Receipt_Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Invoice #"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        // field(50018; Cancelled; Boolean)
        // {
        //     DataClassification = ToBeClassified;
        // }
    }
}