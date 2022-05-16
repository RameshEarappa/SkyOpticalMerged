codeunit 50002 "Magento Integration Utility"
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
        JObject: DotNet JObject;
        FunctionName: Text;
        "SalesOrderNo.": Code[20];
        "CustomerNo.": Code[20];

    [Scope('Internal')]
    procedure "Export Items"(var RecItem: Record "27")
    var
        ExportItem: XMLport "50000";
        TempBlob: Record "99008535" temporary;
        XmlOutStream: OutStream;
        JObject: DotNet JObject;
        JProperty: DotNet JProperty;
        XmlText: Text;
        ClientContext: Text;
        JsonConvert: DotNet JsonConvert;
        XmlDocument2: DotNet XmlDocument;
        JsonText: Text;
        JSONArray: DotNet JArray;
        CR: Text[1];
        XmlInstream: InStream;
        JSONFormatting: DotNet Formatting;
        Items: Record "27";
    begin
        //Not In Use
        /*CLEAR(Items);
        Items.SETRANGE("No.",RecItem."No.");
        IF Items.FINDFIRST THEN BEGIN
          CLEAR(ExportItem);
          CLEAR(TempBlob);
          TempBlob.Blob.CREATEOUTSTREAM(XmlOutStream);
          ExportItem.SETTABLEVIEW(Items);
          ExportItem.SETDESTINATION(XmlOutStream);
          ExportItem.EXPORT;
          CR[1] := 10;
          MESSAGE(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
          XmlDocument2:=XmlDocument2.XmlDocument();
          XmlDocument2.LoadXml(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
          JsonText:=JsonConvert.SerializeXmlNode(XmlDocument2.DocumentElement,JSONFormatting.Indented,TRUE);
          MESSAGE(JsonText);
        END;*/

    end;

    [Scope('Internal')]
    procedure "Export ILE"(var RecItemLE: Record "32")
    var
        ExportItem: XMLport "50001";
        TempBlob: Record "99008535" temporary;
        XmlOutStream: OutStream;
        JObject: DotNet JObject;
        JProperty: DotNet JProperty;
        XmlText: Text;
        ClientContext: Text;
        JsonConvert: DotNet JsonConvert;
        XmlDocument2: DotNet XmlDocument;
        JsonText: Text;
        JSONArray: DotNet JArray;
        CR: Text[1];
        XmlInstream: InStream;
        JSONFormatting: DotNet Formatting;
        ItemLE: Record "32";
    begin
        //Not in use
        /*CLEAR(ItemLE);
        ItemLE.SETRANGE("Entry No.",RecItemLE."Entry No.");
        IF ItemLE.FINDFIRST THEN BEGIN
          CLEAR(ExportItem);
          CLEAR(TempBlob);
          TempBlob.Blob.CREATEOUTSTREAM(XmlOutStream);
          ExportItem.SETTABLEVIEW(ItemLE);
          ExportItem.SETDESTINATION(XmlOutStream);
          ExportItem.EXPORT;
          CR[1] := 10;
          MESSAGE(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
          XmlDocument2:=XmlDocument2.XmlDocument();
          XmlDocument2.LoadXml(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
          JsonText:=JsonConvert.SerializeXmlNode(XmlDocument2.DocumentElement,JSONFormatting.Indented,TRUE);
          MESSAGE(JsonText);
        END;*/

    end;

    [Scope('Internal')]
    procedure InsertCustomer()
    var
        Customer: Record "18";
    begin
        CLEAR(Customer);
        IF NOT Customer.GET(FORMAT(JObject.GetValue('Customer_ID'))) THEN BEGIN
            Customer.INIT;
            Customer.VALIDATE("No.", FORMAT(JObject.GetValue('Customer_ID')));
            Customer.INSERT(TRUE);
        END;
        "CustomerNo." := Customer."No.";
        Customer.VALIDATE(Name, FORMAT(JObject.GetValue('Customer Name')));
        Customer.VALIDATE("E-Mail", FORMAT(JObject.GetValue('Customer Email')));
        Customer.VALIDATE("Gen. Bus. Posting Group", FORMAT(JObject.GetValue('Customer Group')));
        Customer.VALIDATE("Associated to Website", FORMAT(JObject.GetValue('Associated to Website')));
        Customer.VALIDATE(Address, FORMAT(JObject.GetValue('Billing Address Customer Street')));
        Customer.VALIDATE(City, FORMAT(JObject.GetValue('Billing Address City')));
        Customer.VALIDATE("Post Code", FORMAT(JObject.GetValue('Billing Address Postcode')));
        Customer.VALIDATE(County, FORMAT(JObject.GetValue('Billing Address Region')));
        Customer.VALIDATE("Country/Region Code", FORMAT(JObject.GetValue('Billing Address Country')));
        Customer.MODIFY(TRUE);
    end;

    [Scope('Internal')]
    procedure InsertSalesOrder()
    var
        JSONManagement: Codeunit "5459";
        ArrayString: Text;
        JSONMgmt: Codeunit "5459";
        JObject2: DotNet JObject;
        JSONArray2: DotNet JArray;
        SalesLine: Record "37";
        DateL: DateTime;
        DecimalL: Decimal;
        LineNo: Integer;
        SalesHeader: Record "36";
    begin
        SalesHeader.INIT;
        SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.VALIDATE("No.", FORMAT(JObject.GetValue('Order_ID')));
        "SalesOrderNo." := SalesHeader."No.";
        SalesHeader.VALIDATE("Sell-to Customer No.", FORMAT(JObject.GetValue('Customer_ID')));
        SalesHeader.VALIDATE("Order #", FORMAT(JObject.GetValue('Order #')));
        SalesHeader.VALIDATE("Invoice #", FORMAT(JObject.GetValue('Invoice #')));
        EVALUATE(DateL, FORMAT(JObject.GetValue('Order_Date')));
        SalesHeader.VALIDATE("Order Date", DT2DATE(DateL));
        EVALUATE(DateL, FORMAT(JObject.GetValue('Invoice Date')));
        SalesHeader.VALIDATE("Invoice Date", DT2DATE(DateL));
        SalesHeader.VALIDATE("Customer Email", FORMAT(JObject.GetValue('Customer Email')));
        SalesHeader.VALIDATE("Bill-to Address", FORMAT(JObject.GetValue('Billing Address Customer Street')));
        SalesHeader.VALIDATE("Bill-to City", FORMAT(JObject.GetValue('Billing Address City')));
        SalesHeader.VALIDATE("Bill-to Post Code", FORMAT(JObject.GetValue('Billing Address Postcode')));
        SalesHeader.VALIDATE("Bill-to County", FORMAT(JObject.GetValue('Billing Address Region')));
        SalesHeader.VALIDATE("Bill-to Country/Region Code", FORMAT(JObject.GetValue('Billing Address Country')));
        SalesHeader.VALIDATE("Phone Number Billing", FORMAT(JObject.GetValue('Phone Number Billing')));
        SalesHeader.VALIDATE("Ship-to Address", FORMAT(JObject.GetValue('Shipping Address Customer Street')));
        SalesHeader.VALIDATE("Ship-to City", FORMAT(JObject.GetValue('Shipping Address City')));
        SalesHeader.VALIDATE("Ship-to Post Code", FORMAT(JObject.GetValue('Shipping Address Postcode')));
        SalesHeader.VALIDATE("Ship-to Country/Region Code", FORMAT(JObject.GetValue('Shipping Address Country')));
        SalesHeader.VALIDATE("Ship-to County", FORMAT(JObject.GetValue('Shipping Address Region')));
        SalesHeader.VALIDATE("Phone Number Shipping", FORMAT(JObject.GetValue('Phone Number Shipping')));
        SalesHeader.VALIDATE("Order Status", FORMAT(JObject.GetValue('Order Status')));
        SalesHeader.VALIDATE("Order State", FORMAT(JObject.GetValue('Order State')));
        SalesHeader.VALIDATE("Currency Code", FORMAT(JObject.GetValue('Order Currency Code')));
        IF FORMAT(JObject.GetValue('Conversion rate')) <> '' THEN BEGIN
            EVALUATE(DecimalL, FORMAT(JObject.GetValue('Conversion rate')));
            SalesHeader.VALIDATE("Conversion rate", DecimalL);
        END;
        SalesHeader.VALIDATE("Website associated to Names", FORMAT(JObject.GetValue('Website associated to Names')));
        SalesHeader.VALIDATE("Website associated to", FORMAT(JObject.GetValue('Website associated to')));
        SalesHeader.VALIDATE("Store Code", FORMAT(JObject.GetValue('Store Code')));
        SalesHeader.VALIDATE("Payment Method Code", FORMAT(JObject.GetValue('Payment_Method_Code')));
        EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Amount_Before_Discount_and_VAT')));
        SalesHeader.VALIDATE(Total_Amt_Before_Disc_and_VAT, DecimalL);
        EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Discount_Amount')));
        SalesHeader.VALIDATE(Total_Discount_Amount, DecimalL);
        EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_VAT_Amount')));
        SalesHeader.VALIDATE(Total_VAT_Amount, DecimalL);
        EVALUATE(DecimalL, FORMAT(JObject.GetValue('Shipping_Charges')));
        SalesHeader.VALIDATE(Shipping_Charges, DecimalL);
        EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Invoice_Amount')));
        SalesHeader.VALIDATE(Total_Invoice_Amount, DecimalL);
        EVALUATE(DecimalL, FORMAT(JObject.GetValue('Total_Receipt_Amount')));
        SalesHeader.VALIDATE(Total_Receipt_Amount, DecimalL);
        SalesHeader.INSERT(TRUE);
        //CreatedRecordNumber+=SalesHeader."No."+',';
        //Lines
        LineNo := GetLastLineNumber(SalesHeader."No.");
        ArrayString := JObject.SelectToken('SalesOrderLines').ToString;
        CLEAR(JSONMgmt);
        CLEAR(JObject2);
        JSONMgmt.InitializeCollection(ArrayString);
        JSONMgmt.GetJsonArray(JSONArray2);
        FOREACH JObject2 IN JSONArray2 DO BEGIN
            LineNo += 10000;
            SalesLine.INIT;
            SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Order);
            SalesLine.VALIDATE("Document No.", SalesHeader."No.");
            SalesLine.VALIDATE("Line No.", LineNo);
            SalesLine.VALIDATE(Type, SalesLine.Type::Item);
            SalesLine.VALIDATE("No.", FORMAT(JObject2.GetValue('Item_Code')));
            SalesLine.VALIDATE("Item Sku", FORMAT(JObject2.GetValue('Item Sku')));
            EVALUATE(DecimalL, FORMAT(JObject2.GetValue('Quantity')));
            SalesLine.VALIDATE(Quantity, DecimalL);
            EVALUATE(DecimalL, FORMAT(JObject2.GetValue('Rate')));
            SalesLine.VALIDATE("Unit Price", DecimalL);
            EVALUATE(DecimalL, FORMAT(JObject2.GetValue('Discount')));
            SalesLine.VALIDATE("Line Discount Amount", DecimalL);
            EVALUATE(DecimalL, FORMAT(JObject2.GetValue('VAT Percent')));
            SalesLine.VALIDATE("VAT %", DecimalL);
            SalesLine.INSERT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure SetJSONRequestData(var JObjectP: DotNet JObject; FunctionNameP: Text)
    begin
        JObject := JObjectP;
        FunctionName := FunctionNameP;
    end;

    local procedure GetLastLineNumber(NoL: Code[20]): Integer
    var
        RecSalesLine: Record "37";
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

    [Scope('Internal')]
    procedure GetCustomerNumber(): Code[20]
    begin
        EXIT("CustomerNo.");
    end;

    [Scope('Internal')]
    procedure GetSalesOrderNumber(): Code[20]
    begin
        EXIT("SalesOrderNo.");
    end;

    [Scope('Internal')]
    procedure CancelSalesOrder()
    var
        RecSalesInvHeader: Record "112";
        SalesHeader: Record "36";
        CorrectPostedSalesInvoice: Codeunit "1303";
        PurchLine: Record "39";
        PurchHeader: Record "38";
    begin
        "SalesOrderNo." := FORMAT(JObject.GetValue('Order_ID'));

        IF FORMAT(JObject.GetValue('Cancelled')) <> 'true' THEN
            ERROR('Cancelled must be equals to true');

        CLEAR(SalesHeader);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE("No.", FORMAT(JObject.GetValue('Order_ID')));
        SalesHeader.FINDFIRST;
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

    trigger JObject::PropertyChanged(sender: Variant; e: DotNet PropertyChangedEventArgs)
    begin
    end;

    trigger JObject::PropertyChanging(sender: Variant; e: DotNet PropertyChangingEventArgs)
    begin
    end;

    trigger JObject::ListChanged(sender: Variant; e: DotNet ListChangedEventArgs)
    begin
    end;

    trigger JObject::AddingNew(sender: Variant; e: DotNet AddingNewEventArgs)
    begin
    end;

    trigger JObject::CollectionChanged(sender: Variant; e: DotNet NotifyCollectionChangedEventArgs)
    begin
    end;
}

