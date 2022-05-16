codeunit 50101 "Event Subscriber"
{
    var
        SalesHeaderG: Record "Sales Header";

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CustomerL: Record Customer;
    begin
        if Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::"Return Order"] then begin
            if CustomerL.Get(Rec."Sell-to Customer No.") then
                Rec.Branch := CustomerL.Branch;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeApprovalEntryInsert', '', false, false)]
    local procedure OnBeforeApprovalEntryInsert(ApprovalEntryArgument: Record "Approval Entry";
    var ApprovalEntry: Record "Approval Entry"; ApproverId: Code[50]; var IsHandled: Boolean;
    WorkflowStepArgument: Record "Workflow Step Argument")
    var
        GenJnlLineL: Record "Gen. Journal Line";
        WarehouseJournalLine: Record "Warehouse Journal Line";
        ItemJournalLine: Record "Item Journal Line";
        SalesHeaderL: Record "Sales Header";
        LocationL: Record Location;
        SalesLineL: Record "Sales Line";
        ItemL: Record Item;
        ItemNoL: Text;
        CustomerL: Record Customer;
        TotalQty: Integer;
        cust: Record "Cust. Ledger Entry";
    begin
        GenJnlLineL.SetRange("Document No.", ApprovalEntryArgument."Document No.");
        if GenJnlLineL.FindSet() then begin
            repeat
                ApprovalEntry."Total Debit" := GenJnlLineL."Total Debit";
                ApprovalEntry."Total Credit" := GenJnlLineL."Total Credit";
                ApprovalEntry."Posting Date" := GenJnlLineL."Posting Date";
                ApprovalEntry."Account No." := GenJnlLineL."Account No.";
                ApprovalEntry."Bal.Account No." := GenJnlLineL."Bal. Account No.";
                ApprovalEntry.Description := GenJnlLineL.Description;
            until GenJnlLineL.Next() = 0;
        end;
        WarehouseJournalLine.SetRange("Whse. Document No.", ApprovalEntryArgument."Document No.");
        if WarehouseJournalLine.FindSet() then begin
            repeat
                ApprovalEntry."Item No_LT" := WarehouseJournalLine."Item No.";
                ApprovalEntry.Description := WarehouseJournalLine.Description;
                ApprovalEntry.Quantity_LT := WarehouseJournalLine.Quantity;
            until WarehouseJournalLine.Next() = 0;
        end;
        ItemJournalLine.SetRange("Document No.", ApprovalEntryArgument."Document No.");
        if ItemJournalLine.FindSet() then begin
            repeat
                ApprovalEntry."Item No_LT" := ItemJournalLine."Item No.";
                ApprovalEntry.Description := ItemJournalLine.Description;
                ApprovalEntry.Quantity_LT := ItemJournalLine.Quantity;
                ApprovalEntry.Amount := ItemJournalLine.Amount;
            until ItemJournalLine.Next() = 0;
        end;

        //SalesOrder Approval Workflow
        //checking quantity mentioned in the sales order exceeds the available Qty.
        //If Exceeds then sending request to warehouse executive.
        if ApprovalEntry."Table ID" = DATABASE::"Sales Header" then
            if SalesHeaderL.Get(SalesHeaderL."Document Type"::Order, ApprovalEntryArgument."Document No.") then begin
                SalesHeaderL.CalcFields("Amount Including VAT");
                if LocationL.Get(SalesHeaderL."Location Code") then;
                LocationL.TestField(Executive);
                SalesLineL.SetRange("Document Type", SalesLineL."Document Type"::Order);
                SalesLineL.SetRange("Document No.", ApprovalEntry."Document No.");
                if SalesLineL.FindSet() then
                    repeat
                        if ItemL.Get(SalesLineL."No.") then
                            ItemL.CalcFields(Inventory);
                        if ItemL.Inventory < SalesLineL.Quantity then
                            ItemNoL := SalesLineL."No.";
                    until (SalesLineL.Next() = 0) or (ItemNoL <> '');
                if ItemNoL <> '' then
                    ApprovalEntry."Approver ID" := LocationL.Executive
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCreateApprovalRequests', '', false, false)]
    local procedure OnBeforeCreateApprovalRequests(RecRef: RecordRef; var IsHandled: Boolean;
    WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        TransferHeaderL: Record "Transfer Header";
        LocationL: Record Location;
        workflowUser: Record "Workflow User Group";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if TransferHeaderL.Get(RecRef.Field(1)) then begin
            if LocationL.Get(TransferHeaderL."Transfer-from Code") then
                if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
                    if workflowUser.Get(WorkflowStepArgument."Workflow User Group Code") then begin
                        WorkflowUserGroupMember.SetRange("Workflow User Group Code", workflowUser.Code);
                        if WorkflowUserGroupMember.FindFirst() then begin
                            WorkflowUserGroupMember.Delete();
                            WorkflowUserGroupMember.Init();
                            WorkflowUserGroupMember."Workflow User Group Code" := workflowUser.Code;
                            WorkflowUserGroupMember.Validate("User Name", LocationL.Executive);
                            WorkflowUserGroupMember.Insert()
                        end;
                    end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Transfer Order", 'OnBeforeSendApprovalRequest', '', false, false)]
    local procedure OnBeforeSendApprovalRequest(var Rec: Record "Transfer Header"; var IsHandled: Boolean)
    var
        LocationL: Record Location;
    begin
        if LocationL.Get(Rec."Transfer-from Code") then begin
            LocationL.TestField(Executive);
            if Rec."Created By API" then
                if not LocationL."Approval 4 VAN Loading TO" then begin
                    Rec."Workflow Status" := Rec."Workflow Status"::Approved;
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify(true);
                    IsHandled := true;
                end;
            //LocationL.TestField("Approval 4 VAN Loading TO", true);
            if Rec."VAN Unloading TO" then
                if not LocationL."Approval 4 VAN Unloading TO" then begin
                    Rec."Workflow Status" := Rec."Workflow Status"::Approved;
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify(true);
                    IsHandled := true;
                end;
            //LocationL.TestField("Approval 4 VAN Unloading TO", true);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Phys. Inventory Journal EOD", 'OnBeforeSendApprovalRequest', '', false, false)]
    local procedure OnBeforeSendApprovalRequestAfterCreateTransferOrder(var IsHandled: Boolean; var Rec: Record "Item Journal Line"; Var Transferheader: Record "Transfer Header")
    var
        LocationL: Record Location;
        TransferHeaderL: Record "Transfer Header";
    begin
        if LocationL.Get(Rec."Location Code") then
            if not LocationL."Approval 4 VAN Unloading TO" then
                if TransferHeaderL.Get(Transferheader."No.") then begin
                    TransferHeaderL."Workflow Status" := TransferHeaderL."Workflow Status"::Approved;
                    TransferHeaderL.Status := TransferHeaderL.Status::Released;
                    TransferHeaderL.Modify(true);
                    IsHandled := true;
                end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalespriceL: Record "Sales Price";
    begin
        if Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice] then begin
            if Rec.Type = Rec.Type::Item then begin
                SalespriceL.SetRange("Item No.", Rec."No.");
                SalespriceL.SetRange(Status, SalespriceL.Status::Open);
                if SalespriceL.FindFirst() then
                    Error('Item %1, Cannot be used. Status should be approved in sales price table', Rec."No.");
            end;
        end;
    end;

    //SalesOrder Approval Workflow
    //checking quantity mentioned in the sales order exceeds the available Qty and Credit Limit.
    //If not exceeds then updating the status in sales order and skipping the approval request. 
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeMakeApprovalEntry', '', false, false)]
    // local procedure OnBeforeMakeApprovalEntry(ApprovalEntryArgument: Record "Approval Entry";
    // var ApprovalEntry: Record "Approval Entry"; ApproverId: Code[50]; var IsHandled: Boolean;
    // WorkflowStepArgument: Record "Workflow Step Argument")
    // var
    //     SalesHeaderL: Record "Sales Header";
    //     SalesLineL: Record "Sales Line";
    //     ItemL: Record Item;
    //     ItemNoL: Text;
    //     LocationL: Record Location;
    //     CustomerL: Record Customer;
    //     CustL: Record Customer;
    //     TotalQty: Integer;
    //     DimensionValue: Record "Dimension Value";
    //     TotalBalanceL: Integer;
    //     IntegrationSetupL: Record "Integration Setup";
    //     BinContentL: Record "Bin Content";
    // begin
    //     Clear(SalesHeaderG);
    //     IntegrationSetupL.Get();
    //     if ApprovalEntryArgument."Table ID" = DATABASE::"Sales Header" then begin
    //         if SalesHeaderG.Get(SalesHeaderG."Document Type"::Order, ApprovalEntryArgument."Document No.") then begin
    //             SalesHeaderG.CalcFields("Amount Including VAT");
    //             SalesLineL.SetRange("Document Type", SalesLineL."Document Type"::Order);
    //             SalesLineL.SetRange("Document No.", ApprovalEntryArgument."Document No.");
    //             if SalesLineL.FindSet() then begin
    //                 SalesLineL.CalcSums(Quantity);
    //                 TotalQty := SalesLineL.Quantity;
    //                 repeat
    //                     BinContentL.SetRange("Location Code", SalesLineL."Location Code");
    //                     BinContentL.SetRange("Item No.", SalesLineL."No.");
    //                     if BinContentL.FindFirst() then
    //                         // if ItemL.Get(SalesLineL."No.") then
    //                         //     ItemL.CalcFields(Inventory);
    //                         // if ItemL.Inventory < SalesLineL.Quantity then
    //                         ItemNoL := BinContentL."Item No.";
    //                 until (SalesLineL.Next() = 0) or (ItemNoL <> '');
    //             end;
    //             if ItemNoL <> '' then begin
    //                 if SalesHeaderG."Sales Channel Type" = 'KEY ACCOUNT' then begin
    //                     CustomerL.SetRange("No.", SalesHeaderG."Sell-to Customer No.");
    //                     CustomerL.SetRange("Sales Channel Type", SalesHeaderG."Sales Channel Type");
    //                     if CustomerL.FindFirst() then begin
    //                         DimensionValue.SetRange(Code, CustomerL."Key Account");
    //                         if DimensionValue.FindFirst() then;
    //                         CustL.SetRange("No.", CustomerL."No.");
    //                         CustL.SetRange("Sales Channel Type", CustomerL."Sales Channel Type");
    //                         CustL.SetRange("Key Account", DimensionValue.Code);
    //                         if CustL.FindSet() then begin
    //                             CustL.CalcFields("Balance (LCY)", "Balance Due (LCY)");
    //                             CustL.CalcSums("Balance Due (LCY)");
    //                             TotalBalanceL := CustL."Balance Due (LCY)";
    //                             if CustL."Maximum SO Quantity" >= TotalQty then
    //                                 if CustL."Maximum SO Value" >= SalesHeaderG."Amount Including VAT" then
    //                                     if CustL."Balance (LCY)" >= CustL."Balance (LCY)" + SalesHeaderG."Amount Including VAT" then
    //                                         if TotalBalanceL <= IntegrationSetupL."Minimum Balance Due LT" then begin
    //                                             SalesHeaderG.Status := SalesHeaderG.Status::Released;
    //                                             SalesHeaderG.Modify();
    //                                             IsHandled := true;
    //                                         end;
    //                         end;
    //                     end;
    //                 end else begin
    //                     if CustomerL.Get(SalesHeaderG."Sell-to Customer No.") then begin
    //                         CustomerL.CalcFields("Balance (LCY)", "Balance Due (LCY)");
    //                         if CustomerL."Maximum SO Quantity" > TotalQty then
    //                             if CustomerL."Maximum SO Value" > SalesHeaderG."Amount Including VAT" then
    //                                 if CustomerL."Balance (LCY)" > CustomerL."Balance (LCY)" + SalesHeaderG."Amount Including VAT" then
    //                                     if CustomerL."Balance Due (LCY)" <= IntegrationSetupL."Minimum Balance Due LT" then begin
    //                                         SalesHeaderG.Status := SalesHeaderG.Status::Released;
    //                                         SalesHeaderG.Modify();
    //                                         IsHandled := true;
    //                                     end;
    //                     end;
    //                 end;
    //             end;
    //         end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventQuantity(CurrFieldNo: Integer; var Rec: Record "Sales Line";
    var xRec: Record "Sales Line")
    var
        ItemL: Record Item;
    begin
        if ItemL.Get(Rec."No.") then begin
            ItemL.CalcFields(Inventory);
            if ItemL.Inventory < Rec.Quantity then
                Rec."Exceed LT" := true;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforeWhseShptHeaderInsert(var WarehouseRequest: Record "Warehouse Request";
    SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; TransferLine: Record "Transfer Line";
    var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        WarehouseShipmentHeader."Sell-to Customer No. LT" := SalesHeader."Sell-to Customer No.";
        WarehouseShipmentHeader."Sell-to Customer Name LT" := SalesHeader."Sell-to Customer Name";
        WarehouseShipmentHeader."Salesperson Code" := SalesHeader."Salesperson Code";
        WarehouseShipmentHeader.Branch := SalesHeader.Branch;
        WarehouseShipmentHeader."Ship-to Code LT" := SalesHeader."Ship-to Code";
        WarehouseShipmentHeader."Bill-to Post Code LT" := SalesHeader."Bill-to Post Code";
        WarehouseShipmentHeader."Ship-to Post Code LT" := SalesHeader."Ship-to Post Code";
        WarehouseShipmentHeader."SO Shipment LT" := true;
    end;

    //SalesOrder Approval Workflow
    //checking quantity mentioned in the sales order exceeds the available Qty and Credit Limit.
    //If not exceeds then updating the status in sales order and skipping the approval request. 
    procedure CheckCreditLimitBeforeApprovalRequest(Var SalesHeaderP: Record "Sales Header"): Boolean
    var
        SalesHeaderL: Record "Sales Header";
        SalesLineL: Record "Sales Line";
        ItemL: Record Item;
        ItemNoL: Text;
        LocationL: Record Location;
        CustomerL: Record Customer;
        CustL: Record Customer;
        TotalQty: Integer;
        DimensionValue: Record "Dimension Value";
        TotalBalanceL: Integer;
        IntegrationSetupL: Record "Integration Setup";
        BinContentL: Record "Bin Content";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        Clear(SalesHeaderG);
        IntegrationSetupL.Get();
        if SalesHeaderG.Get(SalesHeaderG."Document Type"::Order, SalesHeaderP."No.") then begin
            SalesHeaderG.CalcFields("Amount Including VAT");
            SalesLineL.SetRange("Document Type", SalesLineL."Document Type"::Order);
            SalesLineL.SetRange("Document No.", SalesHeaderG."No.");
            if SalesLineL.FindSet() then begin
                SalesLineL.CalcSums(Quantity);
                TotalQty := SalesLineL.Quantity;
                repeat
                    BinContentL.SetRange("Location Code", SalesLineL."Location Code");
                    BinContentL.SetRange("Item No.", SalesLineL."No.");
                    if not BinContentL.FindFirst() then
                        exit(false);
                until (SalesLineL.Next() = 0);//or (ItemNoL <> '');
            end;
            // if ItemNoL <> '' then begin
            if SalesHeaderG."Sales Channel Type" = 'KEY ACCOUNT' then begin
                CustomerL.SetRange("No.", SalesHeaderG."Sell-to Customer No.");
                CustomerL.SetRange("Sales Channel Type", SalesHeaderG."Sales Channel Type");
                if CustomerL.FindFirst() then begin
                    DimensionValue.SetRange(Code, CustomerL."Key Account");
                    if DimensionValue.FindFirst() then;
                    CustL.SetRange("No.", CustomerL."No.");
                    CustL.SetRange("Sales Channel Type", CustomerL."Sales Channel Type");
                    CustL.SetRange("Key Account", DimensionValue.Code);
                    if CustL.FindSet() then begin
                        CustL.CalcFields("Balance (LCY)", "Balance Due (LCY)");
                        CustL.CalcSums("Balance Due (LCY)");
                        TotalBalanceL := CustL."Balance Due (LCY)";
                        if CustL."Maximum SO Quantity" >= TotalQty then
                            if CustL."Maximum SO Value" >= SalesHeaderG."Amount Including VAT" then
                                if CustL."Balance (LCY)" >= CustL."Balance (LCY)" + SalesHeaderG."Amount Including VAT" then
                                    if TotalBalanceL <= IntegrationSetupL."Minimum Balance Due LT" then begin
                                        ReleaseSalesDoc.PerformManualRelease(SalesHeaderG);
                                        // SalesHeaderG.Status := SalesHeaderG.Status::Released;
                                        // SalesHeaderG.Modify();
                                        exit(true);
                                    end;
                    end;
                end else begin
                    if CustomerL.Get(SalesHeaderG."Sell-to Customer No.") then begin
                        CustomerL.CalcFields("Balance (LCY)", "Balance Due (LCY)");
                        if CustomerL."Maximum SO Quantity" > TotalQty then
                            if CustomerL."Maximum SO Value" > SalesHeaderG."Amount Including VAT" then
                                if CustomerL."Balance (LCY)" > CustomerL."Balance (LCY)" + SalesHeaderG."Amount Including VAT" then
                                    if CustomerL."Balance Due (LCY)" <= IntegrationSetupL."Minimum Balance Due LT" then begin
                                        // SalesHeaderG.Status := SalesHeaderG.Status::Released;
                                        // SalesHeaderG.Modify();
                                        ReleaseSalesDoc.PerformManualRelease(SalesHeaderG);
                                        exit(true);
                                    end;
                    end;
                end;
            end;
        end;
    end;
}