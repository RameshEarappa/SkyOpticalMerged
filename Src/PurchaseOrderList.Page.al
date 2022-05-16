// page 9307 "Purchase Order List"
// {
//     Caption = 'Purchase Orders';
//     CardPageID = "Purchase Order";
//     DataCaptionFields = "Buy-from Vendor No.";
//     Editable = false;
//     PageType = List;
//     PromotedActionCategories = 'New,Process,Report,Request Approval,Print';
//     RefreshOnActivate = true;
//     SourceTable = Table38;
//     SourceTableView = WHERE(Document Type=CONST(Order),
//                             Cancelled=CONST(No));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
//                 }
//                 field("Buy-from Vendor No."; "Buy-from Vendor No.")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the name of the vendor who delivered the items.';
//                 }
//                 field("Order Address Code"; "Order Address Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the order address of the related vendor.';
//                     Visible = false;
//                 }
//                 field("Buy-from Vendor Name"; "Buy-from Vendor Name")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the name of the vendor who delivered the items.';
//                 }
//                 field("Vendor Authorization No."; "Vendor Authorization No.")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the compensation agreement identification number, sometimes referred to as the RMA No. (Returns Materials Authorization).';
//                 }
//                 field("Buy-from Post Code"; "Buy-from Post Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the post code of the vendor who delivered the items.';
//                     Visible = false;
//                 }
//                 field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the city of the vendor who delivered the items.';
//                     Visible = false;
//                 }
//                 field("Buy-from Contact"; "Buy-from Contact")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the name of the contact person at the vendor who delivered the items.';
//                     Visible = false;
//                 }
//                 field("Pay-to Vendor No."; "Pay-to Vendor No.")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
//                     Visible = false;
//                 }
//                 field("Pay-to Name"; "Pay-to Name")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the name of the vendor who you received the invoice from.';
//                     Visible = false;
//                 }
//                 field("Pay-to Post Code"; "Pay-to Post Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the post code of the vendor that you received the invoice from.';
//                     Visible = false;
//                 }
//                 field("Pay-to Country/Region Code"; "Pay-to Country/Region Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the country/region code of the address.';
//                     Visible = false;
//                 }
//                 field("Pay-to Contact"; "Pay-to Contact")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the name of the person to contact about an invoice from this vendor.';
//                     Visible = false;
//                 }
//                 field("Ship-to Code"; "Ship-to Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
//                     Visible = false;
//                 }
//                 field("Ship-to Name"; "Ship-to Name")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the name of the customer at the address that the items are shipped to.';
//                     Visible = false;
//                 }
//                 field("Ship-to Post Code"; "Ship-to Post Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the postal code of the address that the items are shipped to.';
//                     Visible = false;
//                 }
//                 field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the country/region code of the address that the items are shipped to.';
//                     Visible = false;
//                 }
//                 field("Ship-to Contact"; "Ship-to Contact")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the name of the contact person at the address that the items are shipped to.';
//                     Visible = false;
//                 }
//                 field("Posting Date"; "Posting Date")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
//                     Visible = false;
//                 }
//                 field("Location Code"; "Location Code")
//                 {
//                     ApplicationArea = Location;
//                     ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
//                 }
//                 field("Purchaser Code"; "Purchaser Code")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies which purchaser is assigned to the vendor.';
//                     Visible = false;
//                 }
//                 field("Assigned User ID"; "Assigned User ID")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the ID of the user who is responsible for the document.';
//                 }
//                 field("Currency Code"; "Currency Code")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the code of the currency of the amounts on the purchase lines.';
//                     Visible = false;
//                 }
//                 field("Document Date"; "Document Date")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the date when the related document was created.';
//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
//                     Visible = false;
//                 }
//                 field("Payment Terms Code"; "Payment Terms Code")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
//                     Visible = false;
//                 }
//                 field("Due Date"; "Due Date")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies when the purchase invoice is due for payment.';
//                     Visible = false;
//                 }
//                 field("Payment Discount %"; "Payment Discount %")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
//                     Visible = false;
//                 }
//                 field("Payment Method Code"; "Payment Method Code")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies how to make payment, such as with bank transfer, cash,  or check.';
//                     Visible = false;
//                 }
//                 field("Shipment Method Code"; "Shipment Method Code")
//                 {
//                     ApplicationArea = Advanced;
//                     ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
//                     Visible = false;
//                 }
//                 field("Requested Receipt Date"; "Requested Receipt Date")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.';
//                     Visible = false;
//                 }
//                 field("Job Queue Status"; "Job Queue Status")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the status of a job queue entry that handles the posting of purchase orders.';
//                     Visible = JobQueueActive;
//                 }
//                 field("Amount Received Not Invoiced excl. VAT (LCY)"; "A. Rcd. Not Inv. Ex. VAT (LCY)")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies the amount excluding VAT for the items on the order that have been received but are not yet invoiced.';
//                     Visible = false;
//                 }
//                 field("Amount Received Not Invoiced (LCY)"; "Amt. Rcd. Not Invoiced (LCY)")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies the sum, in LCY, for items that have been received but have not yet been invoiced. The value in the Amt. Rcd. Not Invoiced (LCY) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.';
//                     Visible = false;
//                 }
//                 field(Amount; Amount)
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the sum of amounts in the Line Amount field on the purchase order lines.';
//                 }
//                 field("Amount Including VAT"; "Amount Including VAT")
//                 {
//                     ApplicationArea = Suite;
//                     ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(IncomingDocAttachFactBox; 193)
//             {
//                 ApplicationArea = Suite;
//                 ShowFilter = false;
//                 Visible = false;
//             }
//             part(; 9093)
//             {
//                 ApplicationArea = Suite;
//                 SubPageLink = No.=FIELD(Buy-from Vendor No.),
//                               Date Filter=FIELD(Date Filter);
//             }
//             systempart(;Links)
//             {
//                 Visible = false;
//             }
//             systempart(;Notes)
//             {
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("O&rder")
//             {
//                 Caption = 'O&rder';
//                 Image = "Order";
//                 action(Dimensions)
//                 {
//                     AccessByPermission = TableData 348=R;
//                     ApplicationArea = Suite;
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     Promoted = false;
//                     //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedIsBig = false;
//                     ShortCutKey = 'Shift+Ctrl+D';
//                     ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

