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
                IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
            begin
                if Rec."IMW CDGA Enabled" = xRec."IMW CDGA Enabled" then
                    exit;

                if Rec."IMW CDGA Enabled" then
                    IMWCDGAMgt.EnableCDGA()
                else begin
                    IMWCDGAMgt.DisableCDGA();
                    Rec."IMW CDGA Treshold Setup Status" := Rec."IMW CDGA Treshold Setup Status"::Open;
                end;
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
                if not CheckIfDateFormulaIsInThePast(Rec."IMW CDGA Sales Period") then begin
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
                if CheckIfDateFormulaIsInThePast(Rec."IMW CDGA Validity Period") then begin
                    Evaluate(OneDayDateFormula, '1D');
                    Rec."IMW CDGA Validity Period" := OneDayDateFormula;
                end;
            end;
        }
        field(50004; "IMW CDGA Treshold Setup Status"; Enum "IMW CDGA Treshold Setup Status")
        {
            Caption = 'CDGA Treshold Setup Status';
            DataClassification = CustomerContent;
            InitValue = "open";

        }
    }

    local procedure CheckIfDateFormulaIsInThePast(value: DateFormula): Boolean
    begin
        if Today() > CalcDate(value, Today()) then
            exit(true);
        exit(false);
    end;
}