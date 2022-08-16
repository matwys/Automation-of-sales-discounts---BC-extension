codeunit 50001 "IMW Auto Assign Disc. Gr. Mgt."
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
            SalesReceivablesSetup.Validate("IMW Status", SalesReceivablesSetup."IMW Status"::Released);
            SalesReceivablesSetup.Modify();
            Message(ChangeForReleasedMsg);
        end;
    end;

    local procedure CheckZero(): Boolean
    var
        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
    begin
        ReqAutoAssDiscGroup.SetRange(Threshold, 0);
        if ReqAutoAssDiscGroup.Count <> 1 then
            exit(false);
        exit(true);
    end;

    procedure Open()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.Validate("IMW Status", SalesReceivablesSetup."IMW Status"::Open);
        SalesReceivablesSetup.Modify();
        Message(ChangeForOpenMsg);
    end;

    procedure TurnOff()
    var
        Customer: Record Customer;
    begin
        if Customer.FindSet() then
            repeat
                Customer."IMW Auto. Ass. Disc. Valid To" := 0D;
                Customer."IMW Last Auto Ass. Ch. Date" := 0D;
                Customer."IMW Last Auto. Ass. Ch. By" := '';
                Customer.Modify();
            until Customer.Next() = 0;
    end;

    procedure AutoAssingAllCustomersToDiscGroup()
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CountChanges: Integer;
    begin
        if not Confirm(AllUserAssignQst) then
            Customer.SetFilter(Customer."IMW Auto. Ass. Disc. Valid To", '<%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()));
        CountChanges := 0;
        if Customer.FindSet() then
            repeat
                AutoAssingCustomerToDiscGroup(Customer);
                CountChanges := CountChanges + 1;
            until Customer.Next() = 0;
        Message(CountChangesMsg, CountChanges);
    end;

    procedure AutoAssingCustomerToDiscGroup(Customer: Record Customer)
    var
        "Cust. Ledger Entry": Record "Cust. Ledger Entry";
        IMWAutoAssDiscGrHist: Record "IMW Auto. Ass. Disc. Gr. Hist.";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        "Disc. Group. No.": Code[20];
        SalesBalanc: Decimal;
    begin
        SalesReceivablesSetup.Get();
        "Cust. Ledger Entry".SetRange("Cust. Ledger Entry"."Customer No.", Customer."No.");
        "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry"."Posting Date", '>%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()));

        if "Cust. Ledger Entry".FindSet() then
            repeat
                SalesBalanc := SalesBalanc + "Cust. Ledger Entry"."Sales (LCY)";
            until "Cust. Ledger Entry".Next() = 0;
        "Disc. Group. No." := FindGroupForCustomer(SalesBalanc);

        IMWAutoAssDiscGrHist.Init();
        IMWAutoAssDiscGrHist."Customer No." := Customer."No.";
        IMWAutoAssDiscGrHist."Cust. Disc. Group Code" := "Disc. Group. No.";
        IMWAutoAssDiscGrHist."IMW Last Auto. Ass. Ch. By" := UserId;
        IMWAutoAssDiscGrHist."IMW Last Auto Ass. Ch. Date" := Today();
        IMWAutoAssDiscGrHist.Insert();

        Customer.Validate("Customer Disc. Group", "Disc. Group. No.");
        Customer.Validate("IMW Last Auto Ass. Ch. Date", Today);
        Customer.Validate("IMW Auto. Ass. Disc. Valid To", CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today()));
        Customer.Validate("IMW Last Auto. Ass. Ch. By", UserId);
        Customer.Modify();
    end;

    local procedure FindGroupForCustomer(SalesBalanc: Decimal): Code[20]
    var
        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
    begin
        ReqAutoAssDiscGroup.SetFilter(ReqAutoAssDiscGroup.Threshold, '<=%1', SalesBalanc);
        ReqAutoAssDiscGroup.SetCurrentKey(Threshold);
        ReqAutoAssDiscGroup.FindLast();
        exit(ReqAutoAssDiscGroup.Code);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsert(var Customer: Record Customer; xCustomer: Record Customer)
    var
        IMWAutoAssDiscGrHist: Record "IMW Auto. Ass. Disc. Gr. Hist.";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        "Disc. Group. No.": Code[20];
    begin
        SalesReceivablesSetup.Get();
        if not ((SalesReceivablesSetup."IMW Status"::Released = SalesReceivablesSetup."IMW Status") and SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.") then
            exit;

        "Disc. Group. No." := FindGroupForCustomer(0);
        IMWAutoAssDiscGrHist.Init();
        IMWAutoAssDiscGrHist."Customer No." := Customer."No.";
        IMWAutoAssDiscGrHist."Cust. Disc. Group Code" := "Disc. Group. No.";
        IMWAutoAssDiscGrHist."IMW Last Auto. Ass. Ch. By" := UserId;
        IMWAutoAssDiscGrHist."IMW Last Auto Ass. Ch. Date" := Today();
        IMWAutoAssDiscGrHist.Insert();

        Customer."Customer Disc. Group" := "Disc. Group. No.";
        Customer."IMW Last Auto Ass. Ch. Date" := Today;
        Customer."IMW Auto. Ass. Disc. Valid To" := CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today());
        Customer."IMW Last Auto. Ass. Ch. By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer Discount Group", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Customer Discount Group")
    var
        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
    begin
        ReqAutoAssDiscGroup.SetRange(ReqAutoAssDiscGroup.Code, Rec.Code);
        if ReqAutoAssDiscGroup.Count > 0 then
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
        if SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr." then
            if Customer."IMW Auto. Ass. Disc. Valid To" < Today() then
                Error(NewDocumentErr);
    end;

    var
        AllUserAssignQst: Label 'Do you want auto assing all Customers to disc. group?';
        ChangeForOpenMsg: Label 'Status is changed for Open. ';
        ChangeForReleasedMsg: Label 'Status is changed for Released.';
        MissingZeroMsg: Label 'Status is not changed. Only one record must have 0 in Threshold Amount.';
        RemoveDiscGroupErr: Label 'Position in Auto Assign Disc. Group Setup page must be removed before delete Customer Disc. Group.';
        NewDocumentErr: Label 'Customer has invalid assign to Disc. Group. Run action Auto Assign to Disc. Group for this Customer.';
        CountChangesMsg: Label 'Changes: %1';
}