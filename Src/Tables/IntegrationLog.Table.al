table 50100 "Integration Log"
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
        //TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
    begin
        // CLEAR("Request Data");
        // IF NewRequestData = '' THEN
        //     EXIT;
        // TempBlob.Blob := "Request Data";
        // TempBlob.WriteAsText(NewRequestData, TEXTENCODING::Windows);
        // "Request Data" := TempBlob.Blob;
        // MODIFY;
        Clear("Request Data");
        "Request Data".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewRequestData);
    end;

    procedure GetRequestData(): Text
    var
        //TempBlob: Record "99008535" temporary;
        //CR: Text[1];
        InStream: InStream;
        TypeHelper: Codeunit "Type Helper";
    begin
        // CALCFIELDS("Request Data");
        // IF NOT "Request Data".HASVALUE THEN
        //     EXIT('');
        // CR[1] := 10;
        // TempBlob.Blob := "Request Data";
        // EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::Windows));
        CalcFields("Request Data");
        "Request Data".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SetResponseData(NewResponseData: Text)
    var
        //TempBlob: Record "99008535" temporary;
        OutStream: OutStream;
    begin
        // CLEAR("Response Data");
        // IF NewResponseData = '' THEN
        //     EXIT;
        // TempBlob.Blob := "Response Data";
        // TempBlob.WriteAsText(NewResponseData, TEXTENCODING::Windows);
        // "Response Data" := TempBlob.Blob;
        // MODIFY;
        Clear("Response Data");
        "Response Data".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewResponseData);
    end;

    procedure GetResponseData(): Text
    var
        // TempBlob: Record "99008535" temporary;
        // CR: Text[1];
        InStream: InStream;
        TypeHelper: Codeunit "Type Helper";
    begin
        // CALCFIELDS("Response Data");
        // IF NOT "Response Data".HASVALUE THEN
        //     EXIT('');
        // CR[1] := 10;
        // TempBlob.Blob := "Response Data";
        // EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::Windows));
        CalcFields("Response Data");
        "Response Data".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}

