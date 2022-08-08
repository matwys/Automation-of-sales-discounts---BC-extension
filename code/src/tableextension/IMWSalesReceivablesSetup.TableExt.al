tableextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "IMW Auto Ass. Cust. Disc. Gr."; Boolean)
        {
            Caption = 'Auto Assigned Customer Discount Group';
            DataClassification = CustomerContent;
        }
        field(50002; "IMW Turnover Period"; DateFormula)
        {
            Caption = 'Turnover period';
            DataClassification = CustomerContent;
            InitValue = "90D";
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

        }
    }
}