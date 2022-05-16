table 38 "Purchase Header"
{
    Caption = 'Purchase Header';
    DataCaptionFields = "No.", "Buy-from Vendor Name";
    LookupPageID = 53;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "No." = '' THEN
                    InitRecord;
                TESTFIELD(Status, Status::Open);
                IF ("Buy-from Vendor No." <> xRec."Buy-from Vendor No.") AND
                   (xRec."Buy-from Vendor No." <> '')
                THEN BEGIN
                    CheckDropShipmentLineExists;
                    IF HideValidationDialog THEN
                        Confirmed := TRUE
                    ELSE
                        Confirmed := CONFIRM(ConfirmChangeQst, FALSE, BuyFromVendorTxt);
                    IF Confirmed THEN BEGIN
                        IF InitFromVendor("Buy-from Vendor No.", FIELDCAPTION("Buy-from Vendor No.")) THEN
                            EXIT;

                        CheckReceiptInfo(PurchLine, FALSE);
                        CheckPrepmtInfo(PurchLine);
                        CheckReturnInfo(PurchLine, FALSE);

                        PurchLine.RESET;
                    END ELSE BEGIN
                        Rec := xRec;
                        EXIT;
                    END;
                END;

                GetVend("Buy-from Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend, FALSE);
                Vend.TESTFIELD("Gen. Bus. Posting Group");
                "Buy-from Vendor Name" := Vend.Name;
                "Buy-from Vendor Name 2" := Vend."Name 2";
                CopyBuyFromVendorAddressFieldsFromVendor(Vend, FALSE);
                IF NOT SkipBuyFromContact THEN
                    "Buy-from Contact" := Vend.Contact;
                "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                "Tax Area Code" := Vend."Tax Area Code";
                "Tax Liable" := Vend."Tax Liable";
                "VAT Country/Region Code" := Vend."Country/Region Code";
                "VAT Registration No." := Vend."VAT Registration No.";
                VALIDATE("Lead Time Calculation", Vend."Lead Time Calculation");
                "Responsibility Center" := UserSetupMgt.GetRespCenter(1, Vend."Responsibility Center");
                ValidateEmptySellToCustomerAndLocation;

                IF "Buy-from Vendor No." = xRec."Pay-to Vendor No." THEN
                    IF ReceivedPurchLinesExist OR ReturnShipmentExist THEN BEGIN
                        TESTFIELD("VAT Bus. Posting Group", xRec."VAT Bus. Posting Group");
                        TESTFIELD("Gen. Bus. Posting Group", xRec."Gen. Bus. Posting Group");
                    END;

                "Buy-from IC Partner Code" := Vend."IC Partner Code";
                "Send IC Document" := ("Buy-from IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);

                IF Vend."Pay-to Vendor No." <> '' THEN
                    VALIDATE("Pay-to Vendor No.", Vend."Pay-to Vendor No.")
                ELSE BEGIN
                    IF "Buy-from Vendor No." = "Pay-to Vendor No." THEN
                        SkipPayToContact := TRUE;
                    VALIDATE("Pay-to Vendor No.", "Buy-from Vendor No.");
                    SkipPayToContact := FALSE;
                END;
                "Order Address Code" := '';

                CopyPayToVendorAddressFieldsFromVendor(Vend, FALSE);
                IF IsCreditDocType THEN BEGIN
                    "Ship-to Name" := Vend.Name;
                    "Ship-to Name 2" := Vend."Name 2";
                    CopyShipToVendorAddressFieldsFromVendor(Vend, TRUE);
                    "Ship-to Contact" := Vend.Contact;
                    "Shipment Method Code" := Vend."Shipment Method Code";
                    IF Vend."Location Code" <> '' THEN
                        VALIDATE("Location Code", Vend."Location Code");
                END;

                IF (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") OR
                   (xRec."Currency Code" <> "Currency Code") OR
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") OR
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                THEN
                    RecreatePurchLines(BuyFromVendorTxt);

                IF NOT SkipBuyFromContact THEN
                    UpdateBuyFromCont("Buy-from Vendor No.");

                IF (xRec."Buy-from Vendor No." <> '') AND (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") THEN
                    RecallModifyAddressNotification(GetModifyVendorAddressNotificationId);
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            end;
        }
        field(4; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") AND
                   (xRec."Pay-to Vendor No." <> '')
                THEN BEGIN
                    IF HideValidationDialog THEN
                        Confirmed := TRUE
                    ELSE
                        Confirmed := CONFIRM(ConfirmChangeQst, FALSE, PayToVendorTxt);
                    IF Confirmed THEN BEGIN
                        PurchLine.SETRANGE("Document Type", "Document Type");
                        PurchLine.SETRANGE("Document No.", "No.");

                        CheckReceiptInfo(PurchLine, TRUE);
                        CheckPrepmtInfo(PurchLine);
                        CheckReturnInfo(PurchLine, TRUE);

                        PurchLine.RESET;
                    END ELSE
                        "Pay-to Vendor No." := xRec."Pay-to Vendor No.";
                END;

                GetVend("Pay-to Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend, FALSE);
                Vend.TESTFIELD("Vendor Posting Group");
                PostingSetupMgt.CheckVendPostingGroupPayablesAccount("Vendor Posting Group");

                "Pay-to Name" := Vend.Name;
                "Pay-to Name 2" := Vend."Name 2";
                CopyPayToVendorAddressFieldsFromVendor(Vend, FALSE);
                IF NOT SkipPayToContact THEN
                    "Pay-to Contact" := Vend.Contact;
                "Payment Terms Code" := Vend."Payment Terms Code";
                "Prepmt. Payment Terms Code" := Vend."Payment Terms Code";
                "Payment Method Code" := Vend."Payment Method Code";

                IF "Buy-from Vendor No." = Vend."No." THEN
                    "Shipment Method Code" := Vend."Shipment Method Code";
                "Vendor Posting Group" := Vend."Vendor Posting Group";
                GLSetup.GET;
                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN BEGIN
                    "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                    "VAT Country/Region Code" := Vend."Country/Region Code";
                    "VAT Registration No." := Vend."VAT Registration No.";
                    "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                END;
                "Prices Including VAT" := Vend."Prices Including VAT";
                "Currency Code" := Vend."Currency Code";
                "Invoice Disc. Code" := Vend."Invoice Disc. Code";
                "Language Code" := Vend."Language Code";
                SetPurchaserCode(Vend."Purchaser Code", "Purchaser Code");
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
                VALIDATE("Payment Method Code");
                VALIDATE("Currency Code");
                VALIDATE("Creditor No.", Vend."Creditor No.");

                OnValidatePurchaseHeaderPayToVendorNo(Vend);

                IF "Document Type" = "Document Type"::Order THEN
                    VALIDATE("Prepayment %", Vend."Prepayment %");

                IF "Pay-to Vendor No." = xRec."Pay-to Vendor No." THEN BEGIN
                    IF ReceivedPurchLinesExist THEN
                        TESTFIELD("Currency Code", xRec."Currency Code");
                END;

                CreateDim(
                  DATABASE::Vendor, "Pay-to Vendor No.",
                  DATABASE::"Salesperson/Purchaser", "Purchaser Code",
                  DATABASE::Campaign, "Campaign No.",
                  DATABASE::"Responsibility Center", "Responsibility Center");

                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                   (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.")
                THEN
                    RecreatePurchLines(PayToVendorTxt);

                IF NOT SkipPayToContact THEN
                    UpdatePayToCont("Pay-to Vendor No.");

                "Pay-to IC Partner Code" := Vend."IC Partner Code";

                IF (xRec."Pay-to Vendor No." <> '') AND (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") THEN
                    RecallModifyAddressNotification(GetModifyPayToVendorAddressNotificationId);
            end;
        }
        field(5; "Pay-to Name"; Text[50])
        {
            Caption = 'Pay-to Name';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Vendor: Record "23";
            begin
                IF ShouldLookForVendorByName("Pay-to Vendor No.") THEN
                    VALIDATE("Pay-to Vendor No.", Vendor.GetVendorNo("Pay-to Name"));
            end;
        }
        field(6; "Pay-to Name 2"; Text[50])
        {
            Caption = 'Pay-to Name 2';
        }
        field(7; "Pay-to Address"; Text[50])
        {
            Caption = 'Pay-to Address';

            trigger OnValidate()
            begin
                ModifyPayToVendorAddress;
            end;
        }
        field(8; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Pay-to Address 2';

            trigger OnValidate()
            begin
                ModifyPayToVendorAddress;
            end;
        }
        field(9; "Pay-to City"; Text[30])
        {
            Caption = 'Pay-to City';
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                ModifyPayToVendorAddress;
            end;
        }
        field(10;"Pay-to Contact";Text[50])
        {
            Caption = 'Pay-to Contact';

            trigger OnLookup()
            var
                Contact: Record "5050";
            begin
                LookupContact("Pay-to Vendor No.","Pay-to Contact No.",Contact);
                IF PAGE.RUNMODAL(0,Contact) = ACTION::LookupOK THEN
                  VALIDATE("Pay-to Contact No.",Contact."No.");
            end;

            trigger OnValidate()
            begin
                ModifyPayToVendorAddress;
            end;
        }
        field(11;"Your Reference";Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12;"Ship-to Code";Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));

            trigger OnValidate()
            var
                ShipToAddr: Record "222";
            begin
                IF ("Document Type" = "Document Type"::Order) AND
                   (xRec."Ship-to Code" <> "Ship-to Code")
                THEN BEGIN
                  PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
                  PurchLine.SETRANGE("Document No.","No.");
                  PurchLine.SETFILTER("Sales Order Line No.",'<>0');
                  IF NOT PurchLine.ISEMPTY THEN
                    ERROR(
                      YouCannotChangeFieldErr,
                      FIELDCAPTION("Ship-to Code"));
                END;

                IF "Ship-to Code" <> '' THEN BEGIN
                  ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
                  SetShipToAddress(
                    ShipToAddr.Name,ShipToAddr."Name 2",ShipToAddr.Address,ShipToAddr."Address 2",
                    ShipToAddr.City,ShipToAddr."Post Code",ShipToAddr.County,ShipToAddr."Country/Region Code");
                  "Ship-to Contact" := ShipToAddr.Contact;
                  "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                  IF ShipToAddr."Location Code" <> '' THEN
                    VALIDATE("Location Code",ShipToAddr."Location Code");
                END ELSE BEGIN
                  TESTFIELD("Sell-to Customer No.");
                  Cust.GET("Sell-to Customer No.");
                  SetShipToAddress(
                    Cust.Name,Cust."Name 2",Cust.Address,Cust."Address 2",
                    Cust.City,Cust."Post Code",Cust.County,Cust."Country/Region Code");
                  "Ship-to Contact" := Cust.Contact;
                  "Shipment Method Code" := Cust."Shipment Method Code";
                  IF Cust."Location Code" <> '' THEN
                    VALIDATE("Location Code",Cust."Location Code");
                END;
            end;
        }
        field(13;"Ship-to Name";Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(14;"Ship-to Name 2";Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15;"Ship-to Address";Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(16;"Ship-to Address 2";Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17;"Ship-to City";Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(18;"Ship-to Contact";Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19;"Order Date";Date)
        {
            AccessByPermission = TableData 120=R;
            Caption = 'Order Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND
                   NOT ("Order Date" = xRec."Order Date")
                THEN
                  PriceMessageIfPurchLinesExist(FIELDCAPTION("Order Date"));
            end;
        }
        field(20;"Posting Date";Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                SkipJobCurrFactorUpdate: Boolean;
            begin
                TestNoSeriesDate(
                  "Posting No.","Posting No. Series",
                  FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.","Prepayment No. Series",
                  FIELDCAPTION("Prepayment No."),FIELDCAPTION("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.","Prepmt. Cr. Memo No. Series",
                  FIELDCAPTION("Prepmt. Cr. Memo No."),FIELDCAPTION("Prepmt. Cr. Memo No. Series"));

                IF "Incoming Document Entry No." = 0 THEN
                  VALIDATE("Document Date","Posting Date");

                IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
                   NOT ("Posting Date" = xRec."Posting Date")
                THEN
                  PriceMessageIfPurchLinesExist(FIELDCAPTION("Posting Date"));

                IF "Currency Code" <> '' THEN BEGIN
                  UpdateCurrencyFactor;
                  IF "Currency Factor" <> xRec."Currency Factor" THEN
                    SkipJobCurrFactorUpdate := NOT ConfirmUpdateCurrencyFactor;
                END;

                IF "Posting Date" <> xRec."Posting Date" THEN
                  IF DeferralHeadersExist THEN
                    ConfirmUpdateDeferralDate;

                IF PurchLinesExist THEN
                  JobUpdatePurchLines(SkipJobCurrFactorUpdate);
            end;
        }
        field(21;"Expected Receipt Date";Date)
        {
            Caption = 'Expected Receipt Date';

            trigger OnValidate()
            begin
                IF "Expected Receipt Date" <> 0D THEN
                  UpdatePurchLines(FIELDCAPTION("Expected Receipt Date"),CurrFieldNo <> 0);
            end;
        }
        field(22;"Posting Description";Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23;"Payment Terms Code";Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                  PaymentTerms.GET("Payment Terms Code");
                  IF IsCreditDocType AND NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                    VALIDATE("Due Date","Document Date");
                    VALIDATE("Pmt. Discount Date",0D);
                    VALIDATE("Payment Discount %",0);
                  END ELSE BEGIN
                    "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                    "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                    IF NOT UpdateDocumentDate THEN
                      VALIDATE("Payment Discount %",PaymentTerms."Discount %")
                  END;
                END ELSE BEGIN
                  VALIDATE("Due Date","Document Date");
                  IF NOT UpdateDocumentDate THEN BEGIN
                    VALIDATE("Pmt. Discount Date",0D);
                    VALIDATE("Payment Discount %",0);
                  END;
                END;
                IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN
                  VALIDATE("Prepmt. Payment Terms Code","Payment Terms Code");
            end;
        }
        field(24;"Due Date";Date)
        {
            Caption = 'Due Date';
        }
        field(25;"Payment Discount %";Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date"),FIELDNO("Document Date")]) THEN
                  TESTFIELD(Status,Status::Open);
                GLSetup.GET;
                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                  "VAT Base Discount %" := "Payment Discount %"
                ELSE
                  "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(26;"Pmt. Discount Date";Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27;"Shipment Method Code";Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(28;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF ("Location Code" <> xRec."Location Code") AND
                   (xRec."Buy-from Vendor No." = "Buy-from Vendor No.")
                THEN
                  MessageIfPurchLinesExist(FIELDCAPTION("Location Code"));

                UpdateShipToAddress;
                UpdateInboundWhseHandlingTime;
            end;
        }
        field(29;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                          Blocked=CONST(No));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(30;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                          Blocked=CONST(No));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(31;"Vendor Posting Group";Code[20])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
        }
        field(32;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                  TESTFIELD(Status,Status::Open);
                IF (CurrFieldNo <> FIELDNO("Currency Code")) AND ("Currency Code" = xRec."Currency Code") THEN
                  UpdateCurrencyFactor
                ELSE
                  IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    UpdateCurrencyFactor;
                    IF PurchLinesExist THEN
                      IF CONFIRM(ChangeCurrencyQst,FALSE,FIELDCAPTION("Currency Code")) THEN BEGIN
                        SetHideValidationDialog(TRUE);
                        RecreatePurchLines(FIELDCAPTION("Currency Code"));
                        SetHideValidationDialog(FALSE);
                      END ELSE
                        ERROR(Text018,FIELDCAPTION("Currency Code"));
                  END ELSE
                    IF "Currency Code" <> '' THEN BEGIN
                      UpdateCurrencyFactor;
                      IF "Currency Factor" <> xRec."Currency Factor" THEN
                        ConfirmUpdateCurrencyFactor;
                    END;
            end;
        }
        field(33;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                  UpdatePurchLines(FIELDCAPTION("Currency Factor"),CurrFieldNo <> 0);
            end;
        }
        field(35;"Prices Including VAT";Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                PurchLine: Record "39";
                Currency: Record "4";
                RecalculatePrice: Boolean;
                VatFactor: Decimal;
                LineInvDiscAmt: Decimal;
                InvDiscRounding: Decimal;
            begin
                TESTFIELD(Status,Status::Open);

                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                  PurchLine.SETRANGE("Document Type","Document Type");
                  PurchLine.SETRANGE("Document No.","No.");
                  PurchLine.SETFILTER("Direct Unit Cost",'<>%1',0);
                  PurchLine.SETFILTER("VAT %",'<>%1',0);
                  IF PurchLine.FIND('-') THEN BEGIN
                    RecalculatePrice :=
                      CONFIRM(
                        STRSUBSTNO(
                          Text025 +
                          Text027,
                          FIELDCAPTION("Prices Including VAT"),PurchLine.FIELDCAPTION("Direct Unit Cost")),
                        TRUE);
                    PurchLine.SetPurchHeader(Rec);

                    IF "Currency Code" = '' THEN
                      Currency.InitRoundingPrecision
                    ELSE
                      Currency.GET("Currency Code");

                    PurchLine.FINDSET;
                    REPEAT
                      PurchLine.TESTFIELD("Quantity Invoiced",0);
                      PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                      IF NOT RecalculatePrice THEN BEGIN
                        PurchLine."VAT Difference" := 0;
                        PurchLine.UpdateAmounts;
                      END ELSE BEGIN
                        VatFactor := 1 + PurchLine."VAT %" / 100;
                        IF VatFactor = 0 THEN
                          VatFactor := 1;
                        IF NOT "Prices Including VAT" THEN
                          VatFactor := 1 / VatFactor;
                        IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT" THEN
                          VatFactor := 1;
                        PurchLine."Direct Unit Cost" :=
                          ROUND(PurchLine."Direct Unit Cost" * VatFactor,Currency."Unit-Amount Rounding Precision");
                        PurchLine."Line Discount Amount" :=
                          ROUND(
                            PurchLine.Quantity * PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100,
                            Currency."Amount Rounding Precision");
                        LineInvDiscAmt := InvDiscRounding + PurchLine."Inv. Discount Amount" * VatFactor;
                        PurchLine."Inv. Discount Amount" := ROUND(LineInvDiscAmt,Currency."Amount Rounding Precision");
                        InvDiscRounding := LineInvDiscAmt - PurchLine."Inv. Discount Amount";
                        IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT" THEN
                          PurchLine."Line Amount" := PurchLine."Amount Including VAT"
                        ELSE
                          IF "Prices Including VAT" THEN
                            PurchLine."Line Amount" := PurchLine."Amount Including VAT" + PurchLine."Inv. Discount Amount"
                          ELSE
                            PurchLine."Line Amount" := PurchLine.Amount + PurchLine."Inv. Discount Amount";
                        UpdatePrepmtAmounts(PurchLine);
                      END;
                      PurchLine.MODIFY;
                    UNTIL PurchLine.NEXT = 0;
                  END;
                  OnAfterChangePricesIncludingVAT(Rec);
                END;
            end;
        }
        field(37;"Invoice Disc. Code";Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Invoice Disc. Code"));
            end;
        }
        field(41;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;

            trigger OnValidate()
            begin
                MessageIfPurchLinesExist(FIELDCAPTION("Language Code"));
            end;
        }
        field(43;"Purchaser Code";Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = Salesperson/Purchaser;

            trigger OnValidate()
            var
                ApprovalEntry: Record "454";
            begin
                ValidatePurchaserOnPurchHeader(Rec,FALSE,FALSE);

                ApprovalEntry.SETRANGE("Table ID",DATABASE::"Purchase Header");
                ApprovalEntry.SETRANGE("Document Type","Document Type");
                ApprovalEntry.SETRANGE("Document No.","No.");
                ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Created,ApprovalEntry.Status::Open);
                IF NOT ApprovalEntry.ISEMPTY THEN
                  ERROR(Text042,FIELDCAPTION("Purchaser Code"));

                CreateDim(
                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                  DATABASE::Vendor,"Pay-to Vendor No.",
                  DATABASE::Campaign,"Campaign No.",
                  DATABASE::"Responsibility Center","Responsibility Center");
            end;
        }
        field(45;"Order Class";Code[10])
        {
            Caption = 'Order Class';
        }
        field(46;Comment;Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE (Document Type=FIELD(Document Type),
                                                             No.=FIELD(No.),
                                                             Document Line No.=CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51;"On Hold";Code[3])
        {
            Caption = 'On Hold';
        }
        field(52;"Applies-to Doc. Type";Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53;"Applies-to Doc. No.";Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                GenJnlLine: Record "81";
                GenJnlApply: Codeunit "225";
                ApplyVendEntries: Page "233";
            begin
                TESTFIELD("Bal. Account No.",'');
                VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
                VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
                VendLedgEntry.SETRANGE(Open,TRUE);
                IF "Applies-to Doc. No." <> '' THEN BEGIN
                  VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                  IF VendLedgEntry.FINDFIRST THEN;
                  VendLedgEntry.SETRANGE("Document Type");
                  VendLedgEntry.SETRANGE("Document No.");
                END ELSE
                  IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                    VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                    IF VendLedgEntry.FINDFIRST THEN;
                    VendLedgEntry.SETRANGE("Document Type");
                  END ELSE
                    IF Amount <> 0 THEN BEGIN
                      VendLedgEntry.SETRANGE(Positive,Amount < 0);
                      IF VendLedgEntry.FINDFIRST THEN;
                      VendLedgEntry.SETRANGE(Positive);
                    END;
                ApplyVendEntries.SetPurch(Rec,VendLedgEntry,PurchHeader.FIELDNO("Applies-to Doc. No."));
                ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                ApplyVendEntries.SETRECORD(VendLedgEntry);
                ApplyVendEntries.LOOKUPMODE(TRUE);
                IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  ApplyVendEntries.GetVendLedgEntry(VendLedgEntry);
                  GenJnlApply.CheckAgainstApplnCurrency(
                    "Currency Code",VendLedgEntry."Currency Code",GenJnlLine."Account Type"::Vendor,TRUE);
                  "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                  "Applies-to Doc. No." := VendLedgEntry."Document No.";
                END;
                CLEAR(ApplyVendEntries);
            end;

            trigger OnValidate()
            begin
                IF "Applies-to Doc. No." <> '' THEN
                  TESTFIELD("Bal. Account No.",'');

                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                  SetAmountToApply("Applies-to Doc. No.","Buy-from Vendor No.");
                  SetAmountToApply(xRec."Applies-to Doc. No.","Buy-from Vendor No.");
                END ELSE
                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                    SetAmountToApply("Applies-to Doc. No.","Buy-from Vendor No.")
                  ELSE
                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                      SetAmountToApply(xRec."Applies-to Doc. No.","Buy-from Vendor No.");
            end;
        }
        field(55;"Bal. Account No.";Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";

            trigger OnValidate()
            begin
                IF "Bal. Account No." <> '' THEN
                  CASE "Bal. Account Type" OF
                    "Bal. Account Type"::"G/L Account":
                      BEGIN
                        GLAcc.GET("Bal. Account No.");
                        GLAcc.CheckGLAcc;
                        GLAcc.TESTFIELD("Direct Posting",TRUE);
                      END;
                    "Bal. Account Type"::"Bank Account":
                      BEGIN
                        BankAcc.GET("Bal. Account No.");
                        BankAcc.TESTFIELD(Blocked,FALSE);
                        BankAcc.TESTFIELD("Currency Code","Currency Code");
                      END;
                  END;
            end;
        }
        field(56;"Recalculate Invoice Disc.";Boolean)
        {
            CalcFormula = Exist("Purchase Line" WHERE (Document Type=FIELD(Document Type),
                                                       Document No.=FIELD(No.),
                                                       Recalculate Invoice Disc.=CONST(Yes)));
            Caption = 'Recalculate Invoice Disc.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(57;Receive;Boolean)
        {
            Caption = 'Receive';
        }
        field(58;Invoice;Boolean)
        {
            Caption = 'Invoice';
        }
        field(59;"Print Posted Documents";Boolean)
        {
            Caption = 'Print Posted Documents';
        }
        field(60;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line".Amount WHERE (Document Type=FIELD(Document Type),
                                                            Document No.=FIELD(No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE (Document Type=FIELD(Document Type),
                                                                            Document No.=FIELD(No.)));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Receiving No.";Code[20])
        {
            Caption = 'Receiving No.';
        }
        field(63;"Posting No.";Code[20])
        {
            Caption = 'Posting No.';
        }
        field(64;"Last Receiving No.";Code[20])
        {
            Caption = 'Last Receiving No.';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(65;"Last Posting No.";Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Purch. Inv. Header";
        }
        field(66;"Vendor Order No.";Code[35])
        {
            Caption = 'Vendor Order No.';
        }
        field(67;"Vendor Shipment No.";Code[35])
        {
            Caption = 'Vendor Shipment No.';
        }
        field(68;"Vendor Invoice No.";Code[35])
        {
            Caption = 'Vendor Invoice No.';

            trigger OnValidate()
            var
                VendorLedgerEntry: Record "25";
            begin
                IF "Vendor Invoice No." <> '' THEN
                  IF FindPostedDocumentWithSameExternalDocNo(VendorLedgerEntry,"Vendor Invoice No.") THEN
                    ShowExternalDocAlreadyExistNotification(VendorLedgerEntry)
                  ELSE
                    RecallExternalDocAlreadyExistsNotification;
            end;
        }
        field(69;"Vendor Cr. Memo No.";Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';

            trigger OnValidate()
            var
                VendorLedgerEntry: Record "25";
            begin
                IF "Vendor Cr. Memo No." <> '' THEN
                  IF FindPostedDocumentWithSameExternalDocNo(VendorLedgerEntry,"Vendor Cr. Memo No.") THEN
                    ShowExternalDocAlreadyExistNotification(VendorLedgerEntry)
                  ELSE
                    RecallExternalDocAlreadyExistsNotification;
            end;
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(72;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF ("Document Type" = "Document Type"::Order) AND
                   (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
                THEN BEGIN
                  PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
                  PurchLine.SETRANGE("Document No.","No.");
                  PurchLine.SETFILTER("Sales Order Line No.",'<>0');
                  IF NOT PurchLine.ISEMPTY THEN
                    ERROR(
                      YouCannotChangeFieldErr,
                      FIELDCAPTION("Sell-to Customer No."));

                  PurchLine.SETRANGE("Sales Order Line No.");
                  PurchLine.SETFILTER("Special Order Sales Line No.",'<>0');
                  IF NOT PurchLine.ISEMPTY THEN
                    ERROR(
                      YouCannotChangeFieldErr,
                      FIELDCAPTION("Sell-to Customer No."));
                END;

                IF "Sell-to Customer No." = '' THEN
                  VALIDATE("Location Code",UserSetupMgt.GetLocation(1,'',"Responsibility Center"))
                ELSE
                  VALIDATE("Ship-to Code",'');
            end;
        }
        field(73;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74;"Gen. Bus. Posting Group";Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group")
                THEN BEGIN
                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                    "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                  RecreatePurchLines(FIELDCAPTION("Gen. Bus. Posting Group"));
                END;
            end;
        }
        field(76;"Transaction Type";Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Transaction Type"),CurrFieldNo <> 0);
            end;
        }
        field(77;"Transport Method";Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Transport Method"),CurrFieldNo <> 0);
            end;
        }
        field(78;"VAT Country/Region Code";Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = Country/Region;
        }
        field(79;"Buy-from Vendor Name";Text[50])
        {
            Caption = 'Buy-from Vendor Name';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Vendor: Record "23";
            begin
                IF ShouldLookForVendorByName("Pay-to Vendor No.") THEN
                  VALIDATE("Buy-from Vendor No.",Vendor.GetVendorNo("Buy-from Vendor Name"));
            end;
        }
        field(80;"Buy-from Vendor Name 2";Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
        }
        field(81;"Buy-from Address";Text[50])
        {
            Caption = 'Buy-from Address';

            trigger OnValidate()
            begin
                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Address"));
                ModifyVendorAddress;
            end;
        }
        field(82;"Buy-from Address 2";Text[50])
        {
            Caption = 'Buy-from Address 2';

            trigger OnValidate()
            begin
                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Address 2"));
                ModifyVendorAddress;
            end;
        }
        field(83;"Buy-from City";Text[30])
        {
            Caption = 'Buy-from City';
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to City"));
                ModifyVendorAddress;
            end;
        }
        field(84;"Buy-from Contact";Text[50])
        {
            Caption = 'Buy-from Contact';

            trigger OnLookup()
            var
                Contact: Record "5050";
            begin
                IF "Buy-from Vendor No." = '' THEN
                  EXIT;

                LookupContact("Buy-from Vendor No.","Buy-from Contact No.",Contact);
                IF PAGE.RUNMODAL(0,Contact) = ACTION::LookupOK THEN
                  VALIDATE("Buy-from Contact No.",Contact."No.");
            end;

            trigger OnValidate()
            begin
                ModifyVendorAddress;
            end;
        }
        field(85;"Pay-to Post Code";Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                ModifyPayToVendorAddress;
            end;
        }
        field(86;"Pay-to County";Text[30])
        {
            Caption = 'Pay-to County';

            trigger OnValidate()
            begin
                ModifyPayToVendorAddress;
            end;
        }
        field(87;"Pay-to Country/Region Code";Code[10])
        {
            Caption = 'Pay-to Country/Region Code';
            TableRelation = Country/Region;

            trigger OnValidate()
            begin
                ModifyPayToVendorAddress;
            end;
        }
        field(88;"Buy-from Post Code";Code[20])
        {
            Caption = 'Buy-from Post Code';
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Post Code"));
                ModifyVendorAddress;
            end;
        }
        field(89;"Buy-from County";Text[30])
        {
            Caption = 'Buy-from County';

            trigger OnValidate()
            begin
                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to County"));
                ModifyVendorAddress;
            end;
        }
        field(90;"Buy-from Country/Region Code";Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
            TableRelation = Country/Region;

            trigger OnValidate()
            begin
                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Country/Region Code"));
                ModifyVendorAddress;
            end;
        }
        field(91;"Ship-to Post Code";Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(92;"Ship-to County";Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(93;"Ship-to Country/Region Code";Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = Country/Region;
        }
        field(94;"Bal. Account Type";Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(95;"Order Address Code";Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE (Vendor No.=FIELD(Buy-from Vendor No.));

            trigger OnValidate()
            begin
                IF "Order Address Code" <> '' THEN BEGIN
                  OrderAddr.GET("Buy-from Vendor No.","Order Address Code");
                  "Buy-from Vendor Name" := OrderAddr.Name;
                  "Buy-from Vendor Name 2" := OrderAddr."Name 2";
                  "Buy-from Address" := OrderAddr.Address;
                  "Buy-from Address 2" := OrderAddr."Address 2";
                  "Buy-from City" := OrderAddr.City;
                  "Buy-from Contact" := OrderAddr.Contact;
                  "Buy-from Post Code" := OrderAddr."Post Code";
                  "Buy-from County" := OrderAddr.County;
                  "Buy-from Country/Region Code" := OrderAddr."Country/Region Code";

                  IF IsCreditDocType THEN BEGIN
                    SetShipToAddress(
                      OrderAddr.Name,OrderAddr."Name 2",OrderAddr.Address,OrderAddr."Address 2",
                      OrderAddr.City,OrderAddr."Post Code",OrderAddr.County,OrderAddr."Country/Region Code");
                    "Ship-to Contact" := OrderAddr.Contact;
                  END
                END ELSE BEGIN
                  GetVend("Buy-from Vendor No.");
                  "Buy-from Vendor Name" := Vend.Name;
                  "Buy-from Vendor Name 2" := Vend."Name 2";
                  CopyBuyFromVendorAddressFieldsFromVendor(Vend,TRUE);

                  IF IsCreditDocType THEN BEGIN
                    "Ship-to Name" := Vend.Name;
                    "Ship-to Name 2" := Vend."Name 2";
                    CopyShipToVendorAddressFieldsFromVendor(Vend,TRUE);
                    "Ship-to Contact" := Vend.Contact;
                    "Shipment Method Code" := Vend."Shipment Method Code";
                    IF Vend."Location Code" <> '' THEN
                      VALIDATE("Location Code",Vend."Location Code");
                  END
                END;
            end;
        }
        field(97;"Entry Point";Code[10])
        {
            Caption = 'Entry Point';
            TableRelation = "Entry/Exit Point";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Entry Point"),CurrFieldNo <> 0);
            end;
        }
        field(98;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(99;"Document Date";Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                IF xRec."Document Date" <> "Document Date" THEN
                  UpdateDocumentDate := TRUE;
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
            end;
        }
        field(101;"Area";Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION(Area),CurrFieldNo <> 0);
            end;
        }
        field(102;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Transaction Specification"),CurrFieldNo <> 0);
            end;
        }
        field(104;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                PaymentMethod.INIT;
                IF "Payment Method Code" <> '' THEN
                  PaymentMethod.GET("Payment Method Code");
                "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                "Bal. Account No." := PaymentMethod."Bal. Account No.";
                IF "Bal. Account No." <> '' THEN BEGIN
                  TESTFIELD("Applies-to Doc. No.",'');
                  TESTFIELD("Applies-to ID",'');
                END;
            end;
        }
        field(107;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"Posting No. Series";Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  TestNoSeries;
                  IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode,"Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Posting No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  TestNoSeries;
                  NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
                END;
                TESTFIELD("Posting No.",'');
            end;
        }
        field(109;"Receiving No. Series";Code[20])
        {
            Caption = 'Receiving No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Receipt Nos.");
                  IF NoSeriesMgt.LookupSeries(PurchSetup."Posted Receipt Nos.","Receiving No. Series") THEN
                    VALIDATE("Receiving No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Receiving No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Receipt Nos.");
                  NoSeriesMgt.TestSeries(PurchSetup."Posted Receipt Nos.","Receiving No. Series");
                END;
                TESTFIELD("Receiving No.",'');
            end;
        }
        field(114;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Area Code"));
            end;
        }
        field(115;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Liable"));
            end;
        }
        field(116;"VAT Bus. Posting Group";Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                THEN
                  RecreatePurchLines(FIELDCAPTION("VAT Bus. Posting Group"));
            end;
        }
        field(118;"Applies-to ID";Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempVendLedgEntry: Record "25" temporary;
                VendEntrySetApplID: Codeunit "111";
            begin
                IF "Applies-to ID" <> '' THEN
                  TESTFIELD("Bal. Account No.",'');
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                  VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
                  VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
                  VendLedgEntry.SETRANGE(Open,TRUE);
                  VendLedgEntry.SETRANGE("Applies-to ID",xRec."Applies-to ID");
                  IF VendLedgEntry.FINDFIRST THEN
                    VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,'');
                  VendLedgEntry.RESET;
                END;
            end;
        }
        field(119;"VAT Base Discount %";Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                GLSetup.GET;
                IF "VAT Base Discount %" > GLSetup."VAT Tolerance %" THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed :=
                      CONFIRM(
                        Text007 +
                        Text008,FALSE,
                        FIELDCAPTION("VAT Base Discount %"),
                        GLSetup.FIELDCAPTION("VAT Tolerance %"),
                        GLSetup.TABLECAPTION);
                  IF NOT Confirmed THEN
                    "VAT Base Discount %" := xRec."VAT Base Discount %";
                END;

                IF ("VAT Base Discount %" = xRec."VAT Base Discount %") AND
                   (CurrFieldNo <> 0)
                THEN
                  EXIT;

                PurchLine.SETRANGE("Document Type","Document Type");
                PurchLine.SETRANGE("Document No.","No.");
                PurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
                PurchLine.SETFILTER(Quantity,'<>0');
                PurchLine.LOCKTABLE;
                IF PurchLine.FINDSET THEN BEGIN
                  MODIFY;
                  REPEAT
                    PurchLine.UpdateAmounts;
                    PurchLine.MODIFY;
                  UNTIL PurchLine.NEXT = 0;
                END;
                PurchLine.RESET;
            end;
        }
        field(120;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121;"Invoice Discount Calculation";Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122;"Invoice Discount Value";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(123;"Send IC Document";Boolean)
        {
            Caption = 'Send IC Document';

            trigger OnValidate()
            begin
                IF "Send IC Document" THEN BEGIN
                  TESTFIELD("Buy-from IC Partner Code");
                  TESTFIELD("IC Direction","IC Direction"::Outgoing);
                END;
            end;
        }
        field(124;"IC Status";Option)
        {
            Caption = 'IC Status';
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125;"Buy-from IC Partner Code";Code[20])
        {
            Caption = 'Buy-from IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126;"Pay-to IC Partner Code";Code[20])
        {
            Caption = 'Pay-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129;"IC Direction";Option)
        {
            Caption = 'IC Direction';
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;

            trigger OnValidate()
            begin
                IF "IC Direction" = "IC Direction"::Incoming THEN
                  "Send IC Document" := FALSE;
            end;
        }
        field(130;"Prepayment No.";Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(131;"Last Prepayment No.";Code[20])
        {
            Caption = 'Last Prepayment No.';
            TableRelation = "Purch. Inv. Header";
        }
        field(132;"Prepmt. Cr. Memo No.";Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(133;"Last Prepmt. Cr. Memo No.";Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            TableRelation = "Purch. Cr. Memo Hdr.";
        }
        field(134;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF xRec."Prepayment %" <> "Prepayment %" THEN
                  UpdatePurchLines(FIELDCAPTION("Prepayment %"),CurrFieldNo <> 0);
            end;
        }
        field(135;"Prepayment No. Series";Code[20])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                  IF NoSeriesMgt.LookupSeries(GetPostingPrepaymentNoSeriesCode,"Prepayment No. Series") THEN
                    VALIDATE("Prepayment No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Prepayment No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                  NoSeriesMgt.TestSeries(GetPostingPrepaymentNoSeriesCode,"Prepayment No. Series");
                END;
                TESTFIELD("Prepayment No.",'');
            end;
        }
        field(136;"Compress Prepayment";Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(137;"Prepayment Due Date";Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(138;"Prepmt. Cr. Memo No. Series";Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                  IF NoSeriesMgt.LookupSeries(GetPostingPrepaymentNoSeriesCode,"Prepmt. Cr. Memo No. Series") THEN
                    VALIDATE("Prepmt. Cr. Memo No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Prepmt. Cr. Memo No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                  NoSeriesMgt.TestSeries(GetPostingPrepaymentNoSeriesCode,"Prepmt. Cr. Memo No. Series");
                END;
                TESTFIELD("Prepmt. Cr. Memo No.",'');
            end;
        }
        field(139;"Prepmt. Posting Description";Text[50])
        {
            Caption = 'Prepmt. Posting Description';
        }
        field(142;"Prepmt. Pmt. Discount Date";Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(143;"Prepmt. Payment Terms Code";Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                PaymentTerms: Record "3";
            begin
                IF ("Prepmt. Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                  PaymentTerms.GET("Prepmt. Payment Terms Code");
                  IF IsCreditDocType AND NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                    VALIDATE("Prepayment Due Date","Document Date");
                    VALIDATE("Prepmt. Pmt. Discount Date",0D);
                    VALIDATE("Prepmt. Payment Discount %",0);
                  END ELSE BEGIN
                    "Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                    "Prepmt. Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                    IF NOT UpdateDocumentDate THEN
                      VALIDATE("Prepmt. Payment Discount %",PaymentTerms."Discount %")
                  END;
                END ELSE BEGIN
                  VALIDATE("Prepayment Due Date","Document Date");
                  IF NOT UpdateDocumentDate THEN BEGIN
                    VALIDATE("Prepmt. Pmt. Discount Date",0D);
                    VALIDATE("Prepmt. Payment Discount %",0);
                  END;
                END;
            end;
        }
        field(144;"Prepmt. Payment Discount %";Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date"),FIELDNO("Document Date")]) THEN
                  TESTFIELD(Status,Status::Open);
                GLSetup.GET;
                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                  "VAT Base Discount %" := "Payment Discount %"
                ELSE
                  "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(151;"Quote No.";Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(160;"Job Queue Status";Option)
        {
            Caption = 'Job Queue Status';
            Editable = false;
            OptionCaption = ' ,Scheduled for Posting,Error,Posting';
            OptionMembers = " ","Scheduled for Posting",Error,Posting;

            trigger OnLookup()
            var
                JobQueueEntry: Record "472";
            begin
                IF "Job Queue Status" = "Job Queue Status"::" " THEN
                  EXIT;
                JobQueueEntry.ShowStatusMsg("Job Queue Entry ID");
            end;
        }
        field(161;"Job Queue Entry ID";Guid)
        {
            Caption = 'Job Queue Entry ID';
            Editable = false;
        }
        field(165;"Incoming Document Entry No.";Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "130";
            begin
                IF "Incoming Document Entry No." = xRec."Incoming Document Entry No." THEN
                  EXIT;
                IF "Incoming Document Entry No." = 0 THEN
                  IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                ELSE
                  IncomingDocument.SetPurchDoc(Rec);
            end;
        }
        field(170;"Creditor No.";Code[20])
        {
            Caption = 'Creditor No.';
        }
        field(171;"Payment Reference";Code[50])
        {
            Caption = 'Payment Reference';
            Numeric = true;
        }
        field(300;"A. Rcd. Not Inv. Ex. VAT (LCY)";Decimal)
        {
            CalcFormula = Sum("Purchase Line"."A. Rcd. Not Inv. Ex. VAT (LCY)" WHERE (Document Type=FIELD(Document Type),
                                                                                      Document No.=FIELD(No.)));
            Caption = 'Amount Received Not Invoiced (LCY)';
            FieldClass = FlowField;
        }
        field(301;"Amt. Rcd. Not Invoiced (LCY)";Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE (Document Type=FIELD(Document Type),
                                                                                    Document No.=FIELD(No.)));
            Caption = 'Amount Received Not Invoiced (LCY) Incl. VAT';
            FieldClass = FlowField;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
            end;
        }
        field(1305;"Invoice Discount Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Inv. Discount Amount" WHERE (Document No.=FIELD(No.),
                                                                            Document Type=FIELD(Document Type)));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5043;"No. of Archived Versions";Integer)
        {
            CalcFormula = Max("Purchase Header Archive"."Version No." WHERE (Document Type=FIELD(Document Type),
                                                                             No.=FIELD(No.),
                                                                             Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048;"Doc. No. Occurrence";Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                CreateDim(
                  DATABASE::Campaign,"Campaign No.",
                  DATABASE::Vendor,"Pay-to Vendor No.",
                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                  DATABASE::"Responsibility Center","Responsibility Center");
            end;
        }
        field(5052;"Buy-from Contact No.";Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF "Buy-from Vendor No." <> '' THEN
                  IF Cont.GET("Buy-from Contact No.") THEN
                    Cont.SETRANGE("Company No.",Cont."Company No.")
                  ELSE
                    IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Buy-from Vendor No.") THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                    ELSE
                      Cont.SETRANGE("No.",'');

                IF "Buy-from Contact No." <> '' THEN
                  IF Cont.GET("Buy-from Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Buy-from Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
            begin
                TESTFIELD(Status,Status::Open);

                IF "Buy-from Contact No." <> '' THEN
                  IF Cont.GET("Buy-from Contact No.") THEN
                    Cont.CheckIfPrivacyBlockedGeneric;

                IF ("Buy-from Contact No." <> xRec."Buy-from Contact No.") AND
                   (xRec."Buy-from Contact No." <> '')
                THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(ConfirmChangeQst,FALSE,FIELDCAPTION("Buy-from Contact No."));
                  IF Confirmed THEN BEGIN
                    IF InitFromContact("Buy-from Contact No.","Buy-from Vendor No.",FIELDCAPTION("Buy-from Contact No.")) THEN
                      EXIT
                  END ELSE BEGIN
                    Rec := xRec;
                    EXIT;
                  END;
                END;

                IF ("Buy-from Vendor No." <> '') AND ("Buy-from Contact No." <> '') THEN BEGIN
                  Cont.GET("Buy-from Contact No.");
                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Buy-from Vendor No.") THEN
                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                      ERROR(Text038,Cont."No.",Cont.Name,"Buy-from Vendor No.");
                END;

                UpdateBuyFromVend("Buy-from Contact No.");
            end;
        }
        field(5053;"Pay-to Contact No.";Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF "Pay-to Vendor No." <> '' THEN
                  IF Cont.GET("Pay-to Contact No.") THEN
                    Cont.SETRANGE("Company No.",Cont."Company No.")
                  ELSE
                    IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Pay-to Vendor No.") THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                    ELSE
                      Cont.SETRANGE("No.",'');

                IF "Pay-to Contact No." <> '' THEN
                  IF Cont.GET("Pay-to Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Pay-to Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
            begin
                TESTFIELD(Status,Status::Open);

                IF "Pay-to Contact No." <> '' THEN
                  IF Cont.GET("Pay-to Contact No.") THEN
                    Cont.CheckIfPrivacyBlockedGeneric;

                IF ("Pay-to Contact No." <> xRec."Pay-to Contact No.") AND
                   (xRec."Pay-to Contact No." <> '')
                THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(ConfirmChangeQst,FALSE,FIELDCAPTION("Pay-to Contact No."));
                  IF Confirmed THEN BEGIN
                    IF InitFromContact("Pay-to Contact No.","Pay-to Vendor No.",FIELDCAPTION("Pay-to Contact No.")) THEN
                      EXIT
                  END ELSE BEGIN
                    "Pay-to Contact No." := xRec."Pay-to Contact No.";
                    EXIT;
                  END;
                END;

                IF ("Pay-to Vendor No." <> '') AND ("Pay-to Contact No." <> '') THEN BEGIN
                  Cont.GET("Pay-to Contact No.");
                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Pay-to Vendor No.") THEN
                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                      ERROR(Text038,Cont."No.",Cont.Name,"Pay-to Vendor No.");
                END;

                UpdatePayToVend("Pay-to Contact No.");
            end;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
                  ERROR(
                    Text028,
                    RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

                "Location Code" := UserSetupMgt.GetLocation(1,'',"Responsibility Center");
                UpdateInboundWhseHandlingTime;

                UpdateShipToAddress;

                CreateDim(
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::Vendor,"Pay-to Vendor No.",
                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                  DATABASE::Campaign,"Campaign No.");

                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                  "Assigned User ID" := '';
                END;
            end;
        }
        field(5751;"Partially Invoiced";Boolean)
        {
            CalcFormula = Exist("Purchase Line" WHERE (Document Type=FIELD(Document Type),
                                                       Document No.=FIELD(No.),
                                                       Type=FILTER(<>' '),
                                                       Location Code=FIELD(Location Filter),
                                                       Quantity Invoiced=FILTER(<>0)));
            Caption = 'Partially Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752;"Completely Received";Boolean)
        {
            CalcFormula = Min("Purchase Line"."Completely Received" WHERE (Document Type=FIELD(Document Type),
                                                                           Document No.=FIELD(No.),
                                                                           Type=FILTER(<>' '),
                                                                           Location Code=FIELD(Location Filter)));
            Caption = 'Completely Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753;"Posting from Whse. Ref.";Integer)
        {
            AccessByPermission = TableData 14=R;
            Caption = 'Posting from Whse. Ref.';
        }
        field(5754;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790;"Requested Receipt Date";Date)
        {
            Caption = 'Requested Receipt Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Promised Receipt Date" <> 0D THEN
                  ERROR(
                    Text034,
                    FIELDCAPTION("Requested Receipt Date"),
                    FIELDCAPTION("Promised Receipt Date"));

                IF "Requested Receipt Date" <> xRec."Requested Receipt Date" THEN
                  UpdatePurchLines(FIELDCAPTION("Requested Receipt Date"),CurrFieldNo <> 0);
            end;
        }
        field(5791;"Promised Receipt Date";Date)
        {
            Caption = 'Promised Receipt Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Promised Receipt Date" <> xRec."Promised Receipt Date" THEN
                  UpdatePurchLines(FIELDCAPTION("Promised Receipt Date"),CurrFieldNo <> 0);
            end;
        }
        field(5792;"Lead Time Calculation";DateFormula)
        {
            AccessByPermission = TableData 120=R;
            Caption = 'Lead Time Calculation';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                LeadTimeMgt.CheckLeadTimeIsNotNegative("Lead Time Calculation");

                IF "Lead Time Calculation" <> xRec."Lead Time Calculation" THEN
                  UpdatePurchLines(FIELDCAPTION("Lead Time Calculation"),CurrFieldNo <> 0);
            end;
        }
        field(5793;"Inbound Whse. Handling Time";DateFormula)
        {
            AccessByPermission = TableData 14=R;
            Caption = 'Inbound Whse. Handling Time';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Inbound Whse. Handling Time" <> xRec."Inbound Whse. Handling Time" THEN
                  UpdatePurchLines(FIELDCAPTION("Inbound Whse. Handling Time"),CurrFieldNo <> 0);
            end;
        }
        field(5796;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5800;"Vendor Authorization No.";Code[35])
        {
            Caption = 'Vendor Authorization No.';
        }
        field(5801;"Return Shipment No.";Code[20])
        {
            Caption = 'Return Shipment No.';
        }
        field(5802;"Return Shipment No. Series";Code[20])
        {
            Caption = 'Return Shipment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                  IF NoSeriesMgt.LookupSeries(PurchSetup."Posted Return Shpt. Nos.","Return Shipment No. Series") THEN
                    VALIDATE("Return Shipment No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Return Shipment No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                  NoSeriesMgt.TestSeries(PurchSetup."Posted Return Shpt. Nos.","Return Shipment No. Series");
                END;
                TESTFIELD("Return Shipment No.",'');
            end;
        }
        field(5803;Ship;Boolean)
        {
            Caption = 'Ship';
        }
        field(5804;"Last Return Shipment No.";Code[20])
        {
            Caption = 'Last Return Shipment No.';
            Editable = false;
            TableRelation = "Return Shipment Header";
        }
        field(8000;Id;Guid)
        {
            Caption = 'Id';
        }
        field(9000;"Assigned User ID";Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                IF NOT UserSetupMgt.CheckRespCenter2(1,"Responsibility Center","Assigned User ID") THEN
                  ERROR(
                    Text049,"Assigned User ID",
                    RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter2("Assigned User ID"));
            end;
        }
        field(9001;"Pending Approvals";Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE (Table ID=CONST(38),
                                                        Document Type=FIELD(Document Type),
                                                        Document No.=FIELD(No.),
                                                        Status=FILTER(Open|Created)));
            Caption = 'Pending Approvals';
            FieldClass = FlowField;
        }
        field(50000;Cancelled;Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Document Type","No.")
        {
            Clustered = true;
        }
        key(Key2;"No.","Document Type")
        {
        }
        key(Key3;"Document Type","Buy-from Vendor No.")
        {
        }
        key(Key4;"Document Type","Pay-to Vendor No.")
        {
        }
        key(Key5;"Buy-from Vendor No.")
        {
        }
        key(Key6;"Incoming Document Entry No.")
        {
        }
        key(Key7;"Document Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PostPurchDelete: Codeunit "364";
        ArchiveManagement: Codeunit "5063";
    begin
        IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
          ERROR(
            Text023,
            RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

        ArchiveManagement.AutoArchivePurchDocument(Rec);
        PostPurchDelete.DeleteHeader(
          Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
          ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
        VALIDATE("Applies-to ID",'');
        VALIDATE("Incoming Document Entry No.",0);

        ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RECORDID);
        PurchLine.LOCKTABLE;

        WhseRequest.SETRANGE("Source Type",DATABASE::"Purchase Line");
        WhseRequest.SETRANGE("Source Subtype","Document Type");
        WhseRequest.SETRANGE("Source No.","No.");
        WhseRequest.DELETEALL(TRUE);

        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
        DeletePurchaseLines;
        PurchLine.SETRANGE(Type);
        DeletePurchaseLines;

        PurchCommentLine.SETRANGE("Document Type","Document Type");
        PurchCommentLine.SETRANGE("No.","No.");
        PurchCommentLine.DELETEALL;

        IF (PurchRcptHeader."No." <> '') OR
           (PurchInvHeader."No." <> '') OR
           (PurchCrMemoHeader."No." <> '') OR
           (ReturnShptHeader."No." <> '') OR
           (PurchInvHeaderPrepmt."No." <> '') OR
           (PurchCrMemoHeaderPrepmt."No." <> '')
        THEN
          MESSAGE(PostedDocsToPrintCreatedMsg);
    end;

    trigger OnInsert()
    begin
        InitInsert;

        IF GETFILTER("Buy-from Vendor No.") <> '' THEN
          IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
            VALIDATE("Buy-from Vendor No.",GETRANGEMIN("Buy-from Vendor No."));

        IF "Purchaser Code" = '' THEN
          SetDefaultPurchaser;
    end;

    trigger OnRename()
    begin
        ERROR(Text003,TABLECAPTION);
    end;

    var
        Text003: Label 'You cannot rename a %1.';
        ConfirmChangeQst: Label 'Do you want to change %1?', Comment='%1 = a Field Caption like Currency Code';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        YouCannotChangeFieldErr: Label 'You cannot change %1 because the order is associated with one or more sales orders.', Comment='%1 - fieldcaption';
        Text007: Label '%1 is greater than %2 in the %3 table.\';
        Text008: Label 'Confirm change?';
        Text009: Label 'Deleting this document will cause a gap in the number series for receipts. An empty receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment='%1 = Document No.';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment='%1 = Document No.';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment='%1 = Document No.';
        RecreatePurchLinesMsg: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\Do you want to continue?', Comment='%1: FieldCaption';
        ResetItemChargeAssignMsg: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\The amount of the item charge assignment will be reset to 0.\\Do you want to continue?', Comment='%1: FieldCaption';
        Text018: Label 'You must delete the existing purchase lines before you can change %1.';
        LinesNotUpdatedMsg: Label 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.', Comment='You have changed Posting Date on the purchase header, but it has not been changed on the existing purchase lines.';
        Text020: Label 'You must update the existing purchase lines manually.';
        AffectExchangeRateMsg: Label 'The change may affect the exchange rate that is used for price calculation on the purchase lines.';
        Text022: Label 'Do you want to update the exchange rate?';
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text025: Label 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ';
        Text027: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return shipments. An empty return shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment='%1 = Document No.';
        Text032: Label 'You have modified %1.\\';
        Text033: Label 'Do you want to update the lines?';
        PurchSetup: Record "312";
        GLSetup: Record "98";
        GLAcc: Record "15";
        PurchLine: Record "39";
        xPurchLine: Record "39";
        VendLedgEntry: Record "25";
        Vend: Record "23";
        PaymentTerms: Record "3";
        PaymentMethod: Record "289";
        CurrExchRate: Record "330";
        PurchHeader: Record "38";
        PurchCommentLine: Record "43";
        Cust: Record "18";
        CompanyInfo: Record "79";
        PostCode: Record "225";
        OrderAddr: Record "224";
        BankAcc: Record "270";
        PurchRcptHeader: Record "120";
        PurchInvHeader: Record "122";
        PurchCrMemoHeader: Record "124";
        ReturnShptHeader: Record "6650";
        PurchInvHeaderPrepmt: Record "122";
        PurchCrMemoHeaderPrepmt: Record "124";
        GenBusPostingGrp: Record "250";
        RespCenter: Record "5714";
        Location: Record "14";
        WhseRequest: Record "5765";
        InvtSetup: Record "313";
        SalespersonPurchaser: Record "13";
        NoSeriesMgt: Codeunit "396";
        DimMgt: Codeunit "408";
        ApprovalsMgmt: Codeunit "1535";
        UserSetupMgt: Codeunit "5700";
        LeadTimeMgt: Codeunit "5404";
        PostingSetupMgt: Codeunit "48";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text034: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text037: Label 'Contact %1 %2 is not related to vendor %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than vendor %3.';
        Text039: Label 'Contact %1 %2 is not related to a vendor.';
        SkipBuyFromContact: Boolean;
        SkipPayToContact: Boolean;
        Text040: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text042: Label 'You must cancel the approval process if you wish to change the %1.';
        Text045: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text046: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text049: Label '%1 is set up to process from %2 %3 only.';
        Text050: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text052: Label 'The %1 field on the purchase order %2 must be the same as on sales order %3.';
        UpdateDocumentDate: Boolean;
        PrepaymentInvoicesNotPaidErr: Label 'You cannot post the document of type %1 with the number %2 before all related prepayment invoices are posted.', Comment='You cannot post the document of type Order with the number 1001 before all related prepayment invoices are posted.';
        Text054: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        DeferralLineQst: Label 'You have changed the %1 on the purchase header, do you want to update the deferral schedules for the lines with this date?', Comment='%1=The posting date on the document.';
        ChangeCurrencyQst: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created. You may need to update the price information manually.\\Do you want to change %1?';
        PostedDocsToPrintCreatedMsg: Label 'One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.';
        BuyFromVendorTxt: Label 'Buy-from Vendor';
        PayToVendorTxt: Label 'Pay-to Vendor';
        DocumentNotPostedClosePageQst: Label 'The document has not been posted.\Are you sure you want to exit?';
        PurchOrderDocTxt: Label 'Purchase Order';
        SelectNoSeriesAllowed: Boolean;
        PurchQuoteDocTxt: Label 'Purchase Quote';
        MixedDropshipmentErr: Label 'You cannot print the purchase order because it contains one or more lines for drop shipment in addition to regular purchase lines.';
        ModifyVendorAddressNotificationLbl: Label 'Update the address';
        DontShowAgainActionLbl: Label 'Don''t show again';
        ModifyVendorAddressNotificationMsg: Label 'The address you entered for %1 is different from the Vendor''s existing address.', Comment='%1=Vendor name';
        ModifyBuyFromVendorAddressNotificationNameTxt: Label 'Update Buy-from Vendor Address';
        ModifyBuyFromVendorAddressNotificationDescriptionTxt: Label 'Warn if the Buy-from address on sales documents is different from the Vendor''s existing address.';
        ModifyPayToVendorAddressNotificationNameTxt: Label 'Update Pay-to Vendor Address';
        ModifyPayToVendorAddressNotificationDescriptionTxt: Label 'Warn if the Pay-to address on sales documents is different from the Vendor''s existing address.';
        PurchaseAlreadyExistsTxt: Label 'Purchase %1 %2 already exists for this vendor.', Comment='%1 = Document Type; %2 = Document No.';
        ShowVendLedgEntryTxt: Label 'Show the vendor ledger entry.';
        ShowDocAlreadyExistNotificationNameTxt: Label 'Purchase document with same external document number already exists.';
        ShowDocAlreadyExistNotificationDescriptionTxt: Label 'Warn if purchase document with same external document number already exists.';
        SplitMessageTxt: Label '%1\%2', Comment='Some message text 1.\Some message text 2.';

    local procedure InitInsert()
    begin
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
        END;

        InitRecord;
    end;

    procedure InitRecord()
    var
        ArchiveManagement: Codeunit "5063";
    begin
        PurchSetup.GET;

        CASE "Document Type" OF
          "Document Type"::Quote,"Document Type"::Order:
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
              NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",PurchSetup."Posted Prepmt. Inv. Nos.");
                NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",PurchSetup."Posted Prepmt. Cr. Memo Nos.");
              END;
            END;
          "Document Type"::Invoice:
            BEGIN
              IF ("No. Series" <> '') AND
                 (PurchSetup."Invoice Nos." = PurchSetup."Posted Invoice Nos.")
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
              IF PurchSetup."Receipt on Invoice" THEN
                NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
            END;
          "Document Type"::"Return Order":
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
              NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
            END;
          "Document Type"::"Credit Memo":
            BEGIN
              IF ("No. Series" <> '') AND
                 (PurchSetup."Credit Memo Nos." = PurchSetup."Posted Credit Memo Nos.")
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
              IF PurchSetup."Return Shipment on Credit Memo" THEN
                NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
            END;
        END;

        IF "Document Type" = "Document Type"::Invoice THEN
          "Expected Receipt Date" := WORKDATE;

        IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
           ("Posting Date" = 0D)
        THEN
          "Posting Date" := WORKDATE;

        IF PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" THEN
          "Posting Date" := 0D;

        "Order Date" := WORKDATE;
        "Document Date" := WORKDATE;

        ValidateEmptySellToCustomerAndLocation;

        IF IsCreditDocType THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        UpdateInboundWhseHandlingTime;

        "Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center");
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header","Document Type","No.");

        OnAfterInitRecord(Rec);
    end;

    local procedure InitNoSeries()
    begin
        IF xRec."Receiving No." <> '' THEN BEGIN
          "Receiving No. Series" := xRec."Receiving No. Series";
          "Receiving No." := xRec."Receiving No.";
        END;
        IF xRec."Posting No." <> '' THEN BEGIN
          "Posting No. Series" := xRec."Posting No. Series";
          "Posting No." := xRec."Posting No.";
        END;
        IF xRec."Return Shipment No." <> '' THEN BEGIN
          "Return Shipment No. Series" := xRec."Return Shipment No. Series";
          "Return Shipment No." := xRec."Return Shipment No.";
        END;
        IF xRec."Prepayment No." <> '' THEN BEGIN
          "Prepayment No. Series" := xRec."Prepayment No. Series";
          "Prepayment No." := xRec."Prepayment No.";
        END;
        IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
          "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
          "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
        END;

        OnAfterInitNoSeries(Rec);
    end;

    procedure AssistEdit(OldPurchHeader: Record "38"): Boolean
    begin
        PurchSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldPurchHeader."No. Series","No. Series") THEN BEGIN
          PurchSetup.GET;
          TestNoSeries;
          NoSeriesMgt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    local procedure TestNoSeries()
    begin
        PurchSetup.GET;
        CASE "Document Type" OF
          "Document Type"::Quote:
            PurchSetup.TESTFIELD("Quote Nos.");
          "Document Type"::Order:
            PurchSetup.TESTFIELD("Order Nos.");
          "Document Type"::Invoice:
            BEGIN
              PurchSetup.TESTFIELD("Invoice Nos.");
              PurchSetup.TESTFIELD("Posted Invoice Nos.");
            END;
          "Document Type"::"Return Order":
            PurchSetup.TESTFIELD("Return Order Nos.");
          "Document Type"::"Credit Memo":
            BEGIN
              PurchSetup.TESTFIELD("Credit Memo Nos.");
              PurchSetup.TESTFIELD("Posted Credit Memo Nos.");
            END;
          "Document Type"::"Blanket Order":
            PurchSetup.TESTFIELD("Blanket Order Nos.");
        END;

        OnAfterTestNoSeries(Rec);
    end;

    local procedure GetNoSeriesCode(): Code[20]
    var
        NoSeriesCode: Code[20];
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            NoSeriesCode := PurchSetup."Quote Nos.";
          "Document Type"::Order:
            NoSeriesCode := PurchSetup."Order Nos.";
          "Document Type"::Invoice:
            NoSeriesCode := PurchSetup."Invoice Nos.";
          "Document Type"::"Return Order":
            NoSeriesCode := PurchSetup."Return Order Nos.";
          "Document Type"::"Credit Memo":
            NoSeriesCode := PurchSetup."Credit Memo Nos.";
          "Document Type"::"Blanket Order":
            NoSeriesCode := PurchSetup."Blanket Order Nos.";
        END;
        EXIT(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode,SelectNoSeriesAllowed,"No. Series"));
    end;

    local procedure GetPostingNoSeriesCode(): Code[20]
    begin
        IF IsCreditDocType THEN
          EXIT(PurchSetup."Posted Credit Memo Nos.");
        EXIT(PurchSetup."Posted Invoice Nos.");
    end;

    local procedure GetPostingPrepaymentNoSeriesCode(): Code[20]
    begin
        IF IsCreditDocType THEN
          EXIT(PurchSetup."Posted Prepmt. Cr. Memo Nos.");
        EXIT(PurchSetup."Posted Prepmt. Inv. Nos.");
    end;

    local procedure TestNoSeriesDate(No: Code[20];NoSeriesCode: Code[20];NoCapt: Text[1024];NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "308";
    begin
        IF (No <> '') AND (NoSeriesCode <> '') THEN BEGIN
          NoSeries.GET(NoSeriesCode);
          IF NoSeries."Date Order" THEN
            ERROR(
              Text040,
              FIELDCAPTION("Posting Date"),NoSeriesCapt,NoSeriesCode,
              NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
              NoCapt,No);
        END;
    end;

    procedure ConfirmDeletion(): Boolean
    var
        SourceCode: Record "230";
        SourceCodeSetup: Record "242";
        PostPurchDelete: Codeunit "364";
    begin
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Deleted Document");
        SourceCode.GET(SourceCodeSetup."Deleted Document");

        PostPurchDelete.InitDeleteHeader(
          Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
          ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt,SourceCode.Code);

        IF PurchRcptHeader."No." <> '' THEN
          IF NOT CONFIRM(Text009,TRUE,PurchRcptHeader."No.")
          THEN
            EXIT;
        IF PurchInvHeader."No." <> '' THEN
          IF NOT CONFIRM(Text012,TRUE,PurchInvHeader."No.")
          THEN
            EXIT;
        IF PurchCrMemoHeader."No." <> '' THEN
          IF NOT CONFIRM(Text014,TRUE,PurchCrMemoHeader."No.")
          THEN
            EXIT;
        IF ReturnShptHeader."No." <> '' THEN
          IF NOT CONFIRM(Text029,TRUE,ReturnShptHeader."No.")
          THEN
            EXIT;
        IF "Prepayment No." <> '' THEN
          IF NOT CONFIRM(Text045,TRUE,PurchInvHeaderPrepmt."No.")
          THEN
            EXIT;
        IF "Prepmt. Cr. Memo No." <> '' THEN
          IF NOT CONFIRM(Text046,TRUE,PurchCrMemoHeaderPrepmt."No.")
          THEN
            EXIT;
        EXIT(TRUE);
    end;

    local procedure GetVend(VendNo: Code[20])
    begin
        IF VendNo <> Vend."No." THEN
          Vend.GET(VendNo);
    end;

    procedure PurchLinesExist(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        EXIT(PurchLine.FINDFIRST);
    end;

    local procedure RecreatePurchLines(ChangedFieldName: Text[100])
    var
        TempPurchLine: Record "39" temporary;
        ItemChargeAssgntPurch: Record "5805";
        TempItemChargeAssgntPurch: Record "5805" temporary;
        TempInteger: Record "2000000026" temporary;
        SalesHeader: Record "36";
        TransferExtendedText: Codeunit "378";
        ExtendedTextAdded: Boolean;
        ConfirmText: Text;
        IsHandled: Boolean;
    begin
        IF NOT PurchLinesExist THEN
          EXIT;

        IsHandled := FALSE;
        OnRecreatePurchLinesOnBeforeConfirm(Rec,xRec,ChangedFieldName,HideValidationDialog,Confirmed,IsHandled);
        IF NOT IsHandled THEN
          IF HideValidationDialog OR NOT GUIALLOWED THEN
            Confirmed := TRUE
          ELSE BEGIN
            IF HasItemChargeAssignment THEN
              ConfirmText := ResetItemChargeAssignMsg
            ELSE
              ConfirmText := RecreatePurchLinesMsg;
            Confirmed := CONFIRM(ConfirmText,FALSE,ChangedFieldName);
          END;

        IF Confirmed THEN BEGIN
          PurchLine.LOCKTABLE;
          ItemChargeAssgntPurch.LOCKTABLE;
          MODIFY;

          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          IF PurchLine.FINDSET THEN BEGIN
            REPEAT
              PurchLine.TESTFIELD("Quantity Received",0);
              PurchLine.TESTFIELD("Quantity Invoiced",0);
              PurchLine.TESTFIELD("Return Qty. Shipped",0);
              PurchLine.CALCFIELDS("Reserved Qty. (Base)");
              PurchLine.TESTFIELD("Reserved Qty. (Base)",0);
              PurchLine.TESTFIELD("Receipt No.",'');
              PurchLine.TESTFIELD("Return Shipment No.",'');
              PurchLine.TESTFIELD("Blanket Order No.",'');
              IF PurchLine."Drop Shipment" OR PurchLine."Special Order" THEN BEGIN
                CASE TRUE OF
                  PurchLine."Drop Shipment":
                    SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Sales Order No.");
                  PurchLine."Special Order":
                    SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Special Order Sales No.");
                END;
                TESTFIELD("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
                TESTFIELD("Ship-to Code",SalesHeader."Ship-to Code");
              END;

              PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
              TempPurchLine := PurchLine;
              IF PurchLine.Nonstock THEN BEGIN
                PurchLine.Nonstock := FALSE;
                PurchLine.MODIFY;
              END;
              TempPurchLine.INSERT;
            UNTIL PurchLine.NEXT = 0;

            TransferItemChargeAssgntPurchToTemp(ItemChargeAssgntPurch,TempItemChargeAssgntPurch);

            PurchLine.DELETEALL(TRUE);

            PurchLine.INIT;
            PurchLine."Line No." := 0;
            TempPurchLine.FINDSET;
            ExtendedTextAdded := FALSE;
            REPEAT
              IF TempPurchLine."Attached to Line No." = 0 THEN BEGIN
                PurchLine.INIT;
                PurchLine."Line No." := PurchLine."Line No." + 10000;
                PurchLine.VALIDATE(Type,TempPurchLine.Type);
                IF TempPurchLine."No." = '' THEN BEGIN
                  PurchLine.VALIDATE(Description,TempPurchLine.Description);
                  PurchLine.VALIDATE("Description 2",TempPurchLine."Description 2");
                END ELSE BEGIN
                  PurchLine.VALIDATE("No.",TempPurchLine."No.");
                  IF PurchLine.Type <> PurchLine.Type::" " THEN
                    CASE TRUE OF
                      TempPurchLine."Drop Shipment":
                        TransferSavedFieldsDropShipment(PurchLine,TempPurchLine);
                      TempPurchLine."Special Order":
                        TransferSavedFieldsSpecialOrder(PurchLine,TempPurchLine);
                      ELSE
                        TransferSavedFields(PurchLine,TempPurchLine);
                    END;
                END;

                PurchLine.INSERT;
                ExtendedTextAdded := FALSE;

                IF PurchLine.Type = PurchLine.Type::Item THEN
                  RecreatePurchLinesFillItemChargeAssignment(PurchLine,TempPurchLine,TempItemChargeAssgntPurch);

                IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN BEGIN
                  TempInteger.INIT;
                  TempInteger.Number := PurchLine."Line No.";
                  TempInteger.INSERT;
                END;
              END ELSE
                IF NOT ExtendedTextAdded THEN BEGIN
                  TransferExtendedText.PurchCheckIfAnyExtText(PurchLine,TRUE);
                  TransferExtendedText.InsertPurchExtText(PurchLine);
                  OnAfterTransferExtendedTextForPurchaseLineRecreation(PurchLine);
                  PurchLine.FINDLAST;
                  ExtendedTextAdded := TRUE;
                END;
            UNTIL TempPurchLine.NEXT = 0;

            RecreateItemChargeAssgntPurch(TempItemChargeAssgntPurch,TempPurchLine,TempInteger);

            TempPurchLine.SETRANGE(Type);
            TempPurchLine.DELETEALL;
          END;
        END ELSE
          ERROR(
            Text018,ChangedFieldName);
    end;

    local procedure RecreatePurchLinesFillItemChargeAssignment(PurchLine: Record "39";var TempPurchLine: Record "39" temporary;var TempItemChargeAssgntPurch: Record "5805" temporary)
    begin
        ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",TempPurchLine."Document Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",TempPurchLine."Document No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",TempPurchLine."Line No.");
        IF TempItemChargeAssgntPurch.FINDSET THEN
          REPEAT
            IF NOT TempItemChargeAssgntPurch.MARK THEN BEGIN
              TempItemChargeAssgntPurch."Applies-to Doc. Line No." := PurchLine."Line No.";
              TempItemChargeAssgntPurch.Description := PurchLine.Description;
              TempItemChargeAssgntPurch.MODIFY;
              TempItemChargeAssgntPurch.MARK(TRUE);
            END;
          UNTIL TempItemChargeAssgntPurch.NEXT = 0;
    end;

    local procedure RecreateItemChargeAssgntPurch(var TempItemChargeAssgntPurch: Record "5805" temporary;var TempPurchLine: Record "39" temporary;var TempInteger: Record "2000000026" temporary)
    var
        ItemChargeAssgntPurch: Record "5805";
    begin
        ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
        TempPurchLine.SETRANGE(Type,TempPurchLine.Type::"Charge (Item)");
        IF TempPurchLine.FINDSET THEN
          REPEAT
            TempItemChargeAssgntPurch.SETRANGE("Document Line No.",TempPurchLine."Line No.");
            IF TempItemChargeAssgntPurch.FINDSET THEN BEGIN
              REPEAT
                TempInteger.FINDFIRST;
                ItemChargeAssgntPurch.INIT;
                ItemChargeAssgntPurch := TempItemChargeAssgntPurch;
                ItemChargeAssgntPurch."Document Line No." := TempInteger.Number;
                ItemChargeAssgntPurch.VALIDATE("Unit Cost",0);
                ItemChargeAssgntPurch.INSERT;
              UNTIL TempItemChargeAssgntPurch.NEXT = 0;
              TempInteger.DELETE;
            END;
          UNTIL TempPurchLine.NEXT = 0;

        ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
        TempItemChargeAssgntPurch.DELETEALL;
    end;

    local procedure TransferSavedFields(var DestinationPurchaseLine: Record "39";var SourcePurchaseLine: Record "39")
    begin
        DestinationPurchaseLine.VALIDATE("Unit of Measure Code",SourcePurchaseLine."Unit of Measure Code");
        DestinationPurchaseLine.VALIDATE("Variant Code",SourcePurchaseLine."Variant Code");
        DestinationPurchaseLine."Prod. Order No." := SourcePurchaseLine."Prod. Order No.";
        IF DestinationPurchaseLine."Prod. Order No." <> '' THEN BEGIN
          DestinationPurchaseLine.Description := SourcePurchaseLine.Description;
          DestinationPurchaseLine.VALIDATE("VAT Prod. Posting Group",SourcePurchaseLine."VAT Prod. Posting Group");
          DestinationPurchaseLine.VALIDATE("Gen. Prod. Posting Group",SourcePurchaseLine."Gen. Prod. Posting Group");
          DestinationPurchaseLine.VALIDATE("Expected Receipt Date",SourcePurchaseLine."Expected Receipt Date");
          DestinationPurchaseLine.VALIDATE("Requested Receipt Date",SourcePurchaseLine."Requested Receipt Date");
          DestinationPurchaseLine.VALIDATE("Qty. per Unit of Measure",SourcePurchaseLine."Qty. per Unit of Measure");
        END;
        IF (SourcePurchaseLine."Job No." <> '') AND (SourcePurchaseLine."Job Task No." <> '') THEN BEGIN
          DestinationPurchaseLine.VALIDATE("Job No.",SourcePurchaseLine."Job No.");
          DestinationPurchaseLine.VALIDATE("Job Task No.",SourcePurchaseLine."Job Task No.");
          DestinationPurchaseLine."Job Line Type" := SourcePurchaseLine."Job Line Type";
        END;
        IF SourcePurchaseLine.Quantity <> 0 THEN
          DestinationPurchaseLine.VALIDATE(Quantity,SourcePurchaseLine.Quantity);
        IF ("Currency Code" = xRec."Currency Code") AND (PurchLine."Direct Unit Cost" = 0) THEN
          DestinationPurchaseLine.VALIDATE("Direct Unit Cost",SourcePurchaseLine."Direct Unit Cost");
        DestinationPurchaseLine."Routing No." := SourcePurchaseLine."Routing No.";
        DestinationPurchaseLine."Routing Reference No." := SourcePurchaseLine."Routing Reference No.";
        DestinationPurchaseLine."Operation No." := SourcePurchaseLine."Operation No.";
        DestinationPurchaseLine."Work Center No." := SourcePurchaseLine."Work Center No.";
        DestinationPurchaseLine."Prod. Order Line No." := SourcePurchaseLine."Prod. Order Line No.";
        DestinationPurchaseLine."Overhead Rate" := SourcePurchaseLine."Overhead Rate";
    end;

    local procedure TransferSavedFieldsDropShipment(var DestinationPurchaseLine: Record "39";var SourcePurchaseLine: Record "39")
    var
        SalesLine: Record "37";
        CopyDocMgt: Codeunit "6620";
    begin
        SalesLine.GET(SalesLine."Document Type"::Order,
          SourcePurchaseLine."Sales Order No.",
          SourcePurchaseLine."Sales Order Line No.");
        CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,DestinationPurchaseLine);
        DestinationPurchaseLine."Drop Shipment" := SourcePurchaseLine."Drop Shipment";
        DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
        DestinationPurchaseLine."Sales Order No." := SourcePurchaseLine."Sales Order No.";
        DestinationPurchaseLine."Sales Order Line No." := SourcePurchaseLine."Sales Order Line No.";
        EVALUATE(DestinationPurchaseLine."Inbound Whse. Handling Time",'<0D>');
        DestinationPurchaseLine.VALIDATE("Inbound Whse. Handling Time");
        SalesLine.VALIDATE("Unit Cost (LCY)",DestinationPurchaseLine."Unit Cost (LCY)");
        SalesLine."Purchase Order No." := DestinationPurchaseLine."Document No.";
        SalesLine."Purch. Order Line No." := DestinationPurchaseLine."Line No.";
        SalesLine.MODIFY;
    end;

    local procedure TransferSavedFieldsSpecialOrder(var DestinationPurchaseLine: Record "39";var SourcePurchaseLine: Record "39")
    var
        SalesLine: Record "37";
        CopyDocMgt: Codeunit "6620";
    begin
        SalesLine.GET(SalesLine."Document Type"::Order,
          SourcePurchaseLine."Special Order Sales No.",
          SourcePurchaseLine."Special Order Sales Line No.");
        CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,DestinationPurchaseLine);
        DestinationPurchaseLine."Special Order" := SourcePurchaseLine."Special Order";
        DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
        DestinationPurchaseLine."Special Order Sales No." := SourcePurchaseLine."Special Order Sales No.";
        DestinationPurchaseLine."Special Order Sales Line No." := SourcePurchaseLine."Special Order Sales Line No.";
        DestinationPurchaseLine.VALIDATE("Unit of Measure Code",SourcePurchaseLine."Unit of Measure Code");
        IF SourcePurchaseLine.Quantity <> 0 THEN
          DestinationPurchaseLine.VALIDATE(Quantity,SourcePurchaseLine.Quantity);

        SalesLine.VALIDATE("Unit Cost (LCY)",DestinationPurchaseLine."Unit Cost (LCY)");
        SalesLine."Special Order Purchase No." := DestinationPurchaseLine."Document No.";
        SalesLine."Special Order Purch. Line No." := DestinationPurchaseLine."Line No.";
        SalesLine.MODIFY;
    end;

    local procedure MessageIfPurchLinesExist(ChangedFieldName: Text[100])
    var
        MessageText: Text;
    begin
        IF PurchLinesExist AND NOT HideValidationDialog THEN BEGIN
          MessageText := STRSUBSTNO(LinesNotUpdatedMsg,ChangedFieldName);
          MessageText := STRSUBSTNO(SplitMessageTxt,MessageText,Text020);
          MESSAGE(MessageText);
        END;
    end;

    local procedure PriceMessageIfPurchLinesExist(ChangedFieldName: Text[100])
    var
        MessageText: Text;
    begin
        IF PurchLinesExist AND NOT HideValidationDialog THEN BEGIN
          MessageText := STRSUBSTNO(LinesNotUpdatedMsg,ChangedFieldName);
          IF "Currency Code" <> '' THEN
            MessageText := STRSUBSTNO(SplitMessageTxt,MessageText,AffectExchangeRateMsg);
          MESSAGE(MessageText);
        END;
    end;

    local procedure UpdateCurrencyFactor()
    begin
        IF "Currency Code" <> '' THEN BEGIN
          IF "Posting Date" <> 0D THEN
            CurrencyDate := "Posting Date"
          ELSE
            CurrencyDate := WORKDATE;

          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        END ELSE
          "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor(): Boolean
    begin
        IF HideValidationDialog THEN
          Confirmed := TRUE
        ELSE
          Confirmed := CONFIRM(Text022,FALSE);
        IF Confirmed THEN
          VALIDATE("Currency Factor")
        ELSE
          "Currency Factor" := xRec."Currency Factor";
        EXIT(Confirmed);
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure UpdatePurchLines(ChangedFieldName: Text[100];AskQuestion: Boolean)
    var
        PurchLineReserve: Codeunit "99000834";
        Question: Text[250];
    begin
        IF NOT PurchLinesExist THEN
          EXIT;

        IF AskQuestion THEN BEGIN
          Question := STRSUBSTNO(
              Text032 +
              Text033,ChangedFieldName);
          IF GUIALLOWED THEN
            IF DIALOG.CONFIRM(Question,TRUE) THEN
              CASE ChangedFieldName OF
                FIELDCAPTION("Expected Receipt Date"),
                FIELDCAPTION("Requested Receipt Date"),
                FIELDCAPTION("Promised Receipt Date"),
                FIELDCAPTION("Lead Time Calculation"),
                FIELDCAPTION("Inbound Whse. Handling Time"):
                  ConfirmResvDateConflict;
              END
            ELSE
              EXIT;
        END;

        PurchLine.LOCKTABLE;
        MODIFY;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        IF PurchLine.FINDSET THEN
          REPEAT
            xPurchLine := PurchLine;
            CASE ChangedFieldName OF
              FIELDCAPTION("Expected Receipt Date"):
                IF PurchLine."No." <> '' THEN
                  PurchLine.VALIDATE("Expected Receipt Date","Expected Receipt Date");
              FIELDCAPTION("Currency Factor"):
                IF PurchLine.Type <> PurchLine.Type::" " THEN
                  PurchLine.VALIDATE("Direct Unit Cost");
              FIELDCAPTION("Transaction Type"):
                PurchLine.VALIDATE("Transaction Type","Transaction Type");
              FIELDCAPTION("Transport Method"):
                PurchLine.VALIDATE("Transport Method","Transport Method");
              FIELDCAPTION("Entry Point"):
                PurchLine.VALIDATE("Entry Point","Entry Point");
              FIELDCAPTION(Area):
                PurchLine.VALIDATE(Area,Area);
              FIELDCAPTION("Transaction Specification"):
                PurchLine.VALIDATE("Transaction Specification","Transaction Specification");
              FIELDCAPTION("Requested Receipt Date"):
                IF PurchLine."No." <> '' THEN
                  PurchLine.VALIDATE("Requested Receipt Date","Requested Receipt Date");
              FIELDCAPTION("Prepayment %"):
                IF PurchLine."No." <> '' THEN
                  PurchLine.VALIDATE("Prepayment %","Prepayment %");
              FIELDCAPTION("Promised Receipt Date"):
                IF PurchLine."No." <> '' THEN
                  PurchLine.VALIDATE("Promised Receipt Date","Promised Receipt Date");
              FIELDCAPTION("Lead Time Calculation"):
                IF PurchLine."No." <> '' THEN
                  PurchLine.VALIDATE("Lead Time Calculation","Lead Time Calculation");
              FIELDCAPTION("Inbound Whse. Handling Time"):
                IF PurchLine."No." <> '' THEN
                  PurchLine.VALIDATE("Inbound Whse. Handling Time","Inbound Whse. Handling Time");
              PurchLine.FIELDCAPTION("Deferral Code"):
                IF PurchLine."No." <> '' THEN
                  PurchLine.VALIDATE("Deferral Code");
              ELSE
                OnUpdatePurchLinesByChangedFieldName(Rec,PurchLine,ChangedFieldName);
            END;
            PurchLine.MODIFY(TRUE);
            PurchLineReserve.VerifyChange(PurchLine,xPurchLine);
          UNTIL PurchLine.NEXT = 0;
    end;

    local procedure ConfirmResvDateConflict()
    var
        ResvEngMgt: Codeunit "99000831";
    begin
        IF ResvEngMgt.ResvExistsForPurchHeader(Rec) THEN
          IF NOT CONFIRM(Text050,FALSE) THEN
            ERROR('');
    end;

    procedure CreateDim(Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20])
    var
        SourceCodeSetup: Record "242";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

        IF (OldDimSetID <> "Dimension Set ID") AND PurchLinesExist THEN BEGIN
          MODIFY;
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        IF "No." <> '' THEN
          MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF PurchLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    local procedure ReceivedPurchLinesExist(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER("Quantity Received",'<>0');
        EXIT(PurchLine.FINDFIRST);
    end;

    local procedure ReturnShipmentExist(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER("Return Qty. Shipped",'<>0');
        EXIT(PurchLine.FINDFIRST);
    end;

    procedure UpdateShipToAddress()
    begin
        IF IsCreditDocType THEN
          EXIT;

        IF ("Location Code" <> '') AND Location.GET("Location Code") AND ("Sell-to Customer No." = '') THEN BEGIN
          SetShipToAddress(
            Location.Name,Location."Name 2",Location.Address,Location."Address 2",
            Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
          "Ship-to Contact" := Location.Contact;
        END;

        IF ("Location Code" = '') AND ("Sell-to Customer No." = '') THEN BEGIN
          CompanyInfo.GET;
          "Ship-to Code" := '';
          SetShipToAddress(
            CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
            CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
            CompanyInfo."Ship-to Country/Region Code");
          "Ship-to Contact" := CompanyInfo."Ship-to Contact";
        END;

        OnAfterUpdateShipToAddress(Rec);
    end;

    local procedure DeletePurchaseLines()
    var
        ReservMgt: Codeunit "99000845";
    begin
        IF PurchLine.FINDSET THEN BEGIN
          ReservMgt.DeleteDocumentReservation(DATABASE::"Purchase Line","Document Type","No.",HideValidationDialog);
          REPEAT
            PurchLine.SuspendStatusCheck(TRUE);
            PurchLine.DELETE(TRUE);
          UNTIL PurchLine.NEXT = 0;
        END;
    end;

    local procedure ClearItemAssgntPurchFilter(var TempItemChargeAssgntPurch: Record "5805" temporary)
    begin
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
    end;

    local procedure CheckReceiptInfo(var PurchLine: Record "39";PayTo: Boolean)
    begin
        IF "Document Type" = "Document Type"::Order THEN
          PurchLine.SETFILTER("Quantity Received",'<>0')
        ELSE
          IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            IF NOT PayTo THEN
              PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
            PurchLine.SETFILTER("Receipt No.",'<>%1','');
          END;

        IF PurchLine.FINDFIRST THEN
          IF "Document Type" = "Document Type"::Order THEN
            PurchLine.TESTFIELD("Quantity Received",0)
          ELSE
            PurchLine.TESTFIELD("Receipt No.",'');
        PurchLine.SETRANGE("Receipt No.");
        PurchLine.SETRANGE("Quantity Received");
        IF NOT PayTo THEN
          PurchLine.SETRANGE("Buy-from Vendor No.");
    end;

    local procedure CheckPrepmtInfo(var PurchLine: Record "39")
    begin
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          PurchLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
          IF PurchLine.FIND('-') THEN
            PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
          PurchLine.SETRANGE("Prepmt. Amt. Inv.");
        END;
    end;

    local procedure CheckReturnInfo(var PurchLine: Record "39";PayTo: Boolean)
    begin
        IF "Document Type" = "Document Type"::"Return Order" THEN
          PurchLine.SETFILTER("Return Qty. Shipped",'<>0')
        ELSE
          IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
            IF NOT PayTo THEN
              PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
            PurchLine.SETFILTER("Return Shipment No.",'<>%1','');
          END;

        IF PurchLine.FINDFIRST THEN
          IF "Document Type" = "Document Type"::"Return Order" THEN
            PurchLine.TESTFIELD("Return Qty. Shipped",0)
          ELSE
            PurchLine.TESTFIELD("Return Shipment No.",'');
    end;

    local procedure UpdateBuyFromCont(VendorNo: Code[20])
    var
        ContBusRel: Record "5054";
        Vend: Record "23";
        OfficeContact: Record "5050";
        OfficeMgt: Codeunit "1630";
    begin
        IF OfficeMgt.GetContact(OfficeContact,VendorNo) THEN BEGIN
          SetHideValidationDialog(TRUE);
          UpdateBuyFromVend(OfficeContact."No.");
          SetHideValidationDialog(FALSE);
        END ELSE
          IF Vend.GET(VendorNo) THEN BEGIN
            IF Vend."Primary Contact No." <> '' THEN
              "Buy-from Contact No." := Vend."Primary Contact No."
            ELSE
              "Buy-from Contact No." := ContBusRel.GetContactNo(ContBusRel."Link to Table"::Vendor,"Buy-from Vendor No.");
            "Buy-from Contact" := Vend.Contact;
          END;

        IF "Buy-from Contact No." <> '' THEN
          IF OfficeContact.GET("Buy-from Contact No.") THEN
            OfficeContact.CheckIfPrivacyBlockedGeneric;
    end;

    local procedure UpdatePayToCont(VendorNo: Code[20])
    var
        ContBusRel: Record "5054";
        Vend: Record "23";
        Contact: Record "5050";
    begin
        IF Vend.GET(VendorNo) THEN BEGIN
          IF Vend."Primary Contact No." <> '' THEN
            "Pay-to Contact No." := Vend."Primary Contact No."
          ELSE
            "Pay-to Contact No." := ContBusRel.GetContactNo(ContBusRel."Link to Table"::Vendor,"Pay-to Vendor No.");
          "Pay-to Contact" := Vend.Contact;
        END;

        IF "Pay-to Contact No." <> '' THEN
          IF Contact.GET("Pay-to Contact No.") THEN
            Contact.CheckIfPrivacyBlockedGeneric;
    end;

    local procedure UpdateBuyFromVend(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Vend: Record "23";
        Cont: Record "5050";
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
          "Buy-from Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Person THEN
            "Buy-from Contact" := Cont.Name
          ELSE
            IF Vend.GET("Buy-from Vendor No.") THEN
              "Buy-from Contact" := Vend.Contact
            ELSE
              "Buy-from Contact" := ''
        END ELSE BEGIN
          "Buy-from Contact" := '';
          EXIT;
        END;

        IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Vendor,Cont."Company No.") THEN BEGIN
          IF ("Buy-from Vendor No." <> '') AND
             ("Buy-from Vendor No." <> ContBusinessRelation."No.")
          THEN
            ERROR(Text037,Cont."No.",Cont.Name,"Buy-from Vendor No.");
          IF "Buy-from Vendor No." = '' THEN BEGIN
            SkipBuyFromContact := TRUE;
            VALIDATE("Buy-from Vendor No.",ContBusinessRelation."No.");
            SkipBuyFromContact := FALSE;
          END;
        END ELSE
          ERROR(Text039,Cont."No.",Cont.Name);

        IF ("Buy-from Vendor No." = "Pay-to Vendor No.") OR
           ("Pay-to Vendor No." = '')
        THEN
          VALIDATE("Pay-to Contact No.","Buy-from Contact No.");
    end;

    local procedure UpdatePayToVend(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Vend: Record "23";
        Cont: Record "5050";
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
          "Pay-to Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Person THEN
            "Pay-to Contact" := Cont.Name
          ELSE
            IF Vend.GET("Pay-to Vendor No.") THEN
              "Pay-to Contact" := Vend.Contact
            ELSE
              "Pay-to Contact" := '';
        END ELSE BEGIN
          "Pay-to Contact" := '';
          EXIT;
        END;

        IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Vendor,Cont."Company No.") THEN BEGIN
          IF "Pay-to Vendor No." = '' THEN BEGIN
            SkipPayToContact := TRUE;
            VALIDATE("Pay-to Vendor No.",ContBusinessRelation."No.");
            SkipPayToContact := FALSE;
          END ELSE
            IF "Pay-to Vendor No." <> ContBusinessRelation."No." THEN
              ERROR(Text037,Cont."No.",Cont.Name,"Pay-to Vendor No.");
        END ELSE
          ERROR(Text039,Cont."No.",Cont.Name);
    end;

    procedure CreateInvtPutAwayPick()
    var
        WhseRequest: Record "5765";
    begin
        TESTFIELD(Status,Status::Released);

        WhseRequest.RESET;
        WhseRequest.SETCURRENTKEY("Source Document","Source No.");
        CASE "Document Type" OF
          "Document Type"::Order:
            WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Order");
          "Document Type"::"Return Order":
            WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Return Order");
        END;
        WhseRequest.SETRANGE("Source No.","No.");
        REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF PurchLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer;OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
        ReceivedShippedItemLineDimChangeConfirmed: Boolean;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
          EXIT;
        IF NOT CONFIRM(Text051) THEN
          EXIT;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.LOCKTABLE;
        IF PurchLine.FIND('-') THEN
          REPEAT
            NewDimSetID := DimMgt.GetDeltaDimSetID(PurchLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
            IF PurchLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
              PurchLine."Dimension Set ID" := NewDimSetID;

              IF NOT HideValidationDialog AND GUIALLOWED THEN
                VerifyReceivedShippedItemLineDimChange(ReceivedShippedItemLineDimChangeConfirmed);

              DimMgt.UpdateGlobalDimFromDimSetID(
                PurchLine."Dimension Set ID",PurchLine."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 2 Code");
              PurchLine.MODIFY;
            END;
          UNTIL PurchLine.NEXT = 0;
    end;

    local procedure VerifyReceivedShippedItemLineDimChange(var ReceivedShippedItemLineDimChangeConfirmed: Boolean)
    begin
        IF PurchLine.IsReceivedShippedItemDimChanged THEN
          IF NOT ReceivedShippedItemLineDimChangeConfirmed THEN
            ReceivedShippedItemLineDimChangeConfirmed := PurchLine.ConfirmReceivedShippedItemDimChange;
    end;

    procedure SetAmountToApply(AppliesToDocNo: Code[20];VendorNo: Code[20])
    var
        VendLedgEntry: Record "25";
    begin
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.",AppliesToDocNo);
        VendLedgEntry.SETRANGE("Vendor No.",VendorNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
          IF VendLedgEntry."Amount to Apply" = 0 THEN  BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
          END ELSE
            VendLedgEntry."Amount to Apply" := 0;
          VendLedgEntry."Accepted Payment Tolerance" := 0;
          VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
        END;
    end;

    procedure SetShipToForSpecOrder()
    begin
        IF Location.GET("Location Code") THEN BEGIN
          "Ship-to Code" := '';
          SetShipToAddress(
            Location.Name,Location."Name 2",Location.Address,Location."Address 2",
            Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
          "Ship-to Contact" := Location.Contact;
          "Location Code" := Location.Code;
        END ELSE BEGIN
          CompanyInfo.GET;
          "Ship-to Code" := '';
          SetShipToAddress(
            CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
            CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
            CompanyInfo."Ship-to Country/Region Code");
          "Ship-to Contact" := CompanyInfo."Ship-to Contact";
          "Location Code" := '';
        END;
    end;

    local procedure JobUpdatePurchLines(SkipJobCurrFactorUpdate: Boolean)
    begin
        WITH PurchLine DO BEGIN
          SETFILTER("Job No.",'<>%1','');
          SETFILTER("Job Task No.",'<>%1','');
          LOCKTABLE;
          IF FINDSET(TRUE,FALSE) THEN BEGIN
            SetPurchHeader(Rec);
            REPEAT
              IF NOT SkipJobCurrFactorUpdate THEN
                JobSetCurrencyFactor;
              CreateTempJobJnlLine(FALSE);
              UpdateJobPrices;
              MODIFY;
            UNTIL NEXT = 0;
          END;
        END
    end;

    [Scope('Internal')]
    procedure GetPstdDocLinesToRevere()
    var
        PurchPostedDocLines: Page "5855";
    begin
        GetVend("Buy-from Vendor No.");
        PurchPostedDocLines.SetToPurchHeader(Rec);
        PurchPostedDocLines.SETRECORD(Vend);
        PurchPostedDocLines.LOOKUPMODE := TRUE;
        IF PurchPostedDocLines.RUNMODAL = ACTION::LookupOK THEN
          PurchPostedDocLines.CopyLineToDoc;

        CLEAR(PurchPostedDocLines);
    end;

    procedure SetSecurityFilterOnRespCenter()
    begin
        IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;

        SETRANGE("Date Filter",0D,WORKDATE);
    end;

    procedure CalcInvDiscForHeader()
    var
        PurchaseInvDisc: Codeunit "70";
    begin
        PurchSetup.GET;
        IF PurchSetup."Calc. Inv. Discount" THEN
          PurchaseInvDisc.CalculateIncDiscForHeader(Rec);
    end;

    procedure AddShipToAddress(SalesHeader: Record "36";ShowError: Boolean)
    var
        PurchLine2: Record "39";
    begin
        IF ShowError THEN BEGIN
          PurchLine2.RESET;
          PurchLine2.SETRANGE("Document Type","Document Type"::Order);
          PurchLine2.SETRANGE("Document No.","No.");
          IF NOT PurchLine2.ISEMPTY THEN BEGIN
            IF "Ship-to Name" <> SalesHeader."Ship-to Name" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
            IF "Ship-to Name 2" <> SalesHeader."Ship-to Name 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
            IF "Ship-to Address" <> SalesHeader."Ship-to Address" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
            IF "Ship-to Address 2" <> SalesHeader."Ship-to Address 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
            IF "Ship-to Post Code" <> SalesHeader."Ship-to Post Code" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
            IF "Ship-to City" <> SalesHeader."Ship-to City" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
            IF "Ship-to Contact" <> SalesHeader."Ship-to Contact" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
          END ELSE BEGIN
            // no purchase line exists
            "Ship-to Name" := SalesHeader."Ship-to Name";
            "Ship-to Name 2" := SalesHeader."Ship-to Name 2";
            "Ship-to Address" := SalesHeader."Ship-to Address";
            "Ship-to Address 2" := SalesHeader."Ship-to Address 2";
            "Ship-to Post Code" := SalesHeader."Ship-to Post Code";
            "Ship-to City" := SalesHeader."Ship-to City";
            "Ship-to Contact" := SalesHeader."Ship-to Contact";
          END;
        END;
    end;

    procedure DropShptOrderExists(SalesHeader: Record "36"): Boolean
    var
        SalesLine2: Record "37";
    begin
        // returns TRUE if sales is either Drop Shipment of Special Order
        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type",SalesLine2."Document Type"::Order);
        SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
        SalesLine2.SETRANGE("Drop Shipment",TRUE);
        EXIT(NOT SalesLine2.ISEMPTY);
    end;

    procedure SpecialOrderExists(SalesHeader: Record "36"): Boolean
    var
        SalesLine3: Record "37";
    begin
        SalesLine3.RESET;
        SalesLine3.SETRANGE("Document Type",SalesLine3."Document Type"::Order);
        SalesLine3.SETRANGE("Document No.",SalesHeader."No.");
        SalesLine3.SETRANGE("Special Order",TRUE);
        EXIT(NOT SalesLine3.ISEMPTY);
    end;

    local procedure CheckDropShipmentLineExists()
    var
        SalesShipmentLine: Record "111";
    begin
        SalesShipmentLine.SETRANGE("Purchase Order No.","No.");
        SalesShipmentLine.SETRANGE("Drop Shipment",TRUE);
        IF NOT SalesShipmentLine.ISEMPTY THEN
          ERROR(YouCannotChangeFieldErr,FIELDCAPTION("Buy-from Vendor No."));
    end;

    procedure QtyToReceiveIsZero(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER("Qty. to Receive",'<>0');
        EXIT(PurchLine.ISEMPTY);
    end;

    local procedure IsApprovedForPosting(): Boolean
    var
        PrepaymentMgt: Codeunit "441";
    begin
        IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN BEGIN
          IF PrepaymentMgt.TestPurchasePrepayment(Rec) THEN
            ERROR(STRSUBSTNO(PrepaymentInvoicesNotPaidErr,"Document Type","No."));
          IF PrepaymentMgt.TestPurchasePayment(Rec) THEN
            IF NOT CONFIRM(STRSUBSTNO(Text054,"Document Type","No."),TRUE) THEN
              EXIT(FALSE);
          EXIT(TRUE);
        END;
    end;

    procedure IsApprovedForPostingBatch(): Boolean
    var
        PrepaymentMgt: Codeunit "441";
    begin
        IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN BEGIN
          IF PrepaymentMgt.TestPurchasePrepayment(Rec) THEN
            EXIT(FALSE);
          IF PrepaymentMgt.TestPurchasePayment(Rec) THEN
            EXIT(FALSE);
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure IsTotalValid(): Boolean
    var
        IncomingDocument: Record "130";
        PurchaseLine: Record "39";
        TempTotalPurchaseLine: Record "39" temporary;
        GeneralLedgerSetup: Record "98";
        DocumentTotals: Codeunit "57";
        VATAmount: Decimal;
    begin
        IF NOT IncomingDocument.GET("Incoming Document Entry No.") THEN
          EXIT(TRUE);

        IF IncomingDocument."Amount Incl. VAT" = 0 THEN
          EXIT(TRUE);

        PurchaseLine.SETRANGE("Document Type","Document Type");
        PurchaseLine.SETRANGE("Document No.","No.");
        IF NOT PurchaseLine.FINDFIRST THEN
          EXIT(TRUE);

        GeneralLedgerSetup.GET;
        IF (IncomingDocument."Currency Code" <> PurchaseLine."Currency Code") AND
           (IncomingDocument."Currency Code" <> GeneralLedgerSetup."LCY Code")
        THEN
          EXIT(TRUE);

        TempTotalPurchaseLine.INIT;
        DocumentTotals.PurchaseCalculateTotalsWithInvoiceRounding(PurchaseLine,VATAmount,TempTotalPurchaseLine);

        EXIT(IncomingDocument."Amount Incl. VAT" = TempTotalPurchaseLine."Amount Including VAT");
    end;

    procedure SendToPosting(PostingCodeunitID: Integer)
    begin
        IF NOT IsApprovedForPosting THEN
          EXIT;
        CODEUNIT.RUN(PostingCodeunitID,Rec);
    end;

    procedure CancelBackgroundPosting()
    var
        PurchasePostViaJobQueue: Codeunit "98";
    begin
        PurchasePostViaJobQueue.CancelQueueEntry(Rec);
    end;

    procedure AddSpecialOrderToAddress(SalesHeader: Record "36";ShowError: Boolean)
    var
        PurchaseHeader: Record "38";
    begin
        IF ShowError THEN
          IF PurchLinesExist THEN BEGIN
            PurchaseHeader := Rec;
            PurchaseHeader.SetShipToForSpecOrder;
            IF "Ship-to Name" <> PurchaseHeader."Ship-to Name" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
            IF "Ship-to Name 2" <> PurchaseHeader."Ship-to Name 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
            IF "Ship-to Address" <> PurchaseHeader."Ship-to Address" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
            IF "Ship-to Address 2" <> PurchaseHeader."Ship-to Address 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
            IF "Ship-to Post Code" <> PurchaseHeader."Ship-to Post Code" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
            IF "Ship-to City" <> PurchaseHeader."Ship-to City" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
            IF "Ship-to Contact" <> PurchaseHeader."Ship-to Contact" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
          END ELSE
            SetShipToForSpecOrder;
    end;

    procedure InvoicedLineExists(): Boolean
    var
        PurchLine: Record "39";
    begin
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
        PurchLine.SETFILTER("Quantity Invoiced",'<>%1',0);
        EXIT(NOT PurchLine.ISEMPTY);
    end;

    procedure CreateDimSetForPrepmtAccDefaultDim()
    var
        PurchaseLine: Record "39";
        TempPurchaseLine: Record "39" temporary;
    begin
        PurchaseLine.SETRANGE("Document Type","Document Type");
        PurchaseLine.SETRANGE("Document No.","No.");
        PurchaseLine.SETFILTER("Prepmt. Amt. Inv.",'<>%1',0);
        IF PurchaseLine.FINDSET THEN
          REPEAT
            CollectParamsInBufferForCreateDimSet(TempPurchaseLine,PurchaseLine);
          UNTIL PurchaseLine.NEXT = 0;
        TempPurchaseLine.RESET;
        TempPurchaseLine.MARKEDONLY(FALSE);
        IF TempPurchaseLine.FINDSET THEN
          REPEAT
            PurchaseLine.CreateDim(DATABASE::"G/L Account",TempPurchaseLine."No.",
              DATABASE::Job,TempPurchaseLine."Job No.",
              DATABASE::"Responsibility Center",TempPurchaseLine."Responsibility Center",
              DATABASE::"Work Center",TempPurchaseLine."Work Center No.");
          UNTIL TempPurchaseLine.NEXT = 0;
    end;

    local procedure CollectParamsInBufferForCreateDimSet(var TempPurchaseLine: Record "39" temporary;PurchaseLine: Record "39")
    var
        GenPostingSetup: Record "252";
        DefaultDimension: Record "352";
    begin
        TempPurchaseLine.SETRANGE("Gen. Bus. Posting Group",PurchaseLine."Gen. Bus. Posting Group");
        TempPurchaseLine.SETRANGE("Gen. Prod. Posting Group",PurchaseLine."Gen. Prod. Posting Group");
        IF NOT TempPurchaseLine.FINDFIRST THEN BEGIN
          GenPostingSetup.GET(PurchaseLine."Gen. Bus. Posting Group",PurchaseLine."Gen. Prod. Posting Group");
          GenPostingSetup.TESTFIELD("Purch. Prepayments Account");
          DefaultDimension.SETRANGE("Table ID",DATABASE::"G/L Account");
          DefaultDimension.SETRANGE("No.",GenPostingSetup."Purch. Prepayments Account");
          InsertTempPurchaseLineInBuffer(TempPurchaseLine,PurchaseLine,
            GenPostingSetup."Purch. Prepayments Account",DefaultDimension.ISEMPTY);
        END ELSE
          IF NOT TempPurchaseLine.MARK THEN BEGIN
            TempPurchaseLine.SETRANGE("Job No.",PurchaseLine."Job No.");
            TempPurchaseLine.SETRANGE("Responsibility Center",PurchaseLine."Responsibility Center");
            TempPurchaseLine.SETRANGE("Work Center No.",PurchaseLine."Work Center No.");
            IF TempPurchaseLine.ISEMPTY THEN
              InsertTempPurchaseLineInBuffer(TempPurchaseLine,PurchaseLine,TempPurchaseLine."No.",FALSE)
          END;
    end;

    local procedure InsertTempPurchaseLineInBuffer(var TempPurchaseLine: Record "39" temporary;PurchaseLine: Record "39";AccountNo: Code[20];DefaultDimenstionsNotExist: Boolean)
    begin
        TempPurchaseLine.INIT;
        TempPurchaseLine."Line No." := PurchaseLine."Line No.";
        TempPurchaseLine."No." := AccountNo;
        TempPurchaseLine."Job No." := PurchaseLine."Job No.";
        TempPurchaseLine."Responsibility Center" := PurchaseLine."Responsibility Center";
        TempPurchaseLine."Work Center No." := PurchaseLine."Work Center No.";
        TempPurchaseLine."Gen. Bus. Posting Group" := PurchaseLine."Gen. Bus. Posting Group";
        TempPurchaseLine."Gen. Prod. Posting Group" := PurchaseLine."Gen. Prod. Posting Group";
        TempPurchaseLine.MARK := DefaultDimenstionsNotExist;
        TempPurchaseLine.INSERT;
    end;

    local procedure TransferItemChargeAssgntPurchToTemp(var ItemChargeAssgntPurch: Record "5805";var TempItemChargeAssgntPurch: Record "5805" temporary)
    begin
        ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
        IF ItemChargeAssgntPurch.FINDSET THEN BEGIN
          REPEAT
            TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
            TempItemChargeAssgntPurch.INSERT;
          UNTIL ItemChargeAssgntPurch.NEXT = 0;
          ItemChargeAssgntPurch.DELETEALL;
        END;
    end;

    [Scope('Internal')]
    procedure OpenPurchaseOrderStatistics()
    begin
        CalcInvDiscForHeader;
        CreateDimSetForPrepmtAccDefaultDim;
        COMMIT;
        PAGE.RUNMODAL(PAGE::"Purchase Order Statistics",Rec);
    end;

    procedure GetCardpageID(): Integer
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(PAGE::"Purchase Quote");
          "Document Type"::Order:
            EXIT(PAGE::"Purchase Order");
          "Document Type"::Invoice:
            EXIT(PAGE::"Purchase Invoice");
          "Document Type"::"Credit Memo":
            EXIT(PAGE::"Purchase Credit Memo");
          "Document Type"::"Blanket Order":
            EXIT(PAGE::"Blanket Purchase Order");
          "Document Type"::"Return Order":
            EXIT(PAGE::"Purchase Return Order");
        END;
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnCheckPurchasePostRestrictions()
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnCheckPurchaseReleaseRestrictions()
    begin
    end;

    procedure CheckPurchaseReleaseRestrictions()
    var
        ApprovalsMgmt: Codeunit "1535";
    begin
        OnCheckPurchaseReleaseRestrictions;
        ApprovalsMgmt.PrePostApprovalCheckPurch(Rec);
    end;

    procedure SetStatus(NewStatus: Option)
    begin
        Status := NewStatus;
        MODIFY;
    end;

    procedure TriggerOnAfterPostPurchaseDoc(var GenJnlPostLine: Codeunit "12";PurchRcpHdrNo: Code[20];RetShptHdrNo: Code[20];PurchInvHdrNo: Code[20];PurchCrMemoHdrNo: Code[20])
    var
        PurchPost: Codeunit "90";
    begin
        PurchPost.OnAfterPostPurchaseDoc(Rec,GenJnlPostLine,PurchRcpHdrNo,RetShptHdrNo,PurchInvHdrNo,PurchCrMemoHdrNo);
    end;

    procedure DeferralHeadersExist(): Boolean
    var
        DeferralHeader: Record "1701";
        DeferralUtilities: Codeunit "1720";
    begin
        DeferralHeader.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
        DeferralHeader.SETRANGE("Gen. Jnl. Template Name",'');
        DeferralHeader.SETRANGE("Gen. Jnl. Batch Name",'');
        DeferralHeader.SETRANGE("Document Type","Document Type");
        DeferralHeader.SETRANGE("Document No.","No.");
        EXIT(NOT DeferralHeader.ISEMPTY);
    end;

    local procedure ConfirmUpdateDeferralDate()
    begin
        IF HideValidationDialog THEN
          Confirmed := TRUE
        ELSE
          Confirmed := CONFIRM(DeferralLineQst,FALSE,FIELDCAPTION("Posting Date"));
        IF Confirmed THEN
          UpdatePurchLines(PurchLine.FIELDCAPTION("Deferral Code"),FALSE);
    end;

    procedure IsCreditDocType(): Boolean
    begin
        EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
    end;

    procedure SetBuyFromVendorFromFilter()
    var
        BuyFromVendorNo: Code[20];
    begin
        BuyFromVendorNo := GetFilterVendNo;
        IF BuyFromVendorNo = '' THEN BEGIN
          FILTERGROUP(2);
          BuyFromVendorNo := GetFilterVendNo;
          FILTERGROUP(0);
        END;
        IF BuyFromVendorNo <> '' THEN
          VALIDATE("Buy-from Vendor No.",BuyFromVendorNo);
    end;

    procedure CopyBuyFromVendorFilter()
    var
        BuyFromVendorFilter: Text;
    begin
        BuyFromVendorFilter := GETFILTER("Buy-from Vendor No.");
        IF BuyFromVendorFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETFILTER("Buy-from Vendor No.",BuyFromVendorFilter);
          FILTERGROUP(0)
        END;
    end;

    local procedure GetFilterVendNo(): Code[20]
    begin
        IF GETFILTER("Buy-from Vendor No.") <> '' THEN
          IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
            EXIT(GETRANGEMAX("Buy-from Vendor No."));
    end;

    procedure HasBuyFromAddress(): Boolean
    begin
        CASE TRUE OF
          "Buy-from Address" <> '':
            EXIT(TRUE);
          "Buy-from Address 2" <> '':
            EXIT(TRUE);
          "Buy-from City" <> '':
            EXIT(TRUE);
          "Buy-from Country/Region Code" <> '':
            EXIT(TRUE);
          "Buy-from County" <> '':
            EXIT(TRUE);
          "Buy-from Post Code" <> '':
            EXIT(TRUE);
          "Buy-from Contact" <> '':
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    procedure HasShipToAddress(): Boolean
    begin
        CASE TRUE OF
          "Ship-to Address" <> '':
            EXIT(TRUE);
          "Ship-to Address 2" <> '':
            EXIT(TRUE);
          "Ship-to City" <> '':
            EXIT(TRUE);
          "Ship-to Country/Region Code" <> '':
            EXIT(TRUE);
          "Ship-to County" <> '':
            EXIT(TRUE);
          "Ship-to Post Code" <> '':
            EXIT(TRUE);
          "Ship-to Contact" <> '':
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    procedure HasPayToAddress(): Boolean
    begin
        CASE TRUE OF
          "Pay-to Address" <> '':
            EXIT(TRUE);
          "Pay-to Address 2" <> '':
            EXIT(TRUE);
          "Pay-to City" <> '':
            EXIT(TRUE);
          "Pay-to Country/Region Code" <> '':
            EXIT(TRUE);
          "Pay-to County" <> '':
            EXIT(TRUE);
          "Pay-to Post Code" <> '':
            EXIT(TRUE);
          "Pay-to Contact" <> '':
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    local procedure HasItemChargeAssignment(): Boolean
    var
        ItemChargeAssgntPurch: Record "5805";
    begin
        ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
        ItemChargeAssgntPurch.SETFILTER("Amount to Assign",'<>%1',0);
        EXIT(NOT ItemChargeAssgntPurch.ISEMPTY);
    end;

    local procedure CopyBuyFromVendorAddressFieldsFromVendor(var BuyFromVendor: Record "23";ForceCopy: Boolean)
    begin
        IF BuyFromVendorIsReplaced OR ShouldCopyAddressFromBuyFromVendor(BuyFromVendor) OR ForceCopy THEN BEGIN
          "Buy-from Address" := BuyFromVendor.Address;
          "Buy-from Address 2" := BuyFromVendor."Address 2";
          "Buy-from City" := BuyFromVendor.City;
          "Buy-from Post Code" := BuyFromVendor."Post Code";
          "Buy-from County" := BuyFromVendor.County;
          "Buy-from Country/Region Code" := BuyFromVendor."Country/Region Code";
        END;
    end;

    local procedure CopyShipToVendorAddressFieldsFromVendor(var BuyFromVendor: Record "23";ForceCopy: Boolean)
    begin
        IF BuyFromVendorIsReplaced OR (NOT HasShipToAddress) OR ForceCopy THEN BEGIN
          "Ship-to Address" := BuyFromVendor.Address;
          "Ship-to Address 2" := BuyFromVendor."Address 2";
          "Ship-to City" := BuyFromVendor.City;
          "Ship-to Post Code" := BuyFromVendor."Post Code";
          "Ship-to County" := BuyFromVendor.County;
          VALIDATE("Ship-to Country/Region Code",BuyFromVendor."Country/Region Code");
        END;
    end;

    local procedure CopyPayToVendorAddressFieldsFromVendor(var PayToVendor: Record "23";ForceCopy: Boolean)
    begin
        IF PayToVendorIsReplaced OR ShouldCopyAddressFromPayToVendor(PayToVendor) OR ForceCopy THEN BEGIN
          "Pay-to Address" := PayToVendor.Address;
          "Pay-to Address 2" := PayToVendor."Address 2";
          "Pay-to City" := PayToVendor.City;
          "Pay-to Post Code" := PayToVendor."Post Code";
          "Pay-to County" := PayToVendor.County;
          "Pay-to Country/Region Code" := PayToVendor."Country/Region Code";
        END;
    end;

    procedure SetShipToAddress(ShipToName: Text[50];ShipToName2: Text[50];ShipToAddress: Text[50];ShipToAddress2: Text[50];ShipToCity: Text[30];ShipToPostCode: Code[20];ShipToCounty: Text[30];ShipToCountryRegionCode: Code[10])
    begin
        "Ship-to Name" := ShipToName;
        "Ship-to Name 2" := ShipToName2;
        "Ship-to Address" := ShipToAddress;
        "Ship-to Address 2" := ShipToAddress2;
        "Ship-to City" := ShipToCity;
        "Ship-to Post Code" := ShipToPostCode;
        "Ship-to County" := ShipToCounty;
        "Ship-to Country/Region Code" := ShipToCountryRegionCode;
    end;

    local procedure ShouldCopyAddressFromBuyFromVendor(BuyFromVendor: Record "23"): Boolean
    begin
        EXIT((NOT HasBuyFromAddress) AND BuyFromVendor.HasAddress);
    end;

    local procedure ShouldCopyAddressFromPayToVendor(PayToVendor: Record "23"): Boolean
    begin
        EXIT((NOT HasPayToAddress) AND PayToVendor.HasAddress);
    end;

    local procedure ShouldLookForVendorByName(VendorNo: Code[20]): Boolean
    var
        Vendor: Record "23";
    begin
        IF VendorNo = '' THEN
          EXIT(TRUE);

        IF NOT Vendor.GET(VendorNo) THEN
          EXIT(TRUE);

        EXIT(NOT Vendor."Disable Search by Name");
    end;

    local procedure BuyFromVendorIsReplaced(): Boolean
    begin
        EXIT((xRec."Buy-from Vendor No." <> '') AND (xRec."Buy-from Vendor No." <> "Buy-from Vendor No."));
    end;

    local procedure PayToVendorIsReplaced(): Boolean
    begin
        EXIT((xRec."Pay-to Vendor No." <> '') AND (xRec."Pay-to Vendor No." <> "Pay-to Vendor No."));
    end;

    local procedure UpdatePayToAddressFromBuyFromAddress(FieldNumber: Integer)
    begin
        IF ("Order Address Code" = '') AND PayToAddressEqualsOldBuyFromAddress THEN
          CASE FieldNumber OF
            FIELDNO("Pay-to Address"):
              IF xRec."Buy-from Address" = "Pay-to Address" THEN
                "Pay-to Address" := "Buy-from Address";
            FIELDNO("Pay-to Address 2"):
              IF xRec."Buy-from Address 2" = "Pay-to Address 2" THEN
                "Pay-to Address 2" := "Buy-from Address 2";
            FIELDNO("Pay-to City"), FIELDNO("Pay-to Post Code"):
              BEGIN
                IF xRec."Buy-from City" = "Pay-to City" THEN
                  "Pay-to City" := "Buy-from City";
                IF xRec."Buy-from Post Code" = "Pay-to Post Code" THEN
                  "Pay-to Post Code" := "Buy-from Post Code";
                IF xRec."Buy-from County" = "Pay-to County" THEN
                  "Pay-to County" := "Buy-from County";
                IF xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" THEN
                  "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
              END;
            FIELDNO("Pay-to County"):
              IF xRec."Buy-from County" = "Pay-to County" THEN
                "Pay-to County" := "Buy-from County";
            FIELDNO("Pay-to Country/Region Code"):
              IF  xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" THEN
                "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
          END;
    end;

    local procedure PayToAddressEqualsOldBuyFromAddress(): Boolean
    begin
        IF (xRec."Buy-from Address" = "Pay-to Address") AND
           (xRec."Buy-from Address 2" = "Pay-to Address 2") AND
           (xRec."Buy-from City" = "Pay-to City") AND
           (xRec."Buy-from County" = "Pay-to County") AND
           (xRec."Buy-from Post Code" = "Pay-to Post Code") AND
           (xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code")
        THEN
          EXIT(TRUE);
    end;

    procedure ConfirmCloseUnposted(): Boolean
    var
        InstructionMgt: Codeunit "1330";
    begin
        IF PurchLinesExist THEN
          EXIT(InstructionMgt.ShowConfirm(DocumentNotPostedClosePageQst,InstructionMgt.QueryPostOnCloseCode));
        EXIT(TRUE)
    end;

    procedure InitFromPurchHeader(SourcePurchHeader: Record "38")
    begin
        "Document Date" := SourcePurchHeader."Document Date";
        "Expected Receipt Date" := SourcePurchHeader."Expected Receipt Date";
        "Shortcut Dimension 1 Code" := SourcePurchHeader."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := SourcePurchHeader."Shortcut Dimension 2 Code";
        "Dimension Set ID" := SourcePurchHeader."Dimension Set ID";
        "Location Code" := SourcePurchHeader."Location Code";
        SetShipToAddress(
          SourcePurchHeader."Ship-to Name",SourcePurchHeader."Ship-to Name 2",SourcePurchHeader."Ship-to Address",
          SourcePurchHeader."Ship-to Address 2",SourcePurchHeader."Ship-to City",SourcePurchHeader."Ship-to Post Code",
          SourcePurchHeader."Ship-to County",SourcePurchHeader."Ship-to Country/Region Code");
        "Ship-to Contact" := SourcePurchHeader."Ship-to Contact";
    end;

    local procedure InitFromVendor(VendorNo: Code[20];VendorCaption: Text): Boolean
    begin
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        IF VendorNo = '' THEN BEGIN
          IF NOT PurchLine.ISEMPTY THEN
            ERROR(Text005,VendorCaption);
          INIT;
          PurchSetup.GET;
          "No. Series" := xRec."No. Series";
          InitRecord;
          InitNoSeries;
          EXIT(TRUE);
        END;
    end;

    local procedure InitFromContact(ContactNo: Code[20];VendorNo: Code[20];ContactCaption: Text): Boolean
    begin
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        IF (ContactNo = '') AND (VendorNo = '') THEN BEGIN
          IF NOT PurchLine.ISEMPTY THEN
            ERROR(Text005,ContactCaption);
          INIT;
          PurchSetup.GET;
          "No. Series" := xRec."No. Series";
          InitRecord;
          InitNoSeries;
          EXIT(TRUE);
        END;
    end;

    local procedure LookupContact(VendorNo: Code[20];ContactNo: Code[20];var Contact: Record "5050")
    var
        ContactBusinessRelation: Record "5054";
    begin
        IF ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Vendor,VendorNo) THEN
          Contact.SETRANGE("Company No.",ContactBusinessRelation."Contact No.")
        ELSE
          Contact.SETRANGE("Company No.",'');
        IF ContactNo <> '' THEN
          IF Contact.GET(ContactNo) THEN ;
    end;

    [Scope('Internal')]
    procedure SendRecords()
    var
        DocumentSendingProfile: Record "60";
        ReportSelections: Record "77";
        DocTxt: Text[150];
    begin
        CheckMixedDropShipment;

        GetReportSelectionsUsageFromDocumentType(ReportSelections.Usage,DocTxt);

        DocumentSendingProfile.SendVendorRecords(
          ReportSelections.Usage,Rec,DocTxt,"Buy-from Vendor No.","No.",
          FIELDNO("Buy-from Vendor No."),FIELDNO("No."));
    end;

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        DocumentSendingProfile: Record "60";
        DummyReportSelections: Record "77";
    begin
        CheckMixedDropShipment;

        DocumentSendingProfile.TrySendToPrinterVendor(
          DummyReportSelections.Usage::"P.Order",Rec,FIELDNO("Buy-from Vendor No."),ShowRequestForm);
    end;

    procedure SendProfile(var DocumentSendingProfile: Record "60")
    var
        DummyReportSelections: Record "77";
    begin
        CheckMixedDropShipment;

        DocumentSendingProfile.SendVendor(
          DummyReportSelections.Usage::"P.Order",Rec,"No.","Buy-from Vendor No.",
          PurchOrderDocTxt,FIELDNO("Buy-from Vendor No."),FIELDNO("No."));
    end;

    local procedure CheckMixedDropShipment()
    begin
        IF HasMixedDropShipment THEN
          ERROR(MixedDropshipmentErr);
    end;

    local procedure HasMixedDropShipment(): Boolean
    var
        PurchaseLine: Record "39";
        HasDropShipmentLines: Boolean;
    begin
        PurchaseLine.SETRANGE("Document Type","Document Type");
        PurchaseLine.SETRANGE("Document No.","No.");
        PurchaseLine.SETFILTER("No.",'<>%1','');
        PurchaseLine.SETFILTER(Type,'%1|%2',PurchaseLine.Type::Item,PurchaseLine.Type::"Fixed Asset");
        PurchaseLine.SETRANGE("Drop Shipment",TRUE);

        HasDropShipmentLines := NOT PurchaseLine.ISEMPTY;

        PurchaseLine.SETRANGE("Drop Shipment",FALSE);

        EXIT(HasDropShipmentLines AND NOT PurchaseLine.ISEMPTY);
    end;

    local procedure SetDefaultPurchaser()
    var
        UserSetup: Record "91";
    begin
        IF NOT UserSetup.GET(USERID) THEN
          EXIT;

        IF UserSetup."Salespers./Purch. Code" <> '' THEN
          IF SalespersonPurchaser.GET(UserSetup."Salespers./Purch. Code") THEN
            IF NOT SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
              VALIDATE("Purchaser Code",UserSetup."Salespers./Purch. Code");
    end;

    [Scope('Internal')]
    procedure OnAfterValidateBuyFromVendorNo(var PurchaseHeader: Record "38";var xPurchaseHeader: Record "38")
    begin
        IF PurchaseHeader.GETFILTER("Buy-from Vendor No.") = xPurchaseHeader."Buy-from Vendor No." THEN
          IF PurchaseHeader."Buy-from Vendor No." <> xPurchaseHeader."Buy-from Vendor No." THEN
            PurchaseHeader.SETRANGE("Buy-from Vendor No.");
    end;

    [Scope('Internal')]
    procedure BatchConfirmUpdateDeferralDate(var BatchConfirm: Option " ",Skip,Update;ReplacePostingDate: Boolean;PostingDateReq: Date)
    begin
        IF (NOT ReplacePostingDate) OR (PostingDateReq = "Posting Date") OR (BatchConfirm = BatchConfirm::Skip) THEN
          EXIT;

        IF NOT DeferralHeadersExist THEN
          EXIT;

        "Posting Date" := PostingDateReq;
        CASE BatchConfirm OF
          BatchConfirm::" ":
            BEGIN
              ConfirmUpdateDeferralDate;
              IF Confirmed THEN
                BatchConfirm := BatchConfirm::Update
              ELSE
                BatchConfirm := BatchConfirm::Skip;
            END;
          BatchConfirm::Update:
            UpdatePurchLines(PurchLine.FIELDCAPTION("Deferral Code"),FALSE);
        END;
        COMMIT;
    end;

    [Scope('Internal')]
    procedure SetAllowSelectNoSeries()
    begin
        SelectNoSeriesAllowed := TRUE;
    end;

    local procedure ModifyPayToVendorAddress()
    var
        Vendor: Record "23";
    begin
        PurchSetup.GET;
        IF PurchSetup."Ignore Updated Addresses" THEN
          EXIT;
        IF IsCreditDocType THEN
          EXIT;
        IF ("Pay-to Vendor No." <> "Buy-from Vendor No.") AND Vendor.GET("Pay-to Vendor No.") THEN
          IF HasPayToAddress AND HasDifferentPayToAddress(Vendor) THEN
            ShowModifyAddressNotification(GetModifyPayToVendorAddressNotificationId,
              ModifyVendorAddressNotificationLbl,ModifyVendorAddressNotificationMsg,
              'CopyPayToVendorAddressFieldsFromSalesDocument',"Pay-to Vendor No.",
              "Pay-to Name",FIELDNAME("Pay-to Vendor No."));
    end;

    local procedure ModifyVendorAddress()
    var
        Vendor: Record "23";
    begin
        PurchSetup.GET;
        IF PurchSetup."Ignore Updated Addresses" THEN
          EXIT;
        IF IsCreditDocType THEN
          EXIT;
        IF Vendor.GET("Buy-from Vendor No.") AND HasBuyFromAddress AND HasDifferentBuyFromAddress(Vendor) THEN
          ShowModifyAddressNotification(GetModifyVendorAddressNotificationId,
            ModifyVendorAddressNotificationLbl,ModifyVendorAddressNotificationMsg,
            'CopyBuyFromVendorAddressFieldsFromSalesDocument',"Buy-from Vendor No.",
            "Buy-from Vendor Name",FIELDNAME("Buy-from Vendor No."));
    end;

    local procedure ShowModifyAddressNotification(NotificationID: Guid;NotificationLbl: Text;NotificationMsg: Text;NotificationFunctionTok: Text;VendorNumber: Code[20];VendorName: Text[50];VendorNumberFieldName: Text)
    var
        MyNotifications: Record "1518";
        NotificationLifecycleMgt: Codeunit "1511";
        ModifyVendorAddressNotification: Notification;
    begin
        IF NOT MyNotifications.IsEnabled(NotificationID) THEN
          EXIT;

        ModifyVendorAddressNotification.ID := NotificationID;
        ModifyVendorAddressNotification.MESSAGE := STRSUBSTNO(NotificationMsg,VendorName);
        ModifyVendorAddressNotification.ADDACTION(NotificationLbl,CODEUNIT::"Document Notifications",NotificationFunctionTok);
        ModifyVendorAddressNotification.ADDACTION(
          DontShowAgainActionLbl,CODEUNIT::"Document Notifications",'HidePurchaseNotificationForCurrentUser');
        ModifyVendorAddressNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        ModifyVendorAddressNotification.SETDATA(FIELDNAME("Document Type"),FORMAT("Document Type"));
        ModifyVendorAddressNotification.SETDATA(FIELDNAME("No."),"No.");
        ModifyVendorAddressNotification.SETDATA(VendorNumberFieldName,VendorNumber);
        NotificationLifecycleMgt.SendNotification(ModifyVendorAddressNotification,RECORDID);
    end;

    [Scope('Internal')]
    procedure RecallModifyAddressNotification(NotificationID: Guid)
    var
        MyNotifications: Record "1518";
        ModifyVendorAddressNotification: Notification;
    begin
        IF IsCreditDocType OR (NOT MyNotifications.IsEnabled(NotificationID)) THEN
          EXIT;
        ModifyVendorAddressNotification.ID := NotificationID;
        ModifyVendorAddressNotification.RECALL;
    end;

    [Scope('Internal')]
    procedure GetModifyVendorAddressNotificationId(): Guid
    begin
        EXIT('CF3D0CD3-C54A-47D1-8A3F-57A6CCBA8DDE');
    end;

    [Scope('Internal')]
    procedure GetModifyPayToVendorAddressNotificationId(): Guid
    begin
        EXIT('16E45B3A-CB9F-4B2C-9F08-2BCE39E9E980');
    end;

    [Scope('Internal')]
    procedure GetShowExternalDocAlreadyExistNotificationId(): Guid
    begin
        EXIT('D87F624C-D3BE-4E6B-A369-D18AE269181A');
    end;

    [Scope('Internal')]
    procedure GetLineInvoiceDiscountResetNotificationId(): Guid
    begin
        EXIT('3DC9C8BC-0512-4A49-B587-256C308EBCAA');
    end;

    local procedure UpdateInboundWhseHandlingTime()
    begin
        IF "Location Code" = '' THEN BEGIN
          IF InvtSetup.GET THEN
            "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
        END ELSE BEGIN
          IF Location.GET("Location Code") THEN;
          "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
        END;
    end;

    [Scope('Internal')]
    procedure SetModifyVendorAddressNotificationDefaultState()
    var
        MyNotifications: Record "1518";
    begin
        MyNotifications.InsertDefault(GetModifyVendorAddressNotificationId,
          ModifyBuyFromVendorAddressNotificationNameTxt,ModifyBuyFromVendorAddressNotificationDescriptionTxt,TRUE);
    end;

    [Scope('Internal')]
    procedure SetModifyPayToVendorAddressNotificationDefaultState()
    var
        MyNotifications: Record "1518";
    begin
        MyNotifications.InsertDefault(GetModifyPayToVendorAddressNotificationId,
          ModifyPayToVendorAddressNotificationNameTxt,ModifyPayToVendorAddressNotificationDescriptionTxt,TRUE);
    end;

    [Scope('Internal')]
    procedure SetShowExternalDocAlreadyExistNotificationDefaultState(DefaultState: Boolean)
    var
        MyNotifications: Record "1518";
    begin
        MyNotifications.InsertDefault(GetShowExternalDocAlreadyExistNotificationId,
          ShowDocAlreadyExistNotificationNameTxt,ShowDocAlreadyExistNotificationDescriptionTxt,DefaultState);
    end;

    [Scope('Internal')]
    procedure DontNotifyCurrentUserAgain(NotificationID: Guid)
    var
        MyNotifications: Record "1518";
    begin
        IF NOT MyNotifications.Disable(NotificationID) THEN
          CASE NotificationID OF
            GetModifyVendorAddressNotificationId:
              MyNotifications.InsertDefault(NotificationID,ModifyBuyFromVendorAddressNotificationNameTxt,
                ModifyBuyFromVendorAddressNotificationDescriptionTxt,FALSE);
            GetModifyPayToVendorAddressNotificationId:
              MyNotifications.InsertDefault(NotificationID,ModifyPayToVendorAddressNotificationNameTxt,
                ModifyPayToVendorAddressNotificationDescriptionTxt,FALSE);
          END;
    end;

    local procedure HasDifferentBuyFromAddress(Vendor: Record "23"): Boolean
    begin
        EXIT(("Buy-from Address" <> Vendor.Address) OR
          ("Buy-from Address 2" <> Vendor."Address 2") OR
          ("Buy-from City" <> Vendor.City) OR
          ("Buy-from Country/Region Code" <> Vendor."Country/Region Code") OR
          ("Buy-from County" <> Vendor.County) OR
          ("Buy-from Post Code" <> Vendor."Post Code") OR
          ("Buy-from Contact" <> Vendor.Contact));
    end;

    local procedure HasDifferentPayToAddress(Vendor: Record "23"): Boolean
    begin
        EXIT(("Pay-to Address" <> Vendor.Address) OR
          ("Pay-to Address 2" <> Vendor."Address 2") OR
          ("Pay-to City" <> Vendor.City) OR
          ("Pay-to Country/Region Code" <> Vendor."Country/Region Code") OR
          ("Pay-to County" <> Vendor.County) OR
          ("Pay-to Post Code" <> Vendor."Post Code") OR
          ("Pay-to Contact" <> Vendor.Contact));
    end;

    local procedure FindPostedDocumentWithSameExternalDocNo(var VendorLedgerEntry: Record "25";ExternalDocumentNo: Code[35]): Boolean
    var
        VendorMgt: Codeunit "1312";
    begin
        VendorMgt.SetFilterForExternalDocNo(
          VendorLedgerEntry,GetGenJnlDocumentType,ExternalDocumentNo,"Pay-to Vendor No.","Document Date");
        EXIT(VendorLedgerEntry.FINDFIRST);
    end;

    [Scope('Internal')]
    procedure FilterPartialReceived()
    var
        PurchaseHeaderOriginal: Record "38";
        ReceiveFilter: Text;
        IsMarked: Boolean;
        ReceiveValue: Boolean;
    begin
        ReceiveFilter := GETFILTER(Receive);
        SETRANGE(Receive);
        EVALUATE(ReceiveValue,ReceiveFilter);

        PurchaseHeaderOriginal := Rec;
        IF FINDSET THEN
          REPEAT
            IF NOT HasReceivedLines THEN
              IsMarked := NOT ReceiveValue
            ELSE
              IsMarked := ReceiveValue;
            MARK(IsMarked);
          UNTIL NEXT = 0;

        Rec := PurchaseHeaderOriginal;
        MARKEDONLY(TRUE);
    end;

    [Scope('Internal')]
    procedure FilterPartialInvoiced()
    var
        PurchaseHeaderOriginal: Record "38";
        InvoiceFilter: Text;
        IsMarked: Boolean;
        InvoiceValue: Boolean;
    begin
        InvoiceFilter := GETFILTER(Invoice);
        SETRANGE(Invoice);
        EVALUATE(InvoiceValue,InvoiceFilter);

        PurchaseHeaderOriginal := Rec;
        IF FINDSET THEN
          REPEAT
            IF NOT HasInvoicedLines THEN
              IsMarked := NOT InvoiceValue
            ELSE
              IsMarked := InvoiceValue;
            MARK(IsMarked);
          UNTIL NEXT = 0;

        Rec := PurchaseHeaderOriginal;
        MARKEDONLY(TRUE);
    end;

    local procedure HasReceivedLines(): Boolean
    var
        PurchaseLine: Record "39";
    begin
        PurchaseLine.SETRANGE("Document Type","Document Type");
        PurchaseLine.SETRANGE("Document No.","No.");
        PurchaseLine.SETFILTER("No.",'<>%1','');
        PurchaseLine.SETFILTER("Quantity Received",'<>%1',0);
        EXIT(NOT PurchaseLine.ISEMPTY);
    end;

    local procedure HasInvoicedLines(): Boolean
    var
        PurchaseLine: Record "39";
    begin
        PurchaseLine.SETRANGE("Document Type","Document Type");
        PurchaseLine.SETRANGE("Document No.","No.");
        PurchaseLine.SETFILTER("No.",'<>%1','');
        PurchaseLine.SETFILTER("Quantity Invoiced",'<>%1',0);
        EXIT(NOT PurchaseLine.ISEMPTY);
    end;

    local procedure ShowExternalDocAlreadyExistNotification(VendorLedgerEntry: Record "25")
    var
        NotificationLifecycleMgt: Codeunit "1511";
        DocAlreadyExistNotification: Notification;
    begin
        IF NOT IsDocAlreadyExistNotificationEnabled THEN
          EXIT;

        DocAlreadyExistNotification.ID := GetShowExternalDocAlreadyExistNotificationId;
        DocAlreadyExistNotification.MESSAGE :=
          STRSUBSTNO(PurchaseAlreadyExistsTxt,VendorLedgerEntry."Document Type",VendorLedgerEntry."External Document No.");
        DocAlreadyExistNotification.ADDACTION(ShowVendLedgEntryTxt,CODEUNIT::"Document Notifications",'ShowVendorLedgerEntry');
        DocAlreadyExistNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        DocAlreadyExistNotification.SETDATA(FIELDNAME("Document Type"),FORMAT("Document Type"));
        DocAlreadyExistNotification.SETDATA(FIELDNAME("No."),"No.");
        DocAlreadyExistNotification.SETDATA(VendorLedgerEntry.FIELDNAME("Entry No."),FORMAT(VendorLedgerEntry."Entry No."));
        NotificationLifecycleMgt.SendNotificationWithAdditionalContext(
          DocAlreadyExistNotification,RECORDID,GetShowExternalDocAlreadyExistNotificationId);
    end;

    local procedure GetGenJnlDocumentType(): Integer
    var
        RefGenJournalLine: Record "81";
    begin
        CASE "Document Type" OF
          "Document Type"::"Blanket Order",
          "Document Type"::Quote,
          "Document Type"::Invoice,
          "Document Type"::Order:
            EXIT(RefGenJournalLine."Document Type"::Invoice);
          ELSE
            EXIT(RefGenJournalLine."Document Type"::"Credit Memo");
        END;
    end;

    local procedure RecallExternalDocAlreadyExistsNotification()
    var
        NotificationLifecycleMgt: Codeunit "1511";
    begin
        IF NOT IsDocAlreadyExistNotificationEnabled THEN
          EXIT;

        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          RECORDID,GetShowExternalDocAlreadyExistNotificationId,TRUE);
    end;

    local procedure IsDocAlreadyExistNotificationEnabled(): Boolean
    var
        MyNotifications: Record "1518";
    begin
        IF NOT MyNotifications.GET(USERID,GetShowExternalDocAlreadyExistNotificationId) THEN
          EXIT(FALSE);

        EXIT(MyNotifications.Enabled);
    end;

    procedure ShipToAddressEqualsCompanyShipToAddress(): Boolean
    var
        CompanyInformation: Record "79";
    begin
        CompanyInformation.GET;
        EXIT(IsShipToAddressEqualToCompanyShipToAddress(Rec,CompanyInformation));
    end;

    local procedure IsShipToAddressEqualToCompanyShipToAddress(PurchaseHeader: Record "38";CompanyInformation: Record "79"): Boolean
    begin
        EXIT(
          (PurchaseHeader."Ship-to Address" = CompanyInformation."Ship-to Address") AND
          (PurchaseHeader."Ship-to Address 2" = CompanyInformation."Ship-to Address 2") AND
          (PurchaseHeader."Ship-to City" = CompanyInformation."Ship-to City") AND
          (PurchaseHeader."Ship-to County" = CompanyInformation."Ship-to County") AND
          (PurchaseHeader."Ship-to Post Code" = CompanyInformation."Ship-to Post Code") AND
          (PurchaseHeader."Ship-to Country/Region Code" = CompanyInformation."Ship-to Country/Region Code") AND
          (PurchaseHeader."Ship-to Name" = CompanyInformation."Ship-to Name"));
    end;

    procedure BuyFromAddressEqualsShipToAddress(): Boolean
    begin
        EXIT(
          ("Ship-to Address" = "Buy-from Address") AND
          ("Ship-to Address 2" = "Buy-from Address 2") AND
          ("Ship-to City" = "Buy-from City") AND
          ("Ship-to County" = "Buy-from County") AND
          ("Ship-to Post Code" = "Buy-from Post Code") AND
          ("Ship-to Country/Region Code" = "Buy-from Country/Region Code") AND
          ("Ship-to Name" = "Buy-from Vendor Name"));
    end;

    local procedure SetPurchaserCode(PurchaserCodeToCheck: Code[20];var PurchaserCodeToAssign: Code[20])
    begin
        IF PurchaserCodeToCheck <> '' THEN BEGIN
          IF SalespersonPurchaser.GET(PurchaserCodeToCheck) THEN
            IF SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
              PurchaserCodeToAssign := ''
            ELSE
              PurchaserCodeToAssign := PurchaserCodeToCheck;
        END ELSE
          PurchaserCodeToAssign := '';
    end;

    [Scope('Internal')]
    procedure ValidatePurchaserOnPurchHeader(PurchaseHeader2: Record "38";IsTransaction: Boolean;IsPostAction: Boolean)
    begin
        IF PurchaseHeader2."Purchaser Code" <> '' THEN
          IF SalespersonPurchaser.GET(PurchaseHeader2."Purchaser Code") THEN
            IF SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN BEGIN
              IF IsTransaction THEN
                ERROR(SalespersonPurchaser.GetPrivacyBlockedTransactionText(SalespersonPurchaser,IsPostAction,FALSE));
              IF NOT IsTransaction THEN
                ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser,FALSE));
            END;
    end;

    local procedure GetReportSelectionsUsageFromDocumentType(var ReportSelectionsUsage: Option;var DocTxt: Text[150])
    var
        ReportSelections: Record "77";
    begin
        CASE "Document Type" OF
          "Document Type"::Order:
            BEGIN
              ReportSelectionsUsage := ReportSelections.Usage::"P.Order";
              DocTxt := PurchOrderDocTxt;
            END;
          "Document Type"::Quote:
            BEGIN
              ReportSelectionsUsage := ReportSelections.Usage::"P.Quote";
              DocTxt := PurchQuoteDocTxt;
            END;
        END;
    end;

    local procedure ValidateEmptySellToCustomerAndLocation()
    begin
        VALIDATE("Sell-to Customer No.",'');
        VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitRecord(var PurchHeader: Record "38")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitNoSeries(var PurchHeader: Record "38")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterChangePricesIncludingVAT(var PurchaseHeader: Record "38")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTestNoSeries(var PurchHeader: Record "38")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateShipToAddress(var PurchHeader: Record "38")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdatePurchLinesByChangedFieldName(PurchHeader: Record "38";var PurchLine: Record "39";ChangedFieldName: Text[100])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDimTableIDs(var PurchaseHeader: Record "38";FieldNo: Integer;var TableID: array [10] of Integer;var No: array [10] of Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferExtendedTextForPurchaseLineRecreation(var PurchLine: Record "39")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    [Scope('Internal')]
    procedure OnValidatePurchaseHeaderPayToVendorNo(Vendor: Record "23")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRecreatePurchLinesOnBeforeConfirm(var PurchaseHeader: Record "38";xPurchaseHeader: Record "38";ChangedFieldName: Text[100];HideValidationDialog: Boolean;var Confirmed: Boolean;var IsHandled: Boolean)
    begin
    end;

    local procedure UpdatePrepmtAmounts(var PurchaseLine: Record "39")
    var
        Currency: Record "4";
    begin
        Currency.Initialize("Currency Code");
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          PurchaseLine."Prepmt. Line Amount" := ROUND(
              PurchaseLine."Line Amount" * PurchaseLine."Prepayment %" / 100,Currency."Amount Rounding Precision");
          IF ABS(PurchaseLine."Inv. Discount Amount" + PurchaseLine."Prepmt. Line Amount") > ABS(PurchaseLine."Line Amount") THEN
            PurchaseLine."Prepmt. Line Amount" := PurchaseLine."Line Amount" - PurchaseLine."Inv. Discount Amount";
        END;
    end;
}

