codeunit 50002 "IMW CDGA Event"
{


    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsert(var Customer: Record Customer; xCustomer: Record Customer)
    var
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
    begin
        IMWCDGAMgt.OnAfterOnInsertCustomer(Customer);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventSalesHeader(var Rec: Record "Sales Header")
    var
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
    begin
        IMWCDGAMgt.OnAfterValidateEventSalesHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer Discount Group", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Customer Discount Group")
    var
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
    begin
        IMWCDGAMgt.OnBeforeDeleteEvent(Rec);
    end;
}