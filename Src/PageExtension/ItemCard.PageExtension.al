pageextension 50102 "item Card Ext" extends "Item Card"
{
    layout
    {
        addafter("Posting Details")
        {
            field("SKU Id"; Rec."SKU Id")
            {
                ToolTip = 'Specifies the value of the SKU Id field.';
                ApplicationArea = All;
            }
            field("Website ID"; Rec."Website ID")
            {
                ToolTip = 'Specifies the value of the Website ID field.';
                ApplicationArea = All;
            }
            field("Product Type"; Rec."Product Type")
            {
                ToolTip = 'Specifies the value of the Product Type field.';
                ApplicationArea = All;
            }
            field("Tax Class"; Rec."Tax Class")
            {
                ToolTip = 'Specifies the value of the Tax Class field.';
                ApplicationArea = All;
            }
            field("Parent SKU"; Rec."Parent SKU")
            {
                ToolTip = 'Specifies the value of the Parent SKU field.';
                ApplicationArea = All;
            }
            field("Attribute Set"; Rec."Attribute Set")
            {
                ToolTip = 'Specifies the value of the Attribute Set field.';
                ApplicationArea = All;
            }
            field(Weight; Rec.Weight)
            {
                ToolTip = 'Specifies the value of the Weight field.';
                ApplicationArea = All;
            }
            field(Power; Rec.Power)
            {
                ToolTip = 'Specifies the value of the Power field.';
                ApplicationArea = All;
            }
            field("Add"; Rec."Add")
            {
                ToolTip = 'Specifies the value of the Add field.';
                ApplicationArea = All;
            }
            field(Axis; Rec.Axis)
            {
                ToolTip = 'Specifies the value of the Axis field.';
                ApplicationArea = All;
            }
            field(Cylinder; Rec.Cylinder)
            {
                ToolTip = 'Specifies the value of the Cylinder field.';
                ApplicationArea = All;
            }
            field("Base Curve"; Rec."Base Curve")
            {
                ToolTip = 'Specifies the value of the Base Curve field.';
                ApplicationArea = All;
            }
            field(Manufacturer; Rec.Manufacturer)
            {
                ToolTip = 'Specifies the value of the Manufacturer field.';
                ApplicationArea = All;
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ToolTip = 'Specifies the value of the Manufacturer Code field.';
                ApplicationArea = All;
            }
            field(Usage; Rec.Usage)
            {
                ToolTip = 'Specifies the value of the Usage field.';
                ApplicationArea = All;
            }
        }
    }
}
