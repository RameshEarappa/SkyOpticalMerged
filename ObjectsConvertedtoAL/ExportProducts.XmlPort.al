xmlport 50000 "Export Products"
{
    Direction = Export;
    Encoding = UTF8;
    UseRequestPage = false;

    schema
    {
        tableelement(Table27; Table27)
        {
            XmlName = 'Items';
            fieldelement(product_id; Item."No.")
            {
            }
            fieldelement(sku; Item."SKU Id")
            {
            }
            fieldelement(website_id; Item."Website ID")
            {
            }
            fieldelement(type_id; Item."Product Type")
            {
            }
            fieldelement(store_id; Item.Location)
            {
            }
            fieldelement(product_name_value; Item.Description)
            {
            }
            fieldelement(price; Item."Unit Price")
            {
            }
            fieldelement(tax_class_id; Item."Tax Class")
            {
            }
            fieldelement(parent_sku; Item."Parent SKU")
            {
            }
            fieldelement(Attribute_Set; Item."Attribute Set")
            {
            }
            fieldelement(weight; Item.Weight)
            {
            }
            fieldelement(power; Item.Power)
            {
            }
            fieldelement(add; Item.Add)
            {
            }
            fieldelement(axis; Item.Axis)
            {
            }
            fieldelement(cylinder; Item.Cylinder)
            {
            }
            fieldelement(base_curve; Item."Base Curve")
            {
            }
            fieldelement(country_of_manufacture; Item."Country of Origin")
            {
            }
            fieldelement(gtin; Item.GTIN)
            {
            }
            fieldelement(manufacturer; Item.Manufacturer)
            {
            }
            fieldelement(usage; Item.Usage)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

