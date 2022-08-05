pageextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group("Auto assigned customer discount group")
            {
                field("IMW Auto-assign Cust.Disc.Gr."; Rec."IMW Auto-assign Cust.Disc.Gr.")
                {
                    Caption = 'Auto Assigned Cust. Disc. Group';
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
                field("IWM Turnover Period"; Rec."IMW Turnover Period")
                {
                    Caption = 'Turnover Period';
                    ApplicationArea = All;
                    ToolTip = 'Specifies time range for turnover period count';
                    trigger OnValidate()
                    var
                        OneDayDateFormula: DateFormula;
                    begin
                        if not CheckCorectDate(Rec."IMW Turnover Period") then begin
                            Evaluate(OneDayDateFormula, '1D');
                            Rec."IMW Turnover Period" := OneDayDateFormula;
                        end;
                    end;
                }
                field("IWM Period of Validity"; Rec."IMW Period Of Validity")
                {
                    Caption = 'Period of Validity';
                    ApplicationArea = All;
                    ToolTip = 'Specifies time range for period of validity';
                    trigger OnValidate()
                    var
                        OneDayDateFormula: DateFormula;
                    begin
                        if not CheckCorectDate(Rec."IMW Period Of Validity") then begin
                            Evaluate(OneDayDateFormula, '1D');
                            Rec."IMW Period Of Validity" := OneDayDateFormula;
                        end;
                    end;
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
    begin
        if Today() < CalcDate(value, Today()) then
            exit(true);
        exit(false);
    end;
}