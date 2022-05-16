codeunit 50102 "Magento Integration Utility"
{

    trigger OnRun()
    var
        myDate: DateTime;
    begin
        CASE FunctionName OF
            'IMPORT CUSTOMER':
                InsertCustomer();
            'IMPORT SALESORDER':
                InsertSalesOrder();
            'SALES CANCELLATION':
                CancelSalesOrder();
        END;
    end;

    var
        JObject: JsonObject;
        FunctionName: Text;
        "SalesOrderNo.": Code[20];
        "CustomerNo.": Code[20];

    //[Scope('Internal')]
    // procedure "Export Items"(var RecItem: Record Item)
    // var
    //     ExportItem: XMLport "Export ILE";
    //     TempBlob: Record "99008535" temporary;
    //     XmlOutStream: OutStream;
    //     JObject: JsonObject;
    //     JProperty: DotNet JProperty;
    //     XmlText: Text;
    //     ClientContext: Text;
    //     JsonConvert: DotNet JsonConvert;
    //     XmlDocument2: DotNet XmlDocument;
    //     JsonText: Text;
    //     JSONArray: JsonArray;
    //     CR: Text[1];
    //     XmlInstream: InStream;
    //     JSONFormatting: DotNet Formatting;
    //     Items: Record Item;
    // begin
    //     //Not In Use
    //     /*CLEAR(Items);
    //     Items.SETRANGE("No.",RecItem."No.");
    //     IF Items.FINDFIRST THEN BEGIN
    //       CLEAR(ExportItem);
    //       CLEAR(TempBlob);
    //       TempBlob.Blob.CREATEOUTSTREAM(XmlOutStream);
    //       ExportItem.SETTABLEVIEW(Items);
    //       ExportItem.SETDESTINATION(XmlOutStream);
    //       ExportItem.EXPORT;
    //       CR[1] := 10;
    //       MESSAGE(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
    //       XmlDocument2:=XmlDocument2.XmlDocument();
    //       XmlDocument2.LoadXml(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
    //       JsonText:=JsonConvert.SerializeXmlNode(XmlDocument2.DocumentElement,JSONFormatting.Indented,TRUE);
    //       MESSAGE(JsonText);
    //     END;*/

    // end;

    //[Scope('Internal')]
    // procedure "Export ILE"(var RecItemLE: Record "Item Ledger Entry")
    // var
    //     ExportItem: XMLport "Export ILE";
    //     TempBlob: Record "99008535" temporary;
    //     XmlOutStream: OutStream;
    //     JObject: JsonObject
    //     JProperty: DotNet JProperty;
    //     XmlText: Text;
    //     ClientContext: Text;
    //     JsonConvert: DotNet JsonConvert;
    //     XmlDocument2: DotNet XmlDocument;
    //     JsonText: Text;
    //     JSONArray: JsonArray;
    //     CR: Text[1];
    //     XmlInstream: InStream;
    //     JSONFormatting: DotNet Formatting;
    //     ItemLE: Record "Item Ledger Entry";
    // begin
    //     //Not in use
    //     /*CLEAR(ItemLE);
    //     ItemLE.SETRANGE("Entry No.",RecItemLE."Entry No.");
    //     IF ItemLE.FINDFIRST THEN BEGIN
    //       CLEAR(ExportItem);
    //       CLEAR(TempBlob);
    //       TempBlob.Blob.CREATEOUTSTREAM(XmlOutStream);
    //       ExportItem.SETTABLEVIEW(ItemLE);
    //       ExportItem.SETDESTINATION(XmlOutStream);
    //       ExportItem.EXPORT;
    //       CR[1] := 10;
    //       MESSAGE(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
    //       XmlDocument2:=XmlDocument2.XmlDocument();
    //       XmlDocument2.LoadXml(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
    //       JsonText:=JsonConvert.SerializeXmlNode(XmlDocument2.DocumentElement,JSONFormatting.Indented,TRUE);
    //       MESSAGE(JsonText);
    //     END;*/

    // end;

    ////[Scope('Internal')]
    procedure InsertCustomer()
    var
        Customer: Record Customer;
        JTokenL: JsonToken;
        CustomerNo: Code[20];
    begin
        CLEAR(Customer);
        if GetJsonValue('Customer_ID', JTokenL, JObject) then
            CustomerNo := JTokenL.AsValue().AsText();
        IF NOT Customer.GET(CustomerNo) THEN BEGIN
            Customer.INIT;
            Customer.VALIDATE("No.", CustomerNo);
            Customer.INSERT(TRUE);
        END;
        "CustomerNo." := Customer."No.";
        if GetJsonValue('Customer Name', JTokenL, JObject) then
            Customer.VALIDATE(Name, JTokenL.AsValue().AsText());
        //Customer.VALIDATE(Name, FORMAT(JObject.GetValue('Customer Name')));
        if GetJsonValue('Customer Email', JTokenL, JObject) then
            Customer.VALIDATE("E-Mail", JTokenL.AsValue().AsText());
        if GetJsonValue('Customer Group', JTokenL, JObject) then
            Customer.VALIDATE("Gen. Bus. Posting Group", JTokenL.AsValue().AsText());
        //Customer.VALIDATE("Associated to Website", FORMAT(JObject.GetValue('Associated to Website')));
        if GetJsonValue('Associated to Website', JTokenL, JObject) then
            Customer.VALIDATE("Associated to Website", JTokenL.AsValue().AsText());
        //Customer.VALIDATE(Address, FORMAT(JObject.GetValue('Billing Address Customer Street')));
        if GetJsonValue('Billing Address Customer Street', JTokenL, JObject) then
            Customer.VALIDATE(Address, JTokenL.AsValue().AsText());
        //Customer.VALIDATE(City, FORMAT(JObject.GetValue('Billing Address City')));
        if GetJsonValue('Billing Address City', JTokenL, JObject) then
            Customer.VALIDATE(City, JTokenL.AsValue().AsText());
        //Customer.VALIDATE("Post Code", FORMAT(JObject.GetValue('Billing Address Postcode')));
        if GetJsonValue('Billing Address Postcode', JTokenL, JObject) then
            Customer.VALIDATE("Post Code", JTokenL.AsValue().AsText());
        //Customer.VALIDATE(County, FORMAT(JObject.GetValue('Billing Address Region')));
        if GetJsonValue('Billing Address Region', JTokenL, JObject) then
            Customer.VALIDATE(County, JTokenL.AsValue().AsText());
        //Customer.VALIDATE("Country/Region Code", FORMAT(JObject.GetValue('Billing Address Country')));
        if GetJsonValue('Billing Address Country', JTokenL, JObject) then
            Customer.VALIDATE("Country/Region Code", JTokenL.AsValue().AsText());
        Customer.MODIFY(TRUE);
    end;

    ////[Scope('Internal')]
    procedure InsertSalesOrder()
    var
        //JSONManagement: Codeunit "JSON Management";
        ArrayString: Text;
        //JSONMgmt: Codeunit "JSON Management";
        //JObject2: JsonObject;
        JSONArray: JsonArray;
        SalesLine: Record "Sales Line";
        DateL: DateTime;
        DecimalL: Decimal;
        LineNo: Integer;
        SalesHeader: Record "Sales Header";
        JTokenL: JsonToken;
    begin
        SalesHeader.INIT;
        SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::Order);
        //SalesHeader.VALIDATE("No.", FORMAT(JObject.GetValue('Order_ID')));
        if GetJsonValue('Order_ID', JTokenL, JObject) then
            SalesHeader.VALIDATE("No.", JTokenL.AsValue().AsText());
        "SalesOrderNo." := SalesHeader."No.";
        //SalesHeader.VALIDATE("Sell-to Customer No.", FORMAT(JObject.GetValue('Customer_ID')));
        if GetJsonValue('Customer_ID', JTokenL, JObject) then
            SalesHeader.VALIDATE("Sell-to Customer No.", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Order #", FORMAT(JObject.GetValue('Order #')));
        if GetJsonValue('Order #', JTokenL, JObject) then
            SalesHeader.VALIDATE("Order #", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Invoice #", FORMAT(JObject.GetValue('Invoice #')));
        if GetJsonValue('Invoice #', JTokenL, JObject) then
            SalesHeader.VALIDATE("Invoice #", JTokenL.AsValue().AsText());
        //EVALUATE(DateL, FORMAT(JObject.GetValue('Order_Date')));
        if GetJsonValue('Order_Date', JTokenL, JObject) then begin
            EVALUATE(DateL, format(JTokenL.AsValue().AsDate()));
            SalesHeader.VALIDATE("Order Date", DT2DATE(DateL));
        end;
        //EVALUATE(DateL, FORMAT(JObject.GetValue('Invoice Date')));
        if GetJsonValue('Invoice Date', JTokenL, JObject) then begin
            EVALUATE(DateL, Format(JTokenL.AsValue().AsDate()));
            SalesHeader.VALIDATE("Invoice Date", DT2DATE(DateL));
        end;
        //SalesHeader.VALIDATE("Customer Email", FORMAT(JObject.GetValue('Customer Email')));
        if GetJsonValue('Customer Email', JTokenL, JObject) then
            SalesHeader.VALIDATE("Customer Email", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Bill-to Address", FORMAT(JObject.GetValue('Billing Address Customer Street')));
        if GetJsonValue('Billing Address Customer Street', JTokenL, JObject) then
            SalesHeader.VALIDATE("Bill-to Address", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Bill-to City", FORMAT(JObject.GetValue('Billing Address City')));
        if GetJsonValue('Billing Address City', JTokenL, JObject) then
            SalesHeader.VALIDATE("Bill-to City", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Bill-to Post Code", FORMAT(JObject.GetValue('Billing Address Postcode')));
        if GetJsonValue('Billing Address Postcode', JTokenL, JObject) then
            SalesHeader.VALIDATE("Bill-to Post Code", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Bill-to County", FORMAT(JObject.GetValue('Billing Address Region')));
        if GetJsonValue('Billing Address Region', JTokenL, JObject) then
            SalesHeader.VALIDATE("Bill-to County", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Bill-to Country/Region Code", FORMAT(JObject.GetValue('Billing Address Country')));
        if GetJsonValue('Billing Address Country', JTokenL, JObject) then
            SalesHeader.VALIDATE("Bill-to Country/Region Code", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Phone Number Billing", FORMAT(JObject.GetValue('Phone Number Billing')));
        if GetJsonValue('Phone Number Billing', JTokenL, JObject) then
            SalesHeader.VALIDATE("Phone Number Billing", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Ship-to Address", FORMAT(JObject.GetValue('Shipping Address Customer Street')));
        if GetJsonValue('Shipping Address Customer Street', JTokenL, JObject) then
            SalesHeader.VALIDATE("Ship-to Address", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Ship-to City", FORMAT(JObject.GetValue('Shipping Address City')));
        if GetJsonValue('Shipping Address City', JTokenL, JObject) then
            SalesHeader.VALIDATE("Ship-to City", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Ship-to Post Code", FORMAT(JObject.GetValue('Shipping Address Postcode')));
        if GetJsonValue('Shipping Address Postcode', JTokenL, JObject) then
            SalesHeader.VALIDATE("Ship-to Post Code", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Ship-to Country/Region Code", FORMAT(JObject.GetValue('Shipping Address Country')));
        if GetJsonValue('Shipping Address Country', JTokenL, JObject) then
            SalesHeader.VALIDATE("Ship-to Country/Region Code", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Ship-to County", FORMAT(JObject.GetValue('Shipping Address Region')));
        if GetJsonValue('Shipping Address Region', JTokenL, JObject) then
            SalesHeader.VALIDATE("Ship-to County", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Phone Number Shipping", FORMAT(JObject.GetValue('Phone Number Shipping')));
        if GetJsonValue('Phone Number Shipping', JTokenL, JObject) then
            SalesHeader.VALIDATE("Phone Number Shipping", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Order Status", FORMAT(JObject.GetValue('Order Status')));
        if GetJsonValue('Order Status', JTokenL, JObject) then
            SalesHeader.VALIDATE("Order Status", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Order State", FORMAT(JObject.GetValue('Order State')));
        if GetJsonValue('Order State', JTokenL, JObject) then
            SalesHeader.VALIDATE("Order State", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Currency Code", FORMAT(JObject.GetValue('Order Currency Code')));
        if GetJsonValue('Order Currency Code', JTokenL, JObject) then
            SalesHeader.VALIDATE("Currency Code", JTokenL.AsValue().AsText());
        // IF FORMAT(JObject.GetValue('Conversion rate')) <> '' THEN BEGIN
        //     EVALUATE(DecimalL, FORMAT(JObject.GetValue('Conversion rate')));
        //     SalesHeader.VALIDATE("Conversion rate", DecimalL);
        // END;
        if GetJsonValue('Conversion rate', JTokenL, JObject) then
            IF FORMAT(JTokenL.AsValue().AsDecimal()) <> '' THEN BEGIN
                EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
                SalesHeader.VALIDATE("Conversion rate", DecimalL);
            END;
        //SalesHeader.VALIDATE("Website associated to Names", FORMAT(JObject.GetValue('Website associated to Names')));
        if GetJsonValue('Website associated to Names', JTokenL, JObject) then
            SalesHeader.VALIDATE("Website associated to Names", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Website associated to", FORMAT(JObject.GetValue('Website associated to')));
        if GetJsonValue('Website associated to', JTokenL, JObject) then
            SalesHeader.VALIDATE("Website associated to", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Store Code", FORMAT(JObject.GetValue('Store Code')));
        if GetJsonValue('Store Code', JTokenL, JObject) then
            SalesHeader.VALIDATE("Store Code", JTokenL.AsValue().AsText());
        //SalesHeader.VALIDATE("Payment Method Code", FORMAT(JObject.GetValue('Payment_Method_Code')));
        if GetJsonValue('Payment_Method_Code', JTokenL, JObject) then
            SalesHeader.VALIDATE("Payment Method Code", JTokenL.AsValue().AsText());
        //EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Amount_Before_Discount_and_VAT')));
        if GetJsonValue('Total_Amount_Before_Discount_and_VAT', JTokenL, JObject) then begin
            EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
            SalesHeader.VALIDATE(Total_Amt_Before_Disc_and_VAT, DecimalL);
        end;
        //EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Discount_Amount')));
        if GetJsonValue('Total_Discount_Amount', JTokenL, JObject) then begin
            EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
            SalesHeader.VALIDATE(Total_Discount_Amount, DecimalL);
        end;
        //EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_VAT_Amount')));
        if GetJsonValue('Total_VAT_Amount', JTokenL, JObject) then begin
            EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsText()));
            SalesHeader.VALIDATE(Total_VAT_Amount, DecimalL);
        end;
        //EVALUATE(DecimalL, FORMAT(JObject.GetValue('Shipping_Charges')));
        if GetJsonValue('Shipping_Charges', JTokenL, JObject) then begin
            EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
            SalesHeader.VALIDATE(Shipping_Charges, DecimalL);
        end;
        //EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Invoice_Amount')));
        if GetJsonValue('Total_Invoice_Amount', JTokenL, JObject) then begin
            EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
            SalesHeader.VALIDATE(Total_Invoice_Amount, DecimalL);
        end;
        //EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Receipt_Amount')));
        if GetJsonValue('Total_Receipt_Amount', JTokenL, JObject) then begin
            EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsText()));
            SalesHeader.VALIDATE(Total_Receipt_Amount, DecimalL);
        end;
        SalesHeader.INSERT(TRUE);
        //CreatedRecordNumber+=SalesHeader."No."+',';
        //Lines
        LineNo := GetLastLineNumber(SalesHeader."No.");
        JObject.Get('SalesOrderLines', JTokenL);
        JSONArray := JTokenL.AsArray();
        //ArrayString := JObject.SelectToken('SalesOrderLines').ToString;
        // CLEAR(JSONMgmt);
        // CLEAR(JObject2);
        // JSONMgmt.InitializeCollection(ArrayString);
        // JSONMgmt.GetJsonArray(JSONArray2);
        FOREACH JTokenL IN JSONArray DO BEGIN
            LineNo += 10000;
            SalesLine.INIT;
            SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Order);
            SalesLine.VALIDATE("Document No.", SalesHeader."No.");
            SalesLine.VALIDATE("Line No.", LineNo);
            SalesLine.VALIDATE(Type, SalesLine.Type::Item);
            //SalesLine.VALIDATE("No.", FORMAT(JObject2.GetValue('Item_Code')));
            if GetJsonValue('Item_Code', JTokenL, JObject) then
                SalesLine.VALIDATE("No.", JTokenL.AsValue().AsText());
            //SalesLine.VALIDATE("Item Sku", FORMAT(JObject2.GetValue('Item Sku')));
            if GetJsonValue('Item Sku', JTokenL, JObject) then
                SalesLine.VALIDATE("Item Sku", JTokenL.AsValue().AsText());
            //EVALUATE(DecimalL, FORMAT(JObject2.GetValue('Quantity')));
            if GetJsonValue('Quantity', JTokenL, JObject) then begin
                EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsInteger()));
                SalesLine.VALIDATE(Quantity, DecimalL);
            end;
            //EVALUATE(DecimalL, FORMAT(JObject2.GetValue('Rate')));
            if GetJsonValue('Rate', JTokenL, JObject) then begin
                EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
                SalesLine.VALIDATE("Unit Price", DecimalL);
            end;
            //EVALUATE(DecimalL, FORMAT(JObject2.GetValue('Discount')));
            if GetJsonValue('Discount', JTokenL, JObject) then begin
                EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
                SalesLine.VALIDATE("Line Discount Amount", DecimalL);
            end;
            //EVALUATE(DecimalL, FORMAT(JObject2.GetValue('VAT Percent')));
            if GetJsonValue('VAT Percent', JTokenL, JObject) then begin
                EVALUATE(DecimalL, FORMAT(JTokenL.AsValue().AsDecimal()));
                SalesLine.VALIDATE("VAT %", DecimalL);
            end;
            SalesLine.INSERT(TRUE);
        END;
    end;

    //[Scope('Internal')]
    procedure SetJSONRequestData(var JObjectP: JsonObject; FunctionNameP: Text)
    begin
        JObject := JObjectP;
        FunctionName := FunctionNameP;
    end;

    local procedure GetLastLineNumber(NoL: Code[20]): Integer
    var
        RecSalesLine: Record "Sales Line";
    begin
        CLEAR(RecSalesLine);
        RecSalesLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
        RecSalesLine.SETRANGE("Document Type", RecSalesLine."Document Type"::Order);
        RecSalesLine.SETRANGE("Document No.", NoL);
        IF RecSalesLine.FINDLAST THEN
            EXIT(RecSalesLine."Line No.")
        ELSE
            EXIT(0);
    end;

    //[Scope('Internal')]
    procedure GetCustomerNumber(): Code[20]
    begin
        EXIT("CustomerNo.");
    end;

    ////[Scope('Internal')]
    procedure GetSalesOrderNumber(): Code[20]
    begin
        EXIT("SalesOrderNo.");
    end;

    ////[Scope('Internal')]
    procedure CancelSalesOrder()
    var
        RecSalesInvHeader: Record "Sales Invoice Header";
        SalesHeader: Record "Sales Header";
        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        JTokenL: JsonToken;
    begin
        //"SalesOrderNo." := FORMAT(JObject.GetValue('Order_ID'));
        if GetJsonValue('Order_ID', JTokenL, JObject) then
            "SalesOrderNo." := JTokenL.AsValue().AsText();

        // IF FORMAT(JObject.GetValue('Cancelled')) <> 'true' THEN
        //     ERROR('Cancelled must be equals to true');
        if GetJsonValue('Cancelled', JTokenL, JObject) then
            if JTokenL.AsValue().AsText() <> 'true' then
                ERROR('Cancelled must be equals to true');

        CLEAR(SalesHeader);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        //SalesHeader.SETRANGE("No.", FORMAT(JObject.GetValue('Order_ID')));
        if GetJsonValue('Order_ID', JTokenL, JObject) then begin
            SalesHeader.SETRANGE("No.", JTokenL.AsValue().AsText());
            SalesHeader.FINDFIRST;
        end;
        IF SalesHeader.ShippedSalesLinesExist THEN
            ERROR('Sales Line has been shiped. You cannot cancel the order');

        SalesHeader.Cancelled := TRUE;
        SalesHeader.MODIFY;

        CLEAR(PurchLine);
        PurchLine.SETRANGE("Sales Order No.", "SalesOrderNo.");
        IF PurchLine.FINDSET THEN BEGIN
            REPEAT
                CLEAR(PurchHeader);
                PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                PurchHeader.SETRANGE("No.", PurchLine."Document No.");
                PurchHeader.FINDFIRST;
                PurchHeader.Cancelled := TRUE;
                PurchHeader.MODIFY;
            UNTIL PurchLine.NEXT = 0;
        END;
    end;

    local procedure GetJsonValue(TextvalueP: Text; var JTokenP: JsonToken; JobjectP: JsonObject): Boolean
    var
        myInt: Integer;
    begin
        if JobjectP.Get(TextvalueP, JTokenP) then
            exit(true);
    end;

    // trigger JObject::PropertyChanged(sender: Variant; e: DotNet PropertyChangedEventArgs)
    // begin
    // end;

    // trigger JObject::PropertyChanging(sender: Variant; e: DotNet PropertyChangingEventArgs)
    // begin
    // end;

    // trigger JObject::ListChanged(sender: Variant; e: DotNet ListChangedEventArgs)
    // begin
    // end;

    // trigger JObject::AddingNew(sender: Variant; e: DotNet AddingNewEventArgs)
    // begin
    // end;

    // trigger JObject::CollectionChanged(sender: Variant; e: DotNet NotifyCollectionChangedEventArgs)
    // begin
    // end;
}

