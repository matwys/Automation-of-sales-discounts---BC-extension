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
        field(10; Required; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Required Value';

            trigger OnValidate()
            var
                ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
            begin
                ReqAutoAssDiscGroup.SetRange(Required, Rec."Required");
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
        key(Key2; Required)
        {

        }
    }
    var
        InvalideValueErr: Label 'Invalide value.';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}