//                     trigger OnAction()
//                     begin
//                         ShowDocDim;
//                     end;
//                 }
//                 action(Statistics)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F7';
//                     ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

//                     trigger OnAction()
//                     begin
//                         OpenPurchaseOrderStatistics;
//                     end;
//                 }
//                 action(Approvals)
//                 {
//                     AccessByPermission = TableData 454=R;
//                     ApplicationArea = Suite;
//                     Caption = 'Approvals';
//                     Image = Approvals;
//                     ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

//                     trigger OnAction()
//                     var
//                         WorkflowsEntriesBuffer: Record "832";
//                     begin
//                         WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
//                     end;
//                 }
//                 action("Co&mments")
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 66;
//                                     RunPageLink = Document Type=FIELD(Document Type),
//                                   No.=FIELD(No.),
//                                   Document Line No.=CONST(0);
//                     ToolTip = 'View or add comments for the record.';
//                 }
//             }
//             group(Documents)
//             {
//                 Caption = 'Documents';
//                 Image = Documents;
//                 action(Receipts)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Receipts';
//                     Image = PostedReceipts;
//                     Promoted = false;
//                     //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedIsBig = false;
//                     RunObject = Page 145;
//                                     RunPageLink = Order No.=FIELD(No.);
//                     RunPageView = SORTING(Order No.);
//                     ToolTip = 'View a list of posted purchase receipts for the order.';
//                 }
//                 action(PostedPurchaseInvoices)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Invoices';
//                     Image = Invoice;
//                     Promoted = false;
//                     //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedIsBig = false;
//                     RunObject = Page 146;
//                                     RunPageLink = Order No.=FIELD(No.);
//                     RunPageView = SORTING(Order No.);
//                     ToolTip = 'View a list of ongoing purchase invoices for the order.';
//                 }
//                 action(PostedPurchasePrepmtInvoices)
//                 {
//                     ApplicationArea = Prepayments;
//                     Caption = 'Prepa&yment Invoices';
//                     Image = PrepaymentInvoice;
//                     RunObject = Page 146;
//                                     RunPageLink = Prepayment Order No.=FIELD(No.);
//                     RunPageView = SORTING(Prepayment Order No.);
//                     ToolTip = 'View related posted sales invoices that involve a prepayment. ';
//                 }
//                 action("Prepayment Credi&t Memos")
//                 {
//                     ApplicationArea = Prepayments;
//                     Caption = 'Prepayment Credi&t Memos';
//                     Image = PrepaymentCreditMemo;
//                     RunObject = Page 147;
//                                     RunPageLink = Prepayment Order No.=FIELD(No.);
//                     RunPageView = SORTING(Prepayment Order No.);
//                     ToolTip = 'View related posted sales credit memos that involve a prepayment. ';
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("In&vt. Put-away/Pick Lines")
//                 {
//                     ApplicationArea = Warehouse;
//                     Caption = 'In&vt. Put-away/Pick Lines';
//                     Image = PickLines;
//                     RunObject = Page 5774;
//                                     RunPageLink = Source Document=CONST(Purchase Order),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Document,Source No.,Location Code);
//                     ToolTip = 'View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.';
//                 }
//                 action("Whse. Receipt Lines")
//                 {
//                     ApplicationArea = Warehouse;
//                     Caption = 'Whse. Receipt Lines';
//                     Image = ReceiptLines;
//                     RunObject = Page 7342;
//                                     RunPageLink = Source Type=CONST(39),
//                                   Source Subtype=FIELD(Document Type),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
//                     ToolTip = 'View ongoing warehouse receipts for the document, in advanced warehouse configurations.';
//                 }
//             }
//         }
//         area(processing)
//         {
//             group(Print)
//             {
//                 Caption = 'Print';
//                 Image = Print;
//                 action(Print)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = '&Print';
//                     Ellipsis = true;
//                     Image = Print;
//                     Promoted = true;
//                     PromotedCategory = Category5;
//                     ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

