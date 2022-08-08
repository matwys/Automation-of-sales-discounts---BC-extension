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