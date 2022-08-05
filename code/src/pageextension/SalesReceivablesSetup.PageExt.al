pageextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group("Auto assigned customer discount group")
            {
                field("Auto Assigned Cust. Disc. Group"; Rec."IMW Auto-assign Cust.Disc.Gr.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Turn on/turn of - Auto assigned customer discount group';


                    trigger OnValidate()
                    begin
                        if not Rec."IMW Auto-assign Cust.Disc.Gr." then begin
                            if not Confirm(labelChangeAutoAssignedFromTrue) then
                                Rec."IMW Auto-assign Cust.Disc.Gr." := true;
                        end
                        else
                            if not Confirm(labelChangeAutoAssignedFromFalse) then
                                Rec."IMW Auto-assign Cust.Disc.Gr." := false;

                        //autoAssignCustDiscGroupBool := Rec."IMW Auto-assign Cust.Disc.Gr.";
                        //CurrPage.Update();
                    end;
                }
                field("Turnover Period"; Rec."IMW Turnover Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies time range for turnover period count';
                }
                field("Period of Validity"; Rec."IMW Period Of Validity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies time range for period of validity';
                }
            }
        }
    }

    var
        autoAssignCustDiscGroupBool: Boolean;
        labelChangeAutoAssignedFromTrue: Label 'Do you want to turn off? All auto-assigned values will lost validity.';
        labelChangeAutoAssignedFromFalse: Label 'Do you want to turn on?';

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        autoAssignCustDiscGroupBool := SalesReceivablesSetup."IMW Auto-assign Cust.Disc.Gr.";
    end;

    local procedure CheckCorectDate(value: DateFormula): Boolean
    var
        ZeroDateFormule: DateFormula;
    begin
        Evaluate(ZeroDateFormule, '0D');
        if value = ZeroDateFormule then
            exit(true);
        exit(false);
    end;
}