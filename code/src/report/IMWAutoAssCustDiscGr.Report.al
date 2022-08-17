report 50001 "IMW Auto Ass. Cust. Disc. Gr."
{
    Caption = 'Auto Assign All Customers To Discount Groups';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(Customer; Customer)
        {
            trigger OnPreDataItem()
            begin
                if not (SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr." and (SalesReceivablesSetup."IMW Status" = SalesReceivablesSetup."IMW Status"::Released)) then
                    exit;
                if OnlyInvalidCust then
                    Customer.SetFilter(Customer."IMW Auto. Ass. Disc. Valid To", '<%1', Today());
            end;

            trigger OnAfterGetRecord()
            var
                AutoAssignDiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
            begin
                if not (SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr." and (SalesReceivablesSetup."IMW Status" = SalesReceivablesSetup."IMW Status"::Released)) then
                    exit;
                AutoAssignDiscGrMgt.AutoAssingCustomerToDiscGroup(Customer);
                Counter := Counter + 1;
            end;

            trigger OnPostDataItem();
            begin
                if not (SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr." and (SalesReceivablesSetup."IMW Status" = SalesReceivablesSetup."IMW Status"::Released)) then begin
                    Message(FunctionalityDisableMsg);
                    exit;
                end;
                Message(CountChangesMsg, Counter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Setup)
                {
                    Caption = 'Auto Assign Setup';
                    field(OnlyInvalidCust; OnlyInvalidCust)
                    {
                        ApplicationArea = All;
                        Caption = 'Auto Assign To Disc. Group Only With Invalid Assigned';
                        ToolTip = 'Customers With Only Invalid Assign Will Be Assigned.';
                    }
                }
            }
        }
    }
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        OnlyInvalidCust: Boolean;
        Counter: Integer;
        CountChangesMsg: Label 'Changes: %1';
        FunctionalityDisableMsg: Label 'Auto Assign To Discount Group functionality must be enable and Status must be released.';

    trigger OnInitReport()
    var
    begin
        SalesReceivablesSetup.Get();
    end;
}