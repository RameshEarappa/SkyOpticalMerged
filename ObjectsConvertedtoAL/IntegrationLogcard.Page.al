page 50004 "Integration Log card"
{
    Editable = false;
    PageType = Card;
    SourceTable = Table50001;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Requested AT"; "Requested AT")
                {
                }
                field("Request Data"; RequestData)
                {
                    MultiLine = true;
                }
                field("Function Name"; "Function Name")
                {
                }
                field(URL; URL)
                {
                }
                field("Response Data"; ResponseData)
                {
                    MultiLine = true;
                }
                field("Responded AT"; "Responded AT")
                {
                }
                field("Detailed Log"; "Detailed Log")
                {
                }
                field(Status; Status)
                {
                }
                field("Returned Value"; "Returned Value")
                {
                }
                field(Success; Success)
                {
                }
                field(Failed; Failed)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        RequestData := Rec.GetRequestData;
        ResponseData := Rec.GetResponseData;
    end;

    var
        RequestData: Text;
        ResponseData: Text;
}

