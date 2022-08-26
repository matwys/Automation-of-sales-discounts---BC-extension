codeunit 50001 "IMW CDGA Mgt."
{

    var
        ChangeForOpenMsg: Label 'Status is changed for Open. ';
        ChangeForReleasedMsg: Label 'Status is changed for Released.';
        DisableCDGAQst: Label 'Do you want to disable the CDGA functionality? All CDGA lost validity.';
        EnableCDGAQst: Label 'Do you want to enable the CDGA functionality?';
        MissingZeroSalesAmountMsg: Label 'Status is not changed. Only one record must have 0 in Threshold Sales Amount.';
        MissingZeroEntriesCountMsg: Label 'Status is not changed. Only one record must have 0 in Threshold Entries Count.';
        NewSalesDocumentErr: Label 'Customer has invalid assign to Disc. Group. Run action CDGA Update Customer for this Customer.';
        RemoveDiscGroupErr: Label 'Position in CDGA Thresholds Setup page must be removed before delete Customer Disc. Group.';

    procedure AutoAssignCustomerToDiscGroup(Customer: Record Customer)
    var
        "Disc. Group. No.": Code[20];
        IMWCDGAIGroupProvider: Interface "IMW CDGA IGroupProvider";
    begin
        IMWCDGAIGroupProvider := GroupFindByProviderFactory(IMWCDGAIGroupProvider);
        "Disc. Group. No." := IMWCDGAIGroupProvider.GetCustomerDiscGroup(Customer);

        InsertNewCDGAChangeLog(Customer, "Disc. Group. No.");
        UpdateCustomerDiscGroup(Customer, "Disc. Group. No.");
    end;

    procedure ChangeCDGAThresholdSetupStatusForOpen()
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
        if not CheckOnlyOneZeroThresholdSalesAmount() then
            Error(MissingZeroSalesAmountMsg);
        if not CheckOnlyOneZeroThresholdEntriesCount() then
            Error(MissingZeroEntriesCountMsg);

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

    procedure FindCustomerDiscGroupBySalesBalance(Customer: Record Customer): Code[20]
    var
        SalesBalance: Decimal;
    begin
        SalesBalance := CalcSalesBalance(Customer);
        exit(FindGroupForCustomerBySalesBalance(SalesBalance));
    end;

    procedure FindCustomerDiscGroupByEnriesCount(Customer: Record Customer): Code[20]
    var
        EntriesCount: Integer;
    begin
        EntriesCount := CalcEntiesCount(Customer);
        exit(FindGroupForCustomerByEntriesCount(EntriesCount));
    end;

    procedure OnAfterOnInsertCustomer(var Customer: Record Customer)
    var
        IMWCDGAChangeLog: Record "IMW CDGA Change Log";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        "Disc. Group. No.": Code[20];
        IMWCDGAIGroupProvider: Interface "IMW CDGA IGroupProvider";
    begin
        SalesReceivablesSetup.Get();
        if not ((SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released = SalesReceivablesSetup."IMW CDGA Treshold Setup Status") and SalesReceivablesSetup."IMW CDGA Enabled") then
            exit;

        IMWCDGAIGroupProvider := GroupFindByProviderFactory(IMWCDGAIGroupProvider);
        "Disc. Group. No." := IMWCDGAIGroupProvider.GetCustomerDiscGroup(Customer);
        IMWCDGAChangeLog.Init();
        IMWCDGAChangeLog."Customer No." := Customer."No.";
        IMWCDGAChangeLog."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWCDGAChangeLog."Method Of Find Group By" := SalesReceivablesSetup."IMW CDGA Find Group By";
        IMWCDGAChangeLog.Insert();

        Customer."Customer Disc. Group" := "Disc. Group. No.";
        Customer."IMW CDGA Changed Date" := Today;
        Customer."IMW CDGA Valid To" := CalcDate(SalesReceivablesSetup."IMW CDGA Validity Period", Today());
        Customer."IMW CDGA Changed By" := UserId;
    end;

    procedure OnAfterValidateEventSalesHeader(var Rec: Record "Sales Header")
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

    procedure OnBeforeDeleteEvent(var Rec: Record "Customer Discount Group")
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetRange(IMWCDGAThresholdsSetup."Cust. Disc. Group Code", Rec.Code);
        if IMWCDGAThresholdsSetup.Count > 0 then
            Error(RemoveDiscGroupErr);
    end;

    local procedure CalcSalesBalance(Customer: Record Customer): Decimal
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        Customer.SETFILTER("Date Filter", '%1..%2', CalcDate(SalesReceivablesSetup."IMW CDGA Sales Period", Today()), Today());
        Customer.CalcFields(Customer."Sales (LCY)");
        exit(Customer."Sales (LCY)");
    end;

    local procedure CalcEntiesCount(Customer: Record Customer): Integer
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Counter: Integer;
    begin
        Counter := 0;
        SalesReceivablesSetup.Get();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", Customer."No.");
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '>=%1', CalcDate(SalesReceivablesSetup."IMW CDGA Sales Period", Today()));
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '<=%1', Today());
        CustLedgerEntry.SetRange(CustLedgerEntry."Document Type", CustLedgerEntry."Document Type"::Invoice);
        if CustLedgerEntry.FindSet() then
            repeat
                Counter := Counter + 1;
            until CustLedgerEntry.Next() = 0;
        Exit(Counter);
    end;

    local procedure CheckOnlyOneZeroThresholdSalesAmount(): Boolean
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetRange("Threshold Sales Amount", 0);
        exit(IMWCDGAThresholdsSetup.Count = 1);
    end;

    local procedure CheckOnlyOneZeroThresholdEntriesCount(): Boolean
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetRange("Threshold Entries Count", 0);
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

    local procedure FindGroupForCustomerBySalesBalance(SalesBalanc: Decimal): Code[20]
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetFilter(IMWCDGAThresholdsSetup."Threshold Sales Amount", '<=%1', SalesBalanc);
        IMWCDGAThresholdsSetup.SetCurrentKey("Threshold Sales Amount");
        IMWCDGAThresholdsSetup.FindLast();
        exit(IMWCDGAThresholdsSetup."Cust. Disc. Group Code");
    end;

    local procedure FindGroupForCustomerByEntriesCount(EntriesCount: Integer): Code[20]
    var
        IMWCDGAThresholdsSetup: Record "IMW CDGA Thresholds Setup";
    begin
        IMWCDGAThresholdsSetup.SetFilter(IMWCDGAThresholdsSetup."Threshold Entries Count", '<=%1', EntriesCount);
        IMWCDGAThresholdsSetup.SetCurrentKey("Threshold Entries Count");
        IMWCDGAThresholdsSetup.FindLast();
        exit(IMWCDGAThresholdsSetup."Cust. Disc. Group Code");
    end;

    local procedure GroupFindByProviderFactory(var iGroupFindByProvider: Interface "IMW CDGA IGroupProvider"): Interface "IMW CDGA IGroupProvider"
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        iGroupFindByProvider := SalesReceivablesSetup."IMW CDGA Find Group By";
        Exit(iGroupFindByProvider);
    end;

    local procedure InsertNewCDGAChangeLog(Customer: Record Customer; "Disc. Group. No.": Code[20])
    var
        IMWCDGAChangeLog: Record "IMW CDGA Change Log";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        IMWCDGAChangeLog.Init();
        IMWCDGAChangeLog."Customer No." := Customer."No.";
        IMWCDGAChangeLog."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWCDGAChangeLog."Method Of Find Group By" := SalesReceivablesSetup."IMW CDGA Find Group By";
        IMWCDGAChangeLog.Insert();
    end;

    local procedure UpdateCustomerDiscGroup(Customer: Record Customer; "Disc. Group. No.": Code[20])
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