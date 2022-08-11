tableextension 50002 "IMW Customer" extends Customer
{
    fields
    {
        field(50001; "IMW Auto. Ass. Disc. Exp. Date"; Date)
        {
            Caption = 'Auto Assigned Disc. Expiration Date';
            DataClassification = CustomerContent;
        }
        field(50002; "IMW Last Auto. Ass. Ch. By"; Code[50])
        {
            Caption = 'Last Auto Assigned Changed By';
            DataClassification = ToBeClassified;
        }
        field(50003; "IMW Last Auto Ass. Ch. Date"; Date)
        {
            Caption = 'Last Auto Assigned Changed Date';
            DataClassification = ToBeClassified;
        }
    }
}