table 50002 "IMW Auto. Ass. Disc. Gr. Hist."
{
    DataClassification = ToBeClassified;
    Caption = 'Auto Assing To Cust. Disc. Gr. Hist.';

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
        field(11; "Cust. Disc. Group Code"; Code[20])
        {
            Caption = 'Customer Disc. Group Code';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(12; "IMW Last Auto. Ass. Ch. By"; Code[50])
        {
            Caption = 'Last Auto Assign To Disc. Group Changed By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "IMW Last Auto Ass. Ch. Date"; Date)
        {
            Caption = 'Last Auto Assign To Disc. Group Changed Date';
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