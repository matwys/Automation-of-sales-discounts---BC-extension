tableextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "IMW AA Cust. Disc. Gr."; Boolean)
        {
            Caption = 'Auto Assigned Customer Discount Group';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IMWAACustDiscGrMgt: Codeunit "IMW AA Cust. Disc. Gr. Mgt.";
            begin
                if not Rec."IMW AA Cust. Disc. Gr." then begin
                    if not Confirm(labelChangeAutoAssignFromTrueQst) then
                        Rec."IMW AA Cust. Disc. Gr." := true
                    else begin
                        Rec."IMW AA Status" := Rec."IMW AA Status"::Open;
                        IMWAACustDiscGrMgt.TurnOff();
                    end;
                end
                else
                    if not Confirm(labelChangeAutoAssignFromFalseQst) then
                        Rec."IMW AA Cust. Disc. Gr." := false;
            end;
        }
        field(50002; "IMW Turnover Period"; DateFormula)
        {
            Caption = 'Turnover Threshold Period';
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
        field(50004; "IMW AA Status"; Enum "IMW Status")
        {
            Caption = 'Status Of Auto Assign';
            DataClassification = CustomerContent;
            InitValue = "open";

        }
    }
    var
        labelChangeAutoAssignFromTrueQst: Label 'Do you want to disable the functionality? All auto assign lost validity.';
        labelChangeAutoAssignFromFalseQst: Label 'Do you want to enable the functionality?';

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