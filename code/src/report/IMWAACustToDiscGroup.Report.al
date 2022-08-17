report 50001 "IMW AA Cust. To Disc. Group"
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
                if not (SalesReceivablesSetup."IMW AA Cust. Disc. Gr." and (SalesReceivablesSetup."IMW AA Status" = SalesReceivablesSetup."IMW AA Status"::Released)) then
                    exit;
                if OnlyInvalidCust then
                    Customer.SetFilter(Customer."IMW AA Disc. Valid To", '<%1', Today());
            end;

            trigger OnAfterGetRecord()
            var
                IMWAACustDiscGrMgt: Codeunit "IMW AA Cust. Disc. Gr. Mgt.";
            begin
                if not (SalesReceivablesSetup."IMW AA Cust. Disc. Gr." and (SalesReceivablesSetup."IMW AA Status" = SalesReceivablesSetup."IMW AA Status"::Released)) then
                    exit;
                IMWAACustDiscGrMgt.AutoAssignCustomerToDiscGroup(Customer);
                Counter := Counter + 1;
            end;

            trigger OnPostDataItem();
            begin
                if not (SalesReceivablesSetup."IMW AA Cust. Disc. Gr." and (SalesReceivablesSetup."IMW AA Status" = SalesReceivablesSetup."IMW AA Status"::Released)) then begin
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
        FunctionalityDisableMsg: Label 'Customers can not be auto assigned because Auto Assign To Discount Group functionality must be enable and Status must be released.';

    trigger OnInitReport()
    var
    begin
        SalesReceivablesSetup.Get();
    end;
}