codeunit 50001 "Magento Inbound Integration"
{

    trigger OnRun()
    var
        testText: Text;
    begin
        testText := '{"Customers": [{"Customer_ID": "373561","Customer Group": "General","Customer Name": "John Doe","Customer Email": "johndoe@example.com","Associated to Website": "Main Website","Billing Address Customer Street": "Trg slobode 6","Billing Address City": "Osijek","Billing Address Postcode": "31000","Billing Address Region": "Osjecko-baranjska županija","Billing Address Country": "Croatia"}]}';
        MESSAGE(CreateCustomer(testText));
    end;

    var
        IntegrationUtility: Codeunit "50003";

    [Scope('Internal')]
    procedure CreateCustomer(RequestData: Text): Text
    var
        LogEntryNumber: Integer;
        ResponseData: Text;
        Status: Option Failed,Success;
        SuccessCount: Integer;
        FailedCount: Integer;
    begin
        LogEntryNumber := IntegrationUtility.InsertLog(RequestData, 'IMPORT CUSTOMER');
        COMMIT;
        CLEARLASTERROR;
        IntegrationUtility.SetData('IMPORT CUSTOMER', RequestData);
        IF IntegrationUtility.RUN THEN BEGIN
            ResponseData := IntegrationUtility.GetResponse(SuccessCount, FailedCount);
            IntegrationUtility.ModifyLog(LogEntryNumber, Status::Success, ResponseData, ResponseData, SuccessCount, FailedCount);
            EXIT(ResponseData);
        END ELSE BEGIN
            ResponseData := COPYSTR(GETLASTERRORTEXT, 1, 250);
            IntegrationUtility.ModifyLog(LogEntryNumber, Status::Failed, ResponseData, ResponseData, SuccessCount, FailedCount);
            EXIT(ResponseData);
        END;
    end;

    [Scope('Internal')]
    procedure CreateSalesOrder(RequestData: Text): Text
    var
        LogEntryNumber: Integer;
        ResponseData: Text;
        Status: Option Failed,Success;
        SuccessCount: Integer;
        FailedCount: Integer;
    begin
        LogEntryNumber := IntegrationUtility.InsertLog(RequestData, 'IMPORT SALESORDER');
        COMMIT;
        CLEARLASTERROR;
        IntegrationUtility.SetData('IMPORT SALESORDER', RequestData);
        IF IntegrationUtility.RUN THEN BEGIN
            ResponseData := IntegrationUtility.GetResponse(SuccessCount, FailedCount);
            IntegrationUtility.ModifyLog(LogEntryNumber, Status::Success, ResponseData, ResponseData, SuccessCount, FailedCount);
            EXIT(ResponseData);
        END ELSE BEGIN
            ResponseData := COPYSTR(GETLASTERRORTEXT, 1, 250);
            IntegrationUtility.ModifyLog(LogEntryNumber, Status::Failed, ResponseData, ResponseData, SuccessCount, FailedCount);
            EXIT(ResponseData);
        END;
    end;

    [Scope('Internal')]
    procedure SalesCancellation(RequestData: Text): Text
    var
        LogEntryNumber: Integer;
        ResponseData: Text;
        Status: Option Failed,Success;
        SuccessCount: Integer;
        FailedCount: Integer;
    begin
        LogEntryNumber := IntegrationUtility.InsertLog(RequestData, 'SALES CANCELLATION');
        COMMIT;
        CLEARLASTERROR;
        IntegrationUtility.SetData('SALES CANCELLATION', RequestData);
        IF IntegrationUtility.RUN THEN BEGIN
            ResponseData := IntegrationUtility.GetResponse(SuccessCount, FailedCount);
            IntegrationUtility.ModifyLog(LogEntryNumber, Status::Success, ResponseData, ResponseData, SuccessCount, FailedCount);
            EXIT(ResponseData);
        END ELSE BEGIN
            ResponseData := COPYSTR(GETLASTERRORTEXT, 1, 250);
            IntegrationUtility.ModifyLog(LogEntryNumber, Status::Failed, ResponseData, ResponseData, SuccessCount, FailedCount);
            EXIT(ResponseData);
        END;
    end;
}

