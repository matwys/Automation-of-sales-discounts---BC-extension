codeunit 50001 "IMW CDGA Mgt."
{
    procedure Release()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IsHandled: Boolean;
    begin
        IsHandled := CheckZero();
        if not IsHandled then begin
            Message(MissingZeroMsg);
            exit;
        end;
        if IsHandled then begin
            SalesReceivablesSetup.Get();
            SalesReceivablesSetup.Validate("IMW CDGA Treshold Setup Status", SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released);
            SalesReceivablesSetup.Modify();
            Message(ChangeForReleasedMsg);
        end;
    end;

    local procedure CheckZero(): Boolean
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetRange("Threshold Sales Amount", 0);
        if IMWCDGAThresholdsSetup.Count <> 1 then
            exit(false);
        exit(true);
    end;

    procedure Open()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.Validate("IMW CDGA Treshold Setup Status", SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Open);
        SalesReceivablesSetup.Modify();
        Message(ChangeForOpenMsg);
    end;

    procedure TurnOff()
    var
        Customer: Record Customer;
    begin
        if Customer.FindSet() then
            repeat
                Customer."IMW CDGA Valid To" := 0D;
                Customer."IMW CDGA Changed Date" := 0D;
                Customer."IMW CDGA Changed By" := '';
                Customer.Modify();
            until Customer.Next() = 0;
    end;

    procedure AutoAssignCustomerToDiscGroup(Customer: Record Customer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IMWCDGAChangeLog: Record "IMW CDGA Change Log";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        "Disc. Group. No.": Code[20];
        SalesBalanc: Decimal;
    begin
        SalesReceivablesSetup.Get();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", Customer."No.");
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '>%1', CalcDate(SalesReceivablesSetup."IMW CDGA Sales Period", Today()));

        if CustLedgerEntry.FindSet() then
            repeat
                SalesBalanc := SalesBalanc + CustLedgerEntry."Sales (LCY)";
            until CustLedgerEntry.Next() = 0;
        "Disc. Group. No." := FindGroupForCustomer(SalesBalanc);

        IMWCDGAChangeLog.Init();
        IMWCDGAChangeLog."Customer No." := Customer."No.";
        IMWCDGAChangeLog."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWCDGAChangeLog."CDGA Changed By" := UserId;
        IMWCDGAChangeLog."CDGA Changed Date" := Today();
        IMWCDGAChangeLog.Insert();

        Customer.Validate("Customer Disc. Group", "Disc. Group. No.");
        Customer.Validate("IMW CDGA Changed Date", Today);
        Customer.Validate("IMW CDGA Valid To", CalcDate(SalesReceivablesSetup."IMW CDGA Validity Period", Today()));
        Customer.Validate("IMW CDGA Changed By", UserId);
        Customer.Modify();
    end;

    local procedure FindGroupForCustomer(SalesBalanc: Decimal): Code[20]
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetFilter(IMWCDGAThresholdsSetup."Threshold Sales Amount", '<=%1', SalesBalanc);
        IMWCDGAThresholdsSetup.SetCurrentKey("Threshold Sales Amount");
        IMWCDGAThresholdsSetup.FindLast();
        exit(IMWCDGAThresholdsSetup.Code);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsert(var Customer: Record Customer; xCustomer: Record Customer)
    var
        IMWAAToDiscGrHist: Record "IMW CDGA Change Log";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        "Disc. Group. No.": Code[20];
    begin
        SalesReceivablesSetup.Get();
        if not ((SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released = SalesReceivablesSetup."IMW CDGA Treshold Setup Status") and SalesReceivablesSetup."IMW CDGA Enabled") then
            exit;

        "Disc. Group. No." := FindGroupForCustomer(0);
        IMWAAToDiscGrHist.Init();
        IMWAAToDiscGrHist."Customer No." := Customer."No.";
        IMWAAToDiscGrHist."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWAAToDiscGrHist."CDGA Changed By" := UserId;
        IMWAAToDiscGrHist."CDGA Changed Date" := Today();
        IMWAAToDiscGrHist.Insert();

        Customer."Customer Disc. Group" := "Disc. Group. No.";
        Customer."IMW CDGA Changed Date" := Today;
        Customer."IMW CDGA Valid To" := CalcDate(SalesReceivablesSetup."IMW CDGA Validity Period", Today());
        Customer."IMW CDGA Changed By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer Discount Group", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Customer Discount Group")
    var
        IMWAACustDiscGrSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWAACustDiscGrSetup.SetRange(IMWAACustDiscGrSetup.Code, Rec.Code);
        if IMWAACustDiscGrSetup.Count > 0 then
            Error(RemoveDiscGroupErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventSalesHeader(var Rec: Record "Sales Header")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
    begin
        SalesReceivablesSetup.Get();
        Customer.get(Rec."Sell-to Customer No.");
        if SalesReceivablesSetup."IMW CDGA Enabled" then
            if Customer."IMW CDGA Valid To" < Today() then
                Error(NewDocumentErr);
    end;

    var
        ChangeForOpenMsg: Label 'Status is changed for Open. ';
        ChangeForReleasedMsg: Label 'Status is changed for Released.';
        MissingZeroMsg: Label 'Status is not changed. Only one record must have 0 in Threshold Amount.';
        RemoveDiscGroupErr: Label 'Position in Auto Assign Disc. Group Setup page must be removed before delete Customer Disc. Group.';
        NewDocumentErr: Label 'Customer has invalid assign to Disc. Group. Run action Auto Assign to Disc. Group for this Customer.';
}