//                     trigger OnAction()
//                     var
//                         PurchaseHeader: Record "38";
//                     begin
//                         PurchaseHeader := Rec;
//                         CurrPage.SETSELECTIONFILTER(PurchaseHeader);
//                         PurchaseHeader.PrintRecords(TRUE);
//                     end;
//                 }
//                 action(Send)
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Send';
//                     Ellipsis = true;
//                     Image = SendToMultiple;
//                     Promoted = true;
//                     PromotedCategory = Category5;
//                     PromotedIsBig = true;
//                     ToolTip = 'Prepare to send the document according to the vendor''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

//                     trigger OnAction()
//                     var
//                         PurchaseHeader: Record "38";
//                     begin
//                         PurchaseHeader := Rec;
//                         CurrPage.SETSELECTIONFILTER(PurchaseHeader);
//                         PurchaseHeader.SendRecords;
//                     end;
//                 }
//             }
//             group(Release)
//             {
//                 Caption = 'Release';
//                 Image = ReleaseDoc;
//                 action(Release)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Re&lease';
//                     Image = ReleaseDoc;
//                     ShortCutKey = 'Ctrl+F9';
//                     ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';

//                     trigger OnAction()
//                     var
//                         ReleasePurchDoc: Codeunit "415";
//                     begin
//                         ReleasePurchDoc.PerformManualRelease(Rec);
//                     end;
//                 }
//                 action(Reopen)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Re&open';
//                     Image = ReOpen;
//                     ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

