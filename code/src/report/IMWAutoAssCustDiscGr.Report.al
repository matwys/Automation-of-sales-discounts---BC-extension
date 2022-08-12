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
                clear(Customer);
                if not AutoAssignAllCust then
                    Customer.SetFilter(Customer."IMW Auto. Ass. Disc. Exp. Date", '<%1', CalcDate(SalesReceivablesSetup."IMW Turnover Period", Today()))
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
                Message('Ready!, %1 Customers were updated.', Counter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(AutoAssignAllCust; AutoAssignAllCust)
                    {
                        ApplicationArea = All;
                        Caption = 'Auto. Assign All Cust. To Disc. Group';
                        ToolTip = 'Customers with valid assign will be assigned again.';
                    }
                }
            }
        }
    }
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        AutoAssignAllCust: Boolean;
        Counter: Integer;
}