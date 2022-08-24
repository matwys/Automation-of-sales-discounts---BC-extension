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
                if not CDGAIncludeValidAssigned then
                    Customer.SetFilter(Customer."IMW CDGA Valid To", '<%1', Today());
            end;

            trigger OnAfterGetRecord()
            var
                IMWAACustDiscGrMgt: Codeunit "IMW CDGA Mgt.";
            begin
                IMWAACustDiscGrMgt.AutoAssignCustomerToDiscGroup(Customer);
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
                    Caption = 'CDGA Setup';
                    field(IncludeValidAssigned; CDGAIncludeValidAssigned)
                    {
                        ApplicationArea = All;
                        Caption = 'CDGA Include Valid Assigned';
                        ToolTip = 'Customers With Only Invalid Assign Will Be Assigned.';
                    }
                }
            }
        }
    }
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CDGAIncludeValidAssigned: Boolean;
        Counter: Integer;
        CountChangesMsg: Label 'Customer Disc. Group hav been updated for: %1 customers', Comment = '%1 Count changes.';
        OnInitErr: Label 'CDGA Threshold Setup Status must be Released and CDGA Enabled must be enabled.';


    trigger OnInitReport()
    var
    begin
        SalesReceivablesSetup.Get();
        if not (SalesReceivablesSetup."IMW CDGA Enabled" and (SalesReceivablesSetup."IMW CDGA Treshold Setup Status" = SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released)) then
            Error(OnInitErr);
    end;
}