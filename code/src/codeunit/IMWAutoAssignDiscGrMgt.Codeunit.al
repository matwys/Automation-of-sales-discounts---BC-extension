codeunit 50001 "IMW Auto Assign Disc. Gr. Mgt."
{
    // IMW Auto-Assign Disc Group Mgt.
    procedure Release()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IsHandled: Boolean;
    begin
        IsHandled := CheckZero();
        if not IsHandled then
            exit;
        CheckDifferentValue();
        if not IsHandled then
            exit;
        if IsHandled then begin
            SalesReceivablesSetup.Get();
            SalesReceivablesSetup.Validate("IMW Status", SalesReceivablesSetup."IMW Status"::Released);
            SalesReceivablesSetup.Modify();
        end;
    end;

    local procedure CheckDifferentValue()
    var
    //ReqAutoAssDiscGroup: Record "IMW Req. Auto-ass Disc. Group.";
    begin

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
}