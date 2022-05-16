codeunit 50100 "Integration Utility"
{

    trigger OnRun()
    begin
        CASE FunctionName OF
            'IMPORT CUSTOMER':
                InsertCustomer();
            'IMPORT SALESORDER':
                InsertSalesOrder();
            'SALES CANCELLATION':
                SalesCanellation();
        END;
    end;

    var
        FunctionName: Text;
        RequestData: Text;
        Response: Text;
        RecordCreation: Codeunit "Magento Integration Utility";
        FailedCount: Integer;
        SuccessCount: Integer;

    //[Scope('Internal')]
    procedure InsertCustomer()
    var
        JObject: JsonObject;
        JSONArray: JsonArray;
        //JSONManagement: Codeunit "JSON Management";
        //ArrayString: Text;
        Customer: Record Customer;
        //JObjectL: JsonObject;
        //JSONArrayL: JsonArray;
        //JsonObject: JsonObject;
        JTokenL: JsonToken;
        JSonResponseObjectL: JsonObject;
        JsonResponseArrayL: JsonArray;
        JsonResponseTokenL: JsonToken;
    begin
        // JSONManagement.InitializeFromString(RequestData);
        // JSONManagement.GetJSONObject(JObject);
        JObject.ReadFrom(RequestData);
        JObject.Get('Customers', JTokenL);
        JSONArray := JTokenL.AsArray();
        //ArrayString := JObject.SelectToken('Customers').ToString;


        //Read and Parse JSONArray
        // CLEAR(JSONManagement);
        // CLEAR(JObject);
        // JSONManagement.InitializeCollection(ArrayString);
        // JSONManagement.GetJsonArray(JSONArray);

        // CLEAR(JSONArrayL);
        // JSONArrayL := JSONArrayL.JArray;
        FailedCount := 0;
        SuccessCount := 0;
        //loop and can do insert
        FOREACH JTokenL IN JSONArray DO BEGIN
            //CLEAR(JObjectL);
            //JObjectL := JObjectL.JObject;
            JObject := JTokenL.AsObject();
            CLEAR(RecordCreation);
            RecordCreation.SetJSONRequestData(JObject, FunctionName);
            CLEARLASTERROR();
            IF RecordCreation.RUN THEN BEGIN
                JSonResponseObjectL.Add('No.', RecordCreation.GetCustomerNumber());
                JSonResponseObjectL.Add('Status', 'Success');
                JSonResponseObjectL.Add('Description', 'Customer ' + RecordCreation.GetCustomerNumber + ' has been inserted/modified successfully.');
                SuccessCount += 1;
            END ELSE BEGIN
                JSonResponseObjectL.Add('No.', RecordCreation.GetCustomerNumber());
                JSonResponseObjectL.Add('Status', 'Failed');
                JSonResponseObjectL.Add('Description', GETLASTERRORTEXT);
                FailedCount += 1;
            END;
            //JSONManagement.AddJObjectToJArray(JSONArrayL, JObjectL);
            JsonResponseArrayL.Add(JSonResponseObjectL);
        END;
        //JSONManagement.AddJArrayToJObject(JObjectL, 'Customers', JSONArrayL);
        JObject.Add('Customers', JsonResponseArrayL);
        CLEAR(Response);
        //Response := JObjectL.ToString;
        JObject.WriteTo(Response);
    end;

    //[Scope('Internal')]
    procedure SetData("Function": Text; RequestDataL: Text)
    begin
        FunctionName := "Function";
        RequestData := RequestDataL;
    end;

    //[Scope('Internal')]
    procedure InsertLog(RequestData: Text; FunctionName: Text): Integer
    var
        IntegrationLog: Record "Integration Log";
    begin
        CLEAR(IntegrationLog);
        IntegrationLog.INIT;
        IntegrationLog."Entry No." := 0;
        IntegrationLog.INSERT;
        IntegrationLog."Requested AT" := CURRENTDATETIME;
        IntegrationLog.SetRequestData(RequestData);
        IntegrationLog."Function Name" := FunctionName;
        IntegrationLog.MODIFY;
        EXIT(IntegrationLog."Entry No.");
    end;

    //[Scope('Internal')]
    procedure ModifyLog(LogEntryNumber: Integer; Status: Option Failed,Success; ResponseData: Text; ErrorText: Text; SuccessCount: Integer; FailedCount: Integer)
    var
        IntegrationLog: Record "Integration Log";
    begin
        IntegrationLog.GET(LogEntryNumber);
        IntegrationLog.Status := Status;
        IntegrationLog."Responded AT" := CURRENTDATETIME;
        IntegrationLog.SetResponseData(ResponseData);
        IntegrationLog."Returned Value" := COPYSTR(ErrorText, 1, 250);
        IntegrationLog.Success := SuccessCount;
        IntegrationLog.Failed := FailedCount;
        IntegrationLog.MODIFY;
    end;

    //[Scope('Internal')]
    procedure GetResponse(var SuccessCountP: Integer; var FailedCountP: Integer): Text
    begin
        SuccessCountP := SuccessCount;
        FailedCountP := FailedCount;
        EXIT(Response);
    end;

    //[Scope('Internal')]
    procedure InsertSalesOrder()
    var
        JObject: JsonObject;
        JSONArray: JsonArray;
        // JSONManagement: Codeunit "JSON Management";
        // ArrayString: Text;
        // JObjectL: JsonObject;
        // JSONArrayL: JsonArray;
        JTokenL: JsonToken;
        JSonResponseObjectL: JsonObject;
        JsonResponseArrayL: JsonArray;
        JsonResponseTokenL: JsonToken;
    begin
        //JSONManagement.InitializeFromString(RequestData);
        //JSONManagement.GetJSONObject(JObject);
        JObject.ReadFrom(RequestData);
        JObject.Get('SalesOrders', JTokenL);
        JSONArray := JTokenL.AsArray();
        //ArrayString := JObject.SelectToken('SalesOrders').ToString;

        //Read and Parse JSONArray
        // CLEAR(JSONManagement);
        // CLEAR(JObject);
        // JSONManagement.InitializeCollection(ArrayString);
        // JSONManagement.GetJsonArray(JSONArray);

        // CLEAR(JSONArrayL);
        // JSONArrayL := JSONArrayL.JArray;
        FailedCount := 0;
        SuccessCount := 0;
        //loop and can do insert
        FOREACH JTokenL IN JSONArray DO BEGIN
            // CLEAR(JObjectL);
            // JObjectL := JObjectL.JObject;
            JObject := JTokenL.AsObject();
            CLEAR(RecordCreation);
            RecordCreation.SetJSONRequestData(JObject, FunctionName);
            CLEARLASTERROR();
            IF RecordCreation.RUN THEN BEGIN
                JSonResponseObjectL.Add('No.', RecordCreation.GetSalesOrderNumber());
                JSonResponseObjectL.Add('Status', 'Success');
                JSonResponseObjectL.Add('Description', 'Sales Order ' + RecordCreation.GetSalesOrderNumber + ' has been inserted successfully.');
                SuccessCount += 1;
            END ELSE BEGIN
                JSonResponseObjectL.Add('No.', RecordCreation.GetSalesOrderNumber());
                JSonResponseObjectL.Add('Status', 'Failed');
                JSonResponseObjectL.Add('Description', GETLASTERRORTEXT);
                FailedCount += 1;
            END;
            //JSONManagement.AddJObjectToJArray(JSONArrayL, JObjectL);
            JsonResponseArrayL.Add(JSonResponseObjectL);
        END;
        //JSONManagement.AddJArrayToJObject(JObjectL, 'SalesOrders', JSONArrayL);
        JObject.Add('SalesOrders', JsonResponseArrayL);
        CLEAR(Response);
        //Response := JObjectL.SelectToken('SalesOrders').ToString;
        JObject.WriteTo(Response);
    end;

    //[Scope('Internal')]
    procedure SalesCanellation()
    var
        JObject: JsonObject;
        JSONArray: JsonArray;
        // JSONManagement: Codeunit "JSON Management";
        // ArrayString: Text;
        Customer: Record Customer;
        // JObjectL: JsonObject;
        // JSONArrayL: JsonArray;
        JTokenL: JsonToken;
        JSonResponseObjectL: JsonObject;
        JsonResponseArrayL: JsonArray;
        JsonResponseTokenL: JsonToken;
    begin
        // JSONManagement.InitializeFromString(RequestData);
        // JSONManagement.GetJSONObject(JObject);
        JObject.ReadFrom(RequestData);
        JObject.Get('SalesCancellations', JTokenL);
        JSONArray := JTokenL.AsArray();
        //ArrayString := JObject.SelectToken('SalesCancellations').ToString;

        //Read and Parse JSONArray
        // CLEAR(JSONManagement);
        // CLEAR(JObject);
        // JSONManagement.InitializeCollection(ArrayString);
        // JSONManagement.GetJsonArray(JSONArray);

        // CLEAR(JSONArrayL);
        // JSONArrayL := JSONArrayL.JArray;
        FailedCount := 0;
        SuccessCount := 0;
        //loop and can do insert
        FOREACH JTokenL IN JSONArray DO BEGIN
            // CLEAR(JObjectL);
            // JObjectL := JObjectL.JObject;
            JObject := JTokenL.AsObject();
            CLEAR(RecordCreation);
            RecordCreation.SetJSONRequestData(JObject, FunctionName);
            CLEARLASTERROR();
            IF RecordCreation.RUN THEN BEGIN
                JSonResponseObjectL.Add('No.', RecordCreation.GetSalesOrderNumber());
                JSonResponseObjectL.Add('Status', 'Success');
                JSonResponseObjectL.Add('Description', 'Sales Order and linked Purchase Order has been cancelled successfully.');
                SuccessCount += 1;
            END ELSE BEGIN
                JSonResponseObjectL.Add('No.', RecordCreation.GetSalesOrderNumber());
                JSonResponseObjectL.Add('Status', 'Failed');
                JSonResponseObjectL.Add('Description', GETLASTERRORTEXT);
                FailedCount += 1;
            END;
            //JSONManagement.AddJObjectToJArray(JSONArrayL, JObjectL);
            JsonResponseArrayL.Add(JSonResponseObjectL);
        END;
        JObject.Add('SalesCancellations', JsonResponseArrayL);
        //JSONManagement.AddJArrayToJObject(JObjectL, 'SalesCancellations', JSONArrayL);
        CLEAR(Response);
        //Response := JObjectL.ToString;
        JObject.WriteTo(Response);
    end;
}

