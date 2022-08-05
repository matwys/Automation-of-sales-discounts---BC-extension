tableextension 50002 "IMW Customer" extends Customer
{
    fields
    {
        field(50001; "IMW Auto-ass. Disc.Exp.Date"; Date)
        {
            Caption = 'Auto-assgined Disc. Expiration Date';
            DataClassification = CustomerContent;
        }
        field(50002; "IMW Last Auto-ass.Changed By"; Code[20])
        {
            Caption = 'Last Auto-assgined Changed By';
            DataClassification = ToBeClassified;
        }
        field(50003; "IMW Last Auto-ass.Changed Date"; Date)
        {
            Caption = 'Last Auto-assgined Changed Date';
            DataClassification = ToBeClassified;
        }
    }
}