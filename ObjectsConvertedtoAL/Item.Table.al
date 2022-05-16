table 27 Item
{
    Caption = 'Item';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = 31;
    LookupPageID = 31;
    Permissions =;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    GetInvtSetup;
                    NoSeriesMgt.TestManual(InvtSetup."Item Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                    "Search Description" := Description;

                IF "Created From Nonstock Item" THEN BEGIN
                    NonstockItem.SETCURRENTKEY("Item No.");
                    NonstockItem.SETRANGE("Item No.", "No.");
                    IF NonstockItem.FINDFIRST THEN
                        IF NonstockItem.Description = '' THEN BEGIN
                            NonstockItem.Description := Description;
                            NonstockItem.MODIFY;
                        END;
                END;
            end;
        }
        field(4; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(6; "Assembly BOM"; Boolean)
        {
            CalcFormula = Exist ("BOM Component" WHERE (Parent Item No.=FIELD(No.)));
            Caption = 'Assembly BOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Base Unit of Measure";Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UnitOfMeasure: Record "204";
            begin
                UpdateUnitOfMeasureId;

                IF "Base Unit of Measure" <> xRec."Base Unit of Measure" THEN BEGIN
                  TestNoOpenEntriesExist(FIELDCAPTION("Base Unit of Measure"));

                  "Sales Unit of Measure" := "Base Unit of Measure";
                  "Purch. Unit of Measure" := "Base Unit of Measure";
                  IF "Base Unit of Measure" <> '' THEN BEGIN
                    UnitOfMeasure.GET("Base Unit of Measure");

                    IF NOT ItemUnitOfMeasure.GET("No.","Base Unit of Measure") THEN BEGIN
                      ItemUnitOfMeasure.INIT;
                      IF ISTEMPORARY THEN
                        ItemUnitOfMeasure."Item No." := "No."
                      ELSE
                        ItemUnitOfMeasure.VALIDATE("Item No.","No.");
                      ItemUnitOfMeasure.VALIDATE(Code,"Base Unit of Measure");
                      ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
                      ItemUnitOfMeasure.INSERT;
                    END ELSE BEGIN
                      IF ItemUnitOfMeasure."Qty. per Unit of Measure" <> 1 THEN
                        ERROR(STRSUBSTNO(BaseUnitOfMeasureQtyMustBeOneErr,"Base Unit of Measure",ItemUnitOfMeasure."Qty. per Unit of Measure"));
                    END;
                  END;
                END;
            end;
        }
        field(9;"Price Unit Conversion";Integer)
        {
            Caption = 'Price Unit Conversion';
        }
        field(10;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Inventory,Service';
            OptionMembers = Inventory,Service;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "32";
            begin
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETCURRENTKEY("Item No.");
                ItemLedgEntry.SETRANGE("Item No.","No.");
                IF NOT ItemLedgEntry.ISEMPTY THEN
                  ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ItemLedgEntry.TABLECAPTION);

                CheckJournalsAndWorksheets(FIELDNO(Type));
                CheckDocuments(FIELDNO(Type));
                IF Type = Type::Service THEN BEGIN
                  CALCFIELDS("Assembly BOM");
                  TESTFIELD("Assembly BOM",FALSE);

                  CALCFIELDS("Stockkeeping Unit Exists");
                  TESTFIELD("Stockkeeping Unit Exists",FALSE);

                  VALIDATE("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
                  VALIDATE("Replenishment System","Replenishment System"::Purchase);
                  VALIDATE(Reserve,Reserve::Never);
                  VALIDATE("Inventory Posting Group",'');
                  VALIDATE("Item Tracking Code",'');
                  VALIDATE("Costing Method","Costing Method"::FIFO);
                  VALIDATE("Production BOM No.",'');
                  VALIDATE("Routing No.",'');
                  VALIDATE("Reordering Policy","Reordering Policy"::" ");
                  VALIDATE("Order Tracking Policy","Order Tracking Policy"::None);
                  VALIDATE("Overhead Rate",0);
                  VALIDATE("Indirect Cost %",0);
                END;
            end;
        }
        field(11;"Inventory Posting Group";Code[20])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";

            trigger OnValidate()
            begin
                IF "Inventory Posting Group" <> '' THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(12;"Shelf No.";Code[10])
        {
            Caption = 'Shelf No.';
        }
        field(14;"Item Disc. Group";Code[20])
        {
            Caption = 'Item Disc. Group';
            TableRelation = "Item Discount Group";
        }
        field(15;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(16;"Statistics Group";Integer)
        {
            Caption = 'Statistics Group';
        }
        field(17;"Commission Group";Integer)
        {
            Caption = 'Commission Group';
        }
        field(18;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(19;"Price/Profit Calculation";Option)
        {
            Caption = 'Price/Profit Calculation';
            OptionCaption = 'Profit=Price-Cost,Price=Cost+Profit,No Relationship';
            OptionMembers = "Profit=Price-Cost","Price=Cost+Profit","No Relationship";

            trigger OnValidate()
            begin
                CASE "Price/Profit Calculation" OF
                  "Price/Profit Calculation"::"Profit=Price-Cost":
                    IF "Unit Price" <> 0 THEN
                      IF "Unit Cost" = 0 THEN
                        "Profit %" := 0
                      ELSE
                        "Profit %" :=
                          ROUND(
                            100 * (1 - "Unit Cost" /
                                   ("Unit Price" / (1 + CalcVAT))),0.00001)
                    ELSE
                      "Profit %" := 0;
                  "Price/Profit Calculation"::"Price=Cost+Profit":
                    IF "Profit %" < 100 THEN BEGIN
                      GetGLSetup;
                      "Unit Price" :=
                        ROUND(
                          ("Unit Cost" / (1 - "Profit %" / 100)) *
                          (1 + CalcVAT),
                          GLSetup."Unit-Amount Rounding Precision");
                    END;
                END;
            end;
        }
        field(20;"Profit %";Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(21;"Costing Method";Option)
        {
            Caption = 'Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;

            trigger OnValidate()
            begin
                IF "Costing Method" = xRec."Costing Method" THEN
                  EXIT;

                IF "Costing Method" <> "Costing Method"::FIFO THEN
                  TESTFIELD(Type,Type::Inventory);

                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                  TESTFIELD("Item Tracking Code");

                  ItemTrackingCode.GET("Item Tracking Code");
                  IF NOT ItemTrackingCode."SN Specific Tracking" THEN
                    ERROR(
                      Text018,
                      ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"),
                      FORMAT(TRUE),ItemTrackingCode.TABLECAPTION,ItemTrackingCode.Code,
                      FIELDCAPTION("Costing Method"),"Costing Method");
                END;

                TestNoEntriesExist(FIELDCAPTION("Costing Method"));

                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Costing Method"));
            end;
        }
        field(22;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Costing Method" = "Costing Method"::Standard THEN
                  VALIDATE("Standard Cost","Unit Cost")
                ELSE
                  TestNoEntriesExist(FIELDCAPTION("Unit Cost"));
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(24;"Standard Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Standard Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF ("Costing Method" = "Costing Method"::Standard) AND (CurrFieldNo <> 0) THEN
                  IF NOT GUIALLOWED THEN BEGIN
                    "Standard Cost" := xRec."Standard Cost";
                    EXIT;
                  END ELSE
                    IF NOT
                       CONFIRM(
                         Text020 +
                         Text021 +
                         Text022,FALSE,
                         FIELDCAPTION("Standard Cost"))
                    THEN BEGIN
                      "Standard Cost" := xRec."Standard Cost";
                      EXIT;
                    END;

                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Standard Cost"));
            end;
        }
        field(25;"Last Direct Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Last Direct Cost';
            MinValue = 0;
        }
        field(28;"Indirect Cost %";Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Indirect Cost %" > 0 THEN
                  TESTFIELD(Type,Type::Inventory);
                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Indirect Cost %"));
            end;
        }
        field(29;"Cost is Adjusted";Boolean)
        {
            Caption = 'Cost is Adjusted';
            Editable = false;
            InitValue = true;
        }
        field(30;"Allow Online Adjustment";Boolean)
        {
            Caption = 'Allow Online Adjustment';
            Editable = false;
            InitValue = true;
        }
        field(31;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                IF (xRec."Vendor No." <> "Vendor No.") AND
                   ("Vendor No." <> '')
                THEN
                  IF Vend.GET("Vendor No.") THEN
                    "Lead Time Calculation" := Vend."Lead Time Calculation";
            end;
        }
        field(32;"Vendor Item No.";Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(33;"Lead Time Calculation";DateFormula)
        {
            AccessByPermission = TableData 120=R;
            Caption = 'Lead Time Calculation';

            trigger OnValidate()
            begin
                LeadTimeMgt.CheckLeadTimeIsNotNegative("Lead Time Calculation");
            end;
        }
        field(34;"Reorder Point";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Reorder Point';
            DecimalPlaces = 0:5;
        }
        field(35;"Maximum Inventory";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Maximum Inventory';
            DecimalPlaces = 0:5;
        }
        field(36;"Reorder Quantity";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Reorder Quantity';
            DecimalPlaces = 0:5;
        }
        field(37;"Alternative Item No.";Code[20])
        {
            Caption = 'Alternative Item No.';
            TableRelation = Item;
        }
        field(38;"Unit List Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit List Price';
            MinValue = 0;
        }
        field(39;"Duty Due %";Decimal)
        {
            Caption = 'Duty Due %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(40;"Duty Code";Code[10])
        {
            Caption = 'Duty Code';
        }
        field(41;"Gross Weight";Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(42;"Net Weight";Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(43;"Units per Parcel";Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(44;"Unit Volume";Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(45;Durability;Code[10])
        {
            Caption = 'Durability';
        }
        field(46;"Freight Type";Code[10])
        {
            Caption = 'Freight Type';
        }
        field(47;"Tariff No.";Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                TariffNumber: Record "260";
            begin
                IF "Tariff No." = '' THEN
                  EXIT;

                IF (NOT TariffNumber.WRITEPERMISSION) OR
                   (NOT TariffNumber.READPERMISSION)
                THEN
                  EXIT;

                IF TariffNumber.GET("Tariff No.") THEN
                  EXIT;

                TariffNumber.INIT;
                TariffNumber."No." := "Tariff No.";
                TariffNumber.INSERT;
            end;
        }
        field(48;"Duty Unit Conversion";Decimal)
        {
            Caption = 'Duty Unit Conversion';
            DecimalPlaces = 0:5;
        }
        field(49;"Country/Region Purchased Code";Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            TableRelation = Country/Region;
        }
        field(50;"Budget Quantity";Decimal)
        {
            Caption = 'Budget Quantity';
            DecimalPlaces = 0:5;
        }
        field(51;"Budgeted Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(52;"Budget Profit";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budget Profit';
        }
        field(53;Comment;Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE (Table Name=CONST(Item),
                                                      No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54;Blocked;Boolean)
        {
            Caption = 'Blocked';

            trigger OnValidate()
            begin
                IF NOT Blocked THEN
                  "Block Reason" := '';
            end;
        }
        field(55;"Cost is Posted to G/L";Boolean)
        {
            CalcFormula = -Exist("Post Value Entry to G/L" WHERE (Item No.=FIELD(No.)));
            Caption = 'Cost is Posted to G/L';
            Editable = false;
            FieldClass = FlowField;
        }
        field(56;"Block Reason";Text[250])
        {
            Caption = 'Block Reason';

            trigger OnValidate()
            begin
                TESTFIELD(Blocked,TRUE);
            end;
        }
        field(61;"Last DateTime Modified";DateTime)
        {
            Caption = 'Last DateTime Modified';
            Editable = false;
        }
        field(62;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(63;"Last Time Modified";Time)
        {
            Caption = 'Last Time Modified';
            Editable = false;
        }
        field(64;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(65;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(66;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(67;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(68;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                  Location Code=FIELD(Location Filter),
                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                  Variant Code=FIELD(Variant Filter),
                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                  Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(69;"Net Invoiced Qty.";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Net Invoiced Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Net Change";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                  Location Code=FIELD(Location Filter),
                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                  Posting Date=FIELD(Date Filter),
                                                                  Variant Code=FIELD(Variant Filter),
                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                  Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Net Change';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(71;"Purchases (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Purchase),
                                                                             Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Posting Date=FIELD(Date Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Purchases (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(72;"Sales (Qty.)";Decimal)
        {
            CalcFormula = -Sum("Value Entry"."Invoiced Quantity" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                        Item No.=FIELD(No.),
                                                                        Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                        Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                        Location Code=FIELD(Location Filter),
                                                                        Drop Shipment=FIELD(Drop Shipment Filter),
                                                                        Variant Code=FIELD(Variant Filter),
                                                                        Posting Date=FIELD(Date Filter)));
            Caption = 'Sales (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(73;"Positive Adjmt. (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Positive Adjmt.),
                                                                             Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Posting Date=FIELD(Date Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Positive Adjmt. (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(74;"Negative Adjmt. (Qty.)";Decimal)
        {
            CalcFormula = -Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Negative Adjmt.),
                                                                              Item No.=FIELD(No.),
                                                                              Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Location Code=FIELD(Location Filter),
                                                                              Drop Shipment=FIELD(Drop Shipment Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Posting Date=FIELD(Date Filter),
                                                                              Lot No.=FIELD(Lot No. Filter),
                                                                              Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Negative Adjmt. (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(77;"Purchases (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Purchase Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Purchase),
                                                                              Item No.=FIELD(No.),
                                                                              Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Location Code=FIELD(Location Filter),
                                                                              Drop Shipment=FIELD(Drop Shipment Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Posting Date=FIELD(Date Filter)));
            Caption = 'Purchases (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78;"Sales (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                           Item No.=FIELD(No.),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Drop Shipment=FIELD(Drop Shipment Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Posting Date=FIELD(Date Filter)));
            Caption = 'Sales (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79;"Positive Adjmt. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Positive Adjmt.),
                                                                          Item No.=FIELD(No.),
                                                                          Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Drop Shipment=FIELD(Drop Shipment Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Posting Date=FIELD(Date Filter)));
            Caption = 'Positive Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;"Negative Adjmt. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Negative Adjmt.),
                                                                          Item No.=FIELD(No.),
                                                                          Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Drop Shipment=FIELD(Drop Shipment Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Posting Date=FIELD(Date Filter)));
            Caption = 'Negative Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(83;"COGS (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                           Item No.=FIELD(No.),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Drop Shipment=FIELD(Drop Shipment Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Posting Date=FIELD(Date Filter)));
            Caption = 'COGS (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(84;"Qty. on Purch. Order";Decimal)
        {
            AccessByPermission = TableData 120=R;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                               Type=CONST(Item),
                                                                               No.=FIELD(No.),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Location Code=FIELD(Location Filter),
                                                                               Drop Shipment=FIELD(Drop Shipment Filter),
                                                                               Variant Code=FIELD(Variant Filter),
                                                                               Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Qty. on Purch. Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(85;"Qty. on Sales Order";Decimal)
        {
            AccessByPermission = TableData 110=R;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                            Type=CONST(Item),
                                                                            No.=FIELD(No.),
                                                                            Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                            Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Drop Shipment=FIELD(Drop Shipment Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(87;"Price Includes VAT";Boolean)
        {
            Caption = 'Price Includes VAT';

            trigger OnValidate()
            var
                VATPostingSetup: Record "325";
                SalesSetup: Record "311";
            begin
                IF "Price Includes VAT" THEN BEGIN
                  SalesSetup.GET;
                  SalesSetup.TESTFIELD("VAT Bus. Posting Gr. (Price)");
                  "VAT Bus. Posting Gr. (Price)" := SalesSetup."VAT Bus. Posting Gr. (Price)";
                  VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
                END;
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(89;"Drop Shipment Filter";Boolean)
        {
            AccessByPermission = TableData 223=R;
            Caption = 'Drop Shipment Filter';
            FieldClass = FlowFilter;
        }
        field(90;"VAT Bus. Posting Gr. (Price)";Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(91;"Gen. Prod. Posting Group";Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN BEGIN
                  IF CurrFieldNo <> 0 THEN
                    IF ProdOrderExist THEN
                      IF NOT CONFIRM(
                           Text024 +
                           Text022,FALSE,
                           FIELDCAPTION("Gen. Prod. Posting Group"))
                      THEN BEGIN
                        "Gen. Prod. Posting Group" := xRec."Gen. Prod. Posting Group";
                        EXIT;
                      END;

                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                END;

                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(92;Picture;MediaSet)
        {
            Caption = 'Picture';
        }
        field(93;"Transferred (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Transfer),
                                                                             Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Posting Date=FIELD(Date Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Transferred (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(94;"Transferred (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Transfer),
                                                                           Item No.=FIELD(No.),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Drop Shipment=FIELD(Drop Shipment Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Posting Date=FIELD(Date Filter)));
            Caption = 'Transferred (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95;"Country/Region of Origin Code";Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = Country/Region;
        }
        field(96;"Automatic Ext. Texts";Boolean)
        {
            Caption = 'Automatic Ext. Texts';
        }
        field(97;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(98;"Tax Group Code";Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                UpdateTaxGroupId;
            end;
        }
        field(99;"VAT Prod. Posting Group";Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(100;Reserve;Option)
        {
            AccessByPermission = TableData 120=R;
            Caption = 'Reserve';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            begin
                IF Reserve <> Reserve::Never THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(101;"Reserved Qty. on Inventory";Decimal)
        {
            AccessByPermission = TableData 120=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(32),
                                                                           Source Subtype=CONST(0),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Serial No.=FIELD(Serial No. Filter),
                                                                           Lot No.=FIELD(Lot No. Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter)));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"Reserved Qty. on Purch. Orders";Decimal)
        {
            AccessByPermission = TableData 120=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(39),
                                                                           Source Subtype=CONST(1),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Reserved Qty. on Purch. Orders';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"Reserved Qty. on Sales Orders";Decimal)
        {
            AccessByPermission = TableData 110=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(37),
                                                                            Source Subtype=CONST(1),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Reserved Qty. on Sales Orders';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(105;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(106;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(107;"Res. Qty. on Outbound Transfer";Decimal)
        {
            AccessByPermission = TableData 5740=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(5741),
                                                                            Source Subtype=CONST(0),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Outbound Transfer';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(108;"Res. Qty. on Inbound Transfer";Decimal)
        {
            AccessByPermission = TableData 5740=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(5741),
                                                                           Source Subtype=CONST(1),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Inbound Transfer';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(109;"Res. Qty. on Sales Returns";Decimal)
        {
            AccessByPermission = TableData 6660=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(37),
                                                                           Source Subtype=CONST(5),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Sales Returns';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(110;"Res. Qty. on Purch. Returns";Decimal)
        {
            AccessByPermission = TableData 6650=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(39),
                                                                            Source Subtype=CONST(5),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Purch. Returns';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;"Stockout Warning";Option)
        {
            Caption = 'Stockout Warning';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(121;"Prevent Negative Inventory";Option)
        {
            Caption = 'Prevent Negative Inventory';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(200;"Cost of Open Production Orders";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Cost Amount" WHERE (Status=FILTER(Planned|Firm Planned|Released),
                                                                      Item No.=FIELD(No.)));
            Caption = 'Cost of Open Production Orders';
            FieldClass = FlowField;
        }
        field(521;"Application Wksh. User ID";Code[128])
        {
            Caption = 'Application Wksh. User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(910;"Assembly Policy";Option)
        {
            AccessByPermission = TableData 90=R;
            Caption = 'Assembly Policy';
            OptionCaption = 'Assemble-to-Stock,Assemble-to-Order';
            OptionMembers = "Assemble-to-Stock","Assemble-to-Order";

            trigger OnValidate()
            begin
                IF "Assembly Policy" = "Assembly Policy"::"Assemble-to-Order" THEN
                  TESTFIELD("Replenishment System","Replenishment System"::Assembly);
                IF Type = Type::Service THEN
                  TESTFIELD("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
            end;
        }
        field(929;"Res. Qty. on Assembly Order";Decimal)
        {
            AccessByPermission = TableData 90=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(900),
                                                                           Source Subtype=CONST(1),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Assembly Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(930;"Res. Qty. on  Asm. Comp.";Decimal)
        {
            AccessByPermission = TableData 90=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(901),
                                                                            Source Subtype=CONST(1),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on  Asm. Comp.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(977;"Qty. on Assembly Order";Decimal)
        {
            CalcFormula = Sum("Assembly Header"."Remaining Quantity (Base)" WHERE (Document Type=CONST(Order),
                                                                                   Item No.=FIELD(No.),
                                                                                   Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                   Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                   Location Code=FIELD(Location Filter),
                                                                                   Variant Code=FIELD(Variant Filter),
                                                                                   Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Assembly Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(978;"Qty. on Asm. Component";Decimal)
        {
            CalcFormula = Sum("Assembly Line"."Remaining Quantity (Base)" WHERE (Document Type=CONST(Order),
                                                                                 Type=CONST(Item),
                                                                                 No.=FIELD(No.),
                                                                                 Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                 Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                 Location Code=FIELD(Location Filter),
                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                 Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Asm. Component';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1001;"Qty. on Job Order";Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Order),
                                                                                 Type=CONST(Item),
                                                                                 No.=FIELD(No.),
                                                                                 Location Code=FIELD(Location Filter),
                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                 Planning Date=FIELD(Date Filter)));
            Caption = 'Qty. on Job Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1002;"Res. Qty. on Job Order";Decimal)
        {
            AccessByPermission = TableData 167=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(1003),
                                                                            Source Subtype=CONST(2),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Job Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1217;GTIN;Code[14])
        {
            Caption = 'GTIN';
            Numeric = true;
        }
        field(1700;"Default Deferral Template Code";Code[10])
        {
            Caption = 'Default Deferral Template Code';
            TableRelation = "Deferral Template"."Deferral Code";
        }
        field(5400;"Low-Level Code";Integer)
        {
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(5401;"Lot Size";Decimal)
        {
            AccessByPermission = TableData 5405=R;
            Caption = 'Lot Size';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5402;"Serial Nos.";Code[20])
        {
            Caption = 'Serial Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "Serial Nos." <> '' THEN
                  TESTFIELD("Item Tracking Code");
            end;
        }
        field(5403;"Last Unit Cost Calc. Date";Date)
        {
            Caption = 'Last Unit Cost Calc. Date';
            Editable = false;
        }
        field(5404;"Rolled-up Material Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Material Cost';
            DecimalPlaces = 2:5;
            Editable = false;
        }
        field(5405;"Rolled-up Capacity Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Capacity Cost';
            DecimalPlaces = 2:5;
            Editable = false;
        }
        field(5407;"Scrap %";Decimal)
        {
            AccessByPermission = TableData 5405=R;
            Caption = 'Scrap %';
            DecimalPlaces = 0:2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5409;"Inventory Value Zero";Boolean)
        {
            Caption = 'Inventory Value Zero';

            trigger OnValidate()
            begin
                CheckForProductionOutput("No.");
            end;
        }
        field(5410;"Discrete Order Quantity";Integer)
        {
            Caption = 'Discrete Order Quantity';
            MinValue = 0;
        }
        field(5411;"Minimum Order Quantity";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Minimum Order Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5412;"Maximum Order Quantity";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Maximum Order Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5413;"Safety Stock Quantity";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Safety Stock Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5414;"Order Multiple";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Order Multiple';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5415;"Safety Lead Time";DateFormula)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Safety Lead Time';
        }
        field(5417;"Flushing Method";Option)
        {
            AccessByPermission = TableData 5405=R;
            Caption = 'Flushing Method';
            OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward';
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
        }
        field(5419;"Replenishment System";Option)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order,,Assembly';
            OptionMembers = Purchase,"Prod. Order",,Assembly;

            trigger OnValidate()
            begin
                IF "Replenishment System" <> "Replenishment System"::Assembly THEN
                  TESTFIELD("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
                IF "Replenishment System" <> "Replenishment System"::Purchase THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(5420;"Scheduled Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=FILTER(Firm Planned|Released),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Scheduled Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5421;"Scheduled Need (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                     Item No.=FIELD(No.),
                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                     Location Code=FIELD(Location Filter),
                                                                                     Due Date=FIELD(Date Filter)));
            Caption = 'Scheduled Need (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5422;"Rounding Precision";Decimal)
        {
            AccessByPermission = TableData 5405=R;
            Caption = 'Rounding Precision';
            DecimalPlaces = 0:5;
            InitValue = 1;

            trigger OnValidate()
            begin
                IF "Rounding Precision" <= 0 THEN
                  FIELDERROR("Rounding Precision",Text027);
            end;
        }
        field(5423;"Bin Filter";Code[20])
        {
            Caption = 'Bin Filter';
            FieldClass = FlowFilter;
            TableRelation = Bin.Code WHERE (Location Code=FIELD(Location Filter));
        }
        field(5424;"Variant Filter";Code[10])
        {
            Caption = 'Variant Filter';
            FieldClass = FlowFilter;
            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }
        field(5425;"Sales Unit of Measure";Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(5426;"Purch. Unit of Measure";Code[10])
        {
            Caption = 'Purch. Unit of Measure';
            TableRelation = IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(5428;"Time Bucket";DateFormula)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Time Bucket';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Time Bucket");
            end;
        }
        field(5429;"Reserved Qty. on Prod. Order";Decimal)
        {
            AccessByPermission = TableData 5405=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(5406),
                                                                           Source Subtype=FILTER(1..3),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Reserved Qty. on Prod. Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5430;"Res. Qty. on Prod. Order Comp.";Decimal)
        {
            AccessByPermission = TableData 5405=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(5407),
                                                                            Source Subtype=FILTER(1..3),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Prod. Order Comp.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5431;"Res. Qty. on Req. Line";Decimal)
        {
            AccessByPermission = TableData 244=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(246),
                                                                           Source Subtype=FILTER(0),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Req. Line';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5440;"Reordering Policy";Option)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Reordering Policy';
            OptionCaption = ' ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot';
            OptionMembers = " ","Fixed Reorder Qty.","Maximum Qty.","Order","Lot-for-Lot";

            trigger OnValidate()
            begin
                "Include Inventory" :=
                  "Reordering Policy" IN ["Reordering Policy"::"Lot-for-Lot",
                                          "Reordering Policy"::"Maximum Qty.",
                                          "Reordering Policy"::"Fixed Reorder Qty."];

                IF "Reordering Policy" <> "Reordering Policy"::" " THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(5441;"Include Inventory";Boolean)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Include Inventory';
        }
        field(5442;"Manufacturing Policy";Option)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Manufacturing Policy';
            OptionCaption = 'Make-to-Stock,Make-to-Order';
            OptionMembers = "Make-to-Stock","Make-to-Order";
        }
        field(5443;"Rescheduling Period";DateFormula)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Rescheduling Period';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Rescheduling Period");
            end;
        }
        field(5444;"Lot Accumulation Period";DateFormula)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Lot Accumulation Period';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Lot Accumulation Period");
            end;
        }
        field(5445;"Dampener Period";DateFormula)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Dampener Period';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Dampener Period");
            end;
        }
        field(5446;"Dampener Quantity";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Dampener Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5447;"Overflow Level";Decimal)
        {
            AccessByPermission = TableData 244=R;
            Caption = 'Overflow Level';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5449;"Planning Transfer Ship. (Qty).";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Worksheet Template Name=FILTER(<>''),
                                                                          Journal Batch Name=FILTER(<>''),
                                                                          Replenishment System=CONST(Transfer),
                                                                          Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Transfer-from Code=FIELD(Location Filter),
                                                                          Transfer Shipment Date=FIELD(Date Filter)));
            Caption = 'Planning Transfer Ship. (Qty).';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5450;"Planning Worksheet (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Planning Line Origin=CONST(Planning),
                                                                          Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Due Date=FIELD(Date Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            Caption = 'Planning Worksheet (Qty.)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5700;"Stockkeeping Unit Exists";Boolean)
        {
            CalcFormula = Exist("Stockkeeping Unit" WHERE (Item No.=FIELD(No.)));
            Caption = 'Stockkeeping Unit Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5701;"Manufacturer Code";Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(5702;"Item Category Code";Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                ItemAttributeManagement: Codeunit "7500";
            begin
                IF NOT ISTEMPORARY THEN
                  ItemAttributeManagement.InheritAttributesFromItemCategory(Rec,"Item Category Code",xRec."Item Category Code");
            end;
        }
        field(5703;"Created From Nonstock Item";Boolean)
        {
            AccessByPermission = TableData 5718=R;
            Caption = 'Created From Nonstock Item';
            Editable = false;
        }
        field(5704;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            ObsoleteReason = 'Product Groups became first level children of Item Categories.';
            ObsoleteState = Pending;
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
            ValidateTableRelation = false;
        }
        field(5706;"Substitutes Exist";Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                           No.=FIELD(No.)));
            Caption = 'Substitutes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5707;"Qty. in Transit";Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Qty. in Transit (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                              Item No.=FIELD(No.),
                                                                              Transfer-to Code=FIELD(Location Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Receipt Date=FIELD(Date Filter)));
            Caption = 'Qty. in Transit';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5708;"Trans. Ord. Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                               Item No.=FIELD(No.),
                                                                               Transfer-to Code=FIELD(Location Filter),
                                                                               Variant Code=FIELD(Variant Filter),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Receipt Date=FIELD(Date Filter)));
            Caption = 'Trans. Ord. Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5709;"Trans. Ord. Shipment (Qty.)";Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                               Item No.=FIELD(No.),
                                                                               Transfer-from Code=FIELD(Location Filter),
                                                                               Variant Code=FIELD(Variant Filter),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Shipment Date=FIELD(Date Filter)));
            Caption = 'Trans. Ord. Shipment (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5776;"Qty. Assigned to ship";Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Item No.=FIELD(No.),
                                                                                         Location Code=FIELD(Location Filter),
                                                                                         Variant Code=FIELD(Variant Filter),
                                                                                         Due Date=FIELD(Date Filter)));
            Caption = 'Qty. Assigned to ship';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5777;"Qty. Picked";Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Picked (Base)" WHERE (Item No.=FIELD(No.),
                                                                                    Location Code=FIELD(Location Filter),
                                                                                    Variant Code=FIELD(Variant Filter),
                                                                                    Due Date=FIELD(Date Filter)));
            Caption = 'Qty. Picked';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5900;"Service Item Group";Code[10])
        {
            Caption = 'Service Item Group';
            TableRelation = "Service Item Group".Code;

            trigger OnValidate()
            var
                ResSkill: Record "5956";
            begin
                IF xRec."Service Item Group" <> "Service Item Group" THEN BEGIN
                  IF NOT ResSkillMgt.ChangeRelationWithGroup(
                       ResSkill.Type::Item,
                       "No.",
                       ResSkill.Type::"Service Item Group",
                       "Service Item Group",
                       xRec."Service Item Group")
                  THEN
                    "Service Item Group" := xRec."Service Item Group";
                END ELSE
                  ResSkillMgt.RevalidateRelation(
                    ResSkill.Type::Item,
                    "No.",
                    ResSkill.Type::"Service Item Group",
                    "Service Item Group")
            end;
        }
        field(5901;"Qty. on Service Order";Decimal)
        {
            CalcFormula = Sum("Service Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                              Type=CONST(Item),
                                                                              No.=FIELD(No.),
                                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Location Code=FIELD(Location Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Needed by Date=FIELD(Date Filter)));
            Caption = 'Qty. on Service Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5902;"Res. Qty. on Service Orders";Decimal)
        {
            AccessByPermission = TableData 5900=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(5902),
                                                                            Source Subtype=CONST(1),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Service Orders';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(6500;"Item Tracking Code";Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";

            trigger OnValidate()
            begin
                IF "Item Tracking Code" <> '' THEN
                  TESTFIELD(Type,Type::Inventory);
                IF "Item Tracking Code" = xRec."Item Tracking Code" THEN
                  EXIT;

                IF NOT ItemTrackingCode.GET("Item Tracking Code") THEN
                  CLEAR(ItemTrackingCode);

                IF NOT ItemTrackingCode2.GET(xRec."Item Tracking Code") THEN
                  CLEAR(ItemTrackingCode2);

                IF (ItemTrackingCode."SN Specific Tracking" <> ItemTrackingCode2."SN Specific Tracking") OR
                   (ItemTrackingCode."Lot Specific Tracking" <> ItemTrackingCode2."Lot Specific Tracking")
                THEN
                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));

                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));

                  TESTFIELD("Item Tracking Code");

                  ItemTrackingCode.GET("Item Tracking Code");
                  IF NOT ItemTrackingCode."SN Specific Tracking" THEN
                    ERROR(
                      Text018,
                      ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"),
                      FORMAT(TRUE),ItemTrackingCode.TABLECAPTION,ItemTrackingCode.Code,
                      FIELDCAPTION("Costing Method"),"Costing Method");
                END;

                TestNoOpenDocumentsWithTrackingExist;
            end;
        }
        field(6501;"Lot Nos.";Code[20])
        {
            Caption = 'Lot Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "Lot Nos." <> '' THEN
                  TESTFIELD("Item Tracking Code");
            end;
        }
        field(6502;"Expiration Calculation";DateFormula)
        {
            Caption = 'Expiration Calculation';
        }
        field(6503;"Lot No. Filter";Code[20])
        {
            Caption = 'Lot No. Filter';
            FieldClass = FlowFilter;
        }
        field(6504;"Serial No. Filter";Code[20])
        {
            Caption = 'Serial No. Filter';
            FieldClass = FlowFilter;
        }
        field(6650;"Qty. on Purch. Return";Decimal)
        {
            AccessByPermission = TableData 6660=R;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Return Order),
                                                                               Type=CONST(Item),
                                                                               No.=FIELD(No.),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Location Code=FIELD(Location Filter),
                                                                               Drop Shipment=FIELD(Drop Shipment Filter),
                                                                               Variant Code=FIELD(Variant Filter),
                                                                               Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Qty. on Purch. Return';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(6660;"Qty. on Sales Return";Decimal)
        {
            AccessByPermission = TableData 6650=R;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Return Order),
                                                                            Type=CONST(Item),
                                                                            No.=FIELD(No.),
                                                                            Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                            Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Drop Shipment=FIELD(Drop Shipment Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Qty. on Sales Return';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(7171;"No. of Substitutes";Integer)
        {
            CalcFormula = Count("Item Substitution" WHERE (Type=CONST(Item),
                                                           No.=FIELD(No.)));
            Caption = 'No. of Substitutes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7300;"Warehouse Class Code";Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
        }
        field(7301;"Special Equipment Code";Code[10])
        {
            Caption = 'Special Equipment Code';
            TableRelation = "Special Equipment";
        }
        field(7302;"Put-away Template Code";Code[10])
        {
            Caption = 'Put-away Template Code';
            TableRelation = "Put-away Template Header";
        }
        field(7307;"Put-away Unit of Measure Code";Code[10])
        {
            AccessByPermission = TableData 7340=R;
            Caption = 'Put-away Unit of Measure Code';
            TableRelation = IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(7380;"Phys Invt Counting Period Code";Code[10])
        {
            Caption = 'Phys Invt Counting Period Code';
            TableRelation = "Phys. Invt. Counting Period";

            trigger OnValidate()
            var
                PhysInvtCountPeriod: Record "7381";
                PhysInvtCountPeriodMgt: Codeunit "7380";
            begin
                IF "Phys Invt Counting Period Code" <> '' THEN BEGIN
                  PhysInvtCountPeriod.GET("Phys Invt Counting Period Code");
                  PhysInvtCountPeriod.TESTFIELD("Count Frequency per Year");
                  IF "Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code" THEN BEGIN
                    IF CurrFieldNo <> 0 THEN
                      IF NOT CONFIRM(
                           Text7380,
                           FALSE,
                           FIELDCAPTION("Phys Invt Counting Period Code"),
                           FIELDCAPTION("Next Counting Start Date"),
                           FIELDCAPTION("Next Counting End Date"))
                      THEN
                        ERROR(Text7381);

                    IF ("Last Counting Period Update" = 0D) OR
                       ("Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code")
                    THEN
                      PhysInvtCountPeriodMgt.CalcPeriod(
                        "Last Counting Period Update","Next Counting Start Date","Next Counting End Date",
                        PhysInvtCountPeriod."Count Frequency per Year");
                  END;
                END ELSE BEGIN
                  IF CurrFieldNo <> 0 THEN
                    IF NOT CONFIRM(Text003,FALSE,FIELDCAPTION("Phys Invt Counting Period Code")) THEN
                      ERROR(Text7381);
                  "Next Counting Start Date" := 0D;
                  "Next Counting End Date" := 0D;
                  "Last Counting Period Update" := 0D;
                END;
            end;
        }
        field(7381;"Last Counting Period Update";Date)
        {
            AccessByPermission = TableData 7380=R;
            Caption = 'Last Counting Period Update';
            Editable = false;
        }
        field(7383;"Last Phys. Invt. Date";Date)
        {
            CalcFormula = Max("Phys. Inventory Ledger Entry"."Posting Date" WHERE (Item No.=FIELD(No.),
                                                                                   Phys Invt Counting Period Type=FILTER(' '|Item)));
            Caption = 'Last Phys. Invt. Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7384;"Use Cross-Docking";Boolean)
        {
            AccessByPermission = TableData 7302=R;
            Caption = 'Use Cross-Docking';
            InitValue = true;
        }
        field(7385;"Next Counting Start Date";Date)
        {
            Caption = 'Next Counting Start Date';
            Editable = false;
        }
        field(7386;"Next Counting End Date";Date)
        {
            Caption = 'Next Counting End Date';
            Editable = false;
        }
        field(7700;"Identifier Code";Code[20])
        {
            CalcFormula = Lookup("Item Identifier".Code WHERE (Item No.=FIELD(No.)));
            Caption = 'Identifier Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8000;Id;Guid)
        {
            Caption = 'Id';
        }
        field(8001;"Unit of Measure Id";Guid)
        {
            Caption = 'Unit of Measure Id';
            TableRelation = "Unit of Measure".Id;

            trigger OnValidate()
            begin
                UpdateUnitOfMeasureCode;
            end;
        }
        field(8002;"Tax Group Id";Guid)
        {
            Caption = 'Tax Group Id';
            TableRelation = "Tax Group".Id;

            trigger OnValidate()
            begin
                UpdateTaxGroupCode;
            end;
        }
        field(50000;"SKU Id";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001;"Website ID";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","lense.me",solotica,wholesale;
        }
        field(50002;"Product Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Simple,Conf,"Gift Card",Bundle,Virtual;
        }
        field(50003;"Tax Class";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "None","Taxable Goods","Taxable Goods-Plano Cosmetic",Shipping;
        }
        field(50004;"Parent SKU";Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50005;"Attribute Set";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Contact Lens Colored","Contact Lens Daily","Contact Lends Daily WBc","Contact Lens Default","Contact Lens Default WBc","Contact Lens Multifocal","Contact Lens Toric",Default,"Standard Product";
        }
        field(50006;Weight;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007;Power;Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
            OptionMembers = " ","0.00","-0.25","-0.50";
        }
        field(50008;Add;Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50009;Axis;Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50010;Cylinder;Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50011;"Base Curve";Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50012;"Country of Origin";Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
            TableRelation = Country/Region;
        }
        field(50013;Manufacturer;Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Need to create Master for Power';
        }
        field(50014;Usage;Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Daily,Biweekly,Monthly,"3-Monthly","6-Monthly",Yearly;
        }
        field(50015;Location;Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(99000750;"Routing No.";Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";

            trigger OnValidate()
            begin
                IF "Routing No." <> '' THEN
                  TESTFIELD(Type,Type::Inventory);

                PlanningAssignment.RoutingReplace(Rec,xRec."Routing No.");

                IF "Routing No." <> xRec."Routing No." THEN
                  ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Routing No."));
            end;
        }
        field(99000751;"Production BOM No.";Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header";

            trigger OnValidate()
            var
                MfgSetup: Record "99000765";
                ProdBOMHeader: Record "99000771";
                ItemUnitOfMeasure: Record "5404";
            begin
                IF "Production BOM No." <> '' THEN
                  TESTFIELD(Type,Type::Inventory);

                PlanningAssignment.BomReplace(Rec,xRec."Production BOM No.");

                IF "Production BOM No." <> xRec."Production BOM No." THEN
                  ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Production BOM No."));

                IF ("Production BOM No." <> '') AND ("Production BOM No." <> xRec."Production BOM No.") THEN BEGIN
                  ProdBOMHeader.GET("Production BOM No.");
                  ItemUnitOfMeasure.GET("No.",ProdBOMHeader."Unit of Measure Code");
                  IF ProdBOMHeader.Status = ProdBOMHeader.Status::Certified THEN BEGIN
                    MfgSetup.GET;
                    IF MfgSetup."Dynamic Low-Level Code" THEN
                      CODEUNIT.RUN(CODEUNIT::"Calculate Low-Level Code",Rec);
                  END;
                END;
            end;
        }
        field(99000752;"Single-Level Material Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Material Cost';
            Editable = false;
        }
        field(99000753;"Single-Level Capacity Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Capacity Cost';
            Editable = false;
        }
        field(99000754;"Single-Level Subcontrd. Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Subcontrd. Cost';
            Editable = false;
        }
        field(99000755;"Single-Level Cap. Ovhd Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Cap. Ovhd Cost';
            Editable = false;
        }
        field(99000756;"Single-Level Mfg. Ovhd Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Mfg. Ovhd Cost';
            Editable = false;
        }
        field(99000757;"Overhead Rate";Decimal)
        {
            AccessByPermission = TableData 5405=R;
            AutoFormatType = 2;
            Caption = 'Overhead Rate';

            trigger OnValidate()
            begin
                IF "Overhead Rate" <> 0 THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(99000758;"Rolled-up Subcontracted Cost";Decimal)
        {
            AccessByPermission = TableData 5405=R;
            AutoFormatType = 2;
            Caption = 'Rolled-up Subcontracted Cost';
            Editable = false;
        }
        field(99000759;"Rolled-up Mfg. Ovhd Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Mfg. Ovhd Cost';
            Editable = false;
        }
        field(99000760;"Rolled-up Cap. Overhead Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Cap. Overhead Cost';
            Editable = false;
        }
        field(99000761;"Planning Issues (Qty.)";Decimal)
        {
            CalcFormula = Sum("Planning Component"."Expected Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                     Due Date=FIELD(Date Filter),
                                                                                     Location Code=FIELD(Location Filter),
                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                     Planning Line Origin=CONST(" ")));
            Caption = 'Planning Issues (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000762;"Planning Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Due Date=FIELD(Date Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            Caption = 'Planning Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000765;"Planned Order Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Planned),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Planned Order Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000766;"FP Order Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Firm Planned),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'FP Order Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000767;"Rel. Order Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Released),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 2 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Rel. Order Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000768;"Planning Release (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Starting Date=FIELD(Date Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            Caption = 'Planning Release (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000769;"Planned Order Release (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Planned),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 1 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Starting Date=FIELD(Date Filter)));
            Caption = 'Planned Order Release (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000770;"Purch. Req. Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Due Date=FIELD(Date Filter),
                                                                          Planning Line Origin=CONST(" ")));
            Caption = 'Purch. Req. Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000771;"Purch. Req. Release (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Order Date=FIELD(Date Filter)));
            Caption = 'Purch. Req. Release (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000773;"Order Tracking Policy";Option)
        {
            Caption = 'Order Tracking Policy';
            OptionCaption = 'None,Tracking Only,Tracking & Action Msg.';
            OptionMembers = "None","Tracking Only","Tracking & Action Msg.";

            trigger OnValidate()
            var
                ReservEntry: Record "337";
                ActionMessageEntry: Record "99000849";
                TempReservationEntry: Record "337" temporary;
            begin
                IF "Order Tracking Policy" <> "Order Tracking Policy"::None THEN
                  TESTFIELD(Type,Type::Inventory);
                IF xRec."Order Tracking Policy" = "Order Tracking Policy" THEN
                  EXIT;
                IF "Order Tracking Policy" > xRec."Order Tracking Policy" THEN BEGIN
                  MESSAGE(Text99000000 +
                    Text99000001,
                    SELECTSTR("Order Tracking Policy",Text99000002));
                END ELSE BEGIN
                  ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
                  ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
                  ReservEntry.SETRANGE("Item No.","No.");
                  ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Tracking,ReservEntry."Reservation Status"::Surplus);
                  IF ReservEntry.FIND('-') THEN
                    REPEAT
                      ActionMessageEntry.SETRANGE("Reservation Entry",ReservEntry."Entry No.");
                      ActionMessageEntry.DELETEALL;
                      IF "Order Tracking Policy" = "Order Tracking Policy"::None THEN
                        IF ReservEntry.TrackingExists THEN BEGIN
                          TempReservationEntry := ReservEntry;
                          TempReservationEntry."Reservation Status" := TempReservationEntry."Reservation Status"::Surplus;
                          TempReservationEntry.INSERT;
                        END ELSE
                          ReservEntry.DELETE;
                    UNTIL ReservEntry.NEXT = 0;

                  IF TempReservationEntry.FIND('-') THEN
                    REPEAT
                      ReservEntry := TempReservationEntry;
                      ReservEntry.MODIFY;
                    UNTIL TempReservationEntry.NEXT = 0;
                END;
            end;
        }
        field(99000774;"Prod. Forecast Quantity (Base)";Decimal)
        {
            CalcFormula = Sum("Production Forecast Entry"."Forecast Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                            Production Forecast Name=FIELD(Production Forecast Name),
                                                                                            Forecast Date=FIELD(Date Filter),
                                                                                            Location Code=FIELD(Location Filter),
                                                                                            Component Forecast=FIELD(Component Forecast)));
            Caption = 'Prod. Forecast Quantity (Base)';
            DecimalPlaces = 0:5;
            FieldClass = FlowField;
        }
        field(99000775;"Production Forecast Name";Code[10])
        {
            Caption = 'Production Forecast Name';
            FieldClass = FlowFilter;
            TableRelation = "Production Forecast Name";
        }
        field(99000776;"Component Forecast";Boolean)
        {
            Caption = 'Component Forecast';
            FieldClass = FlowFilter;
        }
        field(99000777;"Qty. on Prod. Order";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                Item No.=FIELD(No.),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Prod. Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000778;"Qty. on Component Lines";Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                     Item No.=FIELD(No.),
                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                     Location Code=FIELD(Location Filter),
                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                     Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Component Lines';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000875;Critical;Boolean)
        {
            Caption = 'Critical';
        }
        field(99008500;"Common Item No.";Code[20])
        {
            Caption = 'Common Item No.';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Search Description")
        {
        }
        key(Key3;"Inventory Posting Group")
        {
        }
        key(Key4;"Shelf No.")
        {
        }
        key(Key5;"Vendor No.")
        {
        }
        key(Key6;"Gen. Prod. Posting Group")
        {
        }
        key(Key7;"Low-Level Code")
        {
        }
        key(Key8;"Production BOM No.")
        {
        }
        key(Key9;"Routing No.")
        {
        }
        key(Key10;"Vendor Item No.","Vendor No.")
        {
        }
        key(Key11;"Common Item No.")
        {
        }
        key(Key12;"Service Item Group")
        {
        }
        key(Key13;"Cost is Adjusted","Allow Online Adjustment")
        {
        }
        key(Key14;Description)
        {
        }
        key(Key15;"Base Unit of Measure")
        {
        }
        key(Key16;Type)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Description,"Base Unit of Measure","Unit Price")
        {
        }
        fieldgroup(Brick;"No.",Description,Inventory,"Unit Price","Base Unit of Measure","Description 2",Picture)
        {
        }
    }

    trigger OnDelete()
    begin
        ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);

        CheckJournalsAndWorksheets(0);
        CheckDocuments(0);

        MoveEntries.MoveItemEntries(Rec);

        ServiceItem.RESET;
        ServiceItem.SETRANGE("Item No.","No.");
        IF ServiceItem.FIND('-') THEN
          REPEAT
            ServiceItem.VALIDATE("Item No.",'');
            ServiceItem.MODIFY(TRUE);
          UNTIL ServiceItem.NEXT = 0;

        DeleteRelatedData;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          GetInvtSetup;
          InvtSetup.TESTFIELD("Item Nos.");
          NoSeriesMgt.InitSeries(InvtSetup."Item Nos.",xRec."No. Series",0D,"No.","No. Series");
          "Costing Method" := InvtSetup."Default Costing Method";
        END;

        DimMgt.UpdateDefaultDim(
          DATABASE::Item,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");

        SetLastDateTimeModified;
    end;

    trigger OnModify()
    begin
        SetLastDateTimeModified;
        PlanningAssignment.ItemChange(Rec,xRec);
    end;

    trigger OnRename()
    var
        SalesLine: Record "37";
        PurchaseLine: Record "39";
        TransferLine: Record "5741";
        ItemAttributeValueMapping: Record "7505";
    begin
        SalesLine.RenameNo(SalesLine.Type::Item,xRec."No.","No.");
        PurchaseLine.RenameNo(PurchaseLine.Type::Item,xRec."No.","No.");
        TransferLine.RenameNo(xRec."No.","No.");

        ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);
        ItemAttributeValueMapping.RenameItemAttributeValueMapping(xRec."No.","No.");
        SetLastDateTimeModified;
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Purchase %3 that includes this item.';
        CannotDeleteItemIfSalesDocExistErr: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 that includes this item.', Comment='1: Type, 2 Item No. and 3 : Type of document Order,Invoice';
        CannotDeleteItemIfSalesDocExistInvoicingErr: Label 'You cannot delete %1 %2 because at least one sales document (%3 %4) includes the item.', Comment='1: Type, 2: Item No., 3: Description of document, 4: Document number';
        Text002: Label 'You cannot delete %1 %2 because there are one or more outstanding production orders that include this item.';
        Text003: Label 'Do you want to change %1?';
        Text004: Label 'You cannot delete %1 %2 because there are one or more certified Production BOM that include this item.';
        CannotDeleteItemIfProdBOMVersionExistsErr: Label 'You cannot delete %1 %2 because there are one or more certified production BOM version that include this item.', Comment='%1 - Tablecaption, %2 - No.';
        Text006: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        Text007: Label 'You cannot change %1 because there are one or more ledger entries for this item.';
        Text008: Label 'You cannot change %1 because there is at least one outstanding Purchase %2 that include this item.';
        Text014: Label 'You cannot delete %1 %2 because there are one or more production order component lines that include this item with a remaining quantity that is not 0.';
        Text016: Label 'You cannot delete %1 %2 because there are one or more outstanding transfer orders that include this item.';
        Text017: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 that includes this item.';
        Text018: Label '%1 must be %2 in %3 %4 when %5 is %6.';
        Text019: Label 'You cannot change %1 because there are one or more open ledger entries for this item.';
        Text020: Label 'There may be orders and open ledger entries for the item. ';
        Text021: Label 'If you change %1 it may affect new orders and entries.\\';
        Text022: Label 'Do you want to change %1?';
        GLSetup: Record "98";
        InvtSetup: Record "313";
        Text023: Label 'You cannot delete %1 %2 because there is at least one %3 that includes this item.';
        Text024: Label 'If you change %1 it may affect existing production orders.\';
        Text025: Label '%1 must be an integer because %2 %3 is set up to use %4.';
        Text026: Label '%1 cannot be changed because the %2 has work in process (WIP). Changing the value may offset the WIP account.';
        Text7380: Label 'If you change the %1, the %2 and %3 are calculated.\Do you still want to change the %1?', Comment='If you change the Phys Invt Counting Period Code, the Next Counting Start Date and Next Counting End Date are calculated.\Do you still want to change the Phys Invt Counting Period Code?';
        Text7381: Label 'Cancelled.';
        Text99000000: Label 'The change will not affect existing entries.\';
        CommentLine: Record "97";
        Text99000001: Label 'If you want to generate %1 for existing entries, you must run a regenerative planning.';
        ItemVend: Record "99";
        Text99000002: Label 'tracking,tracking and action messages';
        SalesPrice: Record "7002";
        SalesLineDisc: Record "7004";
        SalesPrepmtPct: Record "459";
        PurchPrice: Record "7012";
        PurchLineDisc: Record "7014";
        PurchPrepmtPct: Record "460";
        ItemTranslation: Record "30";
        BOMComp: Record "90";
        VATPostingSetup: Record "325";
        ExtTextHeader: Record "279";
        GenProdPostingGrp: Record "251";
        ItemUnitOfMeasure: Record "5404";
        ItemVariant: Record "5401";
        ItemJnlLine: Record "83";
        ProdOrderLine: Record "5406";
        ProdOrderComp: Record "5407";
        PlanningAssignment: Record "99000850";
        SKU: Record "5700";
        ItemTrackingCode: Record "6502";
        ItemTrackingCode2: Record "6502";
        ServInvLine: Record "5902";
        ItemSub: Record "5715";
        TransLine: Record "5741";
        Vend: Record "23";
        NonstockItem: Record "5718";
        ProdBOMHeader: Record "99000771";
        ProdBOMLine: Record "99000772";
        ItemIdent: Record "7704";
        RequisitionLine: Record "246";
        ItemBudgetEntry: Record "7134";
        ItemAnalysisViewEntry: Record "7154";
        ItemAnalysisBudgViewEntry: Record "7156";
        TroubleshSetup: Record "5945";
        ServiceItem: Record "5940";
        ServiceContractLine: Record "5964";
        ServiceItemComponent: Record "5941";
        NoSeriesMgt: Codeunit "396";
        MoveEntries: Codeunit "361";
        DimMgt: Codeunit "408";
        NonstockItemMgt: Codeunit "5703";
        ItemCostMgt: Codeunit "5804";
        ResSkillMgt: Codeunit "5931";
        CalendarMgt: Codeunit "7600";
        LeadTimeMgt: Codeunit "5404";
        ApprovalsMgmt: Codeunit "1535";
        HasInvtSetup: Boolean;
        GLSetupRead: Boolean;
        Text027: Label 'must be greater than 0.', Comment='starts with "Rounding Precision"';
        Text028: Label 'You cannot perform this action because entries for item %1 are unapplied in %2 by user %3.';
        CannotChangeFieldErr: Label 'You cannot change the %1 field on %2 %3 because at least one %4 exists for this item.', Comment='%1 = Field Caption, %2 = Item Table Name, %3 = Item No., %4 = Table Name';
        BaseUnitOfMeasureQtyMustBeOneErr: Label 'The quantity per base unit of measure must be 1. %1 is set up with %2 per unit of measure.\\You can change this setup in the Item Units of Measure window.', Comment='%1 Name of Unit of measure (e.g. BOX, PCS, KG...), %2 Qty. of %1 per base unit of measure ';
        OpenDocumentTrackingErr: Label 'You cannot change "Item Tracking Code" because there is at least one open document that includes this item with specified tracking: Source Type = %1, Document No. = %2.';
        SelectItemErr: Label 'You must select an existing item.';
        SelectOrCreateItemErr: Label 'You must select an existing item or create a new.';
        CreateNewItemTxt: Label 'Create a new item card for %1.', Comment='%1 is the name to be used to create the customer. ';
        ItemNotRegisteredTxt: Label 'This item is not registered. To continue, choose one of the following options:';
        SelectItemTxt: Label 'Select an existing item.';

    local procedure DeleteRelatedData()
    var
        BinContent: Record "7302";
        ItemCrossReference: Record "5717";
        SocialListeningSearchTopic: Record "871";
        MyItem: Record "9152";
        ItemAttributeValueMapping: Record "7505";
    begin
        ItemBudgetEntry.SETCURRENTKEY("Analysis Area","Budget Name","Item No.");
        ItemBudgetEntry.SETRANGE("Item No.","No.");
        ItemBudgetEntry.DELETEALL(TRUE);

        ItemSub.RESET;
        ItemSub.SETRANGE(Type,ItemSub.Type::Item);
        ItemSub.SETRANGE("No.","No.");
        ItemSub.DELETEALL;

        ItemSub.RESET;
        ItemSub.SETRANGE("Substitute Type",ItemSub."Substitute Type"::Item);
        ItemSub.SETRANGE("Substitute No.","No.");
        ItemSub.DELETEALL;

        SKU.RESET;
        SKU.SETCURRENTKEY("Item No.");
        SKU.SETRANGE("Item No.","No.");
        SKU.DELETEALL;

        NonstockItemMgt.NonstockItemDel(Rec);
        CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Item);
        CommentLine.SETRANGE("No.","No.");
        CommentLine.DELETEALL;

        ItemVend.SETCURRENTKEY("Item No.");
        ItemVend.SETRANGE("Item No.","No.");
        ItemVend.DELETEALL;

        SalesPrice.SETRANGE("Item No.","No.");
        SalesPrice.DELETEALL;

        SalesLineDisc.SETRANGE(Type,SalesLineDisc.Type::Item);
        SalesLineDisc.SETRANGE(Code,"No.");
        SalesLineDisc.DELETEALL;

        SalesPrepmtPct.SETRANGE("Item No.","No.");
        SalesPrepmtPct.DELETEALL;

        PurchPrice.SETRANGE("Item No.","No.");
        PurchPrice.DELETEALL;

        PurchLineDisc.SETRANGE("Item No.","No.");
        PurchLineDisc.DELETEALL;

        PurchPrepmtPct.SETRANGE("Item No.","No.");
        PurchPrepmtPct.DELETEALL;

        ItemTranslation.SETRANGE("Item No.","No.");
        ItemTranslation.DELETEALL;

        ItemUnitOfMeasure.SETRANGE("Item No.","No.");
        ItemUnitOfMeasure.DELETEALL;

        ItemVariant.SETRANGE("Item No.","No.");
        ItemVariant.DELETEALL;

        ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Item);
        ExtTextHeader.SETRANGE("No.","No.");
        ExtTextHeader.DELETEALL(TRUE);

        ItemAnalysisViewEntry.SETRANGE("Item No.","No.");
        ItemAnalysisViewEntry.DELETEALL;

        ItemAnalysisBudgViewEntry.SETRANGE("Item No.","No.");
        ItemAnalysisBudgViewEntry.DELETEALL;

        PlanningAssignment.SETRANGE("Item No.","No.");
        PlanningAssignment.DELETEALL;

        BOMComp.RESET;
        BOMComp.SETRANGE("Parent Item No.","No.");
        BOMComp.DELETEALL;

        TroubleshSetup.RESET;
        TroubleshSetup.SETRANGE(Type,TroubleshSetup.Type::Item);
        TroubleshSetup.SETRANGE("No.","No.");
        TroubleshSetup.DELETEALL;

        ResSkillMgt.DeleteItemResSkills("No.");
        DimMgt.DeleteDefaultDim(DATABASE::Item,"No.");

        ItemIdent.RESET;
        ItemIdent.SETCURRENTKEY("Item No.");
        ItemIdent.SETRANGE("Item No.","No.");
        ItemIdent.DELETEALL;

        ServiceItemComponent.RESET;
        ServiceItemComponent.SETRANGE(Type,ServiceItemComponent.Type::Item);
        ServiceItemComponent.SETRANGE("No.","No.");
        ServiceItemComponent.MODIFYALL("No.",'');

        BinContent.SETCURRENTKEY("Item No.");
        BinContent.SETRANGE("Item No.","No.");
        BinContent.DELETEALL;

        ItemCrossReference.SETRANGE("Item No.","No.");
        ItemCrossReference.DELETEALL;

        MyItem.SETRANGE("Item No.","No.");
        MyItem.DELETEALL;

        IF NOT SocialListeningSearchTopic.ISEMPTY THEN BEGIN
          SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Item,"No.");
          SocialListeningSearchTopic.DELETEALL;
        END;

        ItemAttributeValueMapping.RESET;
        ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
        ItemAttributeValueMapping.SETRANGE("No.","No.");
        ItemAttributeValueMapping.DELETEALL;
    end;

    procedure AssistEdit(): Boolean
    begin
        GetInvtSetup;
        InvtSetup.TESTFIELD("Item Nos.");
        IF NoSeriesMgt.SelectSeries(InvtSetup."Item Nos.",xRec."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    procedure FindItemVend(var ItemVend: Record "99";LocationCode: Code[10])
    var
        GetPlanningParameters: Codeunit "99000855";
    begin
        TESTFIELD("No.");
        ItemVend.RESET;
        ItemVend.SETRANGE("Item No.","No.");
        ItemVend.SETRANGE("Vendor No.",ItemVend."Vendor No.");
        ItemVend.SETRANGE("Variant Code",ItemVend."Variant Code");

        IF NOT ItemVend.FIND('+') THEN BEGIN
          ItemVend."Item No." := "No.";
          ItemVend."Vendor Item No." := '';
          GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
          IF ItemVend."Vendor No." = '' THEN
            ItemVend."Vendor No." := SKU."Vendor No.";
          IF ItemVend."Vendor Item No." = '' THEN
            ItemVend."Vendor Item No." := SKU."Vendor Item No.";
          ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
        END;
        IF FORMAT(ItemVend."Lead Time Calculation") = '' THEN BEGIN
          GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
          ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
          IF FORMAT(ItemVend."Lead Time Calculation") = '' THEN
            IF Vend.GET(ItemVend."Vendor No.") THEN
              ItemVend."Lead Time Calculation" := Vend."Lead Time Calculation";
        END;
        ItemVend.RESET;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Item,"No.",FieldNumber,ShortcutDimCode);
        MODIFY;
    end;

    local procedure TestNoEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "32";
        PurchaseLine: Record "39";
    begin
        IF "No." = '' THEN
          EXIT;

        ItemLedgEntry.SETCURRENTKEY("Item No.");
        ItemLedgEntry.SETRANGE("Item No.","No.");
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(
            Text007,
            CurrentFieldName);

        PurchaseLine.SETCURRENTKEY("Document Type",Type,"No.");
        PurchaseLine.SETFILTER(
          "Document Type",'%1|%2',
          PurchaseLine."Document Type"::Order,
          PurchaseLine."Document Type"::"Return Order");
        PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("No.","No.");
        IF PurchaseLine.FINDFIRST THEN
          ERROR(
            Text008,
            CurrentFieldName,
            PurchaseLine."Document Type");
    end;

    local procedure TestNoOpenEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "32";
    begin
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE("Item No.","No.");
        ItemLedgEntry.SETRANGE(Open,TRUE);
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(
            Text019,
            CurrentFieldName);
    end;

    local procedure TestNoOpenDocumentsWithTrackingExist()
    var
        TrackingSpecification: Record "336";
        ReservationEntry: Record "337";
        RecRef: RecordRef;
        SourceType: Integer;
        SourceID: Code[20];
    begin
        IF ItemTrackingCode2.Code = '' THEN
          EXIT;

        TrackingSpecification.SETRANGE("Item No.","No.");
        IF TrackingSpecification.FINDFIRST THEN BEGIN
          SourceType := TrackingSpecification."Source Type";
          SourceID := TrackingSpecification."Source ID";
        END ELSE BEGIN
          ReservationEntry.SETRANGE("Item No.","No.");
          ReservationEntry.SETFILTER("Item Tracking",'<>%1',ReservationEntry."Item Tracking"::None);
          IF ReservationEntry.FINDFIRST THEN BEGIN
            SourceType := ReservationEntry."Source Type";
            SourceID := ReservationEntry."Source ID";
          END;
        END;

        IF SourceType = 0 THEN
          EXIT;

        RecRef.OPEN(SourceType);
        ERROR(OpenDocumentTrackingErr,RecRef.CAPTION,SourceID);
    end;

    procedure ItemSKUGet(var Item: Record "27";LocationCode: Code[10];VariantCode: Code[10])
    var
        SKU: Record "5700";
    begin
        IF Item.GET("No.") THEN BEGIN
          IF SKU.GET(LocationCode,Item."No.",VariantCode) THEN
            Item."Shelf No." := SKU."Shelf No.";
        END;
    end;

    local procedure GetInvtSetup()
    begin
        IF NOT HasInvtSetup THEN BEGIN
          InvtSetup.GET;
          HasInvtSetup := TRUE;
        END;
    end;

    procedure IsMfgItem(): Boolean
    begin
        EXIT("Replenishment System" = "Replenishment System"::"Prod. Order");
    end;

    procedure IsAssemblyItem(): Boolean
    begin
        EXIT("Replenishment System" = "Replenishment System"::Assembly);
    end;

    procedure HasBOM(): Boolean
    begin
        CALCFIELDS("Assembly BOM");
        EXIT("Assembly BOM" OR ("Production BOM No." <> ''));
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    local procedure ProdOrderExist(): Boolean
    begin
        ProdOrderLine.SETCURRENTKEY(Status,"Item No.");
        ProdOrderLine.SETFILTER(Status,'..%1',ProdOrderLine.Status::Released);
        ProdOrderLine.SETRANGE("Item No.","No.");
        IF NOT ProdOrderLine.ISEMPTY THEN
          EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure CheckSerialNoQty(ItemNo: Code[20];FieldName: Text[30];Quantity: Decimal)
    var
        ItemRec: Record "27";
        ItemTrackingCode3: Record "6502";
    begin
        IF Quantity = ROUND(Quantity,1) THEN
          EXIT;
        IF NOT ItemRec.GET(ItemNo) THEN
          EXIT;
        IF ItemRec."Item Tracking Code" = '' THEN
          EXIT;
        IF NOT ItemTrackingCode3.GET(ItemRec."Item Tracking Code") THEN
          EXIT;
        IF ItemTrackingCode3."SN Specific Tracking" THEN
          ERROR(Text025,
            FieldName,
            TABLECAPTION,
            ItemNo,
            ItemTrackingCode3.FIELDCAPTION("SN Specific Tracking"));
    end;

    local procedure CheckForProductionOutput(ItemNo: Code[20])
    var
        ItemLedgEntry: Record "32";
    begin
        CLEAR(ItemLedgEntry);
        ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SETRANGE("Item No.",ItemNo);
        ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Output);
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(Text026,FIELDCAPTION("Inventory Value Zero"),TABLECAPTION);
    end;

    procedure CheckBlockedByApplWorksheet()
    var
        ApplicationWorksheet: Page "521";
    begin
        IF "Application Wksh. User ID" <> '' THEN
          ERROR(Text028,"No.",ApplicationWorksheet.CAPTION,"Application Wksh. User ID");
    end;

    procedure ShowTimelineFromItem(var Item: Record "27")
    var
        ItemAvailByTimeline: Page "5540";
    begin
        ItemAvailByTimeline.SetItem(Item);
        ItemAvailByTimeline.RUN;
    end;

    procedure ShowTimelineFromSKU(ItemNo: Code[20];LocationCode: Code[10];VariantCode: Code[10])
    var
        Item: Record "27";
    begin
        Item.GET(ItemNo);
        Item.SETRANGE("No.",Item."No.");
        Item.SETRANGE("Variant Filter",VariantCode);
        Item.SETRANGE("Location Filter",LocationCode);
        ShowTimelineFromItem(Item);
    end;

    local procedure CheckJournalsAndWorksheets(CurrFieldNo: Integer)
    begin
        CheckItemJnlLine(CurrFieldNo);
        CheckStdCostWksh(CurrFieldNo);
        CheckReqLine(CurrFieldNo);
    end;

    local procedure CheckItemJnlLine(CurrFieldNo: Integer)
    begin
        ItemJnlLine.SETRANGE("Item No.","No.");
        IF NOT ItemJnlLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
        END;
    end;

    local procedure CheckStdCostWksh(CurrFieldNo: Integer)
    var
        StdCostWksh: Record "5841";
    begin
        StdCostWksh.RESET;
        StdCostWksh.SETRANGE(Type,StdCostWksh.Type::Item);
        StdCostWksh.SETRANGE("No.","No.");
        IF NOT StdCostWksh.ISEMPTY THEN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",StdCostWksh.TABLECAPTION);
    end;

    local procedure CheckReqLine(CurrFieldNo: Integer)
    begin
        RequisitionLine.SETCURRENTKEY(Type,"No.");
        RequisitionLine.SETRANGE(Type,RequisitionLine.Type::Item);
        RequisitionLine.SETRANGE("No.","No.");
        IF NOT RequisitionLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
        END;
    end;

    local procedure CheckDocuments(CurrFieldNo: Integer)
    begin
        IF "No." = '' THEN
          EXIT;

        CheckBOM(CurrFieldNo);
        CheckPurchLine(CurrFieldNo);
        CheckSalesLine(CurrFieldNo);
        CheckProdOrderLine(CurrFieldNo);
        CheckProdOrderCompLine(CurrFieldNo);
        CheckPlanningCompLine(CurrFieldNo);
        CheckTransLine(CurrFieldNo);
        CheckServLine(CurrFieldNo);
        CheckProdBOMLine(CurrFieldNo);
        CheckServContractLine(CurrFieldNo);
        CheckAsmHeader(CurrFieldNo);
        CheckAsmLine(CurrFieldNo);
        CheckJobPlanningLine(CurrFieldNo);

        OnAfterCheckDocuments(Rec,xRec,CurrFieldNo);
    end;

    local procedure CheckBOM(CurrFieldNo: Integer)
    begin
        BOMComp.RESET;
        BOMComp.SETCURRENTKEY(Type,"No.");
        BOMComp.SETRANGE(Type,BOMComp.Type::Item);
        BOMComp.SETRANGE("No.","No.");
        IF NOT BOMComp.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",BOMComp.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",BOMComp.TABLECAPTION);
        END;
    end;

    local procedure CheckPurchLine(CurrFieldNo: Integer)
    var
        PurchaseLine: Record "39";
    begin
        PurchaseLine.SETCURRENTKEY(Type,"No.");
        PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("No.","No.");
        IF PurchaseLine.FINDFIRST THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text000,TABLECAPTION,"No.",PurchaseLine."Document Type");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PurchaseLine.TABLECAPTION);
        END;
    end;

    local procedure CheckSalesLine(CurrFieldNo: Integer)
    var
        SalesLine: Record "37";
        IdentityManagement: Codeunit "9801";
    begin
        SalesLine.SETCURRENTKEY(Type,"No.");
        SalesLine.SETRANGE(Type,SalesLine.Type::Item);
        SalesLine.SETRANGE("No.","No.");
        IF SalesLine.FINDFIRST THEN BEGIN
          IF CurrFieldNo = 0 THEN BEGIN
            IF IdentityManagement.IsInvAppId THEN
              ERROR(CannotDeleteItemIfSalesDocExistInvoicingErr,TABLECAPTION,Description,
                SalesLine.GetDocumentTypeDescription,SalesLine."Document No.");
            ERROR(CannotDeleteItemIfSalesDocExistErr,TABLECAPTION,"No.",SalesLine."Document Type");
          END;
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",SalesLine.TABLECAPTION);
        END;
    end;

    local procedure CheckProdOrderLine(CurrFieldNo: Integer)
    begin
        IF ProdOrderExist THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text002,TABLECAPTION,"No.");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderLine.TABLECAPTION);
        END;
    end;

    local procedure CheckProdOrderCompLine(CurrFieldNo: Integer)
    begin
        ProdOrderComp.SETCURRENTKEY(Status,"Item No.");
        ProdOrderComp.SETFILTER(Status,'..%1',ProdOrderComp.Status::Released);
        ProdOrderComp.SETRANGE("Item No.","No.");
        IF NOT ProdOrderComp.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text014,TABLECAPTION,"No.");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderComp.TABLECAPTION);
        END;
    end;

    local procedure CheckPlanningCompLine(CurrFieldNo: Integer)
    var
        PlanningComponent: Record "99000829";
    begin
        PlanningComponent.SETCURRENTKEY("Item No.","Variant Code","Location Code","Due Date","Planning Line Origin");
        PlanningComponent.SETRANGE("Item No.","No.");
        IF NOT PlanningComponent.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
        END;
    end;

    local procedure CheckTransLine(CurrFieldNo: Integer)
    begin
        TransLine.SETCURRENTKEY("Item No.");
        TransLine.SETRANGE("Item No.","No.");
        IF NOT TransLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text016,TABLECAPTION,"No.");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",TransLine.TABLECAPTION);
        END;
    end;

    local procedure CheckServLine(CurrFieldNo: Integer)
    begin
        ServInvLine.RESET;
        ServInvLine.SETCURRENTKEY(Type,"No.");
        ServInvLine.SETRANGE(Type,ServInvLine.Type::Item);
        ServInvLine.SETRANGE("No.","No.");
        IF NOT ServInvLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text017,TABLECAPTION,"No.",ServInvLine."Document Type");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServInvLine.TABLECAPTION);
        END;
    end;

    local procedure CheckProdBOMLine(CurrFieldNo: Integer)
    var
        ProductionBOMVersion: Record "99000779";
    begin
        ProdBOMLine.RESET;
        ProdBOMLine.SETCURRENTKEY(Type,"No.");
        ProdBOMLine.SETRANGE(Type,ProdBOMLine.Type::Item);
        ProdBOMLine.SETRANGE("No.","No.");
        IF ProdBOMLine.FIND('-') THEN BEGIN
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdBOMLine.TABLECAPTION);
          IF CurrFieldNo = 0 THEN
            REPEAT
              IF ProdBOMHeader.GET(ProdBOMLine."Production BOM No.") AND
                 (ProdBOMHeader.Status = ProdBOMHeader.Status::Certified)
              THEN
                ERROR(Text004,TABLECAPTION,"No.");
              IF ProductionBOMVersion.GET(ProdBOMLine."Production BOM No.",ProdBOMLine."Version Code") AND
                 (ProductionBOMVersion.Status = ProductionBOMVersion.Status::Certified)
              THEN
                ERROR(CannotDeleteItemIfProdBOMVersionExistsErr,TABLECAPTION,"No.");
            UNTIL ProdBOMLine.NEXT = 0;
        END;
    end;

    local procedure CheckServContractLine(CurrFieldNo: Integer)
    begin
        ServiceContractLine.RESET;
        ServiceContractLine.SETRANGE("Item No.","No.");
        IF NOT ServiceContractLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
        END;
    end;

    local procedure CheckAsmHeader(CurrFieldNo: Integer)
    var
        AsmHeader: Record "900";
    begin
        AsmHeader.SETCURRENTKEY("Document Type","Item No.");
        AsmHeader.SETRANGE("Item No.","No.");
        IF NOT AsmHeader.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
        END;
    end;

    local procedure CheckAsmLine(CurrFieldNo: Integer)
    var
        AsmLine: Record "901";
    begin
        AsmLine.SETCURRENTKEY(Type,"No.");
        AsmLine.SETRANGE(Type,AsmLine.Type::Item);
        AsmLine.SETRANGE("No.","No.");
        IF NOT AsmLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",AsmLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmLine.TABLECAPTION);
        END;
    end;

    procedure PreventNegativeInventory(): Boolean
    var
        InventorySetup: Record "313";
    begin
        CASE "Prevent Negative Inventory" OF
          "Prevent Negative Inventory"::Yes:
            EXIT(TRUE);
          "Prevent Negative Inventory"::No:
            EXIT(FALSE);
          "Prevent Negative Inventory"::Default:
            BEGIN
              InventorySetup.GET;
              EXIT(InventorySetup."Prevent Negative Inventory");
            END;
        END;
    end;

    local procedure CheckJobPlanningLine(CurrFieldNo: Integer)
    var
        JobPlanningLine: Record "1003";
    begin
        JobPlanningLine.SETCURRENTKEY(Type,"No.");
        JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
        JobPlanningLine.SETRANGE("No.","No.");
        IF NOT JobPlanningLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
        END;
    end;

    local procedure CalcVAT(): Decimal
    begin
        IF "Price Includes VAT" THEN BEGIN
          VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
          CASE VATPostingSetup."VAT Calculation Type" OF
            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
              VATPostingSetup."VAT %" := 0;
            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
              ERROR(
                Text006,
                VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                VATPostingSetup."VAT Calculation Type");
          END;
        END ELSE
          CLEAR(VATPostingSetup);

        EXIT(VATPostingSetup."VAT %" / 100);
    end;

    procedure CalcUnitPriceExclVAT(): Decimal
    begin
        GetGLSetup;
        IF 1 + CalcVAT = 0 THEN
          EXIT(0);
        EXIT(ROUND("Unit Price" / (1 + CalcVAT),GLSetup."Unit-Amount Rounding Precision"));
    end;

    [Scope('Internal')]
    procedure GetItemNo(ItemText: Text): Code[20]
    var
        ItemNo: Text[50];
    begin
        TryGetItemNo(ItemNo,ItemText,TRUE);
        EXIT(COPYSTR(ItemNo,1,MAXSTRLEN("No.")));
    end;

    procedure TryGetItemNo(var ReturnValue: Text[50];ItemText: Text;DefaultCreate: Boolean): Boolean
    begin
        EXIT(TryGetItemNoOpenCard(ReturnValue,ItemText,DefaultCreate,TRUE,TRUE));
    end;

    [Scope('Internal')]
    procedure TryGetItemNoOpenCard(var ReturnValue: Text;ItemText: Text;DefaultCreate: Boolean;ShowItemCard: Boolean;ShowCreateItemOption: Boolean): Boolean
    var
        Item: Record "27";
        SalesLine: Record "37";
        FindRecordMgt: Codeunit "703";
        ItemNo: Code[20];
        ItemWithoutQuote: Text;
        ItemFilterContains: Text;
        FoundRecordCount: Integer;
    begin
        ReturnValue := COPYSTR(ItemText,1,MAXSTRLEN(ReturnValue));
        IF ItemText = '' THEN
          EXIT(DefaultCreate);

        FoundRecordCount := FindRecordMgt.FindRecordByDescription(ReturnValue,SalesLine.Type::Item,ItemText);

        IF FoundRecordCount = 1 THEN
          EXIT(TRUE);

        ReturnValue := COPYSTR(ItemText,1,MAXSTRLEN(ReturnValue));
        IF FoundRecordCount = 0 THEN BEGIN
          IF NOT DefaultCreate THEN
            EXIT(FALSE);

          IF NOT GUIALLOWED THEN
            ERROR(SelectItemErr);

          IF Item.WRITEPERMISSION THEN
            IF ShowCreateItemOption THEN
              CASE STRMENU(
                     STRSUBSTNO('%1,%2',STRSUBSTNO(CreateNewItemTxt,CONVERTSTR(ItemText,',','.')),SelectItemTxt),1,ItemNotRegisteredTxt)
              OF
                0:
                  ERROR('');
                1:
                  BEGIN
                    ReturnValue := CreateNewItem(COPYSTR(ItemText,1,MAXSTRLEN(Item.Description)),ShowItemCard);
                    EXIT(TRUE);
                  END;
              END
            ELSE
              ERROR(SelectOrCreateItemErr);
        END;

        IF NOT GUIALLOWED THEN
          ERROR(SelectItemErr);

        IF FoundRecordCount > 0 THEN BEGIN
          ItemWithoutQuote := CONVERTSTR(ItemText,'''','?');
          ItemFilterContains := '''@*' + ItemWithoutQuote + '*''';
          Item.FILTERGROUP(-1);
          Item.SETFILTER("No.",ItemFilterContains);
          Item.SETFILTER(Description,ItemFilterContains);
          Item.SETFILTER("Base Unit of Measure",ItemFilterContains);
        END;

        IF ShowItemCard THEN
          ItemNo := PickItem(Item)
        ELSE BEGIN
          ReturnValue := '';
          EXIT(TRUE);
        END;

        IF ItemNo <> '' THEN BEGIN
          ReturnValue := ItemNo;
          EXIT(TRUE);
        END;

        IF NOT DefaultCreate THEN
          EXIT(FALSE);
        ERROR('');
    end;

    local procedure CreateNewItem(ItemName: Text[50];ShowItemCard: Boolean): Code[20]
    var
        Item: Record "27";
        ItemTemplate: Record "1301";
        ItemCard: Page "30";
    begin
        IF NOT ItemTemplate.NewItemFromTemplate(Item) THEN
          ERROR(SelectItemErr);

        Item.Description := ItemName;
        Item.MODIFY(TRUE);
        COMMIT;
        IF NOT ShowItemCard THEN
          EXIT(Item."No.");
        Item.SETRANGE("No.",Item."No.");
        ItemCard.SETTABLEVIEW(Item);
        IF NOT (ItemCard.RUNMODAL = ACTION::OK) THEN
          ERROR(SelectItemErr);

        EXIT(Item."No.");
    end;

    [Scope('Internal')]
    procedure PickItem(var Item: Record "27"): Code[20]
    var
        ItemList: Page "31";
    begin
        IF Item.FILTERGROUP = -1 THEN
          ItemList.SetTempFilteredItemRec(Item);

        IF Item.FINDFIRST THEN;
        ItemList.SETTABLEVIEW(Item);
        ItemList.SETRECORD(Item);
        ItemList.LOOKUPMODE := TRUE;
        IF ItemList.RUNMODAL = ACTION::LookupOK THEN
          ItemList.GETRECORD(Item)
        ELSE
          CLEAR(Item);

        EXIT(Item."No.");
    end;

    local procedure SetLastDateTimeModified()
    begin
        "Last DateTime Modified" := CURRENTDATETIME;
        "Last Date Modified" := DT2DATE("Last DateTime Modified");
        "Last Time Modified" := DT2TIME("Last DateTime Modified");
    end;

    procedure SetLastDateTimeFilter(DateFilter: DateTime)
    var
        DateFilterCalc: Codeunit "358";
        SyncDateTimeUtc: DateTime;
        CurrentFilterGroup: Integer;
    begin
        SyncDateTimeUtc := DateFilterCalc.ConvertToUtcDateTime(DateFilter);
        CurrentFilterGroup := FILTERGROUP;
        SETFILTER("Last Date Modified",'>=%1',DT2DATE(SyncDateTimeUtc));
        FILTERGROUP(-1);
        SETFILTER("Last Date Modified",'>%1',DT2DATE(SyncDateTimeUtc));
        SETFILTER("Last Time Modified",'>%1',DT2TIME(SyncDateTimeUtc));
        FILTERGROUP(CurrentFilterGroup);
    end;

    procedure UpdateReplenishmentSystem(): Boolean
    begin
        CALCFIELDS("Assembly BOM");

        IF "Assembly BOM" THEN BEGIN
          IF NOT ("Replenishment System" IN ["Replenishment System"::Assembly,"Replenishment System"::"Prod. Order"])
          THEN BEGIN
            VALIDATE("Replenishment System","Replenishment System"::Assembly);
            EXIT(TRUE);
          END
        END ELSE
          IF  "Replenishment System" = "Replenishment System"::Assembly THEN BEGIN
            IF "Assembly Policy" <> "Assembly Policy"::"Assemble-to-Order" THEN BEGIN
              VALIDATE("Replenishment System","Replenishment System"::Purchase);
              EXIT(TRUE);
            END
          END
    end;

    [Scope('Internal')]
    procedure UpdateUnitOfMeasureId()
    var
        UnitOfMeasure: Record "204";
    begin
        IF "Base Unit of Measure" = '' THEN BEGIN
          CLEAR("Unit of Measure Id");
          EXIT;
        END;

        IF NOT UnitOfMeasure.GET("Base Unit of Measure") THEN
          EXIT;

        "Unit of Measure Id" := UnitOfMeasure.Id;
    end;

    [Scope('Internal')]
    procedure UpdateTaxGroupId()
    var
        TaxGroup: Record "321";
    begin
        IF "Tax Group Code" = '' THEN BEGIN
          CLEAR("Tax Group Id");
          EXIT;
        END;

        IF NOT TaxGroup.GET("Tax Group Code") THEN
          EXIT;

        "Tax Group Id" := TaxGroup.Id;
    end;

    local procedure UpdateUnitOfMeasureCode()
    var
        UnitOfMeasure: Record "204";
    begin
        IF NOT ISNULLGUID("Unit of Measure Id") THEN BEGIN
          UnitOfMeasure.SETRANGE(Id,"Unit of Measure Id");
          UnitOfMeasure.FINDFIRST;
        END;

        "Base Unit of Measure" := UnitOfMeasure.Code;
    end;

    local procedure UpdateTaxGroupCode()
    var
        TaxGroup: Record "321";
    begin
        IF NOT ISNULLGUID("Tax Group Id") THEN BEGIN
          TaxGroup.SETRANGE(Id,"Tax Group Id");
          TaxGroup.FINDFIRST;
        END;

        VALIDATE("Tax Group Code",TaxGroup.Code);
    end;

    procedure IsNonInventoriableType(): Boolean
    begin
        EXIT(Type = Type::Service);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckDocuments(var Item: Record "27";var xItem: Record "27";var CurrentFieldNo: Integer)
    begin
    end;
}

