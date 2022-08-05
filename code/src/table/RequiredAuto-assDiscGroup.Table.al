table 50001 "IMW Req. Auto-ass Disc. Group."
{
    DataClassification = CustomerContent;
    Caption = 'Req. Auto-ass Disc. Group.';

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
            Caption = 'Required value';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

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