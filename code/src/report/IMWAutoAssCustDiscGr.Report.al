report 50001 "IMW Auto Ass. Cust. Disc. Gr."
{
    Caption = 'Auto Assign All Customers To Discount Groups';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(Customer; Customer)
        {
            trigger OnPreDataItem()
            begin
                if OnlyValidCust then
                    Customer.SetFilter(Customer."IMW Auto. Ass. Disc. Valid To", '<%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()))
            end;

            trigger OnAfterGetRecord()
            var
                AutoAssignDiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
            begin
                AutoAssignDiscGrMgt.AutoAssingCustomerToDiscGroup(Customer);
                Counter := Counter + 1;
            end;

            trigger OnPostDataItem();
            begin
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
                    field(OnlyValidCust; OnlyValidCust)
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
        OnlyValidCust: Boolean;
        Counter: Integer;
        CountChangesMsg: Label 'Changes: %1';
}