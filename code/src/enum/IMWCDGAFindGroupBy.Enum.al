enum 50002 "IMW CDGA Find Group By" implements "IMW CDGA IGroupProvider"
{
    Extensible = true;

    value(0; "Sales Balance")
    {
        Caption = 'Sales Balance (LCY)';
        Implementation = "IMW CDGA IGroupProvider" = "IMW CDGA Sales Balance Prov.";
    }
}