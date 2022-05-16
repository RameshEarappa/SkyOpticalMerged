tableextension 50100 "Customer Ext" extends Customer
{
    fields
    {
        field(50000; "Associated to Website"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}