//                     trigger OnAction()
//                     var
//                         ReleasePurchDoc: Codeunit "415";
//                     begin
//                         ReleasePurchDoc.PerformManualReopen(Rec);
//                     end;
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Send IC Purchase Order")
//                 {
//                     AccessByPermission = TableData 410=R;
//                     ApplicationArea = Intercompany;
//                     Caption = 'Send IC Purchase Order';
//                     Image = IntercompanyOrder;
//                     ToolTip = 'Send the document to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.';

//                     trigger OnAction()
//                     var
//                         ICInOutboxMgt: Codeunit "427";
//                         ApprovalsMgmt: Codeunit "1535";
//                     begin
//                         IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
//                           ICInOutboxMgt.SendPurchDoc(Rec,FALSE);
//                     end;
//                 }
//             }
//             group("Request Approval")
//             {
//                 Caption = 'Request Approval';
//                 action(SendApprovalRequest)
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Send A&pproval Request';
//                     Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
//                     Image = SendApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     PromotedOnly = true;
//                     ToolTip = 'Request approval of the document.';

//                     trigger OnAction()
//                     var
//                         ApprovalsMgmt: Codeunit "1535";
//                     begin
//                         IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
//                           ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
//                     end;
//                 }
//                 action(CancelApprovalRequest)
//                 {
//                     ApplicationArea = Basic,Suite;
//                     Caption = 'Cancel Approval Re&quest';
//                     Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
//                     Image = CancelApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     PromotedOnly = true;
//                     ToolTip = 'Cancel the approval request.';

//                     trigger OnAction()
//                     var
//                         ApprovalsMgmt: Codeunit "1535";
//                         WorkflowWebhookManagement: Codeunit "1543";
//                     begin
//                         ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
//                         WorkflowWebhookManagement.FindAndCancel(RECORDID);
//                     end;
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("Create &Whse. Receipt")
//                 {
//                     AccessByPermission = TableData 7316=R;
//                     ApplicationArea = Warehouse;
//                     Caption = 'Create &Whse. Receipt';
//                     Image = NewReceipt;
//                     ToolTip = 'Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.';

//                     trigger OnAction()
//                     var
//                         GetSourceDocInbound: Codeunit "5751";
//                     begin
//                         GetSourceDocInbound.CreateFromPurchOrder(Rec);

//                         IF NOT FIND('=><') THEN
//                           INIT;
//                     end;
//                 }
//                 action("Create Inventor&y Put-away/Pick")
//                 {
//                     AccessByPermission = TableData 7340=R;
//                     ApplicationArea = Warehouse;
//                     Caption = 'Create Inventor&y Put-away/Pick';
//                     Ellipsis = true;
//                     Image = CreatePutawayPick;
//                     ToolTip = 'Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.';

//                     trigger OnAction()
//                     begin
//                         CreateInvtPutAwayPick;

//                         IF NOT FIND('=><') THEN
//                           INIT;
//                     end;
//                 }
//             }
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action(TestReport)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Test Report';
//                     Ellipsis = true;
//                     Image = TestReport;
//                     ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

//                     trigger OnAction()
//                     begin
//                         ReportPrint.PrintPurchHeader(Rec);
//                     end;
//                 }
//                 action(Post)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'P&ost';
//                     Ellipsis = true;
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';
//                     ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

//                     trigger OnAction()
//                     var
//                         PurchaseHeader: Record "38";
//                         ApplicationAreaSetup: Record "9178";
//                         PurchaseBatchPostMgt: Codeunit "1372";
//                         BatchProcessingMgt: Codeunit "1380";
//                         BatchPostParameterTypes: Codeunit "1370";
//                         LinesInstructionMgt: Codeunit "1320";
//                     begin
//                         IF ApplicationAreaSetup.IsFoundationEnabled THEN
//                           LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

//                         CurrPage.SETSELECTIONFILTER(PurchaseHeader);

//                         IF PurchaseHeader.COUNT > 1 THEN BEGIN
//                           BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice,TRUE);
//                           BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Receive,TRUE);

