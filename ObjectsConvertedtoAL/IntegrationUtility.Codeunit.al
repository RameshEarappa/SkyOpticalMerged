codeunit 50003 "Integration Utility"
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
        RecordCreation: Codeunit "50002";
        FailedCount: Integer;
        SuccessCount: Integer;

    [Scope('Internal')]
    procedure InsertCustomer()
    var
        JObject: DotNet JObject;
        JSONArray: DotNet JArray;
        JSONManagement: Codeunit "5459";
        ArrayString: Text;
        Customer: Record "18";
        JObjectL: DotNet JObject;
        JSONArrayL: DotNet JArray;
    begin
        JSONManagement.InitializeFromString(RequestData);
        JSONManagement.GetJSONObject(JObject);
        ArrayString := JObject.SelectToken('Customers').ToString;

        //Read and Parse JSONArray
        CLEAR(JSONManagement);
        CLEAR(JObject);
        JSONManagement.InitializeCollection(ArrayString);
        JSONManagement.GetJsonArray(JSONArray);

        CLEAR(JSONArrayL);
        JSONArrayL := JSONArrayL.JArray;
        FailedCount := 0;
        SuccessCount := 0;
        //loop and can do insert
        FOREACH JObject IN JSONArray DO BEGIN
            CLEAR(JObjectL);
            JObjectL := JObjectL.JObject;
            CLEAR(RecordCreation);
            RecordCreation.SetJSONRequestData(JObject, FunctionName);
            CLEARLASTERROR();
            IF RecordCreation.RUN THEN BEGIN
                JSONManagement.AddJPropertyToJObject(JObjectL, 'No.', RecordCreation.GetCustomerNumber());
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Status', 'Success');
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Description', 'Customer ' + RecordCreation.GetCustomerNumber + ' has been inserted/modified successfully.');
                SuccessCount += 1;
            END ELSE BEGIN
                JSONManagement.AddJPropertyToJObject(JObjectL, 'No.', RecordCreation.GetCustomerNumber());
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Status', 'Failed');
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Description', GETLASTERRORTEXT);
                FailedCount += 1;
            END;
            JSONManagement.AddJObjectToJArray(JSONArrayL, JObjectL);
        END;
        CLEAR(JObjectL);
        JObjectL := JObjectL.JObject;
        JSONManagement.AddJArrayToJObject(JObjectL, 'Customers', JSONArrayL);
        CLEAR(Response);
        Response := JObjectL.ToString;
    end;

    [Scope('Internal')]
    procedure SetData("Function": Text; RequestDataL: Text)
    begin
        FunctionName := "Function";
        RequestData := RequestDataL;
    end;

    [Scope('Internal')]
    procedure InsertLog(RequestData: Text; FunctionName: Text): Integer
    var
        IntegrationLog: Record "50001";
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

    [Scope('Internal')]
    procedure ModifyLog(LogEntryNumber: Integer; Status: Option Failed,Success; ResponseData: Text; ErrorText: Text; SuccessCount: Integer; FailedCount: Integer)
    var
        IntegrationLog: Record "50001";
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

    [Scope('Internal')]
    procedure GetResponse(var SuccessCountP: Integer; var FailedCountP: Integer): Text
    begin
        SuccessCountP := SuccessCount;
        FailedCountP := FailedCount;
        EXIT(Response);
    end;

    [Scope('Internal')]
    procedure InsertSalesOrder()
    var
        JObject: DotNet JObject;
        JSONArray: DotNet JArray;
        JSONManagement: Codeunit "5459";
        ArrayString: Text;
        JObjectL: DotNet JObject;
        JSONArrayL: DotNet JArray;
    begin
        JSONManagement.InitializeFromString(RequestData);
        JSONManagement.GetJSONObject(JObject);
        ArrayString := JObject.SelectToken('SalesOrders').ToString;

        //Read and Parse JSONArray
        CLEAR(JSONManagement);
        CLEAR(JObject);
        JSONManagement.InitializeCollection(ArrayString);
        JSONManagement.GetJsonArray(JSONArray);

        CLEAR(JSONArrayL);
        JSONArrayL := JSONArrayL.JArray;
        FailedCount := 0;
        SuccessCount := 0;
        //loop and can do insert
        FOREACH JObject IN JSONArray DO BEGIN
            CLEAR(JObjectL);
            JObjectL := JObjectL.JObject;
            CLEAR(RecordCreation);
            RecordCreation.SetJSONRequestData(JObject, FunctionName);
            CLEARLASTERROR();
            IF RecordCreation.RUN THEN BEGIN
                JSONManagement.AddJPropertyToJObject(JObjectL, 'No.', RecordCreation.GetSalesOrderNumber());
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Status', 'Success');
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Description', 'Sales Order ' + RecordCreation.GetSalesOrderNumber + ' has been inserted successfully.');
                SuccessCount += 1;
            END ELSE BEGIN
                JSONManagement.AddJPropertyToJObject(JObjectL, 'No.', RecordCreation.GetSalesOrderNumber());
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Status', 'Failed');
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Description', GETLASTERRORTEXT);
                FailedCount += 1;
            END;
            JSONManagement.AddJObjectToJArray(JSONArrayL, JObjectL);
        END;
        CLEAR(JObjectL);
        JObjectL := JObjectL.JObject;
        JSONManagement.AddJArrayToJObject(JObjectL, 'SalesOrders', JSONArrayL);
        CLEAR(Response);
        Response := JObjectL.SelectToken('SalesOrders').ToString;
    end;

    [Scope('Internal')]
    procedure SalesCanellation()
    var
        JObject: DotNet JObject;
        JSONArray: DotNet JArray;
        JSONManagement: Codeunit "5459";
        ArrayString: Text;
        Customer: Record "18";
        JObjectL: DotNet JObject;
        JSONArrayL: DotNet JArray;
    begin
        JSONManagement.InitializeFromString(RequestData);
        JSONManagement.GetJSONObject(JObject);
        ArrayString := JObject.SelectToken('SalesCancellations').ToString;

        //Read and Parse JSONArray
        CLEAR(JSONManagement);
        CLEAR(JObject);
        JSONManagement.InitializeCollection(ArrayString);
        JSONManagement.GetJsonArray(JSONArray);

        CLEAR(JSONArrayL);
        JSONArrayL := JSONArrayL.JArray;
        FailedCount := 0;
        SuccessCount := 0;
        //loop and can do insert
        FOREACH JObject IN JSONArray DO BEGIN
            CLEAR(JObjectL);
            JObjectL := JObjectL.JObject;
            CLEAR(RecordCreation);
            RecordCreation.SetJSONRequestData(JObject, FunctionName);
            CLEARLASTERROR();
            IF RecordCreation.RUN THEN BEGIN
                JSONManagement.AddJPropertyToJObject(JObjectL, 'No.', RecordCreation.GetSalesOrderNumber());
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Status', 'Success');
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Description', 'Sales Order and linked Purchase Order has been cancelled successfully.');
                SuccessCount += 1;
            END ELSE BEGIN
                JSONManagement.AddJPropertyToJObject(JObjectL, 'No.', RecordCreation.GetSalesOrderNumber());
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Status', 'Failed');
                JSONManagement.AddJPropertyToJObject(JObjectL, 'Description', GETLASTERRORTEXT);
                FailedCount += 1;
            END;
            JSONManagement.AddJObjectToJArray(JSONArrayL, JObjectL);
        END;
        CLEAR(JObjectL);
        JObjectL := JObjectL.JObject;
        JSONManagement.AddJArrayToJObject(JObjectL, 'SalesCancellations', JSONArrayL);
        CLEAR(Response);
        Response := JObjectL.ToString;
    end;
}

