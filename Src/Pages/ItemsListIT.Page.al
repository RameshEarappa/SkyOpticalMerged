page 50102 "Items List_IT"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'product_id';
                    ToolTip = 'Specifies the number of the item.';
                }
                field("SKU Id"; Rec."SKU Id")
                {
                    Caption = 'sku';
                }
                field("Website ID"; Rec."Website ID")
                {
                    Caption = 'website_id';
                }
                field("Product Type"; Rec."Product Type")
                {
                    Caption = 'type_id';
                }
                field(Location; Rec.Location)
                {
                    Caption = 'store_id';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'product_name_value';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Caption = 'price';
                }
                field("Tax Class"; Rec."Tax Class")
                {
                    Caption = 'tax_class_id';
                }
                field("Parent SKU"; Rec."Parent SKU")
                {
                    Caption = 'parent_sku';
                }
                field("Attribute Set"; Rec."Attribute Set")
                {
                    Caption = 'Attribute_Set';
                }
                field(Weight; Rec.Weight)
                {
                    Caption = 'weight';
                }
                field(Power; Rec.Power)
                {
                    Caption = 'power';
                }
                field(Add; Rec.Add)
                {
                    Caption = 'add';
                }
                field(Axis; Rec.Axis)
                {
                    Caption = 'axis';
                }
                field(Cylinder; Rec.Cylinder)
                {
                    Caption = 'cylinder';
                }
                field("Base Curve"; Rec."Base Curve")
                {
                    Caption = 'base_curve';
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    Caption = 'country_of_manufacture';
                }
                field(GTIN; Rec.GTIN)
                {
                    Caption = 'gtin';
                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    Caption = 'manufacturer';
                }
                field(Usage; Rec.Usage)
                {
                    Caption = 'usage';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Last Time Modified"; Rec."Last Time Modified")
                {
                }
            }
        }
    }

    actions
    {
    }
}

