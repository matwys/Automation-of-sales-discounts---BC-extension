tableextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "IMW Auto Ass. Cust. Disc. Gr."; Boolean)
        {
            Caption = 'Auto Assigned Customer Discount Group';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                AutoAssignDiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
            begin
                if not Rec."IMW Auto Ass. Cust. Disc. Gr." then begin
                    if not Confirm(labelChangeAutoAssignedFromTrueQst) then
                        Rec."IMW Auto Ass. Cust. Disc. Gr." := true
                    else begin
                        Rec."IMW Status" := Rec."IMW Status"::Open;
                        AutoAssignDiscGrMgt.TurnOff();
                    end;
                end
                else
                    if not Confirm(labelChangeAutoAssignedFromFalseQst) then
                        Rec."IMW Auto Ass. Cust. Disc. Gr." := false;

                //autoAssignCustDiscGroupBool := Rec."IMW Auto-assign Cust.Disc.Gr.";
                //CurrPage.Update(true);
            end;
        }
        field(50002; "IMW Turnover Period"; DateFormula)
        {
            Caption = 'Turnover period';
            DataClassification = CustomerContent;
            InitValue = "-90D";

            trigger OnValidate()
            var
                OneDayDateFormula: DateFormula;
            begin
                if not CheckCorectDateMinus(Rec."IMW Turnover Period") then begin
                    Evaluate(OneDayDateFormula, '-1D');
                    Rec."IMW Turnover Period" := OneDayDateFormula;
                end;
            end;
        }
        field(50003; "IMW Period Of Validity"; DateFormula)
        {
            Caption = 'Period Of Validity';
            DataClassification = CustomerContent;
            InitValue = "30D";

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
        field(50004; "IMW Status"; Enum "IMW Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            InitValue = "open";

        }
    }
    var
        labelChangeAutoAssignedFromTrueQst: Label 'Do you want to turn off? All auto-assigned values will lost validity.';
        labelChangeAutoAssignedFromFalseQst: Label 'Do you want to turn on?';

    local procedure CheckCorectDate(value: DateFormula): Boolean
    begin
        if Today() < CalcDate(value, Today()) then
            exit(true);
        exit(false);
    end;

    local procedure CheckCorectDateMinus(value: DateFormula): Boolean
    begin
        if Today() > CalcDate(value, Today()) then
            exit(true);
        exit(false);
    end;
}