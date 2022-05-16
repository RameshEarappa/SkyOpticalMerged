tableextension 50101 "Item Ext" extends Item
{
    fields
    {
        field(50000; "SKU Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Website ID"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","lense.me",solotica,wholesale;
        }
        field(50002; "Product Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Simple,Conf,"Gift Card",Bundle,Virtual;
        }
        field(50003; "Tax Class"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "None","Taxable Goods","Taxable Goods-Plano Cosmetic",Shipping;
        }
        field(50004; "Parent SKU"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Attribute Set"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Contact Lens Colored","Contact Lens Daily","Contact Lends Daily WBc","Contact Lens Default","Contact Lens Default WBc","Contact Lens Multifocal","Contact Lens Toric",Default,"Standard Product";
        }
        field(50006; Weight; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Power; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
            OptionMembers = " ","0.00","-0.25","-0.50";
        }
        field(50008; Add; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50009; Axis; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50010; Cylinder; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50011; "Base Curve"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50012; "Country of Origin"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
            TableRelation = "Country/Region";
        }
        field(50013; Manufacturer; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50014; Usage; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Daily,Biweekly,Monthly,"3-Monthly","6-Monthly",Yearly;
        }
        field(50015; Location; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
    }
}