//                           PurchaseBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
//                           PurchaseBatchPostMgt.RunWithUI(PurchaseHeader,COUNT,ReadyToPostQst);
//                         END ELSE
//                           SendToPosting(CODEUNIT::"Purch.-Post (Yes/No)");
//                     end;
//                 }
//                 action(Preview)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Preview Posting';
//                     Image = ViewPostedOrder;
//                     ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

//                     trigger OnAction()
//                     var
//                         PurchPostYesNo: Codeunit "91";
//                     begin
//                         PurchPostYesNo.Preview(Rec);
//                     end;
//                 }
//                 action(PostAndPrint)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Post and &Print';
//                     Ellipsis = true;
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F9';
//                     ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

//                     trigger OnAction()
//                     begin
//                         SendToPosting(CODEUNIT::"Purch.-Post + Print");
//                     end;
//                 }
//                 action(PostBatch)
//                 {
//                     ApplicationArea = Advanced;
//                     Caption = 'Post &Batch';
//                     Ellipsis = true;
//                     Image = PostBatch;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ToolTip = 'Post several documents at once. A report request window opens where you can specify which documents to post.';

//                     trigger OnAction()
//                     begin
//                         REPORT.RUNMODAL(REPORT::"Batch Post Purchase Orders",TRUE,TRUE,Rec);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action(RemoveFromJobQueue)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Remove From Job Queue';
//                     Image = RemoveLine;
//                     ToolTip = 'Remove the scheduled processing of this record from the job queue.';
//                     Visible = JobQueueActive;

//                     trigger OnAction()
//                     begin
//                         CancelBackgroundPosting;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         SetControlAppearance;
//         CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
//     end;

//     trigger OnFindRecord(Which: Text): Boolean
//     var
//         NextRecNotFound: Boolean;
//     begin
//         IF NOT FIND(Which) THEN
//           EXIT(FALSE);

//         IF ShowHeader THEN
//           EXIT(TRUE);

//         REPEAT
//           NextRecNotFound := NEXT <= 0;
//           IF ShowHeader THEN
//             EXIT(TRUE);
//         UNTIL NextRecNotFound;

//         EXIT(FALSE);
//     end;

//     trigger OnNextRecord(Steps: Integer): Integer
//     var
//         NewStepCount: Integer;
//     begin
//         REPEAT
//           NewStepCount := NEXT(Steps);
//         UNTIL (NewStepCount = 0) OR ShowHeader;

//         EXIT(NewStepCount);
//     end;

//     trigger OnOpenPage()
//     var
//         PurchasesPayablesSetup: Record "312";
//     begin
//         IF GETFILTER(Receive) <> '' THEN
//           FilterPartialReceived;
//         IF GETFILTER(Invoice) <> '' THEN
//           FilterPartialInvoiced;

//         SetSecurityFilterOnRespCenter;

//         JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

//         CopyBuyFromVendorFilter;
//     end;

//     var
//         ReportPrint: Codeunit "228";
//         [InDataSet]
//         JobQueueActive: Boolean;
//         OpenApprovalEntriesExist: Boolean;
//         CanCancelApprovalForRecord: Boolean;
//         SkipLinesWithoutVAT: Boolean;
//         ReadyToPostQst: Label '%1 out of %2 selected orders are ready for post. \Do you want to continue and post them?', Comment='%1 - selected count, %2 - total count';
//         CanRequestApprovalForFlow: Boolean;
//         CanCancelApprovalForFlow: Boolean;

//     local procedure SetControlAppearance()
//     var
//         ApprovalsMgmt: Codeunit "1535";
//         WorkflowWebhookManagement: Codeunit "1543";
//     begin
//         OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

//         CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

//         WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
//     end;

//     procedure SkipShowingLinesWithoutVAT()
//     begin
//         SkipLinesWithoutVAT := TRUE;
//     end;

//     local procedure ShowHeader(): Boolean
//     var
//         CashFlowManagement: Codeunit "841";
//     begin
//         IF NOT SkipLinesWithoutVAT THEN
//           EXIT(TRUE);

//         EXIT(CashFlowManagement.GetTaxAmountFromPurchaseOrder(Rec) <> 0);
//     end;
// }

