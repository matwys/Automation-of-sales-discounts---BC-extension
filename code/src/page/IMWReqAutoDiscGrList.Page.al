page 50001 "IMW Req. Auto Disc. Gr. List"
{
    ApplicationArea = All;
    Caption = 'Requirements Auto Ass. Disc. Group';
    PageType = List;
    SourceTable = "IMW Req. Auto. Cust. Disc. Gr.";
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(Groups)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    Editable = SetupStatus;
                    ToolTip = 'Specifies a code for the customer discount group.';
                }
                field("Required"; Rec."Required")
                {
                    ApplicationArea = All;
                    Caption = 'Required';
                    Editable = SetupStatus;
                    ToolTip = 'Specifies a requirement for the customer discount group.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("IMW Release Group")
            {
                Caption = 'Release';
                action("IMW Release")
                {
                    ApplicationArea = All;
                    Caption = 'Release';
                    Enabled = SetupStatus;
                    Image = ReleaseDoc;
                    ToolTip = 'Release the Requirements Auto-ass Disc. Group to the next stage of processing.';

                    trigger OnAction()
                    var
                        SalesReceivablesSetup: Record "Sales & Receivables Setup";
                        AutoAssignDiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
                    begin
                        AutoAssignDiscGrMgt.Release();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        SetupStatus := false;
                        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Released then
                            SetupStatus := true;
                    end;
                }
                action("IMW Open")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    Enabled = not SetupStatus;
                    Image = ReOpen;
                    ToolTip = 'Reopen the Requirements Auto-ass Disc. Group to change it after it has been approved.';

                    trigger OnAction()
                    var
                        SalesReceivablesSetup: Record "Sales & Receivables Setup";
                        AutoAssignDiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
                    begin
                        AutoAssignDiscGrMgt.Open();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        SetupStatus := false;
                        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Released then
                            SetupStatus := true;
                    end;
                }
            }
            action("IWM Auto Ass. All Cust. To Disc. Gr.")
            {
                Caption = 'Auto Assign All Cust. To Disc. Group';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Enabled = not SetupStatus and AutoAssignCustDiscGroupBool;
                ToolTip = 'Auto Assign All Customers to Discount Group by Balance.';

                trigger OnAction()
                var
                    AutoAssignDiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
                begin
                    AutoAssignDiscGrMgt.AutoAssingAllCustomersToDiscGroup()
                end;
            }
            action("IWM Auto Ass. All Cust. To Disc. Gr. Report")
            {
                Caption = 'Auto Assign All Cust. To Disc. Group Report';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Enabled = not SetupStatus and AutoAssignCustDiscGroupBool;
                ToolTip = 'Auto Assign All Customers to Discount Group by Balance. With Report.';

                trigger OnAction()
                var
                    IMWAutoAssCustDiscGr: Report "IMW Auto Ass. Cust. Disc. Gr.";
                begin
                    IMWAutoAssCustDiscGr.Run();
                end;
            }
        }
    }
    var
        SetupStatus: Boolean;
        AutoAssignCustDiscGroupBool: Boolean;

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SetupStatus := false;
        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Released then
            SetupStatus := true;
        AutoAssignCustDiscGroupBool := SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.";
    end;
}