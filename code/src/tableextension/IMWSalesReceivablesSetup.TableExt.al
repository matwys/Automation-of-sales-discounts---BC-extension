tableextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "IMW CDGA Enabled"; Boolean)
        {
            Caption = 'CDGA Enabled';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IMWAACustDiscGrMgt: Codeunit "IMW CDGA Mgt.";
            begin
                if not Rec."IMW CDGA Enabled" then begin
                    if not Confirm(ChangeEnabledFromTrueQst) then
                        Rec."IMW CDGA Enabled" := true
                    else begin
                        Rec."IMW CDGA Treshold Setup Status" := Rec."IMW CDGA Treshold Setup Status"::Open;
                        IMWAACustDiscGrMgt.TurnOff();
                    end;
                end
                else
                    if not Confirm(ChangeEnabledFromFalseQst) then
                        Rec."IMW CDGA Enabled" := false;
            end;
        }
        field(50002; "IMW CDGA Sales Period"; DateFormula)
        {
            Caption = 'CDGA Sales Period';
            DataClassification = CustomerContent;
            InitValue = "-90D";

            trigger OnValidate()
            var
                OneDayDateFormula: DateFormula;
            begin
                if not CheckCorectDateMinus(Rec."IMW CDGA Sales Period") then begin
                    Evaluate(OneDayDateFormula, '-1D');
                    Rec."IMW CDGA Sales Period" := OneDayDateFormula;
                end;
            end;
        }
        field(50003; "IMW CDGA Validity Period"; DateFormula)
        {
            Caption = 'CDGA Validity Period';
            DataClassification = CustomerContent;
            InitValue = "30D";

            trigger OnValidate()
            var
                OneDayDateFormula: DateFormula;
            begin
                if not CheckCorectDate(Rec."IMW CDGA Validity Period") then begin
                    Evaluate(OneDayDateFormula, '1D');
                    Rec."IMW CDGA Validity Period" := OneDayDateFormula;
                end;
            end;
        }
        field(50004; "IMW CDGA Treshold Setup Status"; Enum "IMW Status")
        {
            Caption = 'CDGA Treshold Setup Status';
            DataClassification = CustomerContent;
            InitValue = "open";

        }
    }
    var
        ChangeEnabledFromTrueQst: Label 'Do you want to disable the CDGA functionality? All CDGA lost validity.';
        ChangeEnabledFromFalseQst: Label 'Do you want to enable the CDGA functionality?';

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