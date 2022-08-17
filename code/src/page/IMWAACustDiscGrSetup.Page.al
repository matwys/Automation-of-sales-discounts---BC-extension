page 50001 "IMW AA Cust. Disc. Gr. Setup"
{
    ApplicationArea = All;
    Caption = 'Auto Assign Customer To Disc. Group Setup';
    PageType = List;
    SourceTable = "IMW AA Cust. Disc. Gr. Setup";
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(Groups)
            {
                Caption = 'Groups';
                field("Customer Disc. Group Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Disc. Gruop Code';
                    Editable = SetupStatus;
                    ToolTip = 'Specifies a code for the customer discount group.';
                }
                field("Threshold Amount"; Rec."Treshold Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Threshold Amount';
                    Editable = SetupStatus;
                    ToolTip = 'Specifies A Threshold For The Customer Disc. Group.';
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
                        IMWAACustDiscGrMgt: Codeunit "IMW AA Cust. Disc. Gr. Mgt.";
                    begin
                        IMWAACustDiscGrMgt.Release();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        SetupStatus := false;
                        if SalesReceivablesSetup."IMW AA Status" <> SalesReceivablesSetup."IMW AA Status"::Released then
                            SetupStatus := true;
                    end;
                }
                action("IMW Open")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    Enabled = not SetupStatus;
                    Image = ReOpen;
                    ToolTip = 'Reopen the Requirements Auto Assign Disc. Group to change it after it has been approved.';

                    trigger OnAction()
                    var
                        SalesReceivablesSetup: Record "Sales & Receivables Setup";
                        AutoAssignDiscGrMgt: Codeunit "IMW AA Cust. Disc. Gr. Mgt.";
                    begin
                        AutoAssignDiscGrMgt.Open();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        SetupStatus := false;
                        if SalesReceivablesSetup."IMW AA Status" <> SalesReceivablesSetup."IMW AA Status"::Released then
                            SetupStatus := true;
                    end;
                }
            }
            action("IWM Auto Ass. All Cust. To Disc. Gr. Report")
            {
                Caption = 'Auto Assign All Cust. To Disc. Group Report';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Enabled = not SetupStatus and AACustDiscGroupEnable;
                ToolTip = 'Auto Assign All Customers to Discount Group by Balance. With Report.';

                trigger OnAction()
                var
                    IMWAutoAssCustDiscGr: Report "IMW AA Cust. To Disc. Group";
                begin
                    IMWAutoAssCustDiscGr.Run();
                end;
            }
        }
    }
    var
        SetupStatus: Boolean;
        AACustDiscGroupEnable: Boolean;

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SetupStatus := false;
        if SalesReceivablesSetup."IMW AA Status" <> SalesReceivablesSetup."IMW AA Status"::Released then
            SetupStatus := true;
        AACustDiscGroupEnable := SalesReceivablesSetup."IMW AA Cust. Disc. Gr.";
    end;
}