page 50003 "Integration Log"
{
    CardPageID = "Integration Log card";
    Editable = false;
    PageType = List;
    SourceTable = Table50001;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Requested AT"; "Requested AT")
                {
                }
                field("Function Name"; "Function Name")
                {
                }
                field("Responded AT"; "Responded AT")
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
}

