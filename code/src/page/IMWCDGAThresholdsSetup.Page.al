page 50001 "IMW CDGA Thresholds Setup"
{
    ApplicationArea = All;
    Caption = 'CDGA Thresholds Setup';
    PageType = List;
    SourceTable = "IMW CDGA Thresholds Setup";
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
                    Editable = CDGAThresholdSetupStatus;
                    ToolTip = 'Specifies a code for the customer discount group.';
                }
                field("Threshold Sales Amount"; Rec."Threshold Sales Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Threshold Sales Amount (LCY)';
                    Editable = CDGAThresholdSetupStatus;
                    ToolTip = 'Specifies A Threshold Sales Amount (LCY) For The Customer Disc. Group.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Release Group")
            {
                Caption = 'Release';
                action("Release")
                {
                    ApplicationArea = All;
                    Caption = 'Release';
                    Enabled = CDGAThresholdSetupStatus;
                    Image = ReleaseDoc;
                    ToolTip = 'Release the Requirements Auto-ass Disc. Group to the next stage of processing.';

                    trigger OnAction()
                    var
                        SalesReceivablesSetup: Record "Sales & Receivables Setup";
                        IMWAACustDiscGrMgt: Codeunit "IMW CDGA Mgt.";
                    begin
                        IMWAACustDiscGrMgt.Release();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        CDGAThresholdSetupStatus := false;
                        if SalesReceivablesSetup."IMW CDGA Treshold Setup Status" <> SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released then
                            CDGAThresholdSetupStatus := true;
                    end;
                }
                action("Open")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    Enabled = not CDGAThresholdSetupStatus;
                    Image = ReOpen;
                    ToolTip = 'Reopen the Requirements Auto Assign Disc. Group to change it after it has been approved.';

                    trigger OnAction()
                    var
                        SalesReceivablesSetup: Record "Sales & Receivables Setup";
                        AutoAssignDiscGrMgt: Codeunit "IMW CDGA Mgt.";
                    begin
                        AutoAssignDiscGrMgt.Open();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        CDGAThresholdSetupStatus := false;
                        if SalesReceivablesSetup."IMW CDGA Treshold Setup Status" <> SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released then
                            CDGAThresholdSetupStatus := true;
                    end;
                }
            }
            action("CDGA Update All Customers")
            {
                ApplicationArea = All;
                Caption = 'CDGA Update All Customers';
                Enabled = not CDGAThresholdSetupStatus and CDGAEnabled;
                Image = ReleaseDoc;
                ToolTip = 'CDGA Update All Customers by Balance';

                trigger OnAction()
                var
                    IMWAutoAssCustDiscGr: Report "IMW CDGA Update All Cust.";
                begin
                    IMWAutoAssCustDiscGr.Run();
                end;
            }
        }
    }
    var
        CDGAEnabled: Boolean;
        CDGAThresholdSetupStatus: Boolean;

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        CDGAThresholdSetupStatus := false;
        if SalesReceivablesSetup."IMW CDGA Treshold Setup Status" <> SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released then
            CDGAThresholdSetupStatus := true;
        CDGAEnabled := SalesReceivablesSetup."IMW CDGA Enabled";
    end;
}