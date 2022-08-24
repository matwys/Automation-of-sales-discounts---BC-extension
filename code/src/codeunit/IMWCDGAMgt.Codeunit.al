codeunit 50001 "IMW CDGA Mgt."
{

    var
        ChangeForOpenMsg: Label 'Status is changed for Open. ';
        ChangeForReleasedMsg: Label 'Status is changed for Released.';
        MissingZeroMsg: Label 'Status is not changed. Only one record must have 0 in Threshold Amount.';
        DisableCDGAQst: Label 'Do you want to disable the CDGA functionality? All CDGA lost validity.';
        EnableCDGAQst: Label 'Do you want to enable the CDGA functionality?';

    procedure AutoAssignCustomerToDiscGroup(Customer: Record Customer)
    var
        "Disc. Group. No.": Code[20];
        SalesBalanc: Decimal;
    begin
        SalesBalanc := CalculateSalesBalance(Customer);
        "Disc. Group. No." := FindGroupForCustomer(SalesBalanc);

        InsertNewCDGAChangeLog(Customer, "Disc. Group. No.");

        SetDataInCustomer(Customer, "Disc. Group. No.");
    end;

    procedure ChangeCDGATHresholdSetupStatusForOpen()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.Validate("IMW CDGA Treshold Setup Status", SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Open);
        SalesReceivablesSetup.Modify();
        Message(ChangeForOpenMsg);
    end;

    procedure ChangeCDGATHresholdSetupStatusForReleased()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if not CheckOnlyOneZero() then
            Error(MissingZeroMsg);

        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.Validate("IMW CDGA Treshold Setup Status", SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released);
        SalesReceivablesSetup.Modify();
        Message(ChangeForReleasedMsg);
    end;

    procedure CheckCDGAEnabledIsEnabled(): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        exit(SalesReceivablesSetup."IMW CDGA Enabled");
    end;

    procedure CheckCDGAThresholdSetupStatusIsRelease(): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        exit(SalesReceivablesSetup."IMW CDGA Treshold Setup Status" = SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released);
    end;

    procedure DisableCDGA()
    begin
        if not Confirm(DisableCDGAQst) then
            Error('');
        DisableCDGAInvalidateData();
    end;

    procedure EnableCDGA()
    begin
        if not Confirm(EnableCDGAQst) then
            Error('');

    end;

    procedure FindGroupForCustomer(SalesBalanc: Decimal): Code[20]
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetFilter(IMWCDGAThresholdsSetup."Threshold Sales Amount", '<=%1', SalesBalanc);
        IMWCDGAThresholdsSetup.SetCurrentKey("Threshold Sales Amount");
        IMWCDGAThresholdsSetup.FindLast();
        exit(IMWCDGAThresholdsSetup."Cust. Disc. Group Code");
    end;

    local procedure CalculateSalesBalance(Customer: Record Customer): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesBalanc: Decimal;
    begin
        SalesReceivablesSetup.Get();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", Customer."No.");
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '>%1', CalcDate(SalesReceivablesSetup."IMW CDGA Sales Period", Today()));

        if CustLedgerEntry.FindSet() then
            repeat
                SalesBalanc := SalesBalanc + CustLedgerEntry."Sales (LCY)";
            until CustLedgerEntry.Next() = 0;
        exit(SalesBalanc);
    end;

    local procedure CheckOnlyOneZero(): Boolean
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetRange("Threshold Sales Amount", 0);
        exit(IMWCDGAThresholdsSetup.Count = 1);
    end;


    local procedure DisableCDGAInvalidateData()
    var
        Customer: Record Customer;
    begin
        Customer.ModifyAll(Customer."IMW CDGA Valid To", 0D);
        Customer.ModifyAll(Customer."IMW CDGA Changed Date", 0D);
        Customer.ModifyAll(Customer."IMW CDGA Changed By", '');
    end;

    local procedure InsertNewCDGAChangeLog(Customer: Record Customer; "Disc. Group. No.": Code[20])
    var
        IMWCDGAChangeLog: Record "IMW CDGA Change Log";
    begin
        IMWCDGAChangeLog.Init();
        IMWCDGAChangeLog."Customer No." := Customer."No.";
        IMWCDGAChangeLog."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWCDGAChangeLog."CDGA Changed By" := UserId;
        IMWCDGAChangeLog."CDGA Changed Date" := Today();
        IMWCDGAChangeLog.Insert();
    end;

    local procedure SetDataInCustomer(Customer: Record Customer; "Disc. Group. No.": Code[20])
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        Customer.Validate("Customer Disc. Group", "Disc. Group. No.");
        Customer.Validate("IMW CDGA Changed Date", Today);
        Customer.Validate("IMW CDGA Valid To", CalcDate(SalesReceivablesSetup."IMW CDGA Validity Period", Today()));
        Customer.Validate("IMW CDGA Changed By", UserId);
        Customer.Modify();
    end;
}