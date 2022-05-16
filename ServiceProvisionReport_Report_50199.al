report 50199 "Service Provision Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Service Provision Report';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var
                PurchRcpLine: Record "Purch. Rcpt. Line";
                PurchInvLine: Record "Purch. Inv. Line";
                PurchInvHeader: Record "Purch. Inv. Header";
                RecPurchLine: Record "Purchase Line";
                InvoiceNo: Text;
                InvoiceDate: Text;
                VendorInvNo: Text;
                InvAmount: Decimal;
                CheckList: List of [Text];
                RecVendor: Record Vendor;
                RecPurchheader: Record "Purchase header";
                PurchRcptLine: Record "Purch. Rcpt. Line";
                RecPurchInvLine: Record "Purch. Inv. Line";
                RecPurchRcptLine: Record "Purch. Rcpt. Line";
            begin
                Clear(PurchRcpLine);
                PurchRcpLine.SetRange("Document No.", "No.");
                PurchRcpLine.SetRange(Type, Type);
                if not PurchRcpLine.FindFirst() then
                    CurrReport.Skip();

                Clear(InvoiceNo);
                Clear(VendorInvNo);
                Clear(InvAmount);
                Clear(InvoiceDate);
                Clear(GRNAmount);
                Clear(PurchRcptLine);


                PurchRcptLine.SetRange("Document No.", "No.");
                PurchRcptLine.SetRange(Type, Type);
                if PurchRcptLine.FindSet() then begin
                    repeat
                        GRNAmount += Round(PurchRcptLine.Quantity * PurchRcptLine."Unit Cost (LCY)", 0.01, '=');
                        TotalGRNAmount += Round(PurchRcptLine.Quantity * PurchRcptLine."Unit Cost (LCY)", 0.01, '=');

                    until PurchRcptLine.Next() = 0;
                end;
                RecPurchRcptLine.SetRange("Document No.", "No.");
                RecPurchRcptLine.SetRange(Type, Type);
                if RecPurchRcptLine.FindSet() then begin
                    repeat
                        RecPurchInvLine.Reset;
                        RecPurchInvLine.SetRange("Receipt No.", RecPurchRcptLine."No.");
                        if not RecPurchInvLine.findfirst then begin
                            //GRNAmount += Round(PurchRcptLine.Quantity * PurchRcptLine."Unit Cost (LCY)", 0.01, '=');
                            TotalGRNamtWOInv += Round(RecPurchRcptLine.Quantity * RecPurchRcptLine."Unit Cost (LCY)", 0.01, '=');
                        end;
                    until RecPurchRcptLine.Next() = 0;
                end;

                RecPurchLine.reset;
                RecpurchLine.SetRange("Receipt No.", PurchRcpLine."Document No.");
                if RecPurchLine.Findfirst then;

                Clear(PurchInvLine);
                PurchInvLine.SetRange("Receipt No.", "No.");
                PurchInvLine.SetRange(Type, Type);
                if PurchInvLine.FindSet() then begin
                    repeat
                        if not CheckList.Contains(PurchInvLine."Document No.") then begin
                            CheckList.Add(PurchInvLine."Document No.");
                            InvoiceNo += PurchInvLine."Document No." + ' /';
                            InvoiceDate += FORMAT(PurchInvLine."Posting Date", 0, '<day,2>/<month,2>/<year4>') + ' ,';
                            Clear(PurchInvHeader);
                            PurchInvHeader.SetRange("No.", PurchInvLine."Document No.");
                            if PurchInvHeader.FindFirst() then
                                VendorInvNo += PurchInvHeader."Vendor Invoice No." + ' /';
                        end;
                        InvAmount += Round(PurchInvLine."Line Amount", 0.01, '=');
                        TotalInvAmount += Round(PurchInvLine."Line Amount", 0.01, '=');
                    until PurchInvLine.Next() = 0;

                    if InvoiceNo <> '' then
                        InvoiceNo := CopyStr(InvoiceNo, 1, StrLen(InvoiceNo) - 1);
                    if InvoiceDate <> '' then
                        InvoiceDate := CopyStr(InvoiceDate, 1, StrLen(InvoiceDate) - 1);
                    if VendorInvNo <> '' then
                        VendorInvNo := CopyStr(VendorInvNo, 1, StrLen(VendorInvNo) - 1);
                end;

                RecVendor.Reset;
                RecVendor.SetRange("No.", PurchRcpLine."Buy-from Vendor No.");
                if RecVendor.findfirst then;

                RecPurchheader.reset;
                RecPurchheader.SetRange("No.", PurchRcpLine."Order No.");
                if RecPurchheader.FindFirst then;

                if (GRNAmount = 0) and ShowOnlyCancelledGRN then begin
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn(PurchRcpLine."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(FORMAT("Posting Date", 0, '<day,2>/<month,2>/<year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(GRNAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(InvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(VendorInvNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(RecVendor."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecVendor."Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchheader."Coordinator Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchheader."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchLine."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                end;

                if (GRNAmount > 0) and ShowOnlyUnpostedInvoices AND (InvoiceNo = '') then begin
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn(PurchRcpLine."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(FORMAT("Posting Date", 0, '<day,2>/<month,2>/<year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(GRNAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(InvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(VendorInvNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(RecVendor."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecVendor."Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchheader."Coordinator Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchheader."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchLine."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;

                if not ShowOnlyUnpostedInvoices AND not ShowOnlyCancelledGRN then begin
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn(PurchRcpLine."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(FORMAT("Posting Date", 0, '<day,2>/<month,2>/<year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(GRNAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(InvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(VendorInvNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(RecVendor."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecVendor."Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchheader."Coordinator Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchheader."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(RecPurchLine."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;

            end;

            trigger OnPreDataItem()
            begin
                if ((FromDate <> 0D) OR (ToDate <> 0D)) then
                    SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date : ';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date : ';
                    }
                    field(Type; Type)
                    {
                        ApplicationArea = All;
                    }
                    Field(ShowOnlyCancelledGRN; ShowOnlyCancelledGRN)
                    {
                        ApplicationArea = All;
                    }
                    Field(ShowOnlyUnpostedInvoices; ShowOnlyUnpostedInvoices)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            myInt: Integer;
        begin
            If CloseAction IN [ACTION::OK, ACTION::LookupOK] then begin
                if Type = Type::" " then
                    Error('Type must have a value.');
            end;
        end;


    }


    trigger OnPreReport()
    begin
        Clear(TotalGRNAmount);
        Clear(TotalInvAmount);
        CLEAR(TotalGRNamtWOInv);
        CLEAR(TotalinvAmtWOInv);
        MakeExcelInfo();
    end;

    trigger OnPostReport()
    begin
        AddTotalInTheLastLine();
        CreateExcelbook;
    end;






    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(FORMAT(Text103), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyName, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text105), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text102), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text104), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Service Provision Report", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text106), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text107), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddInfoColumn(TIME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;


    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Purchase Order No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Posted Invoice No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Posted Invoice Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Coordinator Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Segment', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Invoice No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    END;

    local procedure AddTotalInTheLastLine()
    begin
        if (TotalGRNAmount > 0) and not ShowOnlyUnpostedInvoices and not ShowOnlyCancelledGRN then begin
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(TotalGRNAmount, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(TotalInvAmount, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        end;
        if ShowOnlyCancelledGRN and not ShowOnlyUnpostedInvoices then begin
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        end;

        if ShowOnlyUnpostedInvoices and not ShowOnlyCancelledGRN then begin
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn((TotalGRNAmount - TotalInvAmount), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        end;

        if ShowOnlyUnpostedInvoices and ShowOnlyCancelledGRN then begin
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn((TotalGRNAmount - TotalInvAmount), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        end;

    END;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateNewBook(Text101);
        ExcelBuf.WriteSheet(Text102, COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
    end;


    var
        FromDate: Date;
        ToDate: Date;
        Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        ShowOnlyUnpostedInvoices: Boolean;
        ShowOnlyCancelledGRN: Boolean;

        //Excel Data variables
        ExcelBuf: Record 370 temporary;
        Text103: Label 'Company Name';
        Text102: Label 'Service Provision Report';
        Text104: Label 'Report No.';
        Text105: Label 'Report Name';
        Text106: Label 'User ID';
        Text107: Label 'Date / Time';
        Text101: Label 'Data';
        GRNAmount: Decimal;
        TotalGRNAmount: Decimal;
        TotalInvAmount: Decimal;
        TotalGRNamtWOInv: Decimal;
        TotalinvAmtWOInv: Decimal;

}