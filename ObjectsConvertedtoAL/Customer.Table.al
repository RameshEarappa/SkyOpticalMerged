table 18 Customer
{
    Caption = 'Customer';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = 22;
    LookupPageID = 22;
    Permissions = TableData 21 = r,
                  TableData 167 = r,
                  TableData 249 = rd,
                  TableData 5900 = r,
                  TableData 5940 = rm,
                  TableData 5965 = rm,
                  TableData 7002 = rd,
                  TableData 7004 = rd;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    SalesSetup.GET;
                    NoSeriesMgt.TestManual(SalesSetup."Customer Nos.");
                    "No. Series" := '';
                END;
                IF "Invoice Disc. Code" = '' THEN
                    "Invoice Disc. Code" := "No.";
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City,"Post Code",County,"Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(8;Contact;Text[50])
        {
            Caption = 'Contact';

            trigger OnLookup()
            var
                ContactBusinessRelation: Record "5054";
                Cont: Record "5050";
                TempCust: Record "18" temporary;
            begin
                IF ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer,"No.") THEN
                  Cont.SETRANGE("Company No.",ContactBusinessRelation."Contact No.")
                ELSE
                  Cont.SETRANGE("Company No.",'');

                IF "Primary Contact No." <> '' THEN
                  IF Cont.GET("Primary Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  TempCust.COPY(Rec);
                  FIND;
                  TRANSFERFIELDS(TempCust,FALSE);
                  VALIDATE("Primary Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            begin
                IF RMSetup.GET THEN
                  IF RMSetup."Bus. Rel. Code for Customers" <> '' THEN
                    IF (xRec.Contact = '') AND (xRec."Primary Contact No." = '') AND (Contact <> '') THEN BEGIN
                      MODIFY;
                      UpdateContFromCust.OnModify(Rec);
                      UpdateContFromCust.InsertNewContactPerson(Rec,FALSE);
                      MODIFY(TRUE);
                    END
            end;
        }
        field(9;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10;"Telex No.";Text[20])
        {
            Caption = 'Telex No.';
        }
        field(11;"Document Sending Profile";Code[20])
        {
            Caption = 'Document Sending Profile';
            TableRelation = "Document Sending Profile".Code;
        }
        field(14;"Our Account No.";Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(15;"Territory Code";Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(16;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(17;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(18;"Chain Name";Code[10])
        {
            Caption = 'Chain Name';
        }
        field(19;"Budgeted Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(20;"Credit Limit (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Credit Limit (LCY)';
        }
        field(21;"Customer Posting Group";Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(22;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                UpdateCurrencyId;
            end;
        }
        field(23;"Customer Price Group";Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(24;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(26;"Statistics Group";Integer)
        {
            Caption = 'Statistics Group';
        }
        field(27;"Payment Terms Code";Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                UpdatePaymentTermsId;
            end;
        }
        field(28;"Fin. Charge Terms Code";Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
            TableRelation = "Finance Charge Terms";
        }
        field(29;"Salesperson Code";Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = Salesperson/Purchaser;

            trigger OnValidate()
            begin
                ValidateSalesPersonCode;
            end;
        }
        field(30;"Shipment Method Code";Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                UpdateShipmentMethodId;
            end;
        }
        field(31;"Shipping Agent Code";Code[10])
        {
            AccessByPermission = TableData 5790=R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                  VALIDATE("Shipping Agent Service Code",'');
            end;
        }
        field(32;"Place of Export";Code[20])
        {
            Caption = 'Place of Export';
        }
        field(33;"Invoice Disc. Code";Code[20])
        {
            Caption = 'Invoice Disc. Code';
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(34;"Customer Disc. Group";Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(35;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = Country/Region;

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City,"Post Code",County,"Country/Region Code",xRec."Country/Region Code");

                IF "Country/Region Code" <> xRec."Country/Region Code" THEN
                  VATRegistrationValidation;
            end;
        }
        field(36;"Collection Method";Code[20])
        {
            Caption = 'Collection Method';
        }
        field(37;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(38;Comment;Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE (Table Name=CONST(Customer),
                                                      No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;Blocked;Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Ship,Invoice,All';
            OptionMembers = " ",Ship,Invoice,All;

            trigger OnValidate()
            var
                CustLedgerEntry: Record "21";
                AccountingPeriod: Record "50";
                IdentityManagement: Codeunit "9801";
            begin
                IF (Blocked <> Blocked::All) AND "Privacy Blocked" THEN
                  IF GUIALLOWED THEN
                    IF CONFIRM(ConfirmBlockedPrivacyBlockedQst) THEN
                      "Privacy Blocked" := FALSE
                    ELSE
                      ERROR('')
                  ELSE
                    ERROR(CanNotChangeBlockedDueToPrivacyBlockedErr);

                IF NOT IdentityManagement.IsInvAppId THEN
                  EXIT;

                CustLedgerEntry.RESET;
                CustLedgerEntry.SETCURRENTKEY("Customer No.","Posting Date");
                CustLedgerEntry.SETRANGE("Customer No.","No.");
                AccountingPeriod.SETRANGE(Closed,FALSE);
                IF AccountingPeriod.FINDFIRST THEN
                  CustLedgerEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                IF NOT CustLedgerEntry.ISEMPTY THEN
                  ERROR(CannotDeleteBecauseInInvErr,TABLECAPTION);
            end;
        }
        field(40;"Invoice Copies";Integer)
        {
            Caption = 'Invoice Copies';
        }
        field(41;"Last Statement No.";Integer)
        {
            Caption = 'Last Statement No.';
        }
        field(42;"Print Statements";Boolean)
        {
            Caption = 'Print Statements';
        }
        field(45;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(46;Priority;Integer)
        {
            Caption = 'Priority';
        }
        field(47;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                PaymentMethod: Record "289";
            begin
                UpdatePaymentMethodId;

                IF "Payment Method Code" = '' THEN
                  EXIT;

                PaymentMethod.GET("Payment Method Code");
                IF PaymentMethod."Direct Debit" AND ("Payment Terms Code" = '') THEN
                  VALIDATE("Payment Terms Code",PaymentMethod."Direct Debit Pmt. Terms Code");
            end;
        }
        field(53;"Last Modified Date Time";DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
        field(54;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(55;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(56;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(57;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(58;Balance;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59;"Balance (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Net Change";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Posting Date=FIELD(Date Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Net Change (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Posting Date=FIELD(Date Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Sales (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Cust. Ledger Entry"."Sales (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                        Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                        Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                        Posting Date=FIELD(Date Filter),
                                                                        Currency Code=FIELD(Currency Filter)));
            Caption = 'Sales (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63;"Profit (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Cust. Ledger Entry"."Profit (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                         Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                         Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                         Posting Date=FIELD(Date Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Profit (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64;"Inv. Discounts (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Cust. Ledger Entry"."Inv. Discount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Posting Date=FIELD(Date Filter),
                                                                                Currency Code=FIELD(Currency Filter)));
            Caption = 'Inv. Discounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65;"Pmt. Discounts (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                  Entry Type=FILTER(Payment Discount..'Payment Discount (VAT Adjustment)'),
                                                                                  Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                  Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                  Posting Date=FIELD(Date Filter),
                                                                                  Currency Code=FIELD(Currency Filter)));
            Caption = 'Pmt. Discounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66;"Balance Due";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                         Initial Entry Due Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Balance Due';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67;"Balance Due (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                 Initial Entry Due Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Balance Due (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69;Payments;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = -Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Payment),
                                                                          Entry Type=CONST(Initial Entry),
                                                                          Customer No.=FIELD(No.),
                                                                          Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                          Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                          Posting Date=FIELD(Date Filter),
                                                                          Currency Code=FIELD(Currency Filter)));
            Caption = 'Payments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Invoice Amounts";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Invoice),
                                                                         Entry Type=CONST(Initial Entry),
                                                                         Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Posting Date=FIELD(Date Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Invoice Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71;"Cr. Memo Amounts";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = -Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Credit Memo),
                                                                          Entry Type=CONST(Initial Entry),
                                                                          Customer No.=FIELD(No.),
                                                                          Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                          Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                          Posting Date=FIELD(Date Filter),
                                                                          Currency Code=FIELD(Currency Filter)));
            Caption = 'Cr. Memo Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72;"Finance Charge Memo Amounts";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                         Entry Type=CONST(Initial Entry),
                                                                         Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Posting Date=FIELD(Date Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Finance Charge Memo Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74;"Payments (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Payment),
                                                                                  Entry Type=CONST(Initial Entry),
                                                                                  Customer No.=FIELD(No.),
                                                                                  Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                  Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                  Posting Date=FIELD(Date Filter),
                                                                                  Currency Code=FIELD(Currency Filter)));
            Caption = 'Payments (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75;"Inv. Amounts (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Invoice),
                                                                                 Entry Type=CONST(Initial Entry),
                                                                                 Customer No.=FIELD(No.),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Posting Date=FIELD(Date Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Inv. Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76;"Cr. Memo Amounts (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                  Entry Type=CONST(Initial Entry),
                                                                                  Customer No.=FIELD(No.),
                                                                                  Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                  Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                  Posting Date=FIELD(Date Filter),
                                                                                  Currency Code=FIELD(Currency Filter)));
            Caption = 'Cr. Memo Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(77;"Fin. Charge Memo Amounts (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                 Entry Type=CONST(Initial Entry),
                                                                                 Customer No.=FIELD(No.),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Posting Date=FIELD(Date Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Fin. Charge Memo Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78;"Outstanding Orders";Decimal)
        {
            AccessByPermission = TableData 110=R;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount" WHERE (Document Type=CONST(Order),
                                                                       Bill-to Customer No.=FIELD(No.),
                                                                       Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                       Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                       Currency Code=FIELD(Currency Filter)));
            Caption = 'Outstanding Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79;"Shipped Not Invoiced";Decimal)
        {
            AccessByPermission = TableData 110=R;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced" WHERE (Document Type=CONST(Order),
                                                                         Bill-to Customer No.=FIELD(No.),
                                                                         Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                         Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Shipped Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;"Application Method";Option)
        {
            Caption = 'Application Method';
            OptionCaption = 'Manual,Apply to Oldest';
            OptionMembers = Manual,"Apply to Oldest";
        }
        field(82;"Prices Including VAT";Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(83;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(84;"Fax No.";Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85;"Telex Answer Back";Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(86;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            begin
                "VAT Registration No." := UPPERCASE("VAT Registration No.");
                IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                  VATRegistrationValidation;
            end;
        }
        field(87;"Combine Shipments";Boolean)
        {
            AccessByPermission = TableData 110=R;
            Caption = 'Combine Shipments';
        }
        field(88;"Gen. Bus. Posting Group";Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(89;Picture;BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(90;GLN;Code[13])
        {
            Caption = 'GLN';
            Numeric = true;

            trigger OnValidate()
            var
                GLNCalculator: Codeunit "1607";
            begin
                IF GLN <> '' THEN
                  GLNCalculator.AssertValidCheckDigit13(GLN);
            end;
        }
        field(91;"Post Code";Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City,"Post Code",County,"Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(92;County;Text[30])
        {
            Caption = 'County';
        }
        field(93;"EORI Number";Text[40])
        {
            Caption = 'EORI Number';
        }
        field(95;"Use GLN in Electronic Document";Boolean)
        {
            Caption = 'Use GLN in Electronic Documents';
        }
        field(97;"Debit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE (Customer No.=FIELD(No.),
                                                                                 Entry Type=FILTER(<>Application),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Posting Date=FIELD(Date Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98;"Credit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount" WHERE (Customer No.=FIELD(No.),
                                                                                  Entry Type=FILTER(<>Application),
                                                                                  Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                  Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                  Posting Date=FIELD(Date Filter),
                                                                                  Currency Code=FIELD(Currency Filter)));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99;"Debit Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                       Entry Type=FILTER(<>Application),
                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                       Posting Date=FIELD(Date Filter),
                                                                                       Currency Code=FIELD(Currency Filter)));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Credit Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                        Entry Type=FILTER(<>Application),
                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                        Posting Date=FIELD(Date Filter),
                                                                                        Currency Code=FIELD(Currency Filter)));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"E-Mail";Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "9520";
            begin
                IF "E-Mail" = '' THEN
                  EXIT;
                MailManagement.CheckValidEmailAddresses("E-Mail");
            end;
        }
        field(103;"Home Page";Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(104;"Reminder Terms Code";Code[10])
        {
            Caption = 'Reminder Terms Code';
            TableRelation = "Reminder Terms";
        }
        field(105;"Reminder Amounts";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Reminder),
                                                                         Entry Type=CONST(Initial Entry),
                                                                         Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Posting Date=FIELD(Date Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Reminder Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106;"Reminder Amounts (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Reminder),
                                                                                 Entry Type=CONST(Initial Entry),
                                                                                 Customer No.=FIELD(No.),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Posting Date=FIELD(Date Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Reminder Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(107;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                UpdateTaxAreaId;
            end;
        }
        field(109;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(110;"VAT Bus. Posting Group";Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                UpdateTaxAreaId;
            end;
        }
        field(111;"Currency Filter";Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(113;"Outstanding Orders (LCY)";Decimal)
        {
            AccessByPermission = TableData 110=R;
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                             Bill-to Customer No.=FIELD(No.),
                                                                             Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Currency Code=FIELD(Currency Filter)));
            Caption = 'Outstanding Orders (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(114;"Shipped Not Invoiced (LCY)";Decimal)
        {
            AccessByPermission = TableData 110=R;
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                               Bill-to Customer No.=FIELD(No.),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Currency Code=FIELD(Currency Filter)));
            Caption = 'Shipped Not Invoiced (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(115;Reserve;Option)
        {
            AccessByPermission = TableData 110=R;
            Caption = 'Reserve';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(116;"Block Payment Tolerance";Boolean)
        {
            Caption = 'Block Payment Tolerance';

            trigger OnValidate()
            begin
                UpdatePaymentTolerance((CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(117;"Pmt. Disc. Tolerance (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                  Entry Type=FILTER(Payment Discount Tolerance|'Payment Discount Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'),
                                                                                  Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                  Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                  Posting Date=FIELD(Date Filter),
                                                                                  Currency Code=FIELD(Currency Filter)));
            Caption = 'Pmt. Disc. Tolerance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(118;"Pmt. Tolerance (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                  Entry Type=FILTER(Payment Tolerance|'Payment Tolerance (VAT Adjustment)'|'Payment Tolerance (VAT Excl.)'),
                                                                                  Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                  Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                  Posting Date=FIELD(Date Filter),
                                                                                  Currency Code=FIELD(Currency Filter)));
            Caption = 'Pmt. Tolerance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(119;"IC Partner Code";Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate()
            var
                CustLedgEntry: Record "21";
                AccountingPeriod: Record "50";
                ICPartner: Record "413";
            begin
                IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
                  IF NOT CustLedgEntry.SETCURRENTKEY("Customer No.",Open) THEN
                    CustLedgEntry.SETCURRENTKEY("Customer No.");
                  CustLedgEntry.SETRANGE("Customer No.","No.");
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  IF CustLedgEntry.FINDLAST THEN
                    ERROR(Text012,FIELDCAPTION("IC Partner Code"),TABLECAPTION);

                  CustLedgEntry.RESET;
                  CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
                  CustLedgEntry.SETRANGE("Customer No.","No.");
                  AccountingPeriod.SETRANGE(Closed,FALSE);
                  IF AccountingPeriod.FINDFIRST THEN BEGIN
                    CustLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                    IF CustLedgEntry.FINDFIRST THEN
                      IF NOT CONFIRM(Text011,FALSE,TABLECAPTION) THEN
                        "IC Partner Code" := xRec."IC Partner Code";
                  END;
                END;

                IF "IC Partner Code" <> '' THEN BEGIN
                  ICPartner.GET("IC Partner Code");
                  IF (ICPartner."Customer No." <> '') AND (ICPartner."Customer No." <> "No.") THEN
                    ERROR(Text010,FIELDCAPTION("IC Partner Code"),"IC Partner Code",TABLECAPTION,ICPartner."Customer No.");
                  ICPartner."Customer No." := "No.";
                  ICPartner.MODIFY;
                END;

                IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
                  ICPartner."Customer No." := '';
                  ICPartner.MODIFY;
                END;
            end;
        }
        field(120;Refunds;Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Refund),
                                                                         Entry Type=CONST(Initial Entry),
                                                                         Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Posting Date=FIELD(Date Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Refunds';
            FieldClass = FlowField;
        }
        field(121;"Refunds (LCY)";Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Refund),
                                                                                 Entry Type=CONST(Initial Entry),
                                                                                 Customer No.=FIELD(No.),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Posting Date=FIELD(Date Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Refunds (LCY)';
            FieldClass = FlowField;
        }
        field(122;"Other Amounts";Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(" "),
                                                                         Entry Type=CONST(Initial Entry),
                                                                         Customer No.=FIELD(No.),
                                                                         Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                         Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                         Posting Date=FIELD(Date Filter),
                                                                         Currency Code=FIELD(Currency Filter)));
            Caption = 'Other Amounts';
            FieldClass = FlowField;
        }
        field(123;"Other Amounts (LCY)";Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(" "),
                                                                                 Entry Type=CONST(Initial Entry),
                                                                                 Customer No.=FIELD(No.),
                                                                                 Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                 Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                 Posting Date=FIELD(Date Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Other Amounts (LCY)';
            FieldClass = FlowField;
        }
        field(124;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(125;"Outstanding Invoices (LCY)";Decimal)
        {
            AccessByPermission = TableData 110=R;
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                             Bill-to Customer No.=FIELD(No.),
                                                                             Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Currency Code=FIELD(Currency Filter)));
            Caption = 'Outstanding Invoices (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(126;"Outstanding Invoices";Decimal)
        {
            AccessByPermission = TableData 110=R;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount" WHERE (Document Type=CONST(Invoice),
                                                                       Bill-to Customer No.=FIELD(No.),
                                                                       Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                       Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                       Currency Code=FIELD(Currency Filter)));
            Caption = 'Outstanding Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130;"Bill-to No. Of Archived Doc.";Integer)
        {
            CalcFormula = Count("Sales Header Archive" WHERE (Document Type=CONST(Order),
                                                              Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-to No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(131;"Sell-to No. Of Archived Doc.";Integer)
        {
            CalcFormula = Count("Sales Header Archive" WHERE (Document Type=CONST(Order),
                                                              Sell-to Customer No.=FIELD(No.)));
            Caption = 'Sell-to No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(132;"Partner Type";Option)
        {
            Caption = 'Partner Type';
            OptionCaption = ' ,Company,Person';
            OptionMembers = " ",Company,Person;
        }
        field(140;Image;Media)
        {
            Caption = 'Image';
            ExtendedDatatype = Person;
        }
        field(150;"Privacy Blocked";Boolean)
        {
            Caption = 'Privacy Blocked';

            trigger OnValidate()
            begin
                IF "Privacy Blocked" THEN
                  Blocked := Blocked::All
                ELSE
                  Blocked := Blocked::" ";
            end;
        }
        field(160;"Disable Search by Name";Boolean)
        {
            Caption = 'Disable Search by Name';
            DataClassification = SystemMetadata;
        }
        field(288;"Preferred Bank Account Code";Code[20])
        {
            Caption = 'Preferred Bank Account Code';
            TableRelation = "Customer Bank Account".Code WHERE (Customer No.=FIELD(No.));
        }
        field(840;"Cash Flow Payment Terms Code";Code[10])
        {
            Caption = 'Cash Flow Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(5049;"Primary Contact No.";Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusRel: Record "5054";
                TempCust: Record "18" temporary;
            begin
                ContBusRel.SETCURRENTKEY("Link to Table","No.");
                ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.","No.");
                IF ContBusRel.FINDFIRST THEN
                  Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                ELSE
                  Cont.SETRANGE("No.",'');

                IF "Primary Contact No." <> '' THEN
                  IF Cont.GET("Primary Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  TempCust.COPY(Rec);
                  FIND;
                  TRANSFERFIELDS(TempCust,FALSE);
                  VALIDATE("Primary Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                Cont: Record "5050";
                ContBusRel: Record "5054";
            begin
                Contact := '';
                IF "Primary Contact No." <> '' THEN BEGIN
                  Cont.GET("Primary Contact No.");

                  ContBusRel.SETCURRENTKEY("Link to Table","No.");
                  ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                  ContBusRel.SETRANGE("No.","No.");
                  ContBusRel.FINDFIRST;

                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);

                  IF Cont.Type = Cont.Type::Person THEN
                    Contact := Cont.Name;

                  IF Cont.Image.HASVALUE THEN
                    CopyContactPicture(Cont);

                  IF Cont."Phone No." <> '' THEN
                    "Phone No." := Cont."Phone No.";
                  IF Cont."E-Mail" <> '' THEN
                    "E-Mail" := Cont."E-Mail";
                END ELSE
                  IF Image.HASVALUE THEN
                    CLEAR(Image);
            end;
        }
        field(5050;"Contact Type";Option)
        {
            Caption = 'Contact Type';
            OptionCaption = 'Company,Person';
            OptionMembers = Company,Person;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5750;"Shipping Advice";Option)
        {
            AccessByPermission = TableData 110=R;
            Caption = 'Shipping Advice';
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
        }
        field(5790;"Shipping Time";DateFormula)
        {
            AccessByPermission = TableData 5790=R;
            Caption = 'Shipping Time';
        }
        field(5792;"Shipping Agent Service Code";Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));

            trigger OnValidate()
            begin
                IF ("Shipping Agent Code" <> '') AND
                   ("Shipping Agent Service Code" <> '')
                THEN
                  IF ShippingAgentService.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                    "Shipping Time" := ShippingAgentService."Shipping Time"
                  ELSE
                    EVALUATE("Shipping Time",'<>');
            end;
        }
        field(5900;"Service Zone Code";Code[10])
        {
            Caption = 'Service Zone Code';
            TableRelation = "Service Zone";
        }
        field(5902;"Contract Gain/Loss Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Contract Gain/Loss Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                       Ship-to Code=FIELD(Ship-to Filter),
                                                                       Change Date=FIELD(Date Filter)));
            Caption = 'Contract Gain/Loss Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5903;"Ship-to Filter";Code[10])
        {
            Caption = 'Ship-to Filter';
            FieldClass = FlowFilter;
            TableRelation = "Ship-to Address".Code WHERE (Customer No.=FIELD(No.));
        }
        field(5910;"Outstanding Serv. Orders (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                               Bill-to Customer No.=FIELD(No.),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Currency Code=FIELD(Currency Filter)));
            Caption = 'Outstanding Serv. Orders (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5911;"Serv Shipped Not Invoiced(LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line"."Shipped Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                 Bill-to Customer No.=FIELD(No.),
                                                                                 Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                 Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                 Currency Code=FIELD(Currency Filter)));
            Caption = 'Serv Shipped Not Invoiced(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5912;"Outstanding Serv.Invoices(LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                               Bill-to Customer No.=FIELD(No.),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Currency Code=FIELD(Currency Filter)));
            Caption = 'Outstanding Serv.Invoices(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7171;"No. of Quotes";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Quote),
                                                      Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7172;"No. of Blanket Orders";Integer)
        {
            AccessByPermission = TableData 110=R;
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Blanket Order),
                                                      Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Blanket Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7173;"No. of Orders";Integer)
        {
            AccessByPermission = TableData 110=R;
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Order),
                                                      Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7174;"No. of Invoices";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Invoice),
                                                      Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7175;"No. of Return Orders";Integer)
        {
            AccessByPermission = TableData 6660=R;
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Return Order),
                                                      Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7176;"No. of Credit Memos";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Credit Memo),
                                                      Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7177;"No. of Pstd. Shipments";Integer)
        {
            CalcFormula = Count("Sales Shipment Header" WHERE (Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Pstd. Shipments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7178;"No. of Pstd. Invoices";Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE (Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7179;"No. of Pstd. Return Receipts";Integer)
        {
            CalcFormula = Count("Return Receipt Header" WHERE (Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Pstd. Return Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7180;"No. of Pstd. Credit Memos";Integer)
        {
            CalcFormula = Count("Sales Cr.Memo Header" WHERE (Sell-to Customer No.=FIELD(No.)));
            Caption = 'No. of Pstd. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7181;"No. of Ship-to Addresses";Integer)
        {
            CalcFormula = Count("Ship-to Address" WHERE (Customer No.=FIELD(No.)));
            Caption = 'No. of Ship-to Addresses';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7182;"Bill-To No. of Quotes";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Quote),
                                                      Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7183;"Bill-To No. of Blanket Orders";Integer)
        {
            AccessByPermission = TableData 110=R;
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Blanket Order),
                                                      Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Blanket Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7184;"Bill-To No. of Orders";Integer)
        {
            AccessByPermission = TableData 110=R;
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Order),
                                                      Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7185;"Bill-To No. of Invoices";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Invoice),
                                                      Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7186;"Bill-To No. of Return Orders";Integer)
        {
            AccessByPermission = TableData 6660=R;
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Return Order),
                                                      Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7187;"Bill-To No. of Credit Memos";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Credit Memo),
                                                      Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7188;"Bill-To No. of Pstd. Shipments";Integer)
        {
            CalcFormula = Count("Sales Shipment Header" WHERE (Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Pstd. Shipments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7189;"Bill-To No. of Pstd. Invoices";Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE (Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7190;"Bill-To No. of Pstd. Return R.";Integer)
        {
            CalcFormula = Count("Return Receipt Header" WHERE (Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Pstd. Return R.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7191;"Bill-To No. of Pstd. Cr. Memos";Integer)
        {
            CalcFormula = Count("Sales Cr.Memo Header" WHERE (Bill-to Customer No.=FIELD(No.)));
            Caption = 'Bill-To No. of Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7600;"Base Calendar Code";Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(7601;"Copy Sell-to Addr. to Qte From";Option)
        {
            AccessByPermission = TableData 5050=R;
            Caption = 'Copy Sell-to Addr. to Qte From';
            OptionCaption = 'Company,Person';
            OptionMembers = Company,Person;
        }
        field(7602;"Validate EU Vat Reg. No.";Boolean)
        {
            Caption = 'Validate EU Vat Reg. No.';
        }
        field(8000;Id;Guid)
        {
            Caption = 'Id';
        }
        field(8001;"Currency Id";Guid)
        {
            Caption = 'Currency Id';
            TableRelation = Currency.Id;

            trigger OnValidate()
            begin
                UpdateCurrencyCode;
            end;
        }
        field(8002;"Payment Terms Id";Guid)
        {
            Caption = 'Payment Terms Id';
            TableRelation = "Payment Terms".Id;

            trigger OnValidate()
            begin
                UpdatePaymentTermsCode;
            end;
        }
        field(8003;"Shipment Method Id";Guid)
        {
            Caption = 'Shipment Method Id';
            TableRelation = "Shipment Method".Id;

            trigger OnValidate()
            begin
                UpdateShipmentMethodCode;
            end;
        }
        field(8004;"Payment Method Id";Guid)
        {
            Caption = 'Payment Method Id';
            TableRelation = "Payment Method".Id;

            trigger OnValidate()
            begin
                UpdatePaymentMethodCode;
            end;
        }
        field(9003;"Tax Area ID";Guid)
        {
            Caption = 'Tax Area ID';

            trigger OnValidate()
            begin
                UpdateTaxAreaCode;
            end;
        }
        field(9004;"Tax Area Display Name";Text[50])
        {
            CalcFormula = Lookup("Tax Area".Description WHERE (Code=FIELD(Tax Area Code)));
            Caption = 'Tax Area Display Name';
            FieldClass = FlowField;
            ObsoleteReason = 'This field is not needed and it should not be used.';
            ObsoleteState = Pending;
        }
        field(9005;"Contact ID";Guid)
        {
            Caption = 'Contact ID';
        }
        field(9006;"Contact Graph Id";Text[250])
        {
            Caption = 'Contact Graph Id';
        }
        field(50000;"Associated to Website";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Search Name")
        {
        }
        key(Key3;"Customer Posting Group")
        {
        }
        key(Key4;"Currency Code")
        {
        }
        key(Key5;"Country/Region Code")
        {
        }
        key(Key6;"Gen. Bus. Posting Group")
        {
        }
        key(Key7;Name,Address,City)
        {
        }
        key(Key8;"VAT Registration No.")
        {
        }
        key(Key9;Name)
        {
        }
        key(Key10;City)
        {
        }
        key(Key11;"Post Code")
        {
        }
        key(Key12;"Phone No.")
        {
        }
        key(Key13;Contact)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name,City,"Post Code","Phone No.",Contact)
        {
        }
        fieldgroup(Brick;"No.",Name,"Balance (LCY)",Contact,"Balance Due (LCY)",Image)
        {
        }
    }

    trigger OnDelete()
    var
        CampaignTargetGr: Record "7030";
        ContactBusRel: Record "5054";
        Job: Record "167";
        SocialListeningSearchTopic: Record "871";
        StdCustSalesCode: Record "172";
        CustomReportSelection: Record "9657";
        MyCustomer: Record "9150";
        ServHeader: Record "5900";
        CampaignTargetGrMgmt: Codeunit "7030";
        VATRegistrationLogMgt: Codeunit "249";
    begin
        ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);

        ServiceItem.SETRANGE("Customer No.","No.");
        IF ServiceItem.FINDFIRST THEN
          IF CONFIRM(
               Text008,
               FALSE,
               TABLECAPTION,
               "No.",
               ServiceItem.FIELDCAPTION("Customer No."))
          THEN
            ServiceItem.MODIFYALL("Customer No.",'')
          ELSE
            ERROR(Text009);

        Job.SETRANGE("Bill-to Customer No.","No.");
        IF NOT Job.ISEMPTY THEN
          ERROR(Text015,TABLECAPTION,"No.",Job.TABLECAPTION);

        MoveEntries.MoveCustEntries(Rec);

        CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Customer);
        CommentLine.SETRANGE("No.","No.");
        CommentLine.DELETEALL;

        CustBankAcc.SETRANGE("Customer No.","No.");
        CustBankAcc.DELETEALL;

        ShipToAddr.SETRANGE("Customer No.","No.");
        ShipToAddr.DELETEALL;

        SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Customer);
        SalesPrice.SETRANGE("Sales Code","No.");
        SalesPrice.DELETEALL;

        SalesLineDisc.SETRANGE("Sales Type",SalesLineDisc."Sales Type"::Customer);
        SalesLineDisc.SETRANGE("Sales Code","No.");
        SalesLineDisc.DELETEALL;

        SalesPrepmtPct.SETCURRENTKEY("Sales Type","Sales Code");
        SalesPrepmtPct.SETRANGE("Sales Type",SalesPrepmtPct."Sales Type"::Customer);
        SalesPrepmtPct.SETRANGE("Sales Code","No.");
        SalesPrepmtPct.DELETEALL;

        StdCustSalesCode.SETRANGE("Customer No.","No.");
        StdCustSalesCode.DELETEALL(TRUE);

        ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
        ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
        ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
        ItemCrossReference.DELETEALL;

        IF NOT SocialListeningSearchTopic.ISEMPTY THEN BEGIN
          SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Customer,"No.");
          SocialListeningSearchTopic.DELETEALL;
        END;

        SalesOrderLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
        SalesOrderLine.SETRANGE("Bill-to Customer No.","No.");
        IF SalesOrderLine.FINDFIRST THEN
          ERROR(
            Text000,
            TABLECAPTION,"No.",SalesOrderLine."Document Type");

        SalesOrderLine.SETRANGE("Bill-to Customer No.");
        SalesOrderLine.SETRANGE("Sell-to Customer No.","No.");
        IF SalesOrderLine.FINDFIRST THEN
          ERROR(
            Text000,
            TABLECAPTION,"No.",SalesOrderLine."Document Type");

        CampaignTargetGr.SETRANGE("No.","No.");
        CampaignTargetGr.SETRANGE(Type,CampaignTargetGr.Type::Customer);
        IF CampaignTargetGr.FIND('-') THEN BEGIN
          ContactBusRel.SETRANGE("Link to Table",ContactBusRel."Link to Table"::Customer);
          ContactBusRel.SETRANGE("No.","No.");
          ContactBusRel.FINDFIRST;
          REPEAT
            CampaignTargetGrMgmt.ConverttoContact(Rec,ContactBusRel."Contact No.");
          UNTIL CampaignTargetGr.NEXT = 0;
        END;

        ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
        ServContract.SETRANGE("Customer No.","No.");
        IF NOT ServContract.ISEMPTY THEN
          ERROR(
            Text007,
            TABLECAPTION,"No.");

        ServContract.SETRANGE(Status);
        ServContract.MODIFYALL("Customer No.",'');

        ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
        ServContract.SETRANGE("Bill-to Customer No.","No.");
        IF NOT ServContract.ISEMPTY THEN
          ERROR(
            Text007,
            TABLECAPTION,"No.");

        ServContract.SETRANGE(Status);
        ServContract.MODIFYALL("Bill-to Customer No.",'');

        ServHeader.SETCURRENTKEY("Customer No.","Order Date");
        ServHeader.SETRANGE("Customer No.","No.");
        IF ServHeader.FINDFIRST THEN
          ERROR(
            Text013,
            TABLECAPTION,"No.",ServHeader."Document Type");

        ServHeader.SETRANGE("Bill-to Customer No.");
        IF ServHeader.FINDFIRST THEN
          ERROR(
            Text013,
            TABLECAPTION,"No.",ServHeader."Document Type");

        UpdateContFromCust.OnDelete(Rec);

        CustomReportSelection.SETRANGE("Source Type",DATABASE::Customer);
        CustomReportSelection.SETRANGE("Source No.","No.");
        CustomReportSelection.DELETEALL;

        MyCustomer.SETRANGE("Customer No.","No.");
        MyCustomer.DELETEALL;
        VATRegistrationLogMgt.DeleteCustomerLog(Rec);

        DimMgt.DeleteDefaultDim(DATABASE::Customer,"No.");

        CalendarManagement.DeleteCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Customer,"No.");
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          SalesSetup.GET;
          SalesSetup.TESTFIELD("Customer Nos.");
          NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        IF "Invoice Disc. Code" = '' THEN
          "Invoice Disc. Code" := "No.";

        IF NOT (InsertFromContact OR (InsertFromTemplate AND (Contact <> '')) OR ISTEMPORARY) THEN
          UpdateContFromCust.OnInsert(Rec);

        IF "Salesperson Code" = '' THEN
          SetDefaultSalesperson;

        DimMgt.UpdateDefaultDim(
          DATABASE::Customer,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");

        SetLastModifiedDateTime;
    end;

    trigger OnModify()
    begin
        SetLastModifiedDateTime;
        IF IsContactUpdateNeeded THEN BEGIN
          MODIFY;
          UpdateContFromCust.OnModify(Rec);
          IF NOT FIND THEN BEGIN
            RESET;
            IF FIND THEN;
          END;
        END;
    end;

    trigger OnRename()
    var
        CustomerTemplate: Record "5105";
        SkipRename: Boolean;
    begin
        // Give extensions option to opt out of rename logic.
        SkipRenamingLogic(SkipRename);
        IF SkipRename THEN
          EXIT;

        ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);

        SetLastModifiedDateTime;
        IF xRec."Invoice Disc. Code" = xRec."No." THEN
          "Invoice Disc. Code" := "No.";
        CustomerTemplate.SETRANGE("Invoice Disc. Code",xRec."No.");
        CustomerTemplate.MODIFYALL("Invoice Disc. Code","No.");

        CalendarManagement.RenameCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Customer,"No.",xRec."No.");
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
        Text002: Label 'Do you wish to create a contact for %1 %2?';
        SalesSetup: Record "311";
        CommentLine: Record "97";
        SalesOrderLine: Record "37";
        CustBankAcc: Record "287";
        ShipToAddr: Record "222";
        PostCode: Record "225";
        GenBusPostingGrp: Record "250";
        ShippingAgentService: Record "5790";
        ItemCrossReference: Record "5717";
        RMSetup: Record "5079";
        SalesPrice: Record "7002";
        SalesLineDisc: Record "7004";
        SalesPrepmtPct: Record "459";
        ServContract: Record "5965";
        ServiceItem: Record "5940";
        SalespersonPurchaser: Record "13";
        CustomizedCalendarChange: Record "7602";
        PaymentToleranceMgt: Codeunit "426";
        NoSeriesMgt: Codeunit "396";
        MoveEntries: Codeunit "361";
        UpdateContFromCust: Codeunit "5056";
        DimMgt: Codeunit "408";
        ApprovalsMgmt: Codeunit "1535";
        CalendarManagement: Codeunit "7600";
        InsertFromContact: Boolean;
        Text003: Label 'Contact %1 %2 is not related to customer %3 %4.';
        Text004: Label 'post';
        Text005: Label 'create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        Text007: Label 'You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
        Text008: Label 'Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?';
        Text009: Label 'Cannot delete customer.';
        Text010: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';
        Text011: Label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text012: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text013: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
        Text014: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text015: Label 'You cannot delete %1 %2 because there is at least one %3 associated to this customer.';
        AllowPaymentToleranceQst: Label 'Do you want to allow payment tolerance for entries that are currently open?';
        RemovePaymentRoleranceQst: Label 'Do you want to remove payment tolerance from entries that are currently open?';
        CreateNewCustTxt: Label 'Create a new customer card for %1', Comment='%1 is the name to be used to create the customer. ';
        SelectCustErr: Label 'You must select an existing customer.';
        CustNotRegisteredTxt: Label 'This customer is not registered. To continue, choose one of the following options:';
        SelectCustTxt: Label 'Select an existing customer';
        InsertFromTemplate: Boolean;
        LookupRequested: Boolean;
        OverrideImageQst: Label 'Override Image?';
        CannotDeleteBecauseInInvErr: Label 'You cannot delete %1 because it has open invoices.', Comment='%1 = the object to be deleted (example: Item, Customer).';
        PrivacyBlockedActionErr: Label 'You cannot %1 this type of document when Customer %2 is blocked for privacy.', Comment='%1 = action (create or post), %2 = customer code.';
        PrivacyBlockedGenericTxt: Label 'Privacy Blocked must not be true for customer %1.', Comment='%1 = customer code';
        ConfirmBlockedPrivacyBlockedQst: Label 'If you change the Blocked field, the Privacy Blocked field is changed to No. Do you want to continue?';
        CanNotChangeBlockedDueToPrivacyBlockedErr: Label 'The Blocked field cannot be changed because the user is blocked for privacy reasons.';

    procedure AssistEdit(OldCust: Record "18"): Boolean
    var
        Cust: Record "18";
    begin
        WITH Cust DO BEGIN
          Cust := Rec;
          SalesSetup.GET;
          SalesSetup.TESTFIELD("Customer Nos.");
          IF NoSeriesMgt.SelectSeries(SalesSetup."Customer Nos.",OldCust."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            Rec := Cust;
            EXIT(TRUE);
          END;
        END;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer,"No.",FieldNumber,ShortcutDimCode);
        MODIFY;
    end;

    procedure ShowContact()
    var
        ContBusRel: Record "5054";
        Cont: Record "5050";
        OfficeContact: Record "5050";
        OfficeMgt: Codeunit "1630";
    begin
        IF OfficeMgt.GetContact(OfficeContact,"No.") AND (OfficeContact.COUNT = 1) THEN
          PAGE.RUN(PAGE::"Contact Card",OfficeContact)
        ELSE BEGIN
          IF "No." = '' THEN
            EXIT;

          ContBusRel.SETCURRENTKEY("Link to Table","No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
          ContBusRel.SETRANGE("No.","No.");
          IF NOT ContBusRel.FINDFIRST THEN BEGIN
            IF NOT CONFIRM(Text002,FALSE,TABLECAPTION,"No.") THEN
              EXIT;
            UpdateContFromCust.InsertNewContact(Rec,FALSE);
            ContBusRel.FINDFIRST;
          END;
          COMMIT;

          Cont.FILTERGROUP(2);
          Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
          IF Cont.ISEMPTY THEN BEGIN
            Cont.SETRANGE("Company No.");
            Cont.SETRANGE("No.",ContBusRel."Contact No.");
          END;
          PAGE.RUN(PAGE::"Contact List",Cont);
        END;
    end;

    procedure SetInsertFromContact(FromContact: Boolean)
    begin
        InsertFromContact := FromContact;
    end;

    procedure CheckBlockedCustOnDocs(Cust2: Record "18";DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";Shipment: Boolean;Transaction: Boolean)
    begin
        WITH Cust2 DO BEGIN
          IF "Privacy Blocked" THEN
            CustPrivacyBlockedErrorMessage(Cust2,Transaction);

          IF ((Blocked = Blocked::All) OR
              ((Blocked = Blocked::Invoice) AND
               (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"])) OR
              ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::"Blanket Order"]) AND
               (NOT Transaction)) OR
              ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"]) AND
               Shipment AND Transaction))
          THEN
            CustBlockedErrorMessage(Cust2,Transaction);
        END;
    end;

    procedure CheckBlockedCustOnJnls(Cust2: Record "18";DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;Transaction: Boolean)
    begin
        WITH Cust2 DO BEGIN
          IF "Privacy Blocked" THEN
            CustPrivacyBlockedErrorMessage(Cust2,Transaction);

          IF (Blocked = Blocked::All) OR
             ((Blocked = Blocked::Invoice) AND (DocType IN [DocType::Invoice,DocType::" "]))
          THEN
            CustBlockedErrorMessage(Cust2,Transaction)
        END;
    end;

    procedure CustBlockedErrorMessage(Cust2: Record "18";Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        IF Transaction THEN
          Action := Text004
        ELSE
          Action := Text005;
        ERROR(Text006,Action,Cust2."No.",Cust2.Blocked);
    end;

    procedure CustPrivacyBlockedErrorMessage(Cust2: Record "18";Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        IF Transaction THEN
          Action := Text004
        ELSE
          Action := Text005;

        ERROR(PrivacyBlockedActionErr,Action,Cust2."No.");
    end;

    [Scope('Internal')]
    procedure GetPrivacyBlockedGenericErrorText(Cust2: Record "18"): Text[250]
    begin
        EXIT(STRSUBSTNO(PrivacyBlockedGenericTxt,Cust2."No."));
    end;

    [Scope('Internal')]
    procedure DisplayMap()
    var
        MapPoint: Record "800";
        MapMgt: Codeunit "802";
    begin
        IF MapPoint.FINDFIRST THEN
          MapMgt.MakeSelection(DATABASE::Customer,GETPOSITION)
        ELSE
          MESSAGE(Text014);
    end;

    procedure GetTotalAmountLCY(): Decimal
    begin
        CALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
          "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

        EXIT(GetTotalAmountLCYCommon);
    end;

    procedure GetTotalAmountLCYUI(): Decimal
    begin
        SETAUTOCALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
          "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

        EXIT(GetTotalAmountLCYCommon);
    end;

    local procedure GetTotalAmountLCYCommon(): Decimal
    var
        SalesLine: Record "37";
        ServiceLine: Record "5902";
        SalesOutstandingAmountFromShipment: Decimal;
        ServOutstandingAmountFromShipment: Decimal;
        InvoicedPrepmtAmountLCY: Decimal;
        RetRcdNotInvAmountLCY: Decimal;
    begin
        SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
        ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
        InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCY;
        RetRcdNotInvAmountLCY := GetReturnRcdNotInvAmountLCY;

        EXIT("Balance (LCY)" + "Outstanding Orders (LCY)" + "Shipped Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" +
          "Outstanding Serv. Orders (LCY)" + "Serv Shipped Not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
          SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY - RetRcdNotInvAmountLCY);
    end;

    procedure GetSalesLCY(): Decimal
    var
        CustomerSalesYTD: Record "18";
        AccountingPeriod: Record "50";
        StartDate: Date;
        EndDate: Date;
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);
        CustomerSalesYTD := Rec;
        CustomerSalesYTD."SECURITYFILTERING"("SECURITYFILTERING");
        CustomerSalesYTD.SETRANGE("Date Filter",StartDate,EndDate);
        CustomerSalesYTD.CALCFIELDS("Sales (LCY)");
        EXIT(CustomerSalesYTD."Sales (LCY)");
    end;

    procedure CalcAvailableCredit(): Decimal
    begin
        EXIT(CalcAvailableCreditCommon(FALSE));
    end;

    procedure CalcAvailableCreditUI(): Decimal
    begin
        EXIT(CalcAvailableCreditCommon(TRUE));
    end;

    local procedure CalcAvailableCreditCommon(CalledFromUI: Boolean): Decimal
    begin
        IF "Credit Limit (LCY)" = 0 THEN
          EXIT(0);
        IF CalledFromUI THEN
          EXIT("Credit Limit (LCY)" - GetTotalAmountLCYUI);
        EXIT("Credit Limit (LCY)" - GetTotalAmountLCY);
    end;

    procedure CalcOverdueBalance() OverDueBalance: Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]CustLedgEntryRemainAmtQuery: Query "21";
    begin
        CustLedgEntryRemainAmtQuery.SETRANGE(Customer_No,"No.");
        CustLedgEntryRemainAmtQuery.SETFILTER(Due_Date,'<%1',TODAY);
        CustLedgEntryRemainAmtQuery.SETFILTER(Date_Filter,'<%1',TODAY);
        CustLedgEntryRemainAmtQuery.OPEN;

        IF CustLedgEntryRemainAmtQuery.READ THEN
          OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;

    procedure GetLegalEntityType(): Text
    begin
        EXIT(FORMAT("Partner Type"));
    end;

    procedure GetLegalEntityTypeLbl(): Text
    begin
        EXIT(FIELDCAPTION("Partner Type"));
    end;

    procedure SetStyle(): Text
    begin
        IF CalcAvailableCredit < 0 THEN
          EXIT('Unfavorable');
        EXIT('');
    end;

    procedure HasValidDDMandate(Date: Date): Boolean
    var
        SEPADirectDebitMandate: Record "1230";
    begin
        EXIT(SEPADirectDebitMandate.GetDefaultMandate("No.",Date) <> '');
    end;

    procedure GetReturnRcdNotInvAmountLCY(): Decimal
    var
        SalesLine: Record "37";
    begin
        SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
        SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Return Order");
        SalesLine.SETRANGE("Bill-to Customer No.","No.");
        SalesLine.CALCSUMS("Return Rcd. Not Invd. (LCY)");
        EXIT(SalesLine."Return Rcd. Not Invd. (LCY)");
    end;

    procedure GetInvoicedPrepmtAmountLCY(): Decimal
    var
        SalesLine: Record "37";
    begin
        SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
        SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Bill-to Customer No.","No.");
        SalesLine.CALCSUMS("Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
        EXIT(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    end;

    procedure CalcCreditLimitLCYExpendedPct(): Decimal
    begin
        IF "Credit Limit (LCY)" = 0 THEN
          EXIT(0);

        IF "Balance (LCY)" / "Credit Limit (LCY)" < 0 THEN
          EXIT(0);

        IF "Balance (LCY)" / "Credit Limit (LCY)" > 1 THEN
          EXIT(10000);

        EXIT(ROUND("Balance (LCY)" / "Credit Limit (LCY)" * 10000,1));
    end;

    procedure CreateAndShowNewInvoice()
    var
        SalesHeader: Record "36";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Invoice",SalesHeader)
    end;

    procedure CreateAndShowNewOrder()
    var
        SalesHeader: Record "36";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Order",SalesHeader)
    end;

    procedure CreateAndShowNewCreditMemo()
    var
        SalesHeader: Record "36";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader)
    end;

    procedure CreateAndShowNewQuote()
    var
        SalesHeader: Record "36";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Quote",SalesHeader)
    end;

    local procedure UpdatePaymentTolerance(UseDialog: Boolean)
    begin
        IF "Block Payment Tolerance" THEN BEGIN
          IF UseDialog THEN
            IF NOT CONFIRM(RemovePaymentRoleranceQst,FALSE) THEN
              EXIT;
          PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
        END ELSE BEGIN
          IF UseDialog THEN
            IF NOT CONFIRM(AllowPaymentToleranceQst,FALSE) THEN
              EXIT;
          PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
        END;
    end;

    procedure GetBillToCustomerNo(): Code[20]
    begin
        IF "Bill-to Customer No." <> '' THEN
          EXIT("Bill-to Customer No.");
        EXIT("No.");
    end;

    procedure HasAddressIgnoreCountryCode(): Boolean
    begin
        CASE TRUE OF
          Address <> '':
            EXIT(TRUE);
          "Address 2" <> '':
            EXIT(TRUE);
          City <> '':
            EXIT(TRUE);
          County <> '':
            EXIT(TRUE);
          "Post Code" <> '':
            EXIT(TRUE);
          Contact <> '':
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    procedure HasAddress(): Boolean
    begin
        EXIT(HasAddressIgnoreCountryCode OR ("Country/Region Code" <> ''));
    end;

    procedure GetCustNo(CustomerText: Text): Text
    begin
        EXIT(GetCustNoOpenCard(CustomerText,TRUE,TRUE));
    end;

    procedure GetCustNoOpenCard(CustomerText: Text;ShowCustomerCard: Boolean;ShowCreateCustomerOption: Boolean): Code[20]
    var
        Customer: Record "18";
        CustomerNo: Code[20];
        NoFiltersApplied: Boolean;
        CustomerWithoutQuote: Text;
        CustomerFilterFromStart: Text;
        CustomerFilterContains: Text;
    begin
        IF CustomerText = '' THEN
          EXIT('');

        IF STRLEN(CustomerText) <= MAXSTRLEN(Customer."No.") THEN
          IF Customer.GET(COPYSTR(CustomerText,1,MAXSTRLEN(Customer."No."))) THEN
            EXIT(Customer."No.");

        Customer.SETRANGE(Blocked,Customer.Blocked::" ");
        Customer.SETRANGE(Name,CustomerText);
        IF Customer.FINDFIRST THEN
          EXIT(Customer."No.");

        CustomerWithoutQuote := CONVERTSTR(CustomerText,'''','?');
        Customer.SETFILTER(Name,'''@' + CustomerWithoutQuote + '''');
        IF Customer.FINDFIRST THEN
          EXIT(Customer."No.");
        Customer.SETRANGE(Name);

        CustomerFilterFromStart := '''@' + CustomerWithoutQuote + '*''';

        Customer.FILTERGROUP := -1;
        Customer.SETFILTER("No.",CustomerFilterFromStart);

        Customer.SETFILTER(Name,CustomerFilterFromStart);

        IF Customer.FINDFIRST THEN
          EXIT(Customer."No.");

        CustomerFilterContains := '''@*' + CustomerWithoutQuote + '*''';

        Customer.SETFILTER("No.",CustomerFilterContains);
        Customer.SETFILTER(Name,CustomerFilterContains);
        Customer.SETFILTER(City,CustomerFilterContains);
        Customer.SETFILTER(Contact,CustomerFilterContains);
        Customer.SETFILTER("Phone No.",CustomerFilterContains);
        Customer.SETFILTER("Post Code",CustomerFilterContains);

        IF Customer.COUNT = 0 THEN
          MarkCustomersWithSimilarName(Customer,CustomerText);

        IF Customer.COUNT = 1 THEN BEGIN
          Customer.FINDFIRST;
          EXIT(Customer."No.");
        END;

        IF NOT GUIALLOWED THEN
          ERROR(SelectCustErr);

        IF Customer.COUNT = 0 THEN BEGIN
          IF Customer.WRITEPERMISSION THEN
            IF ShowCreateCustomerOption THEN
              CASE STRMENU(
                     STRSUBSTNO(
                       '%1,%2',STRSUBSTNO(CreateNewCustTxt,CONVERTSTR(CustomerText,',','.')),SelectCustTxt),1,CustNotRegisteredTxt) OF
                0:
                  ERROR(SelectCustErr);
                1:
                  EXIT(CreateNewCustomer(COPYSTR(CustomerText,1,MAXSTRLEN(Customer.Name)),ShowCustomerCard));
              END
            ELSE
              EXIT('');
          Customer.RESET;
          NoFiltersApplied := TRUE;
        END;

        IF ShowCustomerCard THEN
          CustomerNo := PickCustomer(Customer,NoFiltersApplied)
        ELSE BEGIN
          LookupRequested := TRUE;
          EXIT('');
        END;

        IF CustomerNo <> '' THEN
          EXIT(CustomerNo);

        ERROR(SelectCustErr);
    end;

    local procedure MarkCustomersWithSimilarName(var Customer: Record "18";CustomerText: Text)
    var
        TypeHelper: Codeunit "10";
        CustomerCount: Integer;
        CustomerTextLength: Integer;
        Treshold: Integer;
    begin
        IF CustomerText = '' THEN
          EXIT;
        IF STRLEN(CustomerText) > MAXSTRLEN(Customer.Name) THEN
          EXIT;
        CustomerTextLength := STRLEN(CustomerText);
        Treshold := CustomerTextLength DIV 5;
        IF Treshold = 0 THEN
          EXIT;

        Customer.RESET;
        Customer.ASCENDING(FALSE); // most likely to search for newest customers
        Customer.SETRANGE(Blocked,Customer.Blocked::" ");
        IF Customer.FINDSET THEN
          REPEAT
            CustomerCount += 1;
            IF ABS(CustomerTextLength - STRLEN(Customer.Name)) <= Treshold THEN
              IF TypeHelper.TextDistance(UPPERCASE(CustomerText),UPPERCASE(Customer.Name)) <= Treshold THEN
                Customer.MARK(TRUE);
          UNTIL Customer.MARK OR (Customer.NEXT = 0) OR (CustomerCount > 1000);
        Customer.MARKEDONLY(TRUE);
    end;

    [Scope('Internal')]
    procedure CreateNewCustomer(CustomerName: Text[50];ShowCustomerCard: Boolean): Code[20]
    var
        Customer: Record "18";
        MiniCustomerTemplate: Record "1300";
        CustomerCard: Page "21";
    begin
        Customer.Name := CustomerName;
        IF NOT MiniCustomerTemplate.NewCustomerFromTemplate(Customer) THEN
          Customer.INSERT(TRUE)
        ELSE
          IF CustomerName <> Customer.Name THEN BEGIN
            Customer.Name := CustomerName;
            Customer.MODIFY(TRUE);
          END;

        COMMIT;
        IF NOT ShowCustomerCard THEN
          EXIT(Customer."No.");
        Customer.SETRANGE("No.",Customer."No.");
        CustomerCard.SETTABLEVIEW(Customer);
        IF NOT (CustomerCard.RUNMODAL = ACTION::OK) THEN
          ERROR(SelectCustErr);

        EXIT(Customer."No.");
    end;

    local procedure PickCustomer(var Customer: Record "18";NoFiltersApplied: Boolean): Code[20]
    var
        CustomerList: Page "22";
    begin
        IF NOT NoFiltersApplied THEN
          MarkCustomersByFilters(Customer);

        CustomerList.SETTABLEVIEW(Customer);
        CustomerList.SETRECORD(Customer);
        CustomerList.LOOKUPMODE := TRUE;
        IF CustomerList.RUNMODAL = ACTION::LookupOK THEN
          CustomerList.GETRECORD(Customer)
        ELSE
          CLEAR(Customer);

        EXIT(Customer."No.");
    end;

    local procedure MarkCustomersByFilters(var Customer: Record "18")
    begin
        IF Customer.FINDSET THEN
          REPEAT
            Customer.MARK(TRUE);
          UNTIL Customer.NEXT = 0;
        IF Customer.FINDFIRST THEN;
        Customer.MARKEDONLY := TRUE;
    end;

    procedure OpenCustomerLedgerEntries(FilterOnDueEntries: Boolean)
    var
        DetailedCustLedgEntry: Record "379";
        CustLedgerEntry: Record "21";
    begin
        DetailedCustLedgEntry.SETRANGE("Customer No.","No.");
        COPYFILTER("Global Dimension 1 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        COPYFILTER("Global Dimension 2 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        IF FilterOnDueEntries AND (GETFILTER("Date Filter") <> '') THEN BEGIN
          COPYFILTER("Date Filter",DetailedCustLedgEntry."Initial Entry Due Date");
          DetailedCustLedgEntry.SETFILTER("Posting Date",'<=%1',GETRANGEMAX("Date Filter"));
        END;
        COPYFILTER("Currency Filter",DetailedCustLedgEntry."Currency Code");
        CustLedgerEntry.DrillDownOnEntries(DetailedCustLedgEntry);
    end;

    procedure SetInsertFromTemplate(FromTemplate: Boolean)
    begin
        InsertFromTemplate := FromTemplate;
    end;

    procedure IsLookupRequested() Result: Boolean
    begin
        Result := LookupRequested;
        LookupRequested := FALSE;
    end;

    local procedure IsContactUpdateNeeded(): Boolean
    var
        CustContUpdate: Codeunit "5056";
        UpdateNeeded: Boolean;
    begin
        UpdateNeeded :=
          (Name <> xRec.Name) OR
          ("Search Name" <> xRec."Search Name") OR
          ("Name 2" <> xRec."Name 2") OR
          (Address <> xRec.Address) OR
          ("Address 2" <> xRec."Address 2") OR
          (City <> xRec.City) OR
          ("Phone No." <> xRec."Phone No.") OR
          ("Telex No." <> xRec."Telex No.") OR
          ("Territory Code" <> xRec."Territory Code") OR
          ("Currency Code" <> xRec."Currency Code") OR
          ("Language Code" <> xRec."Language Code") OR
          ("Salesperson Code" <> xRec."Salesperson Code") OR
          ("Country/Region Code" <> xRec."Country/Region Code") OR
          ("Fax No." <> xRec."Fax No.") OR
          ("Telex Answer Back" <> xRec."Telex Answer Back") OR
          ("VAT Registration No." <> xRec."VAT Registration No.") OR
          ("Post Code" <> xRec."Post Code") OR
          (County <> xRec.County) OR
          ("E-Mail" <> xRec."E-Mail") OR
          ("Home Page" <> xRec."Home Page") OR
          (Contact <> xRec.Contact);

        IF NOT UpdateNeeded AND NOT ISTEMPORARY THEN
          UpdateNeeded := CustContUpdate.ContactNameIsBlank("No.");

        OnBeforeIsContactUpdateNeeded(Rec,xRec,UpdateNeeded);
        EXIT(UpdateNeeded);
    end;

    local procedure CopyContactPicture(var Cont: Record "5050")
    var
        TempNameValueBuffer: Record "823" temporary;
        FileManagement: Codeunit "419";
        ExportPath: Text;
    begin
        IF Image.HASVALUE THEN
          IF NOT CONFIRM(OverrideImageQst) THEN
            EXIT;

        ExportPath := TEMPORARYPATH + Cont."No." + FORMAT(Cont.Image.MEDIAID);
        Cont.Image.EXPORTFILE(ExportPath);
        FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer,TEMPORARYPATH);
        TempNameValueBuffer.SETFILTER(Name,STRSUBSTNO('%1*',ExportPath));
        TempNameValueBuffer.FINDFIRST;

        CLEAR(Image);
        Image.IMPORTFILE(TempNameValueBuffer.Name,'');
        MODIFY;
        IF FileManagement.DeleteServerFile(TempNameValueBuffer.Name) THEN;
    end;

    local procedure SetDefaultSalesperson()
    var
        UserSetup: Record "91";
    begin
        IF NOT UserSetup.GET(USERID) THEN
          EXIT;

        IF UserSetup."Salespers./Purch. Code" <> '' THEN
          VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
    end;

    local procedure SetLastModifiedDateTime()
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;
    end;

    local procedure VATRegistrationValidation()
    var
        VATRegistrationNoFormat: Record "381";
        VATRegistrationLog: Record "249";
        VATRegNoSrvConfig: Record "248";
        VATRegistrationLogMgt: Codeunit "249";
        ResultRecordRef: RecordRef;
        ApplicableCountryCode: Code[10];
        LogNotVerified: Boolean;
    begin
        IF NOT VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Customer) THEN
          EXIT;

        LogNotVerified := TRUE;
        IF ("Country/Region Code" <> '') OR (VATRegistrationNoFormat."Country/Region Code" <> '') THEN BEGIN
          ApplicableCountryCode := "Country/Region Code";
          IF ApplicableCountryCode = '' THEN
            ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
          IF VATRegNoSrvConfig.VATRegNoSrvIsEnabled THEN BEGIN
            LogNotVerified := FALSE;
            VATRegistrationLogMgt.ValidateVATRegNoWithVIES(
              ResultRecordRef,Rec,"No.",VATRegistrationLog."Account Type"::Customer,ApplicableCountryCode);
            ResultRecordRef.SETTABLE(Rec);
          END;
        END;

        IF LogNotVerified THEN
          VATRegistrationLogMgt.LogCustomer(Rec);
    end;

    [Scope('Internal')]
    procedure SetAddress(CustomerAddress: Text[50];CustomerAddress2: Text[50];CustomerPostCode: Code[20];CustomerCity: Text[30];CustomerCounty: Text[30];CustomerCountryCode: Code[10];CustomerContact: Text[50])
    begin
        Address := CustomerAddress;
        "Address 2" := CustomerAddress2;
        "Post Code" := CustomerPostCode;
        City := CustomerCity;
        County := CustomerCounty;
        "Country/Region Code" := CustomerCountryCode;
        UpdateContFromCust.OnModify(Rec);
        Contact := CustomerContact;
    end;

    [Scope('Internal')]
    procedure FindByEmail(var Customer: Record "18";Email: Text): Boolean
    var
        LocalContact: Record "5050";
        ContactBusinessRelation: Record "5054";
        MarketingSetup: Record "5079";
    begin
        Customer.SETRANGE("E-Mail",Email);
        IF Customer.FINDFIRST THEN
          EXIT(TRUE);

        Customer.SETRANGE("E-Mail");
        LocalContact.SETRANGE("E-Mail",Email);
        IF LocalContact.FINDSET THEN BEGIN
          MarketingSetup.GET;
          REPEAT
            IF ContactBusinessRelation.GET(LocalContact."No.",MarketingSetup."Bus. Rel. Code for Customers") THEN BEGIN
              Customer.GET(ContactBusinessRelation."No.");
              EXIT(TRUE);
            END;
          UNTIL LocalContact.NEXT = 0
        END;
    end;

    local procedure UpdateCurrencyCode()
    var
        Currency: Record "4";
    begin
        IF NOT ISNULLGUID("Currency Id") THEN BEGIN
          Currency.SETRANGE(Id,"Currency Id");
          Currency.FINDFIRST;
        END;

        VALIDATE("Currency Code",Currency.Code);
    end;

    local procedure UpdatePaymentTermsCode()
    var
        PaymentTerms: Record "3";
    begin
        IF NOT ISNULLGUID("Payment Terms Id") THEN BEGIN
          PaymentTerms.SETRANGE(Id,"Payment Terms Id");
          PaymentTerms.FINDFIRST;
        END;

        VALIDATE("Payment Terms Code",PaymentTerms.Code);
    end;

    local procedure UpdateShipmentMethodCode()
    var
        ShipmentMethod: Record "10";
    begin
        IF NOT ISNULLGUID("Shipment Method Id") THEN BEGIN
          ShipmentMethod.SETRANGE(Id,"Shipment Method Id");
          ShipmentMethod.FINDFIRST;
        END;

        VALIDATE("Shipment Method Code",ShipmentMethod.Code);
    end;

    local procedure UpdatePaymentMethodCode()
    var
        PaymentMethod: Record "289";
    begin
        IF NOT ISNULLGUID("Payment Method Id") THEN BEGIN
          PaymentMethod.SETRANGE(Id,"Payment Method Id");
          PaymentMethod.FINDFIRST;
        END;

        VALIDATE("Payment Method Code",PaymentMethod.Code);
    end;

    [Scope('Internal')]
    procedure UpdateCurrencyId()
    var
        Currency: Record "4";
    begin
        IF "Currency Code" = '' THEN BEGIN
          CLEAR("Currency Id");
          EXIT;
        END;

        IF NOT Currency.GET("Currency Code") THEN
          EXIT;

        "Currency Id" := Currency.Id;
    end;

    [Scope('Internal')]
    procedure UpdatePaymentTermsId()
    var
        PaymentTerms: Record "3";
    begin
        IF "Payment Terms Code" = '' THEN BEGIN
          CLEAR("Payment Terms Id");
          EXIT;
        END;

        IF NOT PaymentTerms.GET("Payment Terms Code") THEN
          EXIT;

        "Payment Terms Id" := PaymentTerms.Id;
    end;

    [Scope('Internal')]
    procedure UpdateShipmentMethodId()
    var
        ShipmentMethod: Record "10";
    begin
        IF "Shipment Method Code" = '' THEN BEGIN
          CLEAR("Shipment Method Id");
          EXIT;
        END;

        IF NOT ShipmentMethod.GET("Shipment Method Code") THEN
          EXIT;

        "Shipment Method Id" := ShipmentMethod.Id;
    end;

    [Scope('Internal')]
    procedure UpdatePaymentMethodId()
    var
        PaymentMethod: Record "289";
    begin
        IF "Payment Method Code" = '' THEN BEGIN
          CLEAR("Payment Method Id");
          EXIT;
        END;

        IF NOT PaymentMethod.GET("Payment Method Code") THEN
          EXIT;

        "Payment Method Id" := PaymentMethod.Id;
    end;

    [Scope('Internal')]
    procedure UpdateTaxAreaId()
    var
        VATBusinessPostingGroup: Record "323";
        TaxArea: Record "318";
        GeneralLedgerSetup: Record "98";
    begin
        IF GeneralLedgerSetup.UseVat THEN BEGIN
          IF "VAT Bus. Posting Group" = '' THEN BEGIN
            CLEAR("Tax Area ID");
            EXIT;
          END;

          IF NOT VATBusinessPostingGroup.GET("VAT Bus. Posting Group") THEN
            EXIT;

          "Tax Area ID" := VATBusinessPostingGroup.Id;
        END ELSE BEGIN
          IF "Tax Area Code" = '' THEN BEGIN
            CLEAR("Tax Area ID");
            EXIT;
          END;

          IF NOT TaxArea.GET("Tax Area Code") THEN
            EXIT;

          "Tax Area ID" := TaxArea.Id;
        END;
    end;

    local procedure UpdateTaxAreaCode()
    var
        TaxArea: Record "318";
        VATBusinessPostingGroup: Record "323";
        GeneralLedgerSetup: Record "98";
    begin
        IF ISNULLGUID("Tax Area ID") THEN
          EXIT;

        IF GeneralLedgerSetup.UseVat THEN BEGIN
          VATBusinessPostingGroup.SETRANGE(Id,"Tax Area ID");
          VATBusinessPostingGroup.FINDFIRST;
          "VAT Bus. Posting Group" := VATBusinessPostingGroup.Code;
        END ELSE BEGIN
          TaxArea.SETRANGE(Id,"Tax Area ID");
          TaxArea.FINDFIRST;
          "Tax Area Code" := TaxArea.Code;
        END;
    end;

    [IntegrationEvent(false, false)]
    local procedure SkipRenamingLogic(var SkipRename: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeIsContactUpdateNeeded(Customer: Record "18";xCustomer: Record "18";var UpdateNeeded: Boolean)
    begin
    end;

    local procedure ValidateSalesPersonCode()
    begin
        IF "Salesperson Code" <> '' THEN
          IF SalespersonPurchaser.GET("Salesperson Code") THEN
            IF SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
              ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser,TRUE))
    end;
}

