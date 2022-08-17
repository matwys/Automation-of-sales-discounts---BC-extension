codeunit 50001 "IMW AA Cust. Disc. Gr. Mgt."
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
            SalesReceivablesSetup.Validate("IMW AA Status", SalesReceivablesSetup."IMW AA Status"::Released);
            SalesReceivablesSetup.Modify();
            Message(ChangeForReleasedMsg);
        end;
    end;

    local procedure CheckZero(): Boolean
    var
        AADiscGroupSetup: Record "IMW AA Cust. Disc. Gr. Setup";
    begin
        AADiscGroupSetup.SetRange("Treshold Amount", 0);
        if AADiscGroupSetup.Count <> 1 then
            exit(false);
        exit(true);
    end;

    procedure Open()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.Validate("IMW AA Status", SalesReceivablesSetup."IMW AA Status"::Open);
        SalesReceivablesSetup.Modify();
        Message(ChangeForOpenMsg);
    end;

    procedure TurnOff()
    var
        Customer: Record Customer;
    begin
        if Customer.FindSet() then
            repeat
                Customer."IMW AA Disc. Valid To" := 0D;
                Customer."IMW Last AA Ch. Date" := 0D;
                Customer."IMW Last AA Ch. By" := '';
                Customer.Modify();
            until Customer.Next() = 0;
    end;

    procedure AutoAssingAllCustomersToDiscGroup()
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CountChanges: Integer;
    begin
        if not Confirm(AllUserAAQst) then
            Customer.SetFilter(Customer."IMW AA Disc. Valid To", '<%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()));
        CountChanges := 0;
        if Customer.FindSet() then
            repeat
                AutoAssignCustomerToDiscGroup(Customer);
                CountChanges := CountChanges + 1;
            until Customer.Next() = 0;
        Message(CountChangesMsg, CountChanges);
    end;

    procedure AutoAssignCustomerToDiscGroup(Customer: Record Customer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IMWAAToDiscGrHist: Record "IMW AA To Disc. Gr. Hist.";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        "Disc. Group. No.": Code[20];
        SalesBalanc: Decimal;
    begin
        SalesReceivablesSetup.Get();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", Customer."No.");
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '>%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()));

        if CustLedgerEntry.FindSet() then
            repeat
                SalesBalanc := SalesBalanc + CustLedgerEntry."Sales (LCY)";
            until CustLedgerEntry.Next() = 0;
        "Disc. Group. No." := FindGroupForCustomer(SalesBalanc);

        IMWAAToDiscGrHist.Init();
        IMWAAToDiscGrHist."Customer No." := Customer."No.";
        IMWAAToDiscGrHist."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWAAToDiscGrHist."IMW Last AA Ch. By" := UserId;
        IMWAAToDiscGrHist."IMW Last AA Ch. Date" := Today();
        IMWAAToDiscGrHist.Insert();

        Customer.Validate("Customer Disc. Group", "Disc. Group. No.");
        Customer.Validate("IMW Last AA Ch. Date", Today);
        Customer.Validate("IMW AA Disc. Valid To", CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today()));
        Customer.Validate("IMW Last AA Ch. By", UserId);
        Customer.Modify();
    end;

    local procedure FindGroupForCustomer(SalesBalanc: Decimal): Code[20]
    var
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
    begin
        IMWAACustDiscGrSetup.SetFilter(IMWAACustDiscGrSetup."Treshold Amount", '<=%1', SalesBalanc);
        IMWAACustDiscGrSetup.SetCurrentKey("Treshold Amount");
        IMWAACustDiscGrSetup.FindLast();
        exit(IMWAACustDiscGrSetup.Code);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsert(var Customer: Record Customer; xCustomer: Record Customer)
    var
        IMWAAToDiscGrHist: Record "IMW AA To Disc. Gr. Hist.";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        "Disc. Group. No.": Code[20];
    begin
        SalesReceivablesSetup.Get();
        if not ((SalesReceivablesSetup."IMW AA Status"::Released = SalesReceivablesSetup."IMW AA Status") and SalesReceivablesSetup."IMW AA Cust. Disc. Gr.") then
            exit;

        "Disc. Group. No." := FindGroupForCustomer(0);
        IMWAAToDiscGrHist.Init();
        IMWAAToDiscGrHist."Customer No." := Customer."No.";
        IMWAAToDiscGrHist."Customer Disc. Group Code" := "Disc. Group. No.";
        IMWAAToDiscGrHist."IMW Last AA Ch. By" := UserId;
        IMWAAToDiscGrHist."IMW Last AA Ch. Date" := Today();
        IMWAAToDiscGrHist.Insert();

        Customer."Customer Disc. Group" := "Disc. Group. No.";
        Customer."IMW Last AA Ch. Date" := Today;
        Customer."IMW AA Disc. Valid To" := CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today());
        Customer."IMW Last AA Ch. By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer Discount Group", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Customer Discount Group")
    var
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
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
        if SalesReceivablesSetup."IMW AA Cust. Disc. Gr." then
            if Customer."IMW AA Disc. Valid To" < Today() then
                Error(NewDocumentErr);
    end;

    var
        AllUserAAQst: Label 'Do you want auto assing all Customers to disc. group?';
        ChangeForOpenMsg: Label 'Status is changed for Open. ';
        ChangeForReleasedMsg: Label 'Status is changed for Released.';
        MissingZeroMsg: Label 'Status is not changed. Only one record must have 0 in Threshold Amount.';
        RemoveDiscGroupErr: Label 'Position in Auto Assign Disc. Group Setup page must be removed before delete Customer Disc. Group.';
        NewDocumentErr: Label 'Customer has invalid assign to Disc. Group. Run action Auto Assign to Disc. Group for this Customer.';
        CountChangesMsg: Label 'Changes: %1';
}