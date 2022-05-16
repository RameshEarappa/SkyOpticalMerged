page 50101 "Integration Log card"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Integration Log";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Requested AT"; Rec."Requested AT")
                {
                }
                field("Request Data"; RequestData)
                {
                    MultiLine = true;
                }
                field("Function Name"; Rec."Function Name")
                {
                }
                field(URL; Rec.URL)
                {
                }
                field("Response Data"; ResponseData)
                {
                    MultiLine = true;
                }
                field("Responded AT"; Rec."Responded AT")
                {
                }
                field("Detailed Log"; Rec."Detailed Log")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Returned Value"; Rec."Returned Value")
                {
                }
                field(Success; Rec.Success)
                {
                }
                field(Failed; Rec.Failed)
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
        //RequestData := Rec.GetRequestData;
        //ResponseData := Rec.GetResponseData;
    end;

    var
        RequestData: Text;
        ResponseData: Text;
}

