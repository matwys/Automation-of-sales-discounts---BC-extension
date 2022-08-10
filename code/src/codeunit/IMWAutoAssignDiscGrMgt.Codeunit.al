codeunit 50001 "IMW Auto Assign Disc. Gr. Mgt."
{
    procedure Release()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IsHandled: Boolean;
    begin
        IsHandled := CheckZero();
        if not IsHandled then
            exit;
        if IsHandled then begin
            SalesReceivablesSetup.Get();
            SalesReceivablesSetup.Validate("IMW Status", SalesReceivablesSetup."IMW Status"::Released);
            SalesReceivablesSetup.Modify();
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
    end;

    procedure AutoAssingCustomerToDiscGroup(Customer: Record Customer)
    var
        SalesBalanc: Decimal;
        "Cust. Ledger Entry": Record "Cust. Ledger Entry";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        "Cust. Ledger Entry".SetRange("Cust. Ledger Entry"."Customer No.", Customer."No.");
        "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry"."Posting Date", '>%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()));

        if "Cust. Ledger Entry".FindSet() then
            repeat
                SalesBalanc := SalesBalanc + "Cust. Ledger Entry"."Sales (LCY)";
            until "Cust. Ledger Entry".Next() = 0;
        Message('Sales (LCY) = %1', SalesBalanc);

        Customer.Validate("Customer Disc. Group", FindGroupForCustomer(SalesBalanc));
        Customer.Modify();
        Message('Customer was added to Disc. Group.');
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
}