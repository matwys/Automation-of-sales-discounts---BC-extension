table 50002 "IMW CDGA Change Log"
{
    DataClassification = ToBeClassified;
    Caption = 'Auto Assing To Customer Disc. Group History';

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Customer Disc. Group Code"; Code[20])
        {
            Caption = 'Customer Disc. Group Code';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(12; "CDGA Changed By"; Code[50])
        {
            Caption = 'CDGA Changed By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "CDGA Changed Date"; Date)
        {
            Caption = 'CDGA Changed Date';
            DataClassification = CustomerContent;
            Editable = false;

        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key1; "Customer No.")
        {

        }
    }
}