tableextension 50002 "IMW Customer" extends Customer
{
    fields
    {
        field(50001; "IMW CDGA Valid To"; Date)
        {
            Caption = 'CDGA Valid To';
            DataClassification = CustomerContent;
        }
        field(50002; "IMW CDGA Changed By"; Code[50])
        {
            Caption = 'CDGA Changed By';
            DataClassification = ToBeClassified;
        }
        field(50003; "IMW CDGA Changed Date"; Date)
        {
            Caption = 'CDGA Changed Date';
            DataClassification = ToBeClassified;
        }
    }
}