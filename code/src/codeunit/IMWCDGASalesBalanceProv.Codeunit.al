codeunit 50003 "IMW CDGA Sales Balance Prov." implements "IMW CDGA IGroupProvider"
{
    procedure GetCustomerDiscGroup(Customer: Record Customer): Code[20]
    var
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
    begin
        Exit(IMWCDGAMgt.FindCustomerDiscGroupBySalesBalance(Customer));
    end;
}