tableextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "IMW Auto-assign Cust.Disc.Gr."; Boolean)
        {
            Caption = 'Auto-assigned customer discount group';
            DataClassification = CustomerContent;
        }
        field(50002; "IMW Turnover Period"; DateFormula)
        {
            Caption = 'Turnover period';
            DataClassification = CustomerContent;
        }
        field(50003; "IMW Period Of Validity"; DateFormula)
        {
            Caption = 'Period of validity';
            DataClassification = CustomerContent;
        }
    }
}