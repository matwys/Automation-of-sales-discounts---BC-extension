codeunit 50002 "IMW CDGA Event"
{

    var
        NewSalesDocumentErr: Label 'Customer has invalid assign to Disc. Group. Run action CDGA Update Customer for this Customer.';
        RemoveDiscGroupErr: Label 'Position in CDGA Thresholds Setup page must be removed before delete Customer Disc. Group.';

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsert(var Customer: Record Customer; xCustomer: Record Customer)
    var
        IMWCDGAChangeLog: Record "IMW CDGA Change Log";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
        "Disc. Group. No.": Code[20];
    begin
        SalesReceivablesSetup.Get();
        if not ((SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released = SalesReceivablesSetup."IMW CDGA Treshold Setup Status") and SalesReceivablesSetup."IMW CDGA Enabled") then
            exit;

        "Disc. Group. No." := IMWCDGAMgt.FindGroupForCustomer(0);
        IMWCDGAChangeLog.Init();
        IMWCDGAChangeLog."Customer No." := Customer."No.";
        IMWCDGAChangeLog."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWCDGAChangeLog.Insert();

        Customer."Customer Disc. Group" := "Disc. Group. No.";
        Customer."IMW CDGA Changed Date" := Today;
        Customer."IMW CDGA Valid To" := CalcDate(SalesReceivablesSetup."IMW CDGA Validity Period", Today());
        Customer."IMW CDGA Changed By" := UserId.Substring(1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventSalesHeader(var Rec: Record "Sales Header")
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        Customer.get(Rec."Sell-to Customer No.");
        if SalesReceivablesSetup."IMW CDGA Enabled" then
            if Customer."IMW CDGA Valid To" < Today() then
                Error(NewSalesDocumentErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer Discount Group", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Customer Discount Group")
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetRange(IMWCDGAThresholdsSetup."Cust. Disc. Group Code", Rec.Code);
        if IMWCDGAThresholdsSetup.Count > 0 then
            Error(RemoveDiscGroupErr);
    end;
}