report 50001 "IMW CDGA Update All Cust."
{
    Caption = 'CDGA Update All Customers';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(Customer; Customer)
        {
            trigger OnPreDataItem()
            begin
                if not (SalesReceivablesSetup."IMW CDGA Enabled" and (SalesReceivablesSetup."IMW CDGA Treshold Setup Status" = SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released)) then
                    exit;
                if OnlyInvalidCust then
                    Customer.SetFilter(Customer."IMW CDGA Valid To", '<%1', Today());
            end;

            trigger OnAfterGetRecord()
            var
                IMWAACustDiscGrMgt: Codeunit "IMW CDGA Mgt.";
            begin
                if not (SalesReceivablesSetup."IMW CDGA Enabled" and (SalesReceivablesSetup."IMW CDGA Treshold Setup Status" = SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released)) then
                    exit;
                IMWAACustDiscGrMgt.AutoAssignCustomerToDiscGroup(Customer);
                Counter := Counter + 1;
            end;

            trigger OnPostDataItem();
            begin
                if not (SalesReceivablesSetup."IMW CDGA Enabled" and (SalesReceivablesSetup."IMW CDGA Treshold Setup Status" = SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released)) then begin
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
                    Caption = 'CDGA Setup';
                    field(OnlyInvalidCustomer; OnlyInvalidCust)
                    {
                        ApplicationArea = All;
                        Caption = 'CDGA Only With Invalid Assigned';
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
        CountChangesMsg: Label 'Changes: %1', Comment = '%1 Count changes.';
        FunctionalityDisableMsg: Label 'Customers can not be auto assigned because Auto Assign To Discount Group functionality must be enable and Status must be released.';

    trigger OnInitReport()
    var
    begin
        SalesReceivablesSetup.Get();
    end;
}