table 50001 "IMW AA Cust. Disc. Gr. Setup"
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
        field(10; "Treshold Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Treshold Amount';

            trigger OnValidate()
            var
                ReqAutoAssDiscGroup: Record "IMW AA Cust. Disc. Gr. Setup";
            begin
                ReqAutoAssDiscGroup.SetRange("Treshold Amount", Rec."Treshold Amount");
                ReqAutoAssDiscGroup.SetFilter(Code, '<>%1', Rec.Code);
                if ReqAutoAssDiscGroup.Count <> 0 then
                    Error(InvalideValueErr);
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Treshold Amount")
        {

        }
    }
    var
        InvalideValueErr: Label 'Invalide value. Other Threshold has the same value.';
        RemoveDiscGroupSetupErr: Label 'Status of Auto Assign To Disc. Group Setup is Released. Record can not be removed.';



    trigger OnDelete()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."IMW AA Status" <> SalesReceivablesSetup."IMW AA Status"::Open then
            Error(RemoveDiscGroupSetupErr);
    end;


}