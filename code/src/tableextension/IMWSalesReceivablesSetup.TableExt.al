tableextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "IMW Auto Ass. Cust. Disc. Gr."; Boolean)
        {
            Caption = 'Auto Assigned Customer Discount Group';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Rec."IMW Auto Ass. Cust. Disc. Gr." then begin
                    if not Confirm(labelChangeAutoAssignedFromTrueQst) then
                        Rec."IMW Auto Ass. Cust. Disc. Gr." := true
                    else
                        Rec."IMW Status" := Rec."IMW Status"::Open;
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
        }
        field(50003; "IMW Period Of Validity"; DateFormula)
        {
            Caption = 'Period Of Validity';
            DataClassification = CustomerContent;
            InitValue = "30D";
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
}