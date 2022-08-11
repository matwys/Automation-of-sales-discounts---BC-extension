report 50001 "IMW Auto Ass. Cust. Disc. Gr."
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Auto Assign All Customers To Discount Groups';

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
        AutoAssignAllCust: Boolean;
        //Customer2: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Counter: Integer;
}