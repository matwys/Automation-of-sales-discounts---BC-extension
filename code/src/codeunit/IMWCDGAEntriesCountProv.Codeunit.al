codeunit 50004 "IMW CDGA Entries Count Prov." implements "IMW CDGA IGroupProvider"
{
    procedure GetCustomerDiscGroup(Customer: Record Customer): Code[20]
    var
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
    begin
        Exit(IMWCDGAMgt.FindCustomerDiscGroupByEnriesCount(Customer));
    end;
}