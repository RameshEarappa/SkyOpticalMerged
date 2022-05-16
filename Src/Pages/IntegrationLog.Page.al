page 50100 "Integration Log"
{
    CardPageID = "Integration Log card";
    Editable = false;
    PageType = List;
    SourceTable = "Integration Log";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Requested AT"; Rec."Requested AT")
                {
                }
                field("Function Name"; Rec."Function Name")
                {
                }
                field("Responded AT"; Rec."Responded AT")
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
}

