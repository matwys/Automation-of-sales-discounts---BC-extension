table 50001 "IMW CDGA Thresholds Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Auto Assign Customer To Disc. Group Setup';

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            TableRelation = "Customer Discount Group";
        }
        field(10; "Threshold Sales Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Treshold Amount';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Threshold Sales Amount")
        {
            Unique = true;
        }
    }
    var
        RemoveDiscGroupSetupErr: Label 'Status of Auto Assign To Disc. Group Setup is Released. Record can not be removed.';



    trigger OnDelete()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."IMW CDGA Treshold Setup Status" <> SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Open then
            Error(RemoveDiscGroupSetupErr);
    end;


}