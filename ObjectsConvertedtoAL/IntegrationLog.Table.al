table 50001 "Integration Log"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Requested AT"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Request Data"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Function Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; URL; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Response Data"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Responded AT"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Detailed Log"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Failed,Success;
        }
        field(10; "Returned Value"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Success; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Failed; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetRequestData(NewRequestData: Text)
    var
        TempBlob: Record "99008535" temporary;
    begin
        CLEAR("Request Data");
        IF NewRequestData = '' THEN
            EXIT;
        TempBlob.Blob := "Request Data";
        TempBlob.WriteAsText(NewRequestData, TEXTENCODING::Windows);
        "Request Data" := TempBlob.Blob;
        MODIFY;
    end;

    procedure GetRequestData(): Text
    var
        TempBlob: Record "99008535" temporary;
        CR: Text[1];
    begin
        CALCFIELDS("Request Data");
        IF NOT "Request Data".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        TempBlob.Blob := "Request Data";
        EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::Windows));
    end;

    procedure SetResponseData(NewResponseData: Text)
    var
        TempBlob: Record "99008535" temporary;
    begin
        CLEAR("Response Data");
        IF NewResponseData = '' THEN
            EXIT;
        TempBlob.Blob := "Response Data";
        TempBlob.WriteAsText(NewResponseData, TEXTENCODING::Windows);
        "Response Data" := TempBlob.Blob;
        MODIFY;
    end;

    procedure GetResponseData(): Text
    var
        TempBlob: Record "99008535" temporary;
        CR: Text[1];
    begin
        CALCFIELDS("Response Data");
        IF NOT "Response Data".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        TempBlob.Blob := "Response Data";
        EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::Windows));
    end;
}

