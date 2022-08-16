table 50001 "IMW Req. Auto. Cust. Disc. Gr."
{
    DataClassification = CustomerContent;
    Caption = 'Req. Auto Ass. Disc. Group.';

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            TableRelation = "Customer Discount Group";
        }
        field(10; Threshold; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Treshold Amount';

            trigger OnValidate()
            var
                ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
            begin
                ReqAutoAssDiscGroup.SetRange(Threshold, Rec.Threshold);
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
        key(Key2; Threshold)
        {

        }
    }
    var
        InvalideValueErr: Label 'Invalide value. Other Threshold has the same value.';
        RemoveReqDiscGroupErr: Label 'Status of Auto Assign To Disc. Group Setup is Released. Record can not be removed.';



    trigger OnDelete()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Open then
            Error(RemoveReqDiscGroupErr);
    end;


}