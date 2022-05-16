page 50001 "Items List_IT"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table27;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Caption = 'product_id';
                    ToolTip = 'Specifies the number of the item.';
                }
                field("SKU Id"; "SKU Id")
                {
                    Caption = 'sku';
                }
                field("Website ID"; "Website ID")
                {
                    Caption = 'website_id';
                }
                field("Product Type"; "Product Type")
                {
                    Caption = 'type_id';
                }
                field(Location; Location)
                {
                    Caption = 'store_id';
                }
                field(Description; Description)
                {
                    Caption = 'product_name_value';
                }
                field("Unit Price"; "Unit Price")
                {
                    Caption = 'price';
                }
                field("Tax Class"; "Tax Class")
                {
                    Caption = 'tax_class_id';
                }
                field("Parent SKU"; "Parent SKU")
                {
                    Caption = 'parent_sku';
                }
                field("Attribute Set"; "Attribute Set")
                {
                    Caption = 'Attribute_Set';
                }
                field(Weight; Weight)
                {
                    Caption = 'weight';
                }
                field(Power; Power)
                {
                    Caption = 'power';
                }
                field(Add; Add)
                {
                    Caption = 'add';
                }
                field(Axis; Axis)
                {
                    Caption = 'axis';
                }
                field(Cylinder; Cylinder)
                {
                    Caption = 'cylinder';
                }
                field("Base Curve"; "Base Curve")
                {
                    Caption = 'base_curve';
                }
                field("Country of Origin"; "Country of Origin")
                {
                    Caption = 'country_of_manufacture';
                }
                field(GTIN; GTIN)
                {
                    Caption = 'gtin';
                }
                field(Manufacturer; Manufacturer)
                {
                    Caption = 'manufacturer';
                }
                field(Usage; Usage)
                {
                    Caption = 'usage';
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("Last Time Modified"; "Last Time Modified")
                {
                }
            }
        }
    }

    actions
    {
    }
}

