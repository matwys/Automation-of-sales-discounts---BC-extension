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
        ReqAutoAssDiscGroup.SetRange(Required, 0);
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
                Customer."IMW Auto. Ass. Disc. Exp. Date" := 0D;
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
            Customer.SetFilter(Customer."IMW Auto. Ass. Disc. Exp. Date", '<%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()));
        CountChanges := 0;
        if Customer.FindSet() then
            repeat
                AutoAssingCustomerToDiscGroup(Customer);
                CountChanges := CountChanges + 1;
            until Customer.Next() = 0;
        Message('Changes: %1', CountChanges);
    end;

    procedure AutoAssingCustomerToDiscGroup(Customer: Record Customer)
    var
        "Cust. Ledger Entry": Record "Cust. Ledger Entry";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesBalanc: Decimal;
    begin
        "Cust. Ledger Entry".SetRange("Cust. Ledger Entry"."Customer No.", Customer."No.");
        "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry"."Posting Date", '>%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()));

        if "Cust. Ledger Entry".FindSet() then
            repeat
                SalesBalanc := SalesBalanc + "Cust. Ledger Entry"."Sales (LCY)";
            until "Cust. Ledger Entry".Next() = 0;
        //Message('Sales (LCY) = %1', SalesBalanc);

        Customer.Validate("Customer Disc. Group", FindGroupForCustomer(SalesBalanc));
        Customer.Validate("IMW Last Auto Ass. Ch. Date", Today);
        Customer.Validate("IMW Auto. Ass. Disc. Exp. Date", CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today()));
        Customer.Validate("IMW Last Auto. Ass. Ch. By", UserId);
        Customer.Modify();
        //Message('Customer was added to Disc. Group.');
    end;

    local procedure FindGroupForCustomer(SalesBalanc: Decimal): Code[20]
    var
        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
    begin
        ReqAutoAssDiscGroup.SetFilter(ReqAutoAssDiscGroup.Required, '<=%1', SalesBalanc);
        ReqAutoAssDiscGroup.SetCurrentKey("Required");
        ReqAutoAssDiscGroup.FindLast();
        exit(ReqAutoAssDiscGroup.Code);
    end;

    var
        ChangeForOpenMsg: Label 'Status is changed for Open status.';
        ChangeForReleasedMsg: Label 'Status is changed for Released status.';
        MissingZeroMsg: Label 'Status is not changed. One record must have 0 in Required.';
        AllUserAssignQst: Label 'Do you want auto assing all Customers?';
}