tableextension 50002 "IMW Customer" extends Customer
{
    fields
    {
        field(50001; "IMW AA Disc. Valid To"; Date)
        {
            Caption = 'Auto Assign Disc. To Disc. Valid To';
            DataClassification = CustomerContent;
        }
        field(50002; "IMW Last AA Ch. By"; Code[50])
        {
            Caption = 'Last Auto Assign To Disc. Group Changed By';
            DataClassification = ToBeClassified;
        }
        field(50003; "IMW Last AA Ch. Date"; Date)
        {
            Caption = 'Last Auto Assign To Disc. Group Changed Date';
            DataClassification = ToBeClassified;
        }
